//
//  ViewController.swift
//  CheckerBoardCollection
//
//  Created by Yaroslav Pasternak on 22/12/2016.
//  Copyright © 2016 Yaroslav Pasternak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CheckerBoardLayoutDelegate {
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CheckerBoardLayout()
        layout.delegate = self
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        layout.columns = 5
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView.map { self.view.addSubview($0) }
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath)
        cell.backgroundColor = .orange
        if let layout = collectionView.collectionViewLayout as? CheckerBoardLayout {
            cell.layer.cornerRadius = layout.itemSize.width / 2
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

