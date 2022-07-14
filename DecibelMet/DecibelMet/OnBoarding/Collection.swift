//
//  Colection.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.05.22.
//

import Foundation
import UIKit

class CollectionView: UICollectionView {
    
    let layout = UICollectionViewFlowLayout()
        
    func setupLayout() {
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
    }
    
    init(delegate: UICollectionViewDelegateFlowLayout, dataSource: UICollectionViewDataSource) {
        super.init(frame: .zero, collectionViewLayout: layout)
        setupLayout()
        
        self.delegate = delegate
        self.dataSource = dataSource
        
        backgroundColor = #colorLiteral(red: 0.005383874755, green: 0.01202428713, blue: 0.1731599867, alpha: 1)
        
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
