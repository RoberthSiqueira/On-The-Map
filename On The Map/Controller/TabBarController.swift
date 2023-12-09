import UIKit

class TabBarController: UITabBarController {

    // MARK: - Properties

    let tabBarItems = TabBarItems()

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewControllers()
    }

    // MARK: - Methods

    private func setupViewControllers() {
        let mapVC = UIViewController()
        let listVC = UIViewController()

        let mapNavigationController = UINavigationController(rootViewController: mapVC)
        let listNavigationController = UINavigationController(rootViewController: listVC)

        mapNavigationController.tabBarItem = tabBarItems.mapTabBarItem
        listNavigationController.tabBarItem = tabBarItems.listTabBarItem

        let navigationControllers = [mapNavigationController, listNavigationController]

        setViewControllers(navigationControllers, animated: true)
        selectedViewController = navigationControllers[0]
    }
}
