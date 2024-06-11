//
//  MovieFindViewController.swift
//  mediaproject
//
//  Created by 여누 on 6/11/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class MovieFindViewController: UIViewController {
    
    let movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let titleLabel = UILabel()
    let searchBar = UISearchBar()
    
    var list = MovieList(page: 1, results: [], total_pages: 0, total_results: 0)
    var isEnd = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request(keyword: "")
        
        view.backgroundColor = .black
        
        view.addSubview(movieCollectionView)
        view.addSubview(searchBar)
        view.addSubview(titleLabel)
        
        searchBar.delegate = self
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(MovieFindCollectionViewCell.self, forCellWithReuseIdentifier: MovieFindCollectionViewCell.id)
        
        titleLabel.text = "영화 검색"
        titleLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(searchBar.snp.top)
        }
        
       
        searchBar.placeholder = "영화 제목을 검색해주세요"
        searchBar.searchTextField.font = .systemFont(ofSize: 17, weight: .medium)
        searchBar.searchTextField.textColor = .lightGray //입력글씨색상
        searchBar.searchTextField.tintColor = .lightGray // 커서색상

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(40)
        }
        
        movieCollectionView.backgroundColor = .black
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
       
    }
    
    static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 45
        let height = UIScreen.main.bounds.height - 300
        
        layout.itemSize = CGSize(width: width/3, height: height/3)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 19, left: 10, bottom: 19, right: 10)
        return layout
    }

    // 1) api_key --> Query String
    // 2) Access Token --> Header
    func request(keyword : String) {
        let pram : Parameters = ["query" : keyword , "language" : "ko-KR"]
        let header : HTTPHeaders = ["Authorization" : APIKey.tmdbToken]
        let url = "https://api.themoviedb.org/3/search/movie"
            print(url)

        AF.request(url, parameters: pram, headers: header).responseDecodable(of: MovieList.self) { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                if self.list.page == 1 {
                    self.list = value
                }else {
                    self.list.results.append(contentsOf: value.results)
                }
                self.movieCollectionView.reloadData()
            case .failure(let error):
                print(error)
                }
            }
    }

}

extension MovieFindViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieFindCollectionViewCell.id, for: indexPath) as! MovieFindCollectionViewCell
        let data = list.results[indexPath.item]
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2"+data.poster_path)
        cell.movieImage.kf.setImage(with: imageURL)
        return cell
    }
    
    
}

extension MovieFindViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        list.page = 1
        request(keyword: searchBar.text!)
    }
}

extension MovieFindViewController : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if list.results.count - 2 == i.row && isEnd == false{
                print(list.results.count)
                list.page += 1
                request(keyword: searchBar.text!)
            }
        }
    }
}
    

