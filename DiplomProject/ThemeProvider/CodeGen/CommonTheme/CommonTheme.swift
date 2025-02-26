import UIKit

struct CommonTheme {
    let text: Text
    let background: Background
    let icon: Icon
    let stroke: Stroke
    
    struct Text {
        let action: UIColor
        let negative: UIColor
        let primary: UIColor
        let secondary: UIColor
        let tertiary: UIColor
        let name: UIColor
        let contrast: UIColor
    }
    
    struct Background {
        let themed: UIColor
        let surface: UIColor
        let grouped: UIColor
    }
    
    struct Icon {
        let themed: UIColor
        let secondary: UIColor
        let contrast: UIColor
        let negative: UIColor
    }
    
    struct Stroke {
        let primary: UIColor
        let secondary: UIColor
    }
}
