//
//  SheetList.swift
//  ProtoTypeProject
//
//  Created by 이숭인 on 2020/11/26.
//

import UIKit

struct SheetListInfo{
    let sheetName : String
    let sheetId : Int
    let lastEditUser : String
    let date : Date
    
    init(){
        self.sheetName = "default Sheet Name"
        self.sheetId = 1
        self.lastEditUser = "default Editer Name"
        self.date = Date()
    }
    
    init(sheetName : String, lastEditUser : String, date : Date){
        self.sheetName = sheetName
        self.sheetId = 1
        self.lastEditUser = lastEditUser
        self.date = date
    }
}

class SheetListInfoManager {
    static let shared = SheetListInfoManager()
    
    var sheetList : [SheetListInfo] = []
    
    var dummyList = [
        SheetListInfo(sheetName:"aaaa", lastEditUser: "aaaaa", date: Date()),
        SheetListInfo(sheetName:"aaaa", lastEditUser: "aaaaa", date: Date()),
        SheetListInfo(sheetName:"aaaa", lastEditUser: "aaaaa", date: Date())
    ]

    //함수의 인자는 나중에 설정해줄 예정. 일단 기본값으로만 세팅해주자.
    func createSheetListInfo() -> SheetListInfo{
        return SheetListInfo()
    }
    
    func addSheetListInfo(_ sheetListInfo : SheetListInfo){
        sheetList.append(sheetListInfo)
    }
}

class SheetListInfoViewModel {
    private let manager = SheetListInfoManager.shared
    
    var sheetList : [SheetListInfo] {
        return manager.sheetList
    }
    
    var dummyList : [SheetListInfo] {
        return manager.dummyList
    }
    
    func createSheetListInfo() -> SheetListInfo {
        return manager.createSheetListInfo()
    }
    
    func addSheetListInfo(sheetListInfo : SheetListInfo){
        manager.addSheetListInfo(sheetListInfo)
    }
}
