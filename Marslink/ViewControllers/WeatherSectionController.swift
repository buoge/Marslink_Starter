//
//  WeatherSectionController.swift
//  Marslink
//
//  Created by wuchuanbo on 2017/8/16.
//  Copyright © 2017年 Ray Wenderlich. All rights reserved.
//

import UIKit
import IGListKit

class WeatherSectionController: IGListSectionController {
    
    var weather: Weather!
    
    var expand = false
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension WeatherSectionController: IGListSectionType {
    
    func didUpdate(to object: Any) {
        weather = object as? Weather
    }
    
    func numberOfItems() -> Int {
        return expand ? 5 : 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        let width = context.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: 70)
        } else {
            return CGSize(width: width, height: 40)
        }
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass: AnyClass = index == 0 ? WeatherSummaryCell.self : WeatherDetailCell.self
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
        if let cell = cell as? WeatherSummaryCell {
            // 这里设置指示方向的箭头，指向右方还是指向下方！！！
            cell.setExpanded(expand)
        } else if let cell = cell as? WeatherDetailCell {
            let title: String, detail: String
            switch index {
            case 1:
                title = "SUNRISE"
                detail = weather.sunrise
            case 2:
                title = "SUNSET"
                detail = weather.sunset
            case 3:
                title = "HIGH"
                detail = "\(weather.high) C"
            case 4:
                title = "LOW"
                detail = "\(weather.low) C"
            default:
                title = "n/a"
                detail = "n/a"
            }
            cell.titleLabel.text = title
            cell.detailLabel.text = detail
        }
        return cell
    }
    
    func didSelectItem(at index: Int) {
        expand = !expand
        //reload() 方法重新加载整个 section。
        //当 section controller 中的 cell 的数目或者内容发生变化时，你可以调用这个方法。
        //因此我们通过 numberOfItems() 方法切换 section 的展开状态，
        //在这个方法中根据 expanded 的值来添加或减少 cell 的数目。
        collectionContext?.reload(self)
    }
    
    
    
    
}
