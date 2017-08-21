//
//  FeedViewController.swift
//  Marslink
//
//  Created by wuchuanbo on 2017/8/16.
//  Copyright © 2017年 Ray Wenderlich. All rights reserved.
//

//http://blog.csdn.net/kmyhy/article/details/54846390
//https://www.raywenderlich.com/147162/iglistkit-tutorial-better-uicollectionviews
//https://instagram.github.io/IGListKit/

import UIKit
import IGListKit

class FeedViewController: UIViewController {

    // PathFinder() 扮演了消息系统，并代表了火星上宇航员的探路车
    let pathfinder = Pathfinder()
    
    let loader = JournalEntryLoader()
    
    let collectionView: IGListCollectionView = {
        let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.black
        return view
    }()
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    let wxScanner = WxScanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.loadLatest()
        
        view.addSubview(collectionView)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        pathfinder.delegate = self
        pathfinder.connect()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

}

extension FeedViewController: PathfinderDelegate {
    func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
        adapter.performUpdates(animated: true)
    }
}

extension FeedViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        //1 init
        var items: [IGListDiffable] = [wxScanner.currentWeather]
        items += loader.entries as [IGListDiffable]
        items += pathfinder.messages as [IGListDiffable]
        
        //2 sort
       return items.sorted(by: { (left: Any, right: Any) -> Bool in
            if let left = left as? DateSortable, let right = right as? DateSortable {
                return left.date > right.date
            }
            return false
        })
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        if object is Message{
            return MessageSectionController()
        } else if object is Weather{
            return WeatherSectionController()
        } else {
            return JournalSectionController()
        }
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
}
