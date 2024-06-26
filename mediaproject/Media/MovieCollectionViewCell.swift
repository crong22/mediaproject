//
//  MovieCollectionViewCell.swift
//  mediaproject
//
//  Created by 여누 on 6/26/24.
//

import UIKit
import SnapKit

class MovieCollectionViewCell : UICollectionViewCell {
    static let id = "MovieCollectionViewCell"
    let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
