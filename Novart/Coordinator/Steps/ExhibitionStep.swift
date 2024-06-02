import UIKit

enum ExhibitionStep: Step {
    case exhibitionDetail(id: Int64)
    case comment(id: Int64)
    case login
    case artist(userId: Int64)
    case exhibitionGuide(id: Int64, backgroundColor: UIColor)
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
