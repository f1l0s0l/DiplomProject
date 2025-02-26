import UIKit

final class ThemesCollectionViewController: UICollectionViewController {
    
    // MARK: - Private properties

    private var themeNames: [String]
    private var rootNodes: [String: [StructNode]]
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private weak var coordinator: ExampleColorsCoordinatorProtocol?
    
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
    
    // MARK: - Lifecycles
    
    init(themesDict: [String: [StructNode]], coordinator: ExampleColorsCoordinatorProtocol?) {
        themeNames = themesDict.map(\.key).sorted()
        rootNodes = themesDict
        self.coordinator = coordinator
        
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
        
        title = "Themes"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTheme))
        
        collectionView.addSubview(saveButton)
        
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        saveButton.frame = collectionView.bounds
            .divided(atDistance: 100, from: .maxYEdge).slice
            .inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 50, right: 15))
    }
    
    @objc private func addNewTheme() {
        let alertController = UIAlertController(title: "Выберите тему для копирования", message: nil, preferredStyle: .actionSheet)
        
        let actions = themeNames.map { themeName in
            UIAlertAction(title: themeName, style: .default) { _ in
                self.copyTheme(themeName: themeName)
            }
        }
        actions.forEach(alertController.addAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func copyTheme(themeName: String, tryCount: Int = 1) {
        // сохранить в юсер дефолтс
        guard let rootStruts = rootNodes[themeName] else { return } // TODO: это просто ссылка, нужно создать копию!!
        
        let copyThemeName = "\(themeName)_копия_\(tryCount)"
        guard rootNodes[copyThemeName] == nil else {
            copyTheme(themeName: themeName, tryCount: tryCount + 1)
            return
        }
        themeNames.append(copyThemeName)
        rootNodes[copyThemeName] = rootStruts
        collectionView.reloadData()
    }
    
    @objc private func didTapSaveButton() {
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        themeNames.count
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(class: SimpeCollectionViewCell.self, for: indexPath)
        let themeName = themeNames[indexPath.row]
        cell.label.text = themeName
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
        
        let themeName = themeNames[indexPath.row]
        let rootNodes = rootNodes[themeName]!
        
        let canEdit = themeName.contains("_копия_")
        coordinator?.openTheme(themeName: themeName, rootStruts: rootNodes, canEdit: canEdit)
    }
}
