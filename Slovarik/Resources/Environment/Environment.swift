import Foundation

enum Environment: String {
    
    case debug, release
    
    static let current: Environment = {
        guard let environmentRawValue = Environment.infoDictionary["ENVIRONMENT"] as? String else {
            fatalError("ENVIRONMENT not set in plist")
        }
        guard let enumValue = Environment(rawValue: environmentRawValue) else {
            fatalError("Undefined value for environment")
        }
        return enumValue
    }()
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
}
