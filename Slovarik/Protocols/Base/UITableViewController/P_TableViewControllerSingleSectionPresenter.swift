//
//  P_TableViewControllerPresenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 10.11.2019.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

protocol P_TableViewControllerSingleSectionPresenter: P_TableViewControllerPresenter {

    var cellPresenters: [CELL.PRESENTER] { get set }
    var items: [ITEM] { get set }
    
//    func setItems(_ items: [ITEM])
//    func resetItems()
//    func reloadItems()
//    func appendItem(_ item: ITEM)
//    func insertItem(_ item: ITEM, atIndex index: Int)
//    func moveItem(index: Int, toIndex: Int)
//    func removeItem(atIndex index: Int)
//    func reloadItem(atIndex index: Int)
    
}
extension P_TableViewControllerSingleSectionPresenter {
    
    func setItems(_ items: [ITEM]) {
        self.items = items
        cellPresenters = items.compactMap { cellConfig($0) }
        tableView?.reloadData()
    }
    
    func resetItems() {
        items.removeAll()
        cellPresenters.removeAll()
        tableView?.reloadData()
    }
    
    func reloadItems() {
        cellPresenters = items.compactMap { cellConfig($0) }
        tableView?.reloadData()
    }
    
    func appendItem(_ item: ITEM) {
        items.append(item)
        let indexPath = IndexPath(row: cellPresenters.count, section: 0)
        cellPresenters.append(cellConfig(item))
        tableView?.insertRows(at: [indexPath], with: .automatic)
    }
    
    func insertItem(_ item: ITEM, atIndex index: Int) {
        items.insert(item, at: index)
        let indexPath = IndexPath(row: index, section: 0)
        cellPresenters.insert(cellConfig(item), at: index)
        tableView?.insertRows(at: [indexPath], with: .automatic)
    }
    
    func moveItem(index: Int, toIndex: Int) {
        guard index != toIndex else { return }
        moveItemWitoutTableViewUpdate(atIndex: index, toIndex: toIndex)
        tableView?.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: toIndex, section: 0))
    }
    
    func removeItem(atIndex index: Int) {
        items.remove(at: index)
        cellPresenters.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView?.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func reloadItem(atIndex index: Int) {
        cellPresenters[index] = cellConfig(items[index])
        let indexPath = IndexPath(row: index, section: 0)
        tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func moveItemWitoutTableViewUpdate(atIndex: Int, toIndex: Int) {
        items.insert(items.remove(at: atIndex), at: toIndex)
        cellPresenters.insert(cellPresenters.remove(at: atIndex), at: toIndex)
    }
    
    func configuredCell(atIndexPath indexPath: IndexPath) -> CELL {
        tableView.new(CELL.self, presenter: cellPresenters[indexPath.row])
    }
    
}

class BaseTableViewControllerSingleSectionPresenter<
    VIEWCONTROLLER: P_TableViewController,
    CELL: UITableViewCell & P_PresenterConfigurableView,
    DATA: Equatable
>: BaseTableViewControllerPresenter<VIEWCONTROLLER, CELL, DATA>, P_TableViewControllerSingleSectionPresenter {
    
    var cellPresenters = [CELL.PRESENTER]()
    var items = [ITEM]()
        
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellPresenters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configuredCell(atIndexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        removeItem(atIndex: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItemWitoutTableViewUpdate(atIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
}
