import Foundation

extension String {

    var asInt: Int? { return Int(self) }
    var asURL: URL? { return URL(string: self) }
    
    var onlyDigits: String {
        let set = CharacterSet(charactersIn: "0123456789")
        return self.components(separatedBy: set.inverted).joined()
    }
    
    func separate(every stride: Int = 2, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    var textTrimmedNonEmpty: String? {
        let strpped = self.trimmingCharacters(in: .whitespaces)
        return strpped.isEmpty == true ? nil : strpped
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    
    //    ^                         Start anchor
    //    (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
    //    (?=.*[!@#$&*])            Ensure string has one special case letter.
    //    (?=.*[0-9].*[0-9])        Ensure string has two digits.
    //    (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
    //    .{8,}                     Ensure string length >= 8.
    //    $                         End anchor.
    
    var isValidPassword: Bool {
        let regEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        let string = NSPredicate(format:"SELF MATCHES %@", regEx)
        return string.evaluate(with: self)
    }
    
    var textAsEmail: String? {
        guard let email = textTrimmedNonEmpty else { return nil }
        return email.isValidEmail ? email : nil
    }
    
    var textAsPassword: String? {
        guard let password = textTrimmedNonEmpty else { return nil }
        return password.isValidPassword ? password : nil
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func with(_ attributes: [NSAttributedString.Key : Any]?) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
}
