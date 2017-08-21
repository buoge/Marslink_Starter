//
//  JournalSectionController.swift
//  Marslink
//
//  Created by wuchuanbo on 2017/8/16.
//  Copyright © 2017年 Ray Wenderlich. All rights reserved.
//

import UIKit
import IGListKit

class JournalSectionController: IGListSectionController {

    var entry: JournalEntry!
    let solFormatter = SolFormatter()
    
    override init(){
        super.init()
        //如果不这样做，section 中的 cell 会一个紧挨着一个。
        //这个方法在每个 JournalSectionController 对象的下方增加 15 个像素的间距。
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
}

//注意: IGListKit 非常依赖 required 协议方法。
//但在这些方法中你可以空实现，或者返回 nil，以免收到“缺少方法”的警告或运行时报错。
//这样，在使用 IGListKit 时就不容易出错。
extension JournalSectionController: IGListSectionType {
    
    func numberOfItems() -> Int {
        return 2
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        
        guard let context = collectionContext, let entry = entry else {
            return .zero
        }
        
        let width = context.containerSize.width
        
        if index == 0 {
            return CGSize(width: width, height: 30)
        } else {
            return JournalEntryCell.cellSize(width: width, text: entry.text)
        }
        
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        
        // 项目一种目前做法，是把 cellClass 存储到了model中,
        // IGList,会先判断，有没有注册过cell,如果注册过就直接dequeue,如果没注册过就先registe,再dequeue
        let cellClass: AnyClass = index == 0 ? JournalEntryDateCell.self : JournalEntryCell.self
        
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
        
        if let cell = cell as? JournalEntryDateCell {
            cell.label.text = "SOL \(solFormatter.sols(fromDate: entry.date))"
        } else if let cell = cell as? JournalEntryCell {
            cell.label.text = entry.text
        }
        
        return cell
    }
    
    //didUpdate(to:) 用于将一个对象传给 section controller。
    //注意在任何 cell 协议方法之前调用。这里，你把接收到的 object 参数赋给 entry。
    //注意：在一个 section controller 的生命周期中，对象有可能会被改变多次。
    //这只会在启用了 IGListKit 的更高级的特性时候发生，比如自定义模型的 Diffing 算法。在本教程中你不需要担心 Diffing。
    func didUpdate(to object: Any) {
        entry = object as? JournalEntry
    }
    
    func didSelectItem(at index: Int) {
        
    }
    
}
