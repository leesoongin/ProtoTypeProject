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
    var numberOfCell : Int = 0
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        numberOfCell = collectionView.numberOfItems(inSection: 0)
        
        print("layoutA --> \(layoutAttributesItems.count)")
//        if collectionView.numberOfSections != layoutAttributesItems.count {
//            // TODO : attributes, attributesItem 할당하는 func 작성
            setAttributesAndItems(collectionView: collectionView)
         //   return
       // }
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
                print("for in section , col --->\(section), \(col)")
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
}
