import UIKit

public struct CommonTheme {
    public let background: Background
    public let icon: Icon
    public let stroke: Stroke
    public let text: Text

    public struct Background {
        public let grouped: UIColor
        public let surface: UIColor
        public let themed: UIColor
    }

    public struct Icon {
        public let contrast: UIColor
        public let negative: UIColor
        public let secondary: UIColor
        public let themed: UIColor
    }

    public struct Stroke {
        public let primary: UIColor
        public let secondary: UIColor
    }

    public struct Text {
        public let action: UIColor
        public let contrast: UIColor
        public let name: UIColor
        public let negative: UIColor
        public let primary: UIColor
        public let secondary: UIColor
        public let tertiary: UIColor
    }
}