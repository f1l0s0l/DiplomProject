import UIKit
import FirebaseFirestore

final class FeedViewController: UICollectionViewController {
    
    // MARK: - Private properties
    
    private let viewModel: FeedViewModel
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private let backgroundLoadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self else { return nil }
            
            return makeCollectionLayoutSection(for: sectionIndex)
        }
        return layout
    }()
    
    // MARK: - Lifecycles
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        
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
        self.collectionView.refreshControl = refreshControl
        
//        test(timestamp: 100000)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()
        
        collectionView.addSubview(backgroundLoadingView)
        collectionView.addSubview(activityIndicatorView)

        setupConstraints()
        
        refreshControl.addTarget(self, action: #selector(refreshControlHendler), for: .valueChanged)
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadPosts()
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                break
            case .initialLoading:
                updateActivityIndiator(started: true)
            case .loading:
                break
            case .loaded:
                updateActivityIndiator(started: false)
                collectionView.reloadData()
            case .updateTheme:
                applyTheme()
                collectionView.reloadData()
            case .wrong:
                updateActivityIndiator(started: false)
            }
        }
    }
    
    private func updateActivityIndiator(started: Bool) {
        if started {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
            refreshControl.endRefreshing()
        }
        
        backgroundLoadingView.isHidden = started ? false : true
        activityIndicatorView.isHidden = started ? false : true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundLoadingView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundLoadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func refreshControlHendler() {
        viewModel.loadPosts()
    }
    
    private func applyTheme() {
        collectionView.backgroundColor = viewModel.themeProvider.commonTheme.background.surface
    }
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
            return viewModel.stories.count
        case .feed:
            return viewModel.items.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .stories:
            let story = viewModel.stories[indexPath.item]
            let cell = collectionView.dequeueReusableCell(class: FeedStoriesCollectionCell.self, for: indexPath)
            cell.render(story: story)
            return cell
        case .feed:
            let item = viewModel.items[indexPath.item]
            switch item {
            case .post(let postId):
                let post = viewModel.posts[postId]!
                let user = viewModel.users[post.authorId]!
                
                let cell = collectionView.dequeueReusableCell(class: FeedPostCollectionCell.self, for: indexPath)
                cell.render(post: post, author: user, themeProvider: viewModel.themeProvider)
                return cell
            case .date(let date):
                let cell = collectionView.dequeueReusableCell(class: FeedDateCollectionCell.self, for: indexPath)
                cell.render(date: date, themeProvider: viewModel.themeProvider)
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
                heightDimension: .estimated(200)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
//            section.interGroupSpacing = 1
            
            section.interGroupSpacing = 10
            return section
        }
    }
}


func test(timestamp: Int) {
    let db = Firestore.firestore()

    db.collection("posts").addDocument(data: [
        "authorId": "UHwc5gRdVObEFnb66qymee9Exim1",
        "autorName": "user1",
        "commentsCount": 0,
        "imageURL": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBkJigufyq00dk5hZq_acK0ix6Gq5LMj59Kg&s",
        "text": "Это мой первый пост, не судите строго, пожалуйста!\nЧто бы мне рассказать про себя интересного?\nЭто третья строчка!\nЭто уже четвертая!\nА вот и пятая пошла\nИ шестая!",
        "timestamp": 1709318120 + timestamp // 6 знаков
    ]) { error in
        if let error = error {
            print("Ошибка при добавлении документа: \(error.localizedDescription)")
        } else {
            print("Документ успешно добавлен!")
        }
    }
}
