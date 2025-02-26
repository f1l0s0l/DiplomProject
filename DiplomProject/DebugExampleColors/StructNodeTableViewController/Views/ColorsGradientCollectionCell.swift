import UIKit

final class ColorsGradientCollectionCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.highlightView.alpha = self.isHighlighted ? 1 : 0
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.highlightView.alpha = self.isHighlighted ? 1 : 0
            }
        }
    }
    
    // MARK: - Private properties
    
    private let nameTokenlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray
        return view
    }()
    
    private let lightGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let lightGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        return layer
    }()
    
    private let darkGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let darkGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        return layer
    }()
    
    private let highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.alpha = 0
        return view
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            nameTokenlabel,
            separatorView,
            lightGradientView,
            darkGradientView,
            highlightView,
        ].forEach(contentView.addSubview)
        
        lightGradientView.layer.addSublayer(lightGradientLayer)
        darkGradientView.layer.addSublayer(darkGradientLayer)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1 / UIScreen.main.scale
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray6
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lightGradientLayer.frame = lightGradientView.bounds.insetBy(dx: 15, dy: 8)
        darkGradientLayer.frame = darkGradientView.bounds.insetBy(dx: 15, dy: 8)
    }
    
    // MARK: - Public methods
    
    func render(gradientColors: [UIColor], nodeName: String) {
        nameTokenlabel.text = "/ \(nodeName.splitCamelCase)"
        
        lightGradientLayer.colors = gradientColors
            .map { $0.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light)) }
            .map(\.cgColor)
        
        darkGradientLayer.colors = gradientColors
            .map { $0.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)) }
            .map(\.cgColor)
        
        layoutIfNeeded()
    }
    
    // MARK: - Private methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTokenlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameTokenlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameTokenlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            separatorView.topAnchor.constraint(equalTo: nameTokenlabel.bottomAnchor, constant: 10),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            
            lightGradientView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0),
            lightGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            lightGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            lightGradientView.heightAnchor.constraint(equalToConstant: 75),
            
            darkGradientView.topAnchor.constraint(equalTo: lightGradientView.bottomAnchor),
            darkGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            darkGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            darkGradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            darkGradientView.heightAnchor.constraint(equalToConstant: 75),
            
            highlightView.topAnchor.constraint(equalTo: contentView.topAnchor),
            highlightView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            highlightView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            highlightView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
