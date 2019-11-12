//
//  P_TableViewControllerMultipleSectionPresenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 11.11.2019.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

protocol P_TableViewControllerMultipleSectionPresenter: P_TableViewControllerPresenter {

    var cellPresenters: [[CELL.PRESENTER]] { get set }
    var items: [[ITEM]] { get set }
    
//    func setItems(_ items: [[ITEM]])
//    func resetItems()
//    func reloadItems()
//    func appendItem(_ item: ITEM, section: Int)
//    func insertItem(_ item: ITEM, atIndexPath indexPath: IndexPath)
//    func moveItem(indexPath: IndexPath, toIndexPath: IndexPath)
//    func removeItem(atIndexPath indexPath: IndexPath)
//    func reloadItem(atIndexPath indexPath: IndexPath)
    
}

extension P_TableViewControllerMultipleSectionPresenter {
    
    func setItems(_ items: [[ITEM]]) {
        self.items = items
        cellPresenters = items.compactMap { $0.compactMap { cellConfig($0) } }
        tableView?.reloadData()
    }
    
    func resetItems() {
        items.removeAll()
        cellPresenters.removeAll()
        tableView?.reloadData()
    }
    
    func reloadItems() {
        cellPresenters = items.compactMap { $0.compactMap { cellConfig($0) } }
        tableView?.reloadData()
    }
    
    func appendItem(_ item: ITEM, section: Int) {
        items[section].append(item)
        let indexPath = IndexPath(row: cellPresenters[section].count, section: section)
        cellPresenters[section].append(cellConfig(item))
        tableView?.insertRows(at: [indexPath], with: .automatic)
    }
    
    func insertItem(_ item: ITEM, atIndexPath indexPath: IndexPath) {
        items[indexPath.section].insert(item, at: indexPath.row)
        cellPresenters[indexPath.section].insert(cellConfig(item), at: indexPath.row)
        tableView?.insertRows(at: [indexPath], with: .automatic)
    }
    
    func moveItem(indexPath: IndexPath, toIndexPath: IndexPath) {
        moveItemWithoutTableViewUpdate(indexPath: indexPath, toIndexPath: toIndexPath)
        tableView?.moveRow(at: indexPath, to: toIndexPath)
    }
    
    func insertItems(_ items: [ITEM], section: Int) {
        self.items.insert(items, at: section)
        cellPresenters.insert(items.compactMap { cellConfig($0) }, at: section)
        tableView?.insertSections(IndexSet(integer: section), with: .automatic)
    }
    
    func removeItems(section: Int) {
        items.remove(at: section)
        cellPresenters.remove(at: section)
        tableView?.deleteSections(IndexSet(integer: section), with: .automatic)
    }
    
    func reloadItems(section: Int) {
        tableView?.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func removeItem(atIndexPath indexPath: IndexPath) {
        items[indexPath.section].remove(at: indexPath.row)
        cellPresenters[indexPath.section].remove(at: indexPath.row)
        tableView?.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func reloadItem(atIndexPath indexPath: IndexPath) {
        cellPresenters[indexPath.section][indexPath.row] = cellConfig(items[indexPath.section][indexPath.row])
        tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func moveItemWithoutTableViewUpdate(indexPath: IndexPath, toIndexPath: IndexPath) {
        items[toIndexPath.section].insert(items[indexPath.section].remove(at: indexPath.row), at: toIndexPath.row)
        cellPresenters[toIndexPath.section].insert(cellPresenters[indexPath.section].remove(at: indexPath.row), at: toIndexPath.row)
    }
    
}

class BaseTableViewControllerMultipleSectionPresenter<
    VIEWCONTROLLER: P_TableViewController,
    CELL: UITableViewCell & P_PresenterConfigurableView,
    ITEM: Equatable
>: BaseTableViewControllerPresenter<VIEWCONTROLLER, CELL, ITEM>, P_TableViewControllerMultipleSectionPresenter {
    
    var cellPresenters = [[CELL.PRESENTER]]()
    var items = [[ITEM]]()
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        cellPresenters.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellPresenters[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.new(CELL.self, presenter: cellPresenters[indexPath.section][indexPath.row])
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        removeItem(atIndexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItemWithoutTableViewUpdate(indexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
    }
    
}
