//
//  SheetCell.swift
//  ProtoTypeProject
//
//  Created by 이숭인 on 2020/11/27.
//


import UIKit

struct CellInfo{
    var content : String = ""
    var imageUrl : String = ""
    var width : Int = 100
    var height : Int = 25
    /* width, height 은 일단 default value 나중에 수정 !! */
    
    mutating func updateCellInfo(content : String, imageUrl : String,width : Int, height : Int){
        self.content = content
        self.imageUrl = imageUrl
        self.width = width
        self.height = height
    }
}

//한 섹션에 해당하는 셀들의 리스트가 1차원
// 한 섹션에 해당하는 셀들의 리스트들의 리스트가 최종 목적인 2차원배열

class CellInfoManager {
    static let shared = CellInfoManager()
    
    var sectionCells : [CellInfo] = [] //섹션 별 셀들
    var cells : [[CellInfo]] = [] // 모든 섹션의 셀들
    
    func createCellInfo() -> CellInfo {
        return CellInfo()
    }
    
    func addSectionCellInfo(_ cellInfo : CellInfo){
        sectionCells.append(cellInfo)
    }
    
    func addCellInfo(_ cellInfo : [CellInfo]){
        cells.append(cellInfo)
    }
    
    func removeAllSectionCellInfo(){
        sectionCells.removeAll()
    }
    
    func removeAllCells(){
        cells.removeAll()
    }
    
    //여기서 cellInfo는 서버에서 받아온 cellInfo값. 이걸가지고 update인자에 넣자.
    func updateCellInfo(_ responseCellInfo : CellInfo, _ indexPath : IndexPath){
        cells[indexPath.section][indexPath.item].updateCellInfo(content: responseCellInfo.content, imageUrl: responseCellInfo.imageUrl, width: responseCellInfo.width, height: responseCellInfo.height)
    }
}

class CellInfoViewModel {
    private let manager = CellInfoManager.shared
    
    var sectionCells : [CellInfo] {
        return manager.sectionCells
    }
    
    var cells : [[CellInfo]] {
        return manager.cells
    }
    
    func createCellInfo() -> CellInfo {
        return manager.createCellInfo()
    }
    
    func addSectionCellInfo(cellInfo : CellInfo){
        return manager.addSectionCellInfo(cellInfo)
    }
   
    func addCellInfo(cellInfo : [CellInfo]){
        return manager.addCellInfo(cellInfo)
    }
    
    func removeAllSectionCellInfo(){
        manager.removeAllSectionCellInfo()
    }
    
    func removeAllCell(){
        manager.removeAllCells()
    }
    
    func updateCellInfo(responseCellInfo : CellInfo, indexPath : IndexPath){
        manager.updateCellInfo(responseCellInfo, indexPath)
    }
}
