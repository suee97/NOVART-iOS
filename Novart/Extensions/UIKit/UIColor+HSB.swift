import UIKit

extension UIColor {
    func getHsb() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat  = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        let uiColor = self
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (hue * 360, saturation * 100, brightness * 100, alpha)
    }
}
