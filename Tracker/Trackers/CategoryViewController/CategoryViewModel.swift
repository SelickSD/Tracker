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
    var isDone: Binding<Bool>?
    
    private let model: CategoryModel
    
    init(for model: CategoryModel) {
        self.model = model
    }
    
    func didCheck(status: CategoryStatus) {
        let result = model.didCheck(status: status)
        
        switch result {
        case .success(let success):
            if status == .isEmpty {
                isCategoryEmpty?(success)
            }
            if status == .isChanged {
                isCategoryUpdated?(success)
            }
            if status == .isDone {
                isDone?(success)
            }
        case .failure(_):
            if status == .isEmpty {
                isCategoryEmpty?(false)
            }
            if status == .isChanged {
                isCategoryUpdated?(false)
            }
            if status == .isDone {
                isDone?(false)
            }
        }
    }
    
    func updateCategory(name: String) {
        model.updateCategory(name: name)
    }
    
    func numberOfRowsInSection() -> Int {
        return model.numberOfRowsInSection()
    }
    
    func categoryOfIndex(index: Int) -> String {
        return model.categoryOfIndex(index: index)
    }
    
    func delegateChange() {
        model.delegateChange()
    }
    
    func getDoneIndexPath() -> IndexPath? {
        return model.getDoneIndexPath()
    }
    
    func setDoneIndexPath(indexPath: IndexPath?) {
        model.setDoneIndexPath(indexPath: indexPath)
    }
    
    func getStartIndex() -> Int? {
        return model.getStartIndex()
    }
}
