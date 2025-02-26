import Foundation

final class SelectThemesViewModel {
    
    // MARK: - Public properties
    
    let themeProvider: ThemeProvider
    
    var stateChanged: ((State) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }
    
    private(set) var themeTypes: [CodeGenThemeType] = []
    
    private(set) var selectedIndex: Int
    private(set) var oldIndex: Int
    
    // MARK: - Private properties
    
    private weak var coodrinator: SettingsCoordinatorProtocol?
    
    // MARK: - Lifecycles
    
    init(themeProvider: ThemeProvider, coodrinator: SettingsCoordinatorProtocol?) {
        self.themeProvider = themeProvider
        self.coodrinator = coodrinator
        
        themeTypes = CodeGenThemeType.allCases
        
        let themeType = CodeGenThemeType(rawValue: UserDefaults.standard.object(forKey: "CurrentThemeType") as? Int ?? 0)
                
        selectedIndex = themeTypes.firstIndex { $0 == themeType } ?? 0
        oldIndex = selectedIndex
    }
    
    // MARK: - Public methids
    
    func selectThemes(index: Int) {
        guard selectedIndex != index else { return }
        oldIndex = selectedIndex
        selectedIndex = index
        
        writeToDataBase(selectedThemeType: themeTypes[index])
        state = .updateTheme
    }
    
    func showNavBar() {
        coodrinator?.navBarHidden(false)
    }
    
    // MARK: - Private methods
    
    private func writeToDataBase(selectedThemeType: CodeGenThemeType) {
        UserDefaults.standard.set(selectedThemeType.rawValue, forKey: "CurrentThemeType")
        
        themeProvider.update(themeType: selectedThemeType)
    }
}

// MARK: - State

extension SelectThemesViewModel {
    enum State {
        case initial
        case updateTheme
    }
}
