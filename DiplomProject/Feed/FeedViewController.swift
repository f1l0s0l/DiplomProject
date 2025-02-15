import UIKit

final class FeedViewController: UICollectionViewController {
    
    // MARK: - Private properties
    private let model: FeedViewModel
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self else { return nil }
            
            return makeCollectionLayoutSection(for: sectionIndex)
        }
        return layout
    }()
    
    // MARK: - Lifecycles
    
    init(model: FeedViewModel) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
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
            return model.stories.count
        case .feed:
            return model.items.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .stories:
            let story = model.stories[indexPath.item]
            let cell = collectionView.dequeueReusableCell(class: FeedStoriesCollectionCell.self, for: indexPath)
            cell.render(story: story)
            return cell
        case .feed:
            let item = model.items[indexPath.item]
            switch item {
            case .post(let post):
                let cell = collectionView.dequeueReusableCell(class: FeedPostCollectionCell.self, for: indexPath)
                cell.render(post: post)
                return cell
            case .date(let dateString):
                let cell = collectionView.dequeueReusableCell(class: FeedDateCollectionCell.self, for: indexPath)
                cell.render(date: dateString)
                return cell
            }
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
            section.interGroupSpacing = 1
            return section
        }
    }
}
