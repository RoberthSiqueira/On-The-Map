import UIKit

final class TabBarItems {

    // MARK: UI

    lazy var mapTabBarItem: UITabBarItem = {
        let image = UIImage(named: "icon_mapview-deselected")
        let tabBarItem = UITabBarItem(title: nil, image: image, tag: 0)
        tabBarItem.selectedImage = UIImage(named: "icon_mapview-selected")
        return tabBarItem
    }()

    lazy var listTabBarItem: UITabBarItem = {
        let image = UIImage(named: "icon_listview-deselected")
        let tabBarItem = UITabBarItem(title: nil, image: image, tag: 0)
        tabBarItem.selectedImage = UIImage(named: "icon_listview-selected")
        return tabBarItem
    }()
}
