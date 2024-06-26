//
//  MovieViewController.swift
//  mediaproject
//
//  Created by 여누 on 6/26/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

struct Movie : Decodable {
    let page : Int
    let results : [movie]
    let total_pages : Int
    let total_results : Int
}

struct movie : Decodable {
    let poster_path : String
    let id : Int
}

class MovieViewController : UIViewController {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let tableView = UITableView()
    
    var imageList : [[movie]] = [[ movie(poster_path: "", id: 0)], [ movie(poster_path: "", id: 0)], [ movie(poster_path: "", id: 0 )]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let backBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "chevron.backward") , style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.id)
        

        let movieid = UserDefaults.standard.integer(forKey: "movieId")
        
        let tmdbGroup = DispatchGroup()
        
        tmdbGroup.enter() // +1
        DispatchQueue.global().async(group : tmdbGroup) {
            self.callRequestMovie(id: movieid)
            DispatchQueue.main.async {
            }
            tmdbGroup.leave() // -1
        }
        
        tmdbGroup.enter()
        DispatchQueue.global().async(group : tmdbGroup) {
            self.callRequestTV(id: movieid)
            DispatchQueue.main.async {
            }
            tmdbGroup.leave()
        }
        
        tmdbGroup.notify(queue: .main) {
            print("끝끝끝끝끝")
            self.tableView.reloadData()
        }
        
//        DispatchQueue.global().async {
//            self.callRequest(id: movieid)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
        
    }
    
    @objc func backButtonClicked() {
        navigationController?.pushViewController(MediaViewController(), animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        let title = UserDefaults.standard.string(forKey: "movieTitle")
        titleLabel.text = title!
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .black
        tableView.backgroundColor  = .black
    }
    
    func callRequestMovie(id : Int) {
        let header : HTTPHeaders = ["Authorization" : APIKey.tmdbToken]
        let url = "https://api.themoviedb.org/3/movie/\(id)/similar"
        AF.request(url, headers: header).responseDecodable(of: Movie.self) { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                self.imageList[0] = value.results
                print("2424242424",self.imageList[0][1].id)
                print(self.imageList[0])
            case .failure(let error):
                print(error)
                }
            }
    }
    
    func callRequestTV(id: Int) {
        let header : HTTPHeaders = ["Authorization" : APIKey.tmdbToken]
        let url = "https://api.themoviedb.org/3/movie/\(id)/recommendations"
        AF.request(url, headers: header).responseDecodable(of: Movie.self) { response in
            switch response.result {
            case .success(let value):
                //print("SUCCESS")
                self.imageList[1] = value.results
                //print(self.imageList[1])
            case .failure(let error):
                print(error)
                }
            }
    }
    
    func callRequest(id :Int) {
        let header : HTTPHeaders = ["Authorization" : APIKey.tmdbToken]
    
        let url = "https://api.themoviedb.org/3/movie/\(id)/images"
        AF.request(url, headers: header).responseDecodable(of: Movie.self) { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                self.imageList[2] = value.results
                print(self.imageList[2])
            case .failure(let error):
                print(error)
                }
            }
    }
    
}

extension MovieViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function,imageList.count)
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        let cell = tableView.dequeueReusableCell(withIdentifier:MovieTableViewCell.id , for: indexPath) as! MovieTableViewCell
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.collectionView.tag = indexPath.row
        cell.collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.id)
        
        if cell.collectionView.tag == 0 {
            cell.subtitleLable.text = "비슷한 영화"
        }else if cell.collectionView.tag == 1 {
            cell.subtitleLable.text = "추천 영화"
        }else if cell.collectionView.tag == 2 {
            cell.subtitleLable.text = "포스터"
        }
        
        cell.collectionView.reloadData()
        return cell
    }
    
}
extension MovieViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.id , for: indexPath) as! MovieCollectionViewCell
        let data = imageList[collectionView.tag][indexPath.row]
        print("================== \(data)")
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.poster_path)")
        cell.posterImageView.kf.setImage(with: url)

        return cell
    }
    
}
