//
//  SpreadSheetCollectionViewController.swift
//  ProtoTypeProject
//
//  Created by 이숭인 on 2020/11/26.
//

import UIKit


class SpreadSheetViewController: UICollectionViewController {

    @IBOutlet var collectionVIew: UICollectionView!
    let sheetViewModel = SheetViewModel()
    let cellInfoViewModel = CellInfoViewModel()
    
    var currentSheet : Sheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO : 서버에서 받아온 데이터를 viewModel의 Sheet에 저장 func
        currentSheet = registResponseDataFromServer()
        setCurrentSheet(sheet: currentSheet)
        
        communicateWithCollectionViewLayout() // layout객체에 데이터 전달
    }
    
    //MARK: - add (col or row) EventHandler
    @IBAction func addCol(_ sender: Any) {
        guard let currentCol = currentSheet?.colum else {
            print("currentCol is Nil !")
            return
        }
        currentSheet?.updateCol(col: currentCol + 1)
       
        setCurrentSheet(sheet: currentSheet)
        print("currentCol --> \(currentCol), changeCol --> \(currentSheet?.colum)")
        collectionView.reloadData()
    }
    
    @IBAction func addRow(_ sender: Any) {
        let currentRow = currentSheet?.row

    }
}

//MARK: - collectionViewDataSource
extension SpreadSheetViewController  {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //section이 행의 개수라 생각
        guard let section = sheetViewModel.getCurrentSheet()?.row else {
            print("numberOfSecions nil error !")
            return 1
        }
        return section
        //return sheetViewModel.getCurrentSheet()?.row ?? 1 해도 되지만, error handling위해 guard 썼음 걍
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        // TODO : 섹션당 colum
        guard let col = sheetViewModel.getCurrentSheet()?.colum else {
            print("col nil error")
            return 1
        }
       return col
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sheetCell", for: indexPath) as? sheetCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.layer.borderWidth = 0.5
        print(indexPath)
        if indexPath.section == 0{
            cell.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        if indexPath.row == 0{
            cell.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        return cell
    }
    
    
}

//MARK: - collectionViewDelegate
extension SpreadSheetViewController  {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected cell index --> \(indexPath.row)")
        let cellInfo = cellInfoViewModel.cells[indexPath.section][indexPath.item]
        
        print("section -->\(indexPath.section), row --> \(indexPath.row), info --> \(cellInfo)")
    }
}

// MARK: - SheetCell
class sheetCell : UICollectionViewCell {
    
}

// MARK: - setCurrentSheetFromServer Method
extension SpreadSheetViewController {
    func setCurrentSheet(sheet : Sheet?) {
        guard let sheet = sheet else {
            print("sheet is Nil")
            return
        }
        sheetViewModel.setCurrentSheet(sheet : sheet)
    }
    
    func registResponseDataFromServer() -> Sheet?{
        //임시로 넣어둠 나중에 서버에서 받아올때 쓰자.
        //var responseSheet : Sheet? = Sheet(sheetId: 1, cells: [[]] , row: 3, colum: 6)
        var responseSheet : Sheet? = Sheet()
        
        let row = responseSheet?.row ?? 1
        let col = responseSheet?.colum ?? 1
        
        addCellInfoToSheet(row: row, col: col)
        
        responseSheet?.updateCells(cells: cellInfoViewModel.cells)
        
        return responseSheet
    }
    
    func addCellInfoToSheet(row : Int, col : Int) {
        /* cell 추가 과정
         1. 형 * 열 곱하기만큼 기본 셀만들기, 만들때마다 sectionCellList 에 append
         2. 하나의 섹션이 끝날때 cells 에 append
         */
        for _ in 1...row {
            for _ in 1...col{
                cellInfoViewModel.addSectionCellInfo(cellInfo: cellInfoViewModel.createCellInfo())
            }//inner for
            cellInfoViewModel.addCellInfo(cellInfo: cellInfoViewModel.sectionCells)
            cellInfoViewModel.removeAllSectionCellInfo()
        }//for
    }//func
}//controller

//MARK: - communicate CellInfoModel with collectionView Layout
extension SpreadSheetViewController {
    func communicateWithCollectionViewLayout(){
        if let layout = collectionViewLayout as? SpreadSheetCustomLayout {
            layout.cellInfoModel = sheetViewModel.getCurrentSheet()?.cells
        }
    }
}
