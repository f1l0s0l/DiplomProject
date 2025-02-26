import UIKit

final class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Private properties
    
    private let viewModel: SettingsViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let userHeaderView: SettingsHeaderView = {
        let headerView = SettingsHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    // MARK: - Lifecycles
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(userHeaderView)
                
        applyTheme()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        
        setupConstraints()
        
        userHeaderView.render(user: viewModel.user, themeProvider: viewModel.themeProvider)
        
        NotificationCenter.default.addObserver(forName: ThemeProvider.didChangeThemeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            applyTheme()
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.hideNavBar()
    }
    
    // MARK: - Private methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userHeaderView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func applyTheme() {
        tableView.backgroundColor = viewModel.themeProvider.commonTheme.background.grouped
        view.backgroundColor = viewModel.themeProvider.commonTheme.background.grouped
        
        userHeaderView.render(user: viewModel.user, themeProvider: viewModel.themeProvider)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)!
        
        switch section {
        case .fisrt:
            return 1
        case .signOut:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        let themeProvider = viewModel.themeProvider
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        switch section {
        case .fisrt:
            cell.leftIconImageView.image = UIImage(systemName: "paintbrush")
            cell.leftIconImageView.tintColor = themeProvider.commonTheme.icon.themed
            
            cell.rightIconImageView.image = UIImage(systemName: "chevron.right")
            cell.rightIconImageView.tintColor = themeProvider.commonTheme.icon.secondary
            
            cell.titleLabel.text = "Оформление"
            cell.titleLabel.textAlignment = .left
            cell.titleLabel.textColor = themeProvider.commonTheme.text.primary
        case .signOut:
            cell.leftIconImageView.image = nil
            cell.rightIconImageView.image = nil
            
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.text = "Выйти из профиля"
            cell.titleLabel.textColor = themeProvider.commonTheme.text.negative
        }
        
        cell.backgroundColor = themeProvider.commonTheme.background.surface
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch Section(rawValue: indexPath.section)! {
        case .fisrt:
            viewModel.didTapThemes()
        case .signOut:
            viewModel.signOut()
        }
    }
}

// MARK: - Section

extension SettingsViewController {
    enum Section: Int, CaseIterable {
        case fisrt
        case signOut
    }
}
