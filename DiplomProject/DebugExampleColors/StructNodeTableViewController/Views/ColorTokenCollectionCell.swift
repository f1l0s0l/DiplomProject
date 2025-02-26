import UIKit

private let previewColorSize = CGSize(width: 70, height: 40)

final class ColorTokenCollectionCell: UICollectionViewCell {
    
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
    
    weak var delegate: ColorEditorDelegate?
    
    // MARK: - Private properties
    
    private var nodeName: String?
    private var color: UIColor?
    
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
    
    private let lightContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lightColorPreviewView: ColorValuePreviewView = {
        let view = ColorValuePreviewView(contentInsets: UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 25))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 0
        return view
    }()
    
    private let darkContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let darkColorPreviewView: ColorValuePreviewView = {
        let view = ColorValuePreviewView(contentInsets: UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 25))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 1
        return view
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
            lightContainerView,
            darkContainerView,
            highlightView,
        ].forEach(contentView.addSubview)
        
        lightContainerView.addSubview(lightColorPreviewView)
        darkContainerView.addSubview(darkColorPreviewView)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1 / UIScreen.main.scale
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray6
        
        setupConstraints()
        
        let lightColorTapGetureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLightColor))
        let darkColorTapGetureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDarkColor))


        lightColorPreviewView.addGestureRecognizer(lightColorTapGetureRecognizer)
        darkColorPreviewView.addGestureRecognizer(darkColorTapGetureRecognizer)

    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        delegate = nil
        nodeName = nil
        color = nil
    }
    
    // MARK: - Public methods
    
    func render(nodeName: String, color: UIColor) {
        self.nodeName = nodeName
        self.color = color
        
        nameTokenlabel.text = nodeName.splitCamelCase
        
        let light = color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        let dark = color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        
        lightColorPreviewView.render(color: light, isDark: false)
        darkColorPreviewView.render(color: dark, isDark: true)
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
            
            lightContainerView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0),
            lightContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            lightContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            darkContainerView.topAnchor.constraint(equalTo: lightContainerView.bottomAnchor),
            darkContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            darkContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            darkContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            lightColorPreviewView.topAnchor.constraint(equalTo: lightContainerView.topAnchor),
            lightColorPreviewView.leadingAnchor.constraint(equalTo: lightContainerView.leadingAnchor),
            lightColorPreviewView.trailingAnchor.constraint(equalTo: lightContainerView.trailingAnchor),
            lightColorPreviewView.bottomAnchor.constraint(equalTo: lightContainerView.bottomAnchor),
            
            darkColorPreviewView.topAnchor.constraint(equalTo: darkContainerView.topAnchor),
            darkColorPreviewView.leadingAnchor.constraint(equalTo: darkContainerView.leadingAnchor),
            darkColorPreviewView.trailingAnchor.constraint(equalTo: darkContainerView.trailingAnchor),
            darkColorPreviewView.bottomAnchor.constraint(equalTo: darkContainerView.bottomAnchor),
            
            highlightView.topAnchor.constraint(equalTo: contentView.topAnchor),
            highlightView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            highlightView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            highlightView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    @objc private func didTapColor(isDark: Bool) {
        guard let nodeName, let color else { return }
        
        let resolvedColor = color.resolvedColor(
            with: UITraitCollection(userInterfaceStyle: isDark ? .dark : .light)
        )
        delegate?.didTapColorToken(nameToken: nodeName, color: resolvedColor, isDark: isDark)
    }
    
    @objc private func didTapLightColor() {
        didTapColor(isDark: false)
    }
    
    @objc private func didTapDarkColor() {
        didTapColor(isDark: true)
    }
}


// MARK: - ColorValuePreviewView

final class ColorValuePreviewView: UIView {
    
    // MARK: - Private properties
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1 / UIScreen.main.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentInsets: UIEdgeInsets
    
    // MARK: - Lifecycles
    
    init(contentInsets: UIEdgeInsets) {
        self.contentInsets = contentInsets
        
        super.init(frame: .zero)
        
        addSubview(contentView)
        [
            hexLabel,
            colorView
        ].forEach(contentView.addSubview)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    func render(color: UIColor, isDark: Bool) {
        let alphaString = color.cgColor.alpha == 1 ? "" : " \(Int(color.cgColor.alpha * 100))%"
        hexLabel.text = "\(color.hexString)\(alphaString)"
        colorView.backgroundColor = color
        
        colorView.layer.borderColor = (isDark ? UIColor.white : UIColor.black).cgColor
        hexLabel.textColor = isDark ? .white : .black
    }
    
    // MARK: - Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom),
            
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.widthAnchor.constraint(equalToConstant: previewColorSize.width),
            colorView.heightAnchor.constraint(equalToConstant: previewColorSize.height),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            hexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
