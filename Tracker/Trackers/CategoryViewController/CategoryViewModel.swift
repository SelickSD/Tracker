//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Сергей Денисенко on 08.03.2024.
//

import Foundation
typealias Binding<T> = (T) -> Void

final class CategoryViewModel: CategoryViewModelProtocol {

    var isCategoryEmpty: Binding<Bool>?
    var isCategoryUpdated: Binding<Bool>?
    var isCategorySelected: Binding<Bool>?

    weak var delegate: CategoryViewControllerDelegate?
    private var index: Int?
    private var doneIndex: IndexPath?

    private let categoryDataStore: CategoryDataStore

    init(for model: CategoryDataStore, index: Int?) {
        self.categoryDataStore = model
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
        guard let categories = categoryDataStore.getCategoriesStringName() else {return}
        guard let done = doneIndex else {
            delegate?.fetchCategory(index: nil, categories: categories)
            return
        }
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
