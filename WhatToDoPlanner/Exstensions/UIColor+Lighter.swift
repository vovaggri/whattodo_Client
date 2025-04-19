import UIKit

extension UIColor {
    /// Возвращает цвет, у которого к H/S/B/α добавлены соответствующие дельты (допускаются отрицательные значения).
    func adjusted(hueOffset: CGFloat = 0,
                    saturationOffset: CGFloat = 0,
                    brightnessOffset: CGFloat = 0,
                    alphaOffset: CGFloat = 0) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
            
        // пытаемся разложить цвет в HSB
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            // если не удалось (например, цвет задан в CMYK), возвращаем оригинал
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
