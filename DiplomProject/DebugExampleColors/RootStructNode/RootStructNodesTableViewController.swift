import UIKit

final class RootStructNodesCollectionViewController: UICollectionViewController {
    
    // MARK: - Private properties
    
    private let themeName: String
    private let rootNodes: [StructNode]
    private let canEdit: Bool
    
    private weak var coordinator: ExampleColorsCoordinatorProtocol?
    
    // MARK: - Lifecycles
    
    init(themeName: String, rootNodes: [StructNode], coordinator: ExampleColorsCoordinatorProtocol?, canEdit: Bool) {
        self.themeName = themeName
        self.rootNodes = rootNodes.sorted { $0.name < $1.name }
        self.coordinator = coordinator
        self.canEdit = canEdit
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(cellClass: SimpeCollectionViewCell.self)
        collectionView.registerHeader(HeaderSeparatorCollectionReusableView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(1)
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
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rootNodes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(class: SimpeCollectionViewCell.self, for: indexPath)
        let node = rootNodes[indexPath.row]
        cell.label.text = node.name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableHeader(HeaderSeparatorCollectionReusableView.self, for: indexPath)
         return header
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let node = rootNodes[indexPath.row]
        coordinator?.openNode(node: node, path: [], themeName: themeName, canEdit: canEdit)
    }
}
