import UIKit

enum ExhibitionStep: Step {
    case dummy
    
    var target: UIViewController.Type? { nil }
    var animated: Bool { false }
}
