//
//  SheetListViewController.swift
//  ProtoTypeProject
//
//  Created by 이숭인 on 2020/11/26.
//

import UIKit

class SheetListViewController: UITableViewController {
    
    let sheetListInfoViewModel = SheetListInfoViewModel()
    let sheetViewModel = SheetViewModel()
    
    @IBAction func addSheet(_ sender: Any) {
        // TODO : 원래라면 sheetList에도 추가해야하고 , sheet객체도 만들어서 서버에 저장request 해줘야함
        // TODO : 이 버튼에서 request관련 함수 사용하면 될듯함.
        
        //request func 했다 가정하고,
        //response 하자.
        sheetListResponse()
        tableView.reloadData()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO : 서버에서 받아온 데이터를 viewModel의 InfoList에 저장 func
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sheetDetail" {
            let vc = segue.destination as? SpreadSheetViewController
            
            //sender에서 넘길건 sheetId .
            print("sender ---> \(sender)")
            
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sheetListInfoViewModel.sheetList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheetListCell", for: indexPath) as? SheetListCell else { return UITableViewCell() }
        cell.updateUI(sheetListInfo: sheetListInfoViewModel.sheetList[indexPath.item])
        
        return cell
    }
    
    // MARK: - table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("perform")
        performSegue(withIdentifier: "sheetDetail", sender: indexPath.item)
    
    }
}

extension SheetListViewController {
    func sheetListResponse(){
        //얘를 response데이터라 가정
        let responseData = sheetListInfoViewModel.createSheetListInfo()
        
        sheetListInfoViewModel.addSheetListInfo(sheetListInfo: responseData)
    }
}
//ㅁㄴㅇㄴㅁㅇㅇㄴㅁㄴㅇ

class SheetListCell :UITableViewCell {
    @IBOutlet weak var lastEditUserLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sheetNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(sheetListInfo : SheetListInfo){
        sheetNameLabel.text = sheetListInfo.sheetName
        dateLabel.text = "\(sheetListInfo.date)"
        lastEditUserLabel.text = sheetListInfo.lastEditUser
    }
}

