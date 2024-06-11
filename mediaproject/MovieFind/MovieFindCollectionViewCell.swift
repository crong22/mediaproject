//
//  MovieFindCollectionViewCell.swift
//  mediaproject
//
//  Created by 여누 on 6/11/24.
//

import UIKit
import SnapKit

class MovieFindCollectionViewCell: UICollectionViewCell {
    static let id = "MovieFindCollectionViewCell"
    
    let mainView = UIView()
    let movieImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainView.backgroundColor = .orange
        
        contentView.addSubview(mainView)
        mainView.addSubview(movieImage)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        movieImage.backgroundColor = .blue
        
        movieImage.snp.makeConstraints { make in
            make.edges.equalTo(mainView.safeAreaLayoutGuide)

        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
