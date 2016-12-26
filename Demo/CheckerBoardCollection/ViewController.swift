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
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        layout.footerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        layout.columns = 3
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView.map { self.view.addSubview($0) }
        let cellNib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "Cell")
        collectionView?.register(UINib(nibName: "Header", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView?.register(UINib(nibName: "Footer", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"Cell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        cell.layer.removeAllAnimations()
        cell.backgroundColor = .orange
        cell.label.text = String(indexPath.row)
        if let layout = collectionView.collectionViewLayout as? CheckerBoardLayout {
            cell.layer.cornerRadius = layout.itemSize.width / 2
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
            return view
        }
        
        print(indexPath)
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
        return view
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let finalFrame = cell.frame
        let translation = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
        if translation.y < 0 {
            cell.frame.origin.y -= cell.frame.height / 2
            
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            cell.alpha = 0.5
            
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: [.allowUserInteraction],
                           animations: {
                            cell.transform = CGAffineTransform.identity
                            cell.frame = finalFrame
                            cell.alpha = 1
                            
            }) { finished in
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

