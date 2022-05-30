//
//  CollectionViewSave.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 27.05.22.
//

import Foundation
import UIKit
import AVFAudio

class SaveController: UIViewController {
    
    private var collection: UICollectionView?
    
        let persist = Persist()
        var recordings: [Record]?
        var player: Player!
        var isPlaying: Bool = false
        var tagPlaying: Int?
        var tags: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width) - 40, height: 80)
        layout.minimumLineSpacing = 10
        collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        guard let collection = collection else {
            return
        }
        collection.register(CustomSaveCell.self, forCellWithReuseIdentifier: CustomSaveCell.id)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .black
//        collectionView.frame = view.bounds
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SaveController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomSaveCell.id, for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.contentView.backgroundColor = #colorLiteral(red: 0.1490753889, green: 0.1489614546, blue: 0.1533248723, alpha: 1)
        return cell
    }
    
    
}


