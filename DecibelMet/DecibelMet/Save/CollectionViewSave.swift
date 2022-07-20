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
    let recorder = Recorder()
    var recordings: [Record]?
    var player: Player!
    var info: RecordInfo!
    var isPlaying: Bool = false
    var tagPlaying: Int?
    var tags: [Int] = []
    var session: AVAudioSession!
  
    private lazy var headerLabel = Label(style: .dosimetreDecibelLabel, recordL)
    
    // MARK: Localizable
    var maxL = NSLocalizedString("Maximum", comment: "")
    var minL = NSLocalizedString("Minimum", comment: "")
    var avgL = NSLocalizedString("Average", comment: "")
    var recordL = NSLocalizedString("Records", comment: "")
    
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
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.black
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
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isUserInteractionEnabled = true
        
        //        view.addSubview(collection)
        view.addSubview(headerLabel)
        view.insertSubview(collection, at: 0)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
     
        
        buttonToogler()
        //        let path = Bundle.main.path(forResource: "t", ofType: "m4a")
        //        print(path)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let result = persist.fetch() else { return }
        recordings = result
        self.collection?.reloadData()
        
        buttonToogler()
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
            isPlaying = true
            cell?.isPlaying = true
            sender.setImage(UIImage(named: "stop"), for: .normal)
            self.tagPlaying = sender.tag
            player = Player()
            player.play(path, delegate: self)
        } else {
            isPlaying = false
            cell?.isPlaying = true
            sender.setImage(UIImage(named: "playSVG"), for: .normal)
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
        tabBarController?.tabBar.backgroundColor = .black
        cell.contentView.backgroundColor = UIColor(named: "backCell")
        cell.delegate = self
        
        if let recordings = self.recordings {
            let recording = recordings[indexPath.row]
            
            let time = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.YYYY"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let formatteddate = formatter.string(from: time as Date)
            
            cell.setValues(name: recording.name ?? "",
                           time: recording.length ?? "",
                           min: minL + String(recording.min),
                           max: maxL + String(recording.max),
                           avg: avgL + String(recording.avg),
                           date:formatteddate)
            
            cell.audioID = recording.id
            cell.playButton.uuid = recording.id
        }
        cell.playButton.addTarget(self, action: #selector(playAudio(_:)), for: .touchUpInside)
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
            self.shareAudio(indexPath: indexPath)
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
            self.collection?.reloadData()
        }
        collection!.deleteItems(at: [indexPath])
        do {
            try persist.viewContext.save()
        } catch {
            print(error)
        }
    }

    func shareAudio(indexPath: IndexPath) {
        guard let recordings = recordings else { return }
        let recording = recordings[indexPath.row]
        guard let path = persist.filePath(for: recording.id!.uuidString) else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [path],
            applicationActivities: nil
        )
        
        present(activityVC, animated: true, completion: nil)
    }
    
    private func rename(indexPath: IndexPath) {
        
        let cell = collection?.cellForItem(at: indexPath) as? CustomSaveCell
        cell!.playButton.tag = indexPath.row
        
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
                let nameTF = alert.textFields![0].text
                if let recordings = self.recordings {
                    let recording = recordings[indexPath.row]
                    
                    let time = NSDate()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.YYYY"
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    let formatteddate = formatter.string(from: time as Date)
                    
                    cell!.setValues(name: nameTF ?? "",
                                    time: recording.length ?? "",
                                    min: "MIN " + String(recording.min),
                                    max: "MAX " + String(recording.max),
                                    avg: "AVG " + String(recording.avg), date: formatteddate)
                    
                    if let unwrapped = nameTF {
                        
                        recording.name = unwrapped
                        
                        do {
                            try self.persist.viewContext.save()
                        } catch {
                            print(error)
                        }
                    } else {
                        print("Missing name.")
                    }
                }
            }
        )
        
        alert.addTextField { [self] textField in
            let dateFormatter = DateFormatter()
            if let recordings = self.recordings {
            let recording = recordings[indexPath.row]
            dateFormatter.dateFormat = "yyy-M-d-HH:mm"
            textField.placeholder = "\(recording.name!)"
                textField.text = recording.name!
            }
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


