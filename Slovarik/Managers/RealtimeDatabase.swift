import Firebase
import CodableFirebase

protocol P_RealtimeModelWithId: Codable {
    
    var id: String? { get set }
    
}
extension P_RealtimeModelWithId {
    
    init(dictItem: (key: String, value: [String : Any]), firebaseDecoder: FirebaseDecoder = .init()) throws {
        self = try firebaseDecoder.decode(Self.self, from: dictItem.value)
        self.id = dictItem.key
    }
    
}

class M_RealtimeDatabase_Container<T: P_RealtimeModelWithId> {
    
    let value: T
    
    init(dictItem: (key: String, value: [String : Any]), firebaseDecoder: FirebaseDecoder = .init()) throws {
        var value = try firebaseDecoder.decode(T.self, from: dictItem.value)
        value.id = dictItem.key
        self.value = value
    }
    
}

class RealtimeDatabase {
    
    enum FirebaseError: Error {
        case notAuth, mismatchType
    }
    
    private let root: Database
    private var tabsCollection: DatabaseReference {
        return root.reference(withPath: "Tabs")
    }
    private var wordsCollection: DatabaseReference {
        return root.reference(withPath: "Words")
    }

    init(isPersistenceEnabled: Bool = true) {
        let database = Database.database()
        database.isPersistenceEnabled = isPersistenceEnabled
        root = database
    }
    
    
    // Tabs
    //  userId
    //   tabId
    //    tabItem
    func tabs(_ completion: @escaping ([M_Tab]?, Error?) -> ()) {
        guard let authUser = Auth.auth().currentUser else { return completion(nil, FirebaseError.notAuth) }
        let query = tabsCollection.child(authUser.uid).queryOrderedByKey()
        query.keepSynced(true)
        query.observeSingleEvent(
            of: .value,
            with: {
                guard let dict = $0.value as? [String: [String: Any]] else { return completion([], FirebaseError.mismatchType) }
                
                let tabs: [M_Tab]
                do {
                    tabs = try dict.compactMap { try .init(dictItem: $0) }
                } catch {
                    return completion(nil, error)
                }
                
                guard tabs.count == 0 else { return completion(tabs.sorted(by: { $0.position < $1.position } ), nil) }
                self.addTab(M_Tab.default) { (tab, error) in
                    guard let tab = tab else { return completion(nil, error) }
                    completion([tab], nil)
                }
            },
            withCancel: { completion(nil, $0) }
        )
    }
    
    func addTab(_ tab: M_Tab, _ completion: @escaping (M_Tab?, Error?) -> ()) {
        guard let authUser = Auth.auth().currentUser else { return completion(nil, FirebaseError.notAuth) }
        let value: Any
        do {
            value = try FirebaseEncoder().encode(tab)
        } catch {
            return completion(nil, error)
        }
        tabsCollection.child(authUser.uid).childByAutoId().setValue(value) { (error, ref) in
            guard let id = ref.key else { return completion(nil, error) }
            tab.id = id
            completion(tab, nil)
        }
    }
    
    func removeTab(id: String, _ completion: @escaping (Error?) -> ()) {
        guard let authUser = Auth.auth().currentUser else { return completion(FirebaseError.notAuth) }
        tabsCollection.child(authUser.uid).child(id).removeValue { (error, _) in
            guard error == nil else { return completion(error) }
            self.wordsCollection.child(id).removeValue { (error, _) in
                completion(error)
            }
        }
    }
    
    func updateTab(_ item: M_Tab, _ completion: @escaping (Error?) -> ()) {
        guard let authUser = Auth.auth().currentUser, let id = item.id else { return completion(FirebaseError.notAuth) }
        let value: Any
        do {
            value = try FirebaseEncoder().encode(item)
        } catch {
            return completion(error)
        }
        tabsCollection.child(authUser.uid).child(id).setValue(value) { (error, _) in
            completion(error)
        }
    }
    
    func removeTabs(_ completion: @escaping (Error?) -> ()) {
        guard let _ = Auth.auth().currentUser else { return completion(FirebaseError.notAuth) }
        tabs { (tabs, error) in
            guard let tabIds = tabs?.compactMap( { $0.id } ) else { return completion(error) }
            guard tabIds.count > 0 else { return completion(nil) }
            self.removeTabs(ids: tabIds, completion)
        }
    }
    
    func removeTabs(ids: [String], _ completion: @escaping (Error?) -> ()) {
        guard let tabId = ids.first else { return completion(nil) }
        removeTab(id: tabId) { (error) in
            guard error == nil else { return completion(error) }
            self.removeTabs(ids: Array(ids.dropFirst()), completion)
        }
    }
    
    func updateTabs(_ tabs: [M_Tab], _ completion: @escaping (Error?) -> ()) {
        guard let tab = tabs.first else { return completion(nil) }
        updateTab(tab) { (error) in
            guard error == nil else { return completion(error) }
            self.updateTabs(Array(tabs.dropFirst()), completion)
        }
    }
    
    
    
    
    // Words
    //  tabId
    //   wordId
    //    wordItem
    func words(forTadId tabId: String, completion: @escaping ([M_Word]?, Error?) -> ()) {
        guard let _ = Auth.auth().currentUser else { return completion(nil, FirebaseError.notAuth) }
        let query = wordsCollection.child(tabId).queryOrderedByKey()
        query.keepSynced(true)
        query.observeSingleEvent(
            of: .value,
            with: {
                guard let dict = $0.value as? [String: [String: Any]] else { return completion([], FirebaseError.mismatchType) }
                do {
                    let words: [M_Word] = try dict.compactMap { try .init(dictItem: $0) }
                    completion(words, nil)
                } catch {
                    completion(nil, error)
                }
            },
            withCancel: { completion(nil, $0) }
        )
    }
    
    func addWord(_ word: M_Word, forTabId tabId: String, _ completion: @escaping (M_Word?, Error?) -> ()) {
        guard let _ = Auth.auth().currentUser else { return completion(nil, FirebaseError.notAuth) }
        let value: Any
        do {
            value = try FirebaseEncoder().encode(word)
        } catch {
            return completion(nil, error)
        }
        wordsCollection.child(tabId).childByAutoId().setValue(value) { (error, ref) in
            guard let id = ref.key else { return completion(nil, error) }
            word.id = id
            completion(word, nil)
        }
    }
    
    func removeWord(id: String, forTabId tabId: String, _ completion: @escaping (Error?) -> ()) {
        guard let _ = Auth.auth().currentUser else { return completion(FirebaseError.notAuth) }
        wordsCollection.child(tabId).child(id).removeValue { (error, _) in
            completion(error)
        }
    }
    
    func updarwWord(_ word: M_Word, forTabId tabId: String, _ completion: @escaping (Error?) -> ()) {
        guard let _ = Auth.auth().currentUser, let wordId = word.id else { return completion(FirebaseError.notAuth) }
        let value: Any
        do {
            value = try FirebaseEncoder().encode(word)
        } catch {
            return completion(error)
        }
        wordsCollection.child(tabId).child(wordId).setValue(value) { (error, _) in
            completion(error)
        }
    }
    
    func removeWords(ids: [String], forTabId tabId: String, _ completion: @escaping (Error?) -> ()) {
        guard let wordId = ids.first else { return completion(nil) }
        removeWord(id: wordId, forTabId: tabId) { (error) in
            guard error == nil else { return completion(error) }
            self.removeWords(ids: Array(ids.dropFirst()), forTabId: tabId, completion)
        }
    }
    
    func removeWords(forTabId tabId: String, _ completion: @escaping (Error?) -> ()) {
        guard let _ = Auth.auth().currentUser else { return completion(FirebaseError.notAuth) }
        words(forTadId: tabId) { (words, error) in
            guard let wordIds = words?.compactMap( { $0.id } ), error == nil else { return completion(error) }
            self.removeWords(ids: wordIds, forTabId: tabId, completion)
        }
    }
    
}
