import UIKit

extension UIColor {
    
    var hexCode: String {
        get {
            let colorComponents = self.cgColor.components!
            if colorComponents.count < 4 {
                return String(
                    format: "%02x%02x%02x",
                    Int(colorComponents[0] * 255),
                    Int(colorComponents[0] * 255),
                    Int(colorComponents[0] * 255)
                ).uppercased()
            }
            return String(
                format: "%02x%02x%02x",
                Int(colorComponents[0] * 255),
                Int(colorComponents[1] * 255),
                Int(colorComponents[2] * 255)
            ).uppercased()
        }
    }
    
    //Amount should be between 0 and 1
    func lighterColor(_ amount: CGFloat) -> UIColor {
        return UIColor.blendColors(color: self, destinationColor: .white, amount: amount)
    }
    
    func darkerColor(_ amount: CGFloat) -> UIColor {
        return UIColor.blendColors(color: self, destinationColor: .black, amount: amount)
    }
    
    static func blendColors(color: UIColor, destinationColor: UIColor, amount: CGFloat) -> UIColor {
        var amountToBlend = amount
        if amountToBlend > 1 {
            amountToBlend = 1
        } else if amountToBlend < 0 {
            amountToBlend = 0
        }
        
        var r,g,b, alpha: CGFloat
        r = 0
        g = 0
        b = 0
        alpha = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &alpha) //gets the rgba values (0-1)
        
        //Get the destination rgba values
        var dest_r, dest_g, dest_b, dest_alpha: CGFloat
        dest_r = 0
        dest_g = 0
        dest_b = 0
        dest_alpha = 0
        destinationColor.getRed(&dest_r, green: &dest_g, blue: &dest_b, alpha: &dest_alpha)
        
        r = amountToBlend * (dest_r * 255) + (1 - amountToBlend) * (r * 255)
        g = amountToBlend * (dest_g * 255) + (1 - amountToBlend) * (g * 255)
        b = amountToBlend * (dest_b * 255) + (1 - amountToBlend) * (b * 255)
        alpha = abs(alpha / dest_alpha)
        
        return UIColor(
            red: r / 255,
            green: g / 255,
            blue: b / 255,
            alpha: alpha
        )
    }
    
}
