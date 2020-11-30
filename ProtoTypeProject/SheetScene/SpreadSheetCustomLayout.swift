//
//  SpreadSheetCustomLayout.swift
//  ProtoTypeProject
//
//  Created by 이숭인 on 2020/11/28.
//

import UIKit



class SpreadSheetCustomLayout: UICollectionViewLayout {

    var layoutAttributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var layoutAttributesItems = [[UICollectionViewLayoutAttributes]]()
    
    public var cellInfoModel : [[CellInfo]]! //viewController에서 받아올 cellInfo 의 정보
    public var isChange : Bool = false //viewController에서 데이터 변경이 일어났을 경우 true로.
    public var numberOfCell : Int = 0
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
       // numberOfCell = collectionView.numberOfItems(inSection: 0)
      
        if isChange {
            layoutAttributes = []
            layoutAttributesItems = []
            
            setAttributesAndItems(collectionView: collectionView)
            sticktHeader(collectionView: collectionView, forItems: layoutAttributesItems)
            isChange = false
            return
        }
        
        sticktHeader(collectionView: collectionView, forItems: layoutAttributesItems)
    }//prepare
    
    override var collectionViewContentSize: CGSize{
        
        let width = CGFloat((layoutAttributesItems.last?.last?.frame.maxX)!) //한 섹션의 모든 width총합
        let height = CGFloat((layoutAttributesItems.last?.last?.frame.maxY)!)
        return CGSize(width: width, height: height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // 항목의 셀에 적용 할 정보가 포함 된 레이아웃 속성 대상체입니다.
        //하나의 셀 대상체 라는느낌같네
        return layoutAttributesItems[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //셀 및 뷰에 대한 레이아웃 정보를 나타내는 UICollectionViewLayoutAttributes 개체의 배열입니다. 기본 구현은 nil을 반환합니다.
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}

extension SpreadSheetCustomLayout {
    func setAttributesAndItems(collectionView : UICollectionView){
        var x : Int = 0
        var y : Int = 0
        var oneOfSectionAttributeList = [UICollectionViewLayoutAttributes]()
        
        print("section --> \(collectionView.numberOfSections), col --> \(numberOfCell)")
        for section in 0..<collectionView.numberOfSections{
            for col in 0..<numberOfCell{
                let indexPath = IndexPath(item: col, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
             //   print("for in section , col --->\(section), \(col)")
                attribute.frame = CGRect(x: x, y: y, width: cellInfoModel[section][col].width , height: cellInfoModel[section][col].height )
                
                oneOfSectionAttributeList.append(attribute)
                layoutAttributes.append(attribute)
                
                if col == numberOfCell-1 {
                    x = 0
                    y += cellInfoModel[section][col].height
                }else{
                    x += cellInfoModel[section][col].width
                }//else
            }//inner for
            layoutAttributesItems.append(oneOfSectionAttributeList)
            oneOfSectionAttributeList.removeAll()
        }//for
    }//func
    
    func sticktHeader(collectionView : UICollectionView, forItems : [[UICollectionViewLayoutAttributes]]){
        //0행
        for col in 0..<numberOfCell {
            forItems[0][col].frame.origin.y = collectionView.contentOffset.y
            forItems[0][col].zIndex = 100
        }
        //0열
        for section in 0..<collectionView.numberOfSections{
            forItems[section][0].frame.origin.x = collectionView.contentOffset.x
            forItems[section][0].zIndex = 100
        }
        //(0,0) 좌표 고정
        forItems[0][0].frame.origin.x = collectionView.contentOffset.x
        forItems[0][0].frame.origin.y = collectionView.contentOffset.y
        forItems[0][0].zIndex = 125
    }
}
