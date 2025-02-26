import UIKit

final class ColorPickerViewController: UIColorPickerViewController {
    
    var didSetColor: ((UIColor) -> Void)?
        
    init(selectedColor: UIColor) {
        super.init()
        
        self.selectedColor = selectedColor
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Установить", style: .done, target: self, action: #selector(didTapSetColorButton))
    }
    
    @objc private func didTapSetColorButton() {
        didSetColor?(selectedColor.sRGB)
    }
}
