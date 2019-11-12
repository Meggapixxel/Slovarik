import Foundation

enum AppError: Error {
    
    case tabExists, wordNotExists, other(Error)
    
}
