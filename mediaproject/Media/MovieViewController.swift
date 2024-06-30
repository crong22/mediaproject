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

// 1 호출
// 2 호출
// 3 호출

// --> 3번 완료 1번 완료  2번완료 --> 다 완료된 시점에 --> 각각의 데이터 찍어복기 --> reload Data
class MovieViewController : UIViewController {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let tableView = UITableView()
    
    var imageList: [[movie]] = [[], [], []]
    var poster: [[movieposter]] = [[], [], []]
    var detailMovie : DetailMovie?
    var list = Media(page: 1, results: [])
    
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
        
        callRequest()
        
        let movieid = UserDefaults.standard.integer(forKey: "movieId")
        print("movieid \(movieid)")
        
        // DispatchGroup 생성
        let MovieGroup = DispatchGroup()
        
        MovieGroup.enter() // +1
        DispatchQueue.global().async {
            MovieAPI.shared.callRequest(api: .callRequestMovie(id: movieid)) { movie, error in
                if let error = error {
                    print(error)
                }else {
                    guard let movie = movie else { return }
                    self.imageList[0] = movie
                }
                MovieGroup.leave() // -1
            }
        }
        
        MovieGroup.enter() // +1
        DispatchQueue.global().async {
            MovieAPI.shared.callRequest(api: .callRequestTV(id: movieid)) { tv, error in
                if let error = error {
                    print(error)
                }else {
                    guard let tv = tv else { return }
                    self.imageList[1] = tv
                }
                MovieGroup.leave() // -1
            }
        }
        
        
        
        MovieGroup.enter()
        DispatchQueue.global().async {
            MovieAPI.shared.callRequestPoster(api: .callRequest(id: movieid)) { posterImage, error in
                if let error = error {
                    print(error)
                }else {
                    guard let posterImage = posterImage else { return }
                    self.poster[2] = posterImage

                }
                MovieGroup.leave() // -1
            }
        }
        

        MovieGroup.notify(queue: .main) {
            print("끝끝끝끝끝")
            self.tableView.reloadData()
        }
        

        
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
    
    func callRequest() {
        print(#function)
        
        let url = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(APIKey.tmdbKey)&language=ko-KR"

        AF.request(url).responseDecodable(of: Media.self) { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                if self.list.page == 1 {
                    self.list = value
                    print("리스트만듬")
                    print(self.list.results.count)
                }else {
                    self.list.results.append(contentsOf: value.results)
                }
                self.tableView.reloadData()
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
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("estimatedHeightForRowAt",indexPath.row)
//        if indexPath.row == 0 || indexPath.row == 1 {
//            return 200
//        }else {
//            return 400
//        }
//    }
    
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
        }else {
            cell.subtitleLable.text = "포스터"
        }
        
        cell.collectionView.reloadData()
        return cell
    }
    
}
extension MovieViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection \(collectionView.tag)")
        if collectionView.tag == 0 || collectionView.tag == 1 {
            print("TV / Movie count: \(imageList[collectionView.tag].count)") // 로그 추가
            return imageList[collectionView.tag].count
        }else {
            print("Poster count: \(poster[2].count)") // 로그 추가
            return poster[2].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.id , for: indexPath) as! MovieCollectionViewCell

        if collectionView.tag == 0{
            let data = imageList[0][indexPath.row]
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.poster_path)")
            cell.posterImageView.kf.setImage(with: url)
        }else if collectionView.tag == 1 {
            let data = imageList[1][indexPath.row]
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.poster_path)")
            cell.posterImageView.kf.setImage(with: url)
        }else if collectionView.tag == 2 {
            let data = poster[2][indexPath.row]
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.file_path)")
            cell.posterImageView.kf.setImage(with: url)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView.tag == 0 {
            let movieid = imageList[0][indexPath.row].id
            print("저장된Id \(movieid)")
            DispatchQueue.global().async {
                MovieAPI.shared.callRequestDetail(api: .callRequestDetailMovie(id: movieid)) { detail, error in
                    if let error = error {
                        print(error)
                    }else {
                        guard let detail = detail else {return}
                        self.detailMovie = detail
                        print(self.detailMovie!)
                        UserDefaults.standard.setValue(self.detailMovie?.original_title, forKey: "detailName")
                        UserDefaults.standard.setValue(self.detailMovie?.poster_path, forKey: "detailPoster")
                        
                        DispatchQueue.main.async {
                            let vc = DetailViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }else if collectionView.tag == 1 {
            let movieid = imageList[1][indexPath.row].id
            print("저장된Id \(movieid)")
            DispatchQueue.global().async {
                MovieAPI.shared.callRequestDetail(api: .callRequestDetailMovie(id: movieid)) { detail, error in
                    if let error = error {
                        print(error)
                    }else {
                        guard let detail = detail else {return}
                        self.detailMovie = detail
                        print(self.detailMovie!)
                        UserDefaults.standard.setValue(self.detailMovie?.original_title, forKey: "detailName")
                        UserDefaults.standard.setValue(self.detailMovie?.poster_path, forKey: "detailPoster")
                        
                        DispatchQueue.main.async {
                            let vc = DetailViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }else {
            print("포스터클릭")
        }


    }
    
    

}
