//
//  MediaViewController.swift
//  mediaproject
//
//  Created by 여누 on 6/10/24.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

class MediaViewController: UIViewController {
    
    let mainView = UIView()
    let tableView = UITableView()
    
    let movieButton = UIButton()
    let findButton = UIButton()

    var list = Media(page: 1, results: [])
    var isEnd = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        configureHierarchy()
        configureUI()
        configureTableView()
        callRequest()
        //
        tableView.rowHeight = 400

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MediaInfoTableViewCell.self, forCellReuseIdentifier: MediaInfoTableViewCell.identifire)
    }
    

    
    func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(movieButton)
        view.addSubview(findButton)
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        
        tableView.backgroundColor = .white
        
        let image = UIImage(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(pointSize : CGFloat(imageFontSize.mainImage) ,weight: .light))
        movieButton.setImage(image, for: .normal )
        
        let image2 = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize : CGFloat(imageFontSize.mainImage) ,weight: .light))
        findButton.setImage(image2, for: .normal )
        
        
    }
    
    func configureTableView() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        movieButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        findButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        
    }
    
    func callRequest() {
        print(#function)
        
        let url = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(APIKey.tmdbKey)&language=ko-KR"
        print(url)

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

    extension MediaViewController : UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return list.results.count
        }
        
        // 1) API Call
        // 2) Success --> list를 변경
        // 3) list가 변경되면 tableview를 reload
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("############")
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaInfoTableViewCell.identifire , for:  indexPath) as! MediaInfoTableViewCell
            let data = list.results[indexPath.row]
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2"+data.poster_path)
            cell.movieImage.kf.setImage(with: imageURL)
            cell.titleLabel.text = data.title
            cell.movieDateLabel.text = data.release_date
            let oneformat = String(format: "%.1f", data.vote_average)
            cell.rateLabel.text = "\(oneformat)"
            cell.storyLabel.text = data.overview
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("셀클릭")
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaInfoTableViewCell.identifire , for:  indexPath) as! MediaInfoTableViewCell
            let data = list.results[indexPath.row]
            UserDefaults.standard.setValue(data.title, forKey: "movieTitle")
            UserDefaults.standard.setValue(data.id, forKey: "movieId")
            navigationController?.pushViewController(MovieViewController(), animated: true)
        }
    }
    

