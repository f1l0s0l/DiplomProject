import UIKit

protocol ExampleColorsCoordinatorProtocol: AnyObject {
    func openTheme(themeName: String, rootStruts: [StructNode], canEdit: Bool)
    func openNode(node: StructNode, path: [String], themeName: String, canEdit: Bool)
    func openColorPicker(selectedColor: UIColor, completion: ((UIColor) -> Void)?)
    func pop()
}

final class ExampleColorsCoordinator {
    
    // MARK: - Private properties
    
    private var navigationController: UINavigationController
    private var childCoordinators: [Coordinator] = []
    
    private let themeProvider: ThemeProvider
        
    // MARK: - Lifecycles
    
    init(themeProvider: ThemeProvider) {
        self.themeProvider = themeProvider
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .white
        
        let navController = UINavigationController()
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController = navController
    }
    
    // MARK: - Private methods
    
    private func addChildCoordinator(_ coordinator: Coordinator) {
        guard !self.childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        self.childCoordinators.append(coordinator)
    }
    
    private func removeChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators.removeAll(where: {$0 === coordinator})
    }
    
    private func createThemes() -> [String: [StructNode]] {
        let simpleTheme: [StructNode] = [
            StructNode.convertToStructNode(CommonTheme.bumble),
            StructNode.convertToStructNode(NavigationBarTheme.bumble),
            StructNode.convertToStructNode(TabBarTheme.bumble),
        ]

        let leavesTheme: [StructNode] = [
            StructNode.convertToStructNode(CommonTheme.monochrome),
            StructNode.convertToStructNode(NavigationBarTheme.monochrome),
            StructNode.convertToStructNode(TabBarTheme.monochrome),
        ]

        return [
            "bumble": simpleTheme,
            "monochrome": leavesTheme
        ]
    }
}

// MARK: - Coordinator

extension ExampleColorsCoordinator: Coordinator {
    func start() -> UIViewController {
        let themes = createThemes()
        let themesViewController = ThemesCollectionViewController(themesDict: themes, coordinator: self)
        navigationController.setViewControllers([themesViewController], animated: false)
        return navigationController
    }
}

// MARK: - ExampleColorsCoordinatorProtocol

extension ExampleColorsCoordinator: ExampleColorsCoordinatorProtocol {
    func openTheme(themeName: String, rootStruts: [StructNode], canEdit: Bool) {
        let rootNodesViewController = RootStructNodesCollectionViewController(themeName: themeName, rootNodes: rootStruts, coordinator: self, canEdit: canEdit)
        rootNodesViewController.title = themeName
        rootNodesViewController.navigationItem.backButtonTitle = ""
        
        navigationController.pushViewController(rootNodesViewController, animated: true)
    }
    
    func openNode(node: StructNode, path: [String], themeName: String, canEdit: Bool) {
        let nodeViewController = StructNodeTableViewController(node: node, path: path, coordinator: self, canEdit: canEdit)
        nodeViewController.title = themeName
        nodeViewController.navigationItem.backButtonTitle = ""
        
        navigationController.pushViewController(nodeViewController, animated: true)
    }
    
    func openColorPicker(selectedColor: UIColor, completion: ((UIColor) -> Void)?) {
        let colorPickerViewController = ColorPickerViewController(selectedColor: selectedColor)
        colorPickerViewController.didSetColor = completion
        navigationController.pushViewController(colorPickerViewController, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
