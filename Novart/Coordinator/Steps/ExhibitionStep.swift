import UIKit

enum ExhibitionStep: Step {
    case exhibitionDetail(id: Int64)
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
