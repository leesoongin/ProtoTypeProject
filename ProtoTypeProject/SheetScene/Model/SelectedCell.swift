//
//  SelectedCell.swift
//  ProtoTypeProject
//
//  Created by 이숭인 on 2020/12/01.
//

import UIKit

struct SelectedCell {
    let row : Int
    let col : Int
    
    init (row : Int , col : Int) {
        self.row = row
        self.col = col
    }
}

class SelectedCellsManager {
    static let shared = SelectedCellsManager()
    
    var selectedCells : [SelectedCell] = []
    
    func createSelectedCell(_ indexPath : IndexPath) -> SelectedCell{
        return SelectedCell(row: indexPath.section, col: indexPath.row)
    }
    
    func addSelectedCell (_ selectedCell : SelectedCell) {
        selectedCells.append(selectedCell)
    }
    
    func isContainSelectedCell(_ indexPath : IndexPath) -> Bool{
        return selectedCells.contains { $0.row == indexPath.section && $0.col == indexPath.row }
    }
}

class SelectedCellsViewModel {
    private let manager = SelectedCellsManager.shared
    
    var selectedCells : [SelectedCell] {
        return manager.selectedCells
    }
    
    func createSelectedCell(indexPath : IndexPath) -> SelectedCell {
        return manager.createSelectedCell(indexPath)
    }
    
    func addSelectedCell(selectedCell : SelectedCell){
        manager.addSelectedCell(selectedCell)
    }
    
    func isContainSelectedCell(indexPath : IndexPath) -> Bool{
        return manager.isContainSelectedCell(indexPath)
    }
}
