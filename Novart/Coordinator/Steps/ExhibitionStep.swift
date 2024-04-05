import UIKit

enum ExhibitionStep: Step {
    case exhibitionDetail(id: Int64)
    case comment(id: Int64)
    case login
    case artist(userId: Int64)
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
