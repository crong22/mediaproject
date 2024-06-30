//
//  DetailViewController.swift
//  mediaproject
//
//  Created by 여누 on 6/30/24.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController : UIViewController {
    
    let titleLabel = UILabel()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(titleLabel)
        view.addSubview(imageView)

        
        let poster = UserDefaults.standard.string(forKey: "detailPoster")
        let name = UserDefaults.standard.string(forKey: "detailName")
        print("넘어온 poster \(poster)")
        imageView.backgroundColor = .blue
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(poster!)")
        imageView.kf.setImage(with: url)
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(550)
        }
        
        titleLabel.text = name
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
    }
    
    
}
