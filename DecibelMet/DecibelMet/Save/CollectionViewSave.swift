//
//  CollectionViewSave.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 27.05.22.
//

import Foundation
import UIKit
import AVFAudio
import SwipeCellKit
import CoreData

class SaveController: UIViewController {
    
    private var collection: UICollectionView?
    
    let persist = Persist()
    var recordings: [Record]?
    var player: Player!
    var info: RecordInfo!
    var isPlaying: Bool = false
    var tagPlaying: Int?
    var tags: [Int] = []
    var session: AVAudioSession!
    
    func buttonToogler() {
        for tag in tags {
            guard let tmp = collection?.cellForItem(at: [0, tag]) as? CustomSaveCell else { return }
            
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
        tabBarController?.tabBar.isHidden = false
        //        self.tabBarController?.tabBar.tintColor = UIColor.white
        //        self.tabBarController?.tabBar.barTintColor = UIColor.black
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width) - 30, height: 80)
        layout.minimumLineSpacing = 10
        collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.backgroundColor = UIColor(named: "backgroundColor")
        guard let collection = collection else {
            return
        }
        collection.register(CustomSaveCell.self, forCellWithReuseIdentifier: CustomSaveCell.id)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor(named: "backgroundColor")
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
        let path = Bundle.main.path(forResource: "t", ofType: "m4a")
        print(path)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let result = persist.fetch() else { return }
        recordings = result
        buttonToogler()
        self.collection?.reloadData()
    }
    
    
    @objc func playAudio(_ sender: UIButton) {
        let cell = collection?.cellForItem(at: [0, sender.tag]) as? CustomSaveCell
        
        if sender.tag == 0 {
            tagPlaying = 0
        }
        
        buttonToogler()
        
        if isPlaying == false {
            let button = sender as! Button
            guard let path = Persist().filePath(for: button.uuid!.uuidString) else { return }
            print(path)
            isPlaying = true
            cell?.isPlaying = true
            sender.setImage(UIImage(named: "Pause"), for: .normal)
            self.tagPlaying = sender.tag
            player = Player()
            player.play(path, delegate: self)
        } else {
            isPlaying = false
            cell?.isPlaying = true
            sender.setImage(UIImage(named: "Play"), for: .normal)
            player.player.stop()
            player.session = nil
            self.tagPlaying = nil
        }
    }
}

extension SaveController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.recordings != nil {
            self.tags = Array(0..<recordings!.count)
            return recordings!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomSaveCell.id, for: indexPath) as! CustomSaveCell
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor(named: "backCell")
        cell.delegate = self
        
        if let recordings = self.recordings {
            let recording = recordings[indexPath.row]
            
            cell.setValues(name: recording.name ?? "",
                           time: recording.length ?? "",
                           min: "MIN " + String(recording.min),
                           max: "MAX " + String(recording.max),
                           avg: "AVG " + String(recording.avg))
            
            cell.audioID = recording.id
            cell.playButton.uuid = recording.id
            
            cell.playButton.addTarget(self, action: #selector(playAudio(_:)), for: .touchUpInside)
        }
        cell.playButton.tag = indexPath.row
        return cell
    }
    
}

extension SaveController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle action by updating model with deletion
            self.delete(indexPath: indexPath)
        }
        
        let editAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.rename(indexPath: indexPath)
        }
        
        let shareAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle action by updating model with deletion
            self.share(indexPath: indexPath)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.979583323, green: 0.004220267292, blue: 1, alpha: 1)
        editAction.backgroundColor = #colorLiteral(red: 0.07074324042, green: 0.8220555186, blue: 0.6004908681, alpha: 1)
        shareAction.backgroundColor = #colorLiteral(red: 0.137247622, green: 0, blue: 0.956287086, alpha: 1)
        deleteAction.image = UIImage(named: "delete")
        editAction.image = UIImage(named: "edit")
        shareAction.image = UIImage(named: "icons")
        return [deleteAction,shareAction,editAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}

extension SaveController {
    
    func delete(indexPath: IndexPath) {
        DispatchQueue.main.async { [unowned self] in
            persist.viewContext.delete(recordings![indexPath.row])
            recordings?.remove(at: indexPath.row)
        }
        collection!.deleteItems(at: [indexPath])
        do {
            try persist.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    private func share(indexPath: IndexPath) {
        let cell = collection?.cellForItem(at: indexPath) as? CustomSaveCell
        let t = URL(string: "file:///var/mobile/Containers/Data/Application/3702531B-9120-4247-BFFA-6C2DF71B9021/Documents/BEAAEBA4-D9AA-49B8-918B-E1B4DF8D9512.m4a")
        let objectsToShare: [Any] = ["fck sharing", t]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func rename(indexPath: IndexPath) {
        
        let alert = UIAlertController(
            title: "Recording name",
            message: nil, preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        let save = UIAlertAction(
            title: "Save",
            style: .default,
            handler: { _ in
                let name = alert.textFields![0].text
                
                if name == "" {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyy-M-d-HH:mm"
                    self.info.name = dateFormatter.string(from: self.info.date as Date)
                } else {
                    self.info.name = name
                }
                self.persist.saveAudio(info: self.info)
                let url: URL = self.persist.filePath(for: self.info.id.uuidString)!
                print(url)
            }
        )
        
        alert.addTextField { textField in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyy-M-d-HH:mm"
            textField.placeholder = "write"
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        present(alert, animated: true, completion: nil)
    }
}

extension SaveController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            buttonToogler()
            print("VRODE RABOTAET")
        } else {
            print("NE RABOTAEN BLYAT")
        }
    }
}


