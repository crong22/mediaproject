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


class MovieViewController : UIViewController {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let tableView = UITableView()
    
    var imageList : [[movie]] = [[ movie(poster_path: "")], [ movie(poster_path: "")], [ movie(poster_path: "")]]
    
    var poster : [[movieposter]] = [[movieposter(file_path: "")],[ movieposter(file_path: "")], [movieposter(file_path: "")]]
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let backBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "chevron.backward") , style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        tableView.dataSource = self
        tableView.delegate = self
        if tableView.tag == 0 || tableView.tag == 1{
            print("tag 0 , 1 \(tableView.tag)")
            tableView.rowHeight = 200
        }else {
            tableView.rowHeight = 400
        }
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.id)
        

        let movieid = UserDefaults.standard.integer(forKey: "movieId")
        print("movieid \(movieid)")
//        let tmdbGroup = DispatchGroup()
        
//        tmdbGroup.enter() // +1
        MovieAPI.shared.callRequest(api: .callRequestMovie(id: movieid)) { movie, error in
            if let error = error {
                print(error)
            }else {
                guard let movie = movie else { return }
                self.imageList[0] = movie
            }
            self.tableView.reloadData()
        }
        
        MovieAPI.shared.callRequest(api: .callRequestTV(id: movieid)) { movie, error in
            if let error = error {
                print(error)
            }else {
                guard let movie = movie else { return }
                self.imageList[1] = movie
            }
            self.tableView.reloadData()
        }
        
//        DispatchQueue.global().async(group : tmdbGroup) {
//            self.callRequestMovie(id: movieid)
//            DispatchQueue.main.async {
//            }
////            tmdbGroup.leave() // -1
//            self.tableView.reloadData()
//        }
        
//        tmdbGroup.enter()
//        DispatchQueue.global().async(group : tmdbGroup) {
//            self.callRequestTV(id: movieid)
//            DispatchQueue.main.async {
//            }
//            tmdbGroup.leave()
//        }
//        
//        tmdbGroup.enter()
//        DispatchQueue.global().async {
//            self.callRequest(id: movieid)
//            DispatchQueue.main.async {
//            }
//            tmdbGroup.leave()
//        }
//        
//        
//        tmdbGroup.notify(queue: .main) {
//            print("끝끝끝끝끝")
//            self.tableView.reloadData()
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
    
    
    func callRequest(id :Int) {
        let header : HTTPHeaders = ["Authorization" : APIKey.tmdbToken]
    
        let url = "https://api.themoviedb.org/3/movie/\(id)/images"
        AF.request(url, headers: header).responseDecodable(of: MoviePoster.self) { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                self.poster[2] = value.posters
                print("########@@@@@@@@@@@@@@@@@@@@@@@@################",self.poster[2])
            case .failure(let error):
                print(error)
                }
            }
    }
    
}

extension MovieViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        print("numberOfItemsInSection \(collectionView.tag)")
            return imageList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.id , for: indexPath) as! MovieCollectionViewCell
        let data = imageList[collectionView.tag][indexPath.row]
//        let posterimage = poster[2][indexPath.row]
        
        if collectionView.tag == 0{
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.poster_path)")
            cell.posterImageView.kf.setImage(with: url)
        }else if collectionView.tag == 1 {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.poster_path)")
            cell.posterImageView.kf.setImage(with: url)
        }else if collectionView.tag == 2 {
            print("22222222")
//            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterimage.file_path)")
//            cell.posterImageView.kf.setImage(with: url)
        }

        return cell
    }
    
}
