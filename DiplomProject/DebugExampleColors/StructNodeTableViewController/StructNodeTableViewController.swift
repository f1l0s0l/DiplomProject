import UIKit

protocol ColorEditorDelegate: AnyObject {
    func didTapColorToken(nameToken: String, color: UIColor, isDark: Bool)
}

final class StructNodeTableViewController: UICollectionViewController {
    
    // MARK: - Private properties
    
    private let rootNode: StructNode
    private let childrenNodeNames: [String]
    private let path: [String]
    
    private let canEdit: Bool
    
    private weak var coordinator: ExampleColorsCoordinatorProtocol?
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            header.pinToVisibleBounds = true
            
            section.boundarySupplementaryItems = [header]
            return section
        }
    }()
    
    // MARK: - Lifecycles
    
    init(node: StructNode, path: [String], coordinator: ExampleColorsCoordinatorProtocol?, canEdit: Bool) {
        rootNode = node
        childrenNodeNames = rootNode.children
            .sorted { $0.value.children.count > $1.value.children.count }
            .map(\.key)
        
        self.path = path + [rootNode.name]
        self.coordinator = coordinator
        self.canEdit = canEdit
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(cellClass: SimpeCollectionViewCell.self)
        collectionView.register(cellClass: ColorTokenCollectionCell.self)
        collectionView.register(cellClass: ColorsGradientCollectionCell.self)
        collectionView.registerHeader(PathHeaderView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .white
        view.backgroundColor = .white
        
        collectionView.alwaysBounceVertical = true
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        childrenNodeNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let nodeName = childrenNodeNames[indexPath.item]
        let node = rootNode.children[nodeName]!
        
        if let nodeValue = node.value {
            switch nodeValue {
            case .color(let color):
                let cell = collectionView.dequeueReusableCell(class: ColorTokenCollectionCell.self, for: indexPath)
                cell.render(nodeName: node.name, color: color)
                cell.delegate = self
                return cell
            case .gradientColors(let colors):
                let cell = collectionView.dequeueReusableCell(class: ColorsGradientCollectionCell.self, for: indexPath)
                cell.render(gradientColors: colors, nodeName: node.name)
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(class: SimpeCollectionViewCell.self, for: indexPath)
            cell.label.text =  "/ \(node.name.splitCamelCase)"
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableHeader(PathHeaderView.self, for: indexPath)
        header.render(path: path)
        return header
    }
    
    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let nodeName = childrenNodeNames[indexPath.row]
        let node = rootNode.children[nodeName]!
        
        if node.value == nil {
            coordinator?.openNode(node: node, path: path, themeName: title ?? "", canEdit: canEdit)
        }
    }
    
    // MARK: - Private methods
    
    private func updateGradientColorsIfNeeded() {
        guard let gradientNode = rootNode.children.map(\.value).first(where: {$0.name.contains("gradient")}) else {
            return
        }
        
        let colors = rootNode.children.compactMap(\.value.value?.color)
        gradientNode.value = .gradientColors(colors)
    }
}

// MARK: - ColorEditorDelegate

extension StructNodeTableViewController: ColorEditorDelegate {
    func didTapColorToken(nameToken: String, color: UIColor, isDark: Bool) {
        guard canEdit else { return }
        guard let node = rootNode.children[nameToken],
              let value = node.value,
              case let .color(dinamicColor) = value else { return }
        
        coordinator?.openColorPicker(selectedColor: color) { [weak self] color in
            guard let self else { return }
            
            let newColor = UIColor(
                light: isDark
                ? dinamicColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
                : color,
                dark: isDark
                ? color
                : dinamicColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
            )
            
            node.value = .color(newColor)
            updateGradientColorsIfNeeded()
            collectionView.reloadData()
            coordinator?.pop()
        }
    }
}
