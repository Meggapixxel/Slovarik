//
//  TabContentVC+Presenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/30/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_TabWords: P_TableViewController {
    
    class Presenter: BaseTableViewControllerMultipleSectionPresenter<VC_TabWords, LabelBlurBackgroundCell, M_Word>, UITableViewDelegate {
        
        override var headerView: UIView? { vc.headerView.config { $0.backgroundColor = vc.tableView.separatorColor } }
        var footerView: UIView? { vc.footerView }
        
        private var sections = [String]()
        
        override func initialUpdateUI() {
            super.initialUpdateUI()
            
            vc.tableView.delegate = self
            vc.tableView.register(headerFooter: BlurSectionView.self)
        }
        
        func setWords(_ words: [M_Word]) {
            let firstLetters = words.compactMap { $0.name[$0.name.startIndex].uppercased() }.sorted()
            sections = Array(Set(firstLetters))
            var futureItems = (0..<sections.count).compactMap { _ in [M_Word]() }
            futureItems = words.reduce(into: futureItems) { (result, word) in
                guard let section = sections.firstIndex(of: word.name[word.name.startIndex].uppercased()) else {
                    fatalError("Can't find section")
                }
                result[section].append(word)
            }
            futureItems = futureItems.compactMap { $0.sorted { $0.name < $1.name } }
            setItems(futureItems)
        }
        
        func appendNewWord(_ newWord: M_Word) {
            let firstLetter = newWord.name[newWord.name.startIndex].uppercased()
            let indexPath: IndexPath
            if  let section = sections.firstIndex(of: firstLetter) {
                var wordsInSection = items[section].compactMap { $0.name }
                wordsInSection.append(newWord.name)
                guard let row = wordsInSection.firstIndex(of: newWord.name) else {
                    fatalError("Can't find word")
                }
                indexPath = IndexPath(row: row, section: section)
                insertItem(newWord, atIndexPath: indexPath)
            } else {
                sections.append(firstLetter)
                sections = sections.sorted()
                guard let section = sections.firstIndex(of: firstLetter) else {
                    fatalError("Can't find section")
                }
                indexPath = IndexPath(row: 0, section: section)
                insertItems([newWord], section: section)
            }
            vc.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard editingStyle == .delete else { return }
            
            let words = items[indexPath.section]
            let word = words[indexPath.row]
            
            guard let wordId = word.id else { return }
            
            vc.deleteWord(withId: wordId) { [weak self] in
                if words.count == 1 {
                    self?.sections.remove(at: indexPath.section)
                    self?.removeItems(section: indexPath.section)
                } else {
                    self?.removeItem(atIndexPath: indexPath)
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { false }
        
        
        
        // MARK: - UITableViewDelegate
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return tableView.new(headerFooter: BlurSectionView.self, presenter: .init(title: sections[section]))
        }
        
    }

}
