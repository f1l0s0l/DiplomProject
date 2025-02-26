import UIKit

final class SelectThemesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Private properties
    
    private let viewModel: SelectThemesViewModel
    
    private let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycles
    
    init(viewModel: SelectThemesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
                
        tableView.delegate = self
        tableView.dataSource = self
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        bindViewModel()
        updateColors()
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.showNavBar()
    }
    
    private func updateColors() {
        view.backgroundColor = viewModel.themeProvider.navigationBarTheme.background
        tableView.backgroundColor = viewModel.themeProvider.commonTheme.background.grouped
        
        tableView.indexPathsForVisibleRows?
            .compactMap(tableView.cellForRow)
            .forEach { $0.backgroundColor = viewModel.themeProvider.commonTheme.background.surface }
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .initial:
                break
            case .updateTheme:
                tableView.performBatchUpdates {
                    let oldSelectedCell = self.tableView.cellForRow(at: IndexPath(row: self.viewModel.oldIndex, section: 0))
                    let selectedCell = self.tableView.cellForRow(at: IndexPath(row: self.viewModel.selectedIndex, section: 0))
                    
                    oldSelectedCell?.accessoryView = nil
                    selectedCell?.accessoryView = self.checkmarkImageView
                    self.updateColors()
                }
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.themeTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        
        let themeType = viewModel.themeTypes[indexPath.row]
        cell.textLabel?.text = "\(themeType)"
        
        checkmarkImageView.tintColor = viewModel.themeProvider.commonTheme.icon.themed
        checkmarkImageView.backgroundColor = .clear
        cell.accessoryView = viewModel.selectedIndex == indexPath.row ? checkmarkImageView : nil
        
        cell.backgroundColor = viewModel.themeProvider.commonTheme.background.surface
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.selectThemes(index: indexPath.row)
    }
}
