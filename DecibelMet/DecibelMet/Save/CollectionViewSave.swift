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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        buttonToogler()
    }
    
    func buttonToogler() {
        for tag in tags {
            let tmp = self.collection?.cellForItem(at: [0, tag]) as! CustomSaveCell
            
            if tmp.isPlaying {
                if let tagPlaying = tagPlaying {
                    if tmp.tag == 0 {
                        if tmp.isPlaying {
                            print("wrong")
                            tmp.isPlaying = false
                            tmp.playButton.setImage(UIImage(named: "png"), for: .normal)
                            if player.player.isPlaying {
                                player.player.stop()
                            }
                        } else {
                            print("true")
                            tmp.isPlaying = true
                            tmp.playButton.setImage(UIImage(named: "button3"), for: .normal)
                        }
                    } else if tmp.tag == tagPlaying {
                        print("true")
                        tmp.isPlaying = true
                        tmp.playButton.setImage(UIImage(named: "button3"), for: .normal)
                    } else {
                        print("wrong")
                        tmp.isPlaying = false
                        tmp.playButton.setImage(UIImage(named: "png"), for: .normal)
                        if player.player.isPlaying {
                            player.player.stop()
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection?.reloadData()
        tabBarController?.tabBar.isHidden = false
//        self.tabBarController?.tabBar.tintColor = UIColor.white
//        self.tabBarController?.tabBar.barTintColor = UIColor.black
        
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
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        buttonToogler()

    }
    
}

extension SaveController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomSaveCell.id, for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.contentView.backgroundColor = #colorLiteral(red: 0.1490753889, green: 0.1489614546, blue: 0.1533248723, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = collectionView.cellForItem(at: indexPath)
        
        selectedItem?.layer.borderColor = UIColor.red.cgColor
        
        print(1)
    }
    
    
}


