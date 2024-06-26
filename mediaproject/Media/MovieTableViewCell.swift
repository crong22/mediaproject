//
//  MovieTableViewCell.swift
//  mediaproject
//
//  Created by 여누 on 6/26/24.
//

import UIKit
import SnapKit

class MovieTableViewCell : UITableViewCell {
    
    static let id = "MovieTableViewCell"
    let subtitleLable = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .bold)
        view.textColor = .white
        view.textAlignment = .left
        view.text = "비슷한 영화"
        return view
    }()
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
        
    }

    func configureHierarchy() {
        contentView.addSubview(subtitleLable)
        contentView.addSubview(collectionView)
    }
    
    func configureLayout() {
        subtitleLable.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(15)
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(contentView)
            make.top.equalTo(subtitleLable.snp.bottom).offset(10)
        }
    }
    
    func configureView() {
        contentView.backgroundColor = .black
        collectionView.backgroundColor = .black
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 160)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
        
    
}
