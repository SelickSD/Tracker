//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Сергей Денисенко on 08.03.2024.
//

import Foundation
typealias Binding<T> = (T) -> Void

final class CategoryViewModel {

    var isCategoryEmpty: Binding<Bool>?
    var isCategoryUpdated: Binding<Bool>?
    var isCategorySelected: Binding<Bool>?

    weak var delegate: CategoryViewControllerDelegate?
    private var myCell: MainTableViewCellProtocol
    private var index: Int?
    private var doneIndex: IndexPath?

    private let categoryDataStore: CategoryDataStore

    init(for model: CategoryDataStore, myCell: MainTableViewCellProtocol, index: Int?) {
        self.categoryDataStore = model
        self.myCell = myCell
        self.index = index
    }

    func checkInitialStatus() {
        guard let categories = categoryDataStore.getObjects() else { return }
        isCategoryEmpty?(categories.isEmpty)
    }

    func updateCategory(name: String) {
        categoryDataStore.createNewCategory(name: name)
        guard let categories = categoryDataStore.getCategoriesStringName() else {return}
        delegate?.fetchCategory(index: index, categories: categories)
        isCategoryEmpty?(false)
        isCategoryUpdated?(true)
    }

    func numberOfRowsInSection() -> Int {
        guard let numberOfRowsInSection = categoryDataStore.getCategoriesStringName() else {return 0}
        return numberOfRowsInSection.count
    }

    func categoryOfIndex(index: Int) -> String {
        guard let categoryOfIndex = categoryDataStore.getCategoriesStringName() else {return ""}
        return categoryOfIndex[index]
    }

    func delegateChange() {
        guard let targetCell = myCell as? MainTableViewCell,
              let categories = categoryDataStore.getCategoriesStringName() else {return}
        guard let done = doneIndex else {
            targetCell.discardChanges()
            delegate?.fetchCategory(index: nil, categories: categories)
            return
        }
        targetCell.configLabel(newLabelText: categories[done.row])
        delegate?.fetchCategory(index: done.row, categories: categories)

    }

    func getDoneIndexPath() -> IndexPath? {
        return doneIndex
    }

    func setDoneIndexPath(indexPath: IndexPath?) {
        self.doneIndex = indexPath
        indexPath != nil ? isCategorySelected?(true) : isCategorySelected?(false)
    }

    func getStartIndex() -> Int? {
        return index
    }
}
