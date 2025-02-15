import UIKit

final class FeedViewController: UICollectionViewController {
    
    // MARK: - Private properties
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self else { return nil }
            
            return makeCollectionLayoutSection(for: sectionIndex)
        }
        return layout
    }()
    
    // MARK: - Lifecycles
    
    override func loadView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        [
            FeedStoriesCollectionCell.self,
            FeedDateCollectionCell.self,
            FeedPostCollectionCell.self
        ].forEach(collectionView.register)
        
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
    
    // MARK: - Private methods
}

// MARK: - DataSource

extension FeedViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = Section(rawValue: section)!
        switch section {
        case .stories:
            return 30
        case .feed:
            return 50
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .stories:
            let cell = collectionView.dequeueReusableCell(class: FeedStoriesCollectionCell.self, for: indexPath)
            cell.backgroundColor = .green
            return cell
        case .feed:
            let cell = collectionView.dequeueReusableCell(class: FeedPostCollectionCell.self, for: indexPath)
            cell.backgroundColor = .yellow
            return cell
        }
    }
}

// MARK: - Section

extension FeedViewController {
    enum Section: Int, CaseIterable {
        case stories
        case feed
    }
}

// MARK: - CompositionalLayout

extension FeedViewController {
    func makeCollectionLayoutSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let section = Section(rawValue: sectionIndex)!
        switch section {
        case .stories:
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(80))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .feed:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            return section
        }
    }
}
