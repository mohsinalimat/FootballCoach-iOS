//
//  PlayerStatHistoryViewController.swift
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/13/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

import UIKit
import AccordionSwift

struct YearCellModel {
    let name: String
}

struct StatCellModel {
    let name: String
    let value: String
}

@objc class PlayerStatHistoryViewController: UITableViewController {
    
    var selectedPlayer: Player?
    
    @objc public init(player: Player) {
        self.selectedPlayer = player
        super.init(style: UITableView.Style.plain)
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.height * (3.0/4.0)))
    }

    required init?(coder aDecoder: NSCoder) {
        self.selectedPlayer = nil
        super.init(coder: aDecoder)
    }

    // MARK: - Typealias
    
    typealias ParentCellModel = Parent<YearCellModel, StatCellModel>
    typealias ParentCellConfig = CellViewConfig<ParentCellModel, UITableViewCell>
    typealias ChildCellConfig = CellViewConfig<StatCellModel, UITableViewCell>
    
    // MARK: - Properties
    
    /// The Data Source Provider with the type of DataSource and the different models for the Parent and Child cell.
    var dataSourceProvider: DataSourceProvider<DataSource<ParentCellModel>, ParentCellConfig, ChildCellConfig>?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        configDataSource()
        navigationItem.title = "Stat History"
        
        self.tableView.register(UINib.init(nibName: "YearCell", bundle: nil), forCellReuseIdentifier: "YearCell")
        self.tableView.register(UINib.init(nibName: "StatCell", bundle: nil), forCellReuseIdentifier: "StatCell")
        
        self.tableView.backgroundColor = HBSharedUtils.styleColor()
    }
    
    
    // MARK: - Methods
    
    /// Configure the data source
    private func configDataSource() {
        var dataset = [Parent<YearCellModel, StatCellModel>]()
        if (selectedPlayer != nil) {
            // sort statHistory by Year
            if (selectedPlayer?.statHistoryDictionary != nil) {
                let years: Array = HBSharedUtils.sortStatHistoryYears((selectedPlayer!.statHistoryDictionary!).allKeys as? [String])
                for (year) in years {
                    let statDict: NSDictionary = (selectedPlayer!.statHistoryDictionary)![year] as! NSDictionary
                    var childItems = [StatCellModel]()
                    // sort children by stat order for position
                    let statKeys: Array = HBSharedUtils.sortStatKeyArray(statDict.allKeys as? [String])
                    //                for (statName, value) in (statDict as! NSDictionary) {
                    //                    childItems.append(StatCellModel(name: HBSharedUtils.convertStatKey(toTitle: statName as? String), value: value as! String))
                    //                }
                    for statName in statKeys {
                        childItems.append(StatCellModel(name: HBSharedUtils.convertStatKey(toTitle: statName as? String), value: statDict[statName] as! String))
                    }
                    let parentItem = Parent(state: .collapsed, item: YearCellModel(name: year as! String), childs: childItems)
                    dataset.append(parentItem)
                }
            }
        }
        
        
        let section0 = Section(dataset, headerTitle: nil)
        let dataSource = DataSource(sections: section0)
        
        let parentCellConfig = CellViewConfig<Parent<YearCellModel, StatCellModel>, UITableViewCell>(
        reuseIdentifier: "YearCell") { (cell, model, tableView, indexPath) -> UITableViewCell in
            cell.textLabel?.text = model?.item.name
            cell.textLabel?.textColor = HBSharedUtils.styleColor()
            return cell
        }
        
        let childCellConfig = CellViewConfig<StatCellModel, UITableViewCell>(
        reuseIdentifier: "StatCell") { (cell, item, tableView, indexPath) -> UITableViewCell in
            cell.textLabel?.text = item?.name
            cell.detailTextLabel?.text = item?.value
            cell.detailTextLabel?.textColor = UIColor.lightGray
            cell.selectionStyle = .none
            return cell
        }
        
        let didSelectParentCell = { (tableView: UITableView, indexPath: IndexPath, item: ParentCellModel?) -> Void in
            //print("Parent cell \(item!.item.name) tapped")
            tableView.deselectRow(at: indexPath, animated: true)
        }
//
//        let didSelectChildCell = { (tableView: UITableView, indexPath: IndexPath, item: StatCellModel?) -> Void in
//            print("Child cell \(item!.name) tapped")
//        }
        
        dataSourceProvider = DataSourceProvider(
            dataSource: dataSource,
            parentCellConfig: parentCellConfig,
            childCellConfig: childCellConfig,
            didSelectParentAtIndexPath: didSelectParentCell//,
//            didSelectChildAtIndexPath: didSelectChildCell
        )
        
        tableView.dataSource = dataSourceProvider?.tableViewDataSource
        tableView.delegate = dataSourceProvider?.tableViewDelegate
        tableView.tableFooterView = UIView()
    }

}

extension PlayerStatHistoryViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Stat History", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17.0),
            NSAttributedString.Key.foregroundColor : UIColor.lightText,
        ])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        return NSAttributedString(string: "This player hasn't played a full season yet. Check back here for his year-by-year stats once he's progressed in his career!", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0),
            NSAttributedString.Key.foregroundColor : UIColor.lightText,
            NSAttributedString.Key.paragraphStyle : paragraphStyle
        ])
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return HBSharedUtils.styleColor()
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0.0
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0.0
    }
}

extension PlayerStatHistoryViewController : DZNEmptyDataSetDelegate {
    
}
