//
//  CategoryViewModelProtocol.swift
//  Tracker
//
//  Created by Сергей Денисенко on 10.03.2024.
//
import Foundation
protocol CategoryViewModelProtocol {
    var isCategoryEmpty: Binding<Bool>? { get set }
    var isCategoryUpdated: Binding<Bool>? { get set }
    var isCategorySelected: Binding<Bool>? { get set }
    var delegate: CategoryViewControllerDelegate? { get set }
    
    func checkInitialStatus()
    func updateCategory(name: String)
    func numberOfRowsInSection() -> Int
    func categoryOfIndex(index: Int) -> String
    func delegateChange()
    func getDoneIndexPath() -> IndexPath?
    func setDoneIndexPath(indexPath: IndexPath?)
    func getStartIndex() -> Int?
}
