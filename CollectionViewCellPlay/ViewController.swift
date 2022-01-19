//
//  ViewController.swift
//  CollectionViewCellPlay
//
//  Created by CodeSpyder on 1/19/22.
//

import UIKit

private enum Section: Hashable {
    case main
}

private struct Item {
    let uuid = UUID()
    let title: String?
    let description: String?
    let image: String?
    init(title: String? = nil, description: String? = nil, image: String? = nil) {
        self.title = title
        self.description = description
        self.image = image
    }
}

extension Item: Hashable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.image == rhs.image
        && lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(image)
        hasher.combine(uuid)
    }
}

class ViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private var collectionView: UICollectionView! = nil
    
    fileprivate var items = [Item()]
    var copper: UIColor {
        return UIColor(red: 184/255, green: 115/255, blue: 51/255, alpha: 1.0)  // Copper
    }

    var silver: UIColor {
        return UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)  // Silver
    }

    var gold: UIColor {
        return UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0)  // Gold
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        items = [Item(title: "Jungle Cruise at Shrunken Ned's", description: "4 Die Hand Crank Electric - Penny"), Item(title: "Plaza Del Sol Caribe Bazar", description: "Medallion Machine - Medallion"), Item(title: "Plaza Del Sol Caribe Bazar", description: "8 Die Touch Screen - Penny"), Item(title: "Verandah Breezeway", description: "8 Die Touch Screen - Penny")]
        
        configureHierarchy()
        configureDataSource()
        setSnapshot()
    }
}

extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.headerMode = .firstItemInSection
        config.backgroundColor = .systemGray5
        config.showsSeparators = false
        var separatorConfig = UIListSeparatorConfiguration(listAppearance: .grouped)
        separatorConfig.topSeparatorInsets = .init(top: 10.0, leading: 0, bottom: 2.0, trailing: 0)
        separatorConfig.bottomSeparatorInsets = .init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0)
        config.separatorConfiguration = separatorConfig
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension ViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    private func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.groupedHeader()
            content.textProperties.color = .black
            content.text = item.title
            cell.contentConfiguration = content
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            // Set a white background color to use the cell's tint color.
            backgroundConfig.backgroundColor = .white
            cell.backgroundConfiguration = backgroundConfig
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.cell()
            content.text = item.title!
            content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
            content.textProperties.color = .white
            content.textProperties.alignment = .center
            content.secondaryText = item.description!
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            content.secondaryTextProperties.color = .white
            content.secondaryTextProperties.alignment = .center
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 13, leading: 2, bottom: 13, trailing: 2)
            cell.contentConfiguration = content
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            
            backgroundConfig.backgroundColor = self.copper
            if indexPath.row == 2 {
                backgroundConfig.backgroundColor = UIColor(named: "AppGreen")
            }
            backgroundConfig.cornerRadius = 10
            backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
            cell.backgroundConfiguration = backgroundConfig
            let accessory = UICellAccessory.disclosureIndicator(displayed: .always, options: .init(tintColor: .white))
            cell.accessories = [accessory]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            if indexPath.row == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    private func setSnapshot() {
        // initial data
        // main Items
        var mainSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let mainHeader = Item(title: "Machines", description: "", image: "")
        mainSnapshot.append([mainHeader])
        mainSnapshot.append(items)
        dataSource.apply(mainSnapshot, to: .main, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? CustomMenuCell {
//            if var content = cell.contentConfiguration as? UIListContentConfiguration {
//                content.textProperties.color = .black
//                content.secondaryTextProperties.color = .black
//                cell.contentConfiguration = content
//            }
//
//            if var backgroundConfig = cell.backgroundConfiguration {
//                // Set a green background color to use the cell's tint color.
//                backgroundConfig.backgroundColor = .lightGray.withAlphaComponent(0.3)
//                cell.backgroundConfiguration = backgroundConfig
//            }
//
//            let accessory = UICellAccessory.disclosureIndicator(displayed: .always, options: .init(tintColor: .black))
//            cell.accessories = [accessory]
//        }
////        collectionView.deselectItem(at: indexPath, animated: true)
//    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? CustomMenuCell {
//            if var content = cell.contentConfiguration as? UIListContentConfiguration {
//                content.textProperties.color = .white
//                content.secondaryTextProperties.color = .white
//                cell.contentConfiguration = content
//            }
//
//            if var backgroundConfig = cell.backgroundConfiguration {
//                // Set a green background color to use the cell's tint color.
//                backgroundConfig.backgroundColor = self.copper
//                if indexPath.row == 2 {
//                    backgroundConfig.backgroundColor = .blue
//                }
//                cell.backgroundConfiguration = backgroundConfig
//            }
//
//            let accessory = UICellAccessory.disclosureIndicator(displayed: .always, options: .init(tintColor: .white))
//            cell.accessories = [accessory]
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewListCell {
            if var content = cell.contentConfiguration as? UIListContentConfiguration {
                content.textProperties.color = .black
                content.secondaryTextProperties.color = .black
                cell.contentConfiguration = content
            }
            
            if var backgroundConfig = cell.backgroundConfiguration {
                // Set a green background color to use the cell's tint color.
                backgroundConfig.backgroundColor = .lightGray.withAlphaComponent(0.3)
                cell.backgroundConfiguration = backgroundConfig
            }
            
            let accessory = UICellAccessory.disclosureIndicator(displayed: .always, options: .init(tintColor: .black))
            cell.accessories = [accessory]
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewListCell {
            if var content = cell.contentConfiguration as? UIListContentConfiguration {
                content.textProperties.color = .white
                content.secondaryTextProperties.color = .white
                cell.contentConfiguration = content
            }
            
            if var backgroundConfig = cell.backgroundConfiguration {
                // Set a green background color to use the cell's tint color.
                backgroundConfig.backgroundColor = self.copper
                if indexPath.row == 2 {
                    backgroundConfig.backgroundColor = UIColor(named: "AppGreen")
                }
                cell.backgroundConfiguration = backgroundConfig
            }
            
            let accessory = UICellAccessory.disclosureIndicator(displayed: .always, options: .init(tintColor: .white))
            cell.accessories = [accessory]
        }
    }
}

