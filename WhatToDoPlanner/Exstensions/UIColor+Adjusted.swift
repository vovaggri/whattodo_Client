import UIKit

extension UIColor {
    /// Returns a color with the appropriate deltas added to H/S/B/alpha (negative values ​​are allowed).
    func adjusted(hueOffset: CGFloat = 0,
                    saturationOffset: CGFloat = 0,
                    brightnessOffset: CGFloat = 0,
                    alphaOffset: CGFloat = 0) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
            
        // Decompose color in HSB
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            return self
        }
            
        // newX = clamp(oldX + offset, 0…1)
        let newHue        = min(max(h + hueOffset, 0), 1)
        let newSaturation = min(max(s + saturationOffset, 0), 1)
        let newBrightness = min(max(b + brightnessOffset, 0), 1)
        let newAlpha      = min(max(a + alphaOffset, 0), 1)
        
        return UIColor(hue: newHue,
                        saturation: newSaturation,
                        brightness: newBrightness,
                        alpha: newAlpha)
    }
}
