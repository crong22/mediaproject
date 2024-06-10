//
//  MediaInfoTableViewCell.swift
//  mediaproject
//
//  Created by 여누 on 6/10/24.
//

import UIKit
import SnapKit

class MediaInfoTableViewCell: UITableViewCell {
    static let identifire = "MediaInfoTableViewCell"
    let movieDateLabel = UILabel()
    let mainView = UIView()
    let movieImage = UIImageView()
    let movierate = UILabel()
    let rateLabel = UILabel()
    let titleLabel = UILabel()
    let storyLabel = UILabel()
    let detailLabel = UILabel()
    let detailButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(movieDateLabel)
        contentView.addSubview(mainView)
        
        mainView.addSubview(movieImage)
        mainView.addSubview(titleLabel)
        mainView.addSubview(storyLabel)
        mainView.addSubview(detailLabel)
        mainView.addSubview(detailButton)
        
        movieImage.addSubview(movierate)
        movieImage.addSubview(rateLabel)
        
        contentView.backgroundColor = .white
        
        
        movieDateLabel.backgroundColor = .white

        movieDateLabel.textAlignment = .left
        movieDateLabel.font = .boldSystemFont(ofSize: 12)
        movieDateLabel.textColor = .darkGray
//        movieDateLabel.text = "12/10/2020"
        
        movieDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(24)
        }
        
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize(width: -2, height: 4)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
//        mainView.clipsToBounds = true
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(300)
            
        }
        
        movieImage.backgroundColor = .blue
        movieImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        movieImage.layer.cornerRadius = 10
  
        
        movieImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(mainView.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        movierate.backgroundColor = .purple
        movierate.text = "평점"
        movierate.textColor = .white
        movierate.font = .systemFont(ofSize: 12)
        movierate.textAlignment = .center
        
        movierate.snp.makeConstraints { make in
            make.bottom.equalTo(movieImage.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(movieImage.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(25)
            make.width.equalTo(30)
        }

        rateLabel.backgroundColor = .white
//        rateLabel.text = "3.3"
        rateLabel.textAlignment = .center
        rateLabel.textColor = .black
        rateLabel.font = .systemFont(ofSize: 12)
        
        rateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(movierate)
            make.trailing.equalTo(movierate).inset(-30)
            make.height.equalTo(25)
            make.width.equalTo(30)
        }
        
        //titleLabel.backgroundColor = .brown
//        titleLabel.text = "Alice in Borderland"
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textAlignment = .left
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImage.snp.bottom).offset(20)
            make.leading.equalTo(10)
            make.height.equalTo(24)
        }
        
        //storyLabel.backgroundColor = .cyan
//        storyLabel.text = "이 영화는 엄청난 영화로 인기가 아주 많은 영화입니다. 그렇습니다. 맞습니다. 예예예예예예예예예예예"
        storyLabel.textColor = .darkGray
        storyLabel.font = .systemFont(ofSize: 12)
        
        storyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(20)
        }
        
        //detailLabel.backgroundColor = .magenta
        detailLabel.text = "자세히 보기"
        detailLabel.textColor = .darkGray
        detailLabel.textAlignment = .left
        detailLabel.font = .systemFont(ofSize: 12)
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(storyLabel.snp.bottom).offset(12)
            make.leading.equalTo(10)
            make.width.equalTo(80)
        }
        
        let image = UIImage(systemName: "greaterthan", withConfiguration: UIImage.SymbolConfiguration(pointSize : 15,weight: .medium))
        detailButton.setImage(image, for: .normal )
        detailButton.tintColor = .darkGray
        
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(storyLabel.snp.bottom).offset(10)
            make.trailing.equalTo(-10)
            make.width.equalTo(40)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
