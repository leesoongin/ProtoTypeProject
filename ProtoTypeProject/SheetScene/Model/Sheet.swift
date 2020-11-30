//
//  Sheet.swift
//  ProtoTypeProject
//
//  Created by 이숭인 on 2020/11/26.
//

/*
 1. row , colum 는 default값 주고 업데이트하는식으로?
 */

import UIKit

struct Sheet{
    //일단 default값 넣자
    var sheetId : Int
    var cells : [[CellInfo]]
    var row : Int  //section개념으로 생각해야할거같은데.
    var colum : Int 
    
    // TODO : cellInfo에 대한 mutating func도 필요할듯, 나중에 추가 !!
    
    mutating func updateRow(row : Int){
        self.row = row
    }

    mutating func updateCol(col : Int){
        self.colum = col
    }
    
    mutating func updateCells(cells : [[CellInfo]]){
        self.cells = cells
    }
    
    init(){
        self.sheetId = 0
        self.cells = []
        self.row = 100
        self.colum = 5
    }
    
    init (sheetId : Int, cells : [[CellInfo]], row : Int, colum : Int){
        self.sheetId = sheetId
        self.cells = cells
        self.row = row
        self.colum = colum
    }
}

class SheetManager {
    static let shared = SheetManager()
    
    /* 임시!! 나중에 response데이터를 받아와 currentSheet에 저장하자. */

    var currentSheet : Sheet?
    
    // getter , setter
    func getCurrentSheet() -> Sheet? {
        return currentSheet
    }
    
    func setCurrentSheet(_ sheet : Sheet) {
        currentSheet = sheet
    }
    //하나의 섹션이 하나의 줄을 담당할거야. 하나의 줄에 포함되는 개수는 col의 개수가 될거고
    //update row(section) , colum
    func updateRow(_ row : Int){
        currentSheet?.updateRow(row: row)
    }
    
    func updateCol(_ col : Int){
        currentSheet?.updateCol(col: col)
    }
    
    func updateCells(_ cells : [[CellInfo]]){
        currentSheet?.updateCells(cells: cells)
    }
}

class SheetViewModel {
    private let manager = SheetManager.shared
    
    // getter , setter
    func getCurrentSheet() -> Sheet? {
        return manager.getCurrentSheet()
    }
    
    func setCurrentSheet(sheet : Sheet){
        manager.setCurrentSheet(sheet)
    }
    
    //update row , col
    func updateRow(row : Int){
        manager.updateRow(row)
    }
    
    func updateCol(col : Int){
        manager.updateCol(col)
    }
    
    func updateCells(cells : [[CellInfo]]){
        manager.updateCells(cells)
    }
}
