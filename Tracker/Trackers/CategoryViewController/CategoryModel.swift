//
//  CategoryModel.swift
//  Tracker
//
//  Created by Сергей Денисенко on 08.03.2024.
//

import Foundation
final class CategoryModel {
    weak var delegate: CategoryViewControllerDelegate?
    private var categories: [String]
    private var isNewCategories: Bool
    private var myCell: MainTableViewCellProtocol
    private var doneIndex: IndexPath?
    private var index: Int?
    
    init() {
        self.categories = []
        self.isNewCategories = false
        self.myCell = MainTableViewCell()
        self.index = nil
    }
    
    func setProperties(categories: [String], cell: MainTableViewCellProtocol, index: Int?) {
        self.categories = categories
        self.myCell = cell
        self.index = index
    }
    
    func didCheck(status: CategoryStatus) -> Result<Bool, Error> {
        switch status {
        case .isEmpty:
            let isEmpty = checkCategories()
            return .success(isEmpty)
        case .isChanged:
            let isChanged = checkStatus()
            return .success(isChanged)
        case .isDone:
            let isDone = checkDone()
            return .success(isDone)
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return categories.count
    }
    
    func categoryOfIndex(index: Int) -> String {
        return categories[index]
    }
    
    func updateCategory(name: String) {
        categories.append(name)
        isNewCategories = true
    }
    
    func delegateChange() {
        guard let targetCell = myCell as? MainTableViewCell else {return}
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
        doneIndex = indexPath
        if index != nil {
            index = nil
        }
    }
    
    func getStartIndex() -> Int? {
        return index
    }
    
    private func checkCategories() -> Bool  {
        return categories.isEmpty
    }
    
    private func checkStatus() -> Bool {
        return isNewCategories
    }
    
    private func checkDone() -> Bool {
        return doneIndex != nil ? true : false
    }
}
