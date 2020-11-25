//
//  IRChapterListViewController.swift
//  iRead
//
//  Created by zzyong on 2020/10/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

protocol IRChapterListViewControllerDelagate: AnyObject {
    func chapterListViewController(_ vc: IRChapterListViewController, didSelectTocReference tocReference: FRTocReference)
    func chapterListViewController(_ vc: IRChapterListViewController, didSelectBookmark bookmark: IRBookmarkModel)
}

enum IRSegmentType: String {
    /// 目录
    case chapter = "目录"
    /// 书签
    case bookmark = "书签"
}

class IRChapterListViewController: IRBaseViewcontroller, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    weak var delegate: IRChapterListViewControllerDelagate?
    
    var chapterListView: UICollectionView?
    var bookmarkListListView: UICollectionView?
     
    var segmentType = IRSegmentType.chapter
    var currentChapterIdx: Int?
    lazy var chapterList = [FRTocReference]()
    lazy var bookmarkList = [IRBookmarkModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLeftBackBarButton()
        self.setupNavigationBar()
        self.setupCollectionView()
    }
    
    // MARK: - Private
    
    func setupNavigationBar() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        self.navigationController?.navigationBar.barStyle = IRReaderConfig.barStyle
        self.navigationController?.navigationBar.barTintColor = IRReaderConfig.pageColor
        self.backButtonItem?.tintColor = IRReaderConfig.textColor
        
        let segment = UISegmentedControl.init(items: [IRSegmentType.chapter.rawValue, IRSegmentType.bookmark.rawValue])
        segment.width = 160
        segment.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        self.navigationItem.titleView = segment
    }
    
    func setupCollectionView() {
        if segmentType == .chapter {
            self.addChapterListViewIfNeeded()
        } else {
            self.addBookmarkListListViewIfNeeded()
        }
    }
    
    func addChapterListViewIfNeeded() {
        if self.chapterListView == nil {
            self.chapterListView = self.defaultCollectionView()
            self.chapterListView!.register(IRChapterCell.self, forCellWithReuseIdentifier: "IRChapterCell")
            self.chapterListView!.frame = self.view.bounds
            self.view.addSubview(self.chapterListView!)
            self.chapterListView!.reloadData()
        }
    }
    
    func addBookmarkListListViewIfNeeded() {
        if self.bookmarkListListView == nil {
            self.bookmarkListListView = self.defaultCollectionView()
            self.bookmarkListListView!.register(IRBookmarkCell.self, forCellWithReuseIdentifier: "IRBookmarkCell")
            self.bookmarkListListView!.frame = self.view.bounds
            self.view.addSubview(self.bookmarkListListView!)
            self.bookmarkListListView!.reloadData()
        }
    }
    
    func defaultCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = IRReaderConfig.pageColor
        collectionView.alwaysBounceVertical = true
        return collectionView
    }
    
    @objc func segmentValueDidChange(_ segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            segmentType = .chapter
            self.addChapterListViewIfNeeded()
            self.view.addSubview(self.chapterListView!)
            self.bookmarkListListView?.removeFromSuperview()
        } else {
            segmentType = .bookmark
            self.addBookmarkListListViewIfNeeded()
            self.view.addSubview(self.bookmarkListListView!)
            self.chapterListView?.removeFromSuperview()
        }
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentType == .chapter {
            return chapterList.count
        } else {
            return bookmarkList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segmentType == .chapter {
            let chapterCell: IRChapterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRChapterCell", for: indexPath) as! IRChapterCell
            chapterCell.tocReference = chapterList[indexPath.item]
            if let currentChapterIdx = currentChapterIdx {
                chapterCell.isSelected = indexPath.item == currentChapterIdx
            }
            return chapterCell
        } else {
            let bookmarkCell: IRBookmarkCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IRBookmarkCell", for: indexPath) as! IRBookmarkCell
            bookmarkCell.bookmarkModel = bookmarkList[indexPath.item]
            return bookmarkCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if segmentType == .chapter {
            return CGSize.init(width: collectionView.width, height: 50)
        } else {
            return CGSize.init(width: collectionView.width, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentType == .chapter {
            self.delegate?.chapterListViewController(self, didSelectTocReference: chapterList[indexPath.item])
        } else {
            self.delegate?.chapterListViewController(self, didSelectBookmark: bookmarkList[indexPath.item])
        }
        self.navigationController?.popViewController(animated: true)
    }
}
