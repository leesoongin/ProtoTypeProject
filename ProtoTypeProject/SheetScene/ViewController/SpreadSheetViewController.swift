//
//  SpreadSheetCollectionViewController.swift
//  ProtoTypeProject
//
//  Created by 이숭인 on 2020/11/26.
//

import UIKit


class SpreadSheetViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentSheet : Sheet?
    
    let sheetViewModel = SheetViewModel()
    let cellInfoViewModel = CellInfoViewModel()
    let selectedCellViewModel = SelectedCellsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO : 서버에서 받아온 데이터를 viewModel의 Sheet에 저장 func
        currentSheet = registResponseDataFromServer()
        setCurrentSheet(sheet: currentSheet)
        
        communicateWithCollectionViewLayout() // layout객체에 데이터 전달
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - add (col or row) EventHandler
    @IBAction func addCol(_ sender: Any) {
        guard let currentCol = currentSheet?.colum else {
            print("currentCol is Nil !")
            return
        }
        guard let currentRow = currentSheet?.row else {
            print("currentRow is Nil")
            return
        }
        // TODO : 원래 cells 정보 지우기
        // TODO : 업데이트 된 row col정보로 cell정보 다시 만들기
        // TODO : 업데이트 된 정보들이 있다면 currentSheet 세팅해주기
        // TODO : 새로운 정보를 가진 시트의 cells 정보를 layout에 전달해주기
        cellInfoViewModel.removeAllCell()
        
        addCellInfoToSheet(row: currentRow, col: currentCol + 1)
        
        currentSheet?.updateCells(cells: cellInfoViewModel.cells)
        currentSheet?.updateCol(col: currentCol + 1)
        setCurrentSheet(sheet: currentSheet)
        
        communicateWithCollectionViewLayout()
        collectionView.reloadData()
    }
    
    @IBAction func addRow(_ sender: Any) {
        guard let currentCol = currentSheet?.colum else {
            print("currentCol is Nil !")
            return
        }
        guard let currentRow = currentSheet?.row else {
            print("currentRow is Nil")
            return
        }
        
        cellInfoViewModel.removeAllCell()
        addCellInfoToSheet(row: currentRow + 1, col: currentCol)
        
        currentSheet?.updateCells(cells: cellInfoViewModel.cells)
        currentSheet?.updateRow(row: currentRow + 1)
        setCurrentSheet(sheet: currentSheet)
        
        communicateWithCollectionViewLayout()
        collectionView.reloadData()
    }
}

//MARK: - collectionViewDataSource

extension SpreadSheetViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //section이 행의 개수라 생각
        guard let section = sheetViewModel.getCurrentSheet()?.row else {
            print("numberOfSecions nil error !")
            return 1
        }
        return section
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        // TODO : 섹션당 colum
        guard let col = sheetViewModel.getCurrentSheet()?.colum else {
            print("col nil error")
            return 1
        }
       return col
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sheetCell", for: indexPath) as? sheetCell else { return UICollectionViewCell() }
        
        
        if indexPath.section == 0 && indexPath.row == 0{
            cell.label.text = ""
            cell.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            cell.layer.borderWidth = 0.5
        }else if indexPath.section == 0 || indexPath.row == 0{
            if indexPath.section == 0 {
                let int:UInt8 = 64 + UInt8(indexPath.item)
                var string = ""
                string.append(Character(UnicodeScalar(int)))
                cell.label.text = string
            }else {
                cell.label.text = String(indexPath.section)
            }
            
            cell.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            cell.layer.borderWidth = 0.5
        }else{
            cell.label.text = ""
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            cell.layer.borderWidth = 0.5
        }
        return cell
    }
}

//MARK: - collectionViewDelegate
extension SpreadSheetViewController : UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO : 선택된 셀 리스트에 들어갈 선택된 셀 객체를 하나 만든다.
        // TODO : 지금 만들어진 셀 객체가 리스트 안에 존재하는지, 존재하지 않는지 체크한다.
        // TODO : 존재하지않으면 리스트에 추가한다.
        let selectedCell = selectedCellViewModel.createSelectedCell(indexPath: indexPath)
        
        if !selectedCellViewModel.isContainSelectedCell(indexPath: indexPath){//들어있지 않다면
            selectedCellViewModel.addSelectedCell(selectedCell: selectedCell)
            if let cell = collectionView.cellForItem(at: indexPath) as? sheetCell {
                cell.layer.borderColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                cell.layer.borderWidth = 3
            }
        }
        
       
    }
}

// MARK: - SheetCell

class sheetCell : UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
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
        
        if let layout = collectionView.collectionViewLayout as? SpreadSheetCustomLayout {
            layout.cellInfoModel = sheetViewModel.getCurrentSheet()?.cells
            layout.numberOfCell = sheetViewModel.getCurrentSheet()?.colum ?? 1
            layout.isChange = true
        }
    }
}
