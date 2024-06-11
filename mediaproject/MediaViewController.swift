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
    var page = 1
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
        //
        //barbuttonitem 생성
        //        let movieList = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain , target: self, action: #selector(listClicked))
        //        movieList.tintColor = .black
        //        navigationItem.leftBarButtonItem = movieList
        //
        //        let find = UIBarButtonItem(image: UIImage(systemName:"magnifyingglass"), style: .plain, target: self, action: #selector(findClicked))
        //        navigationItem.rightBarButtonItem = find
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MediaInfoTableViewCell.self, forCellReuseIdentifier: MediaInfoTableViewCell.identifire)
    }
    
    //    @objc func listClicked() {
    //        print(#function)
    //    }
    //
    //    @objc func findClicked() {
    //        print(#function)
    //    }
    
    func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(movieButton)
        view.addSubview(findButton)
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        
        tableView.backgroundColor = .blue
        
        let image = UIImage(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(pointSize : 25,weight: .light))
        movieButton.setImage(image, for: .normal )
        
        let image2 = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize : 25,weight: .light))
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
        // 1. struct오류가 아닌데 왜 struct오류로 뜨는지 (query 값을 안넣었을 때 ) = > 성공에대한 struct이므로
        // 2. succes가 실행 ? fail실행 ?
        // 3. succes랑 fail의 구분 > 서버 상태값 (400, 200등) (상태코드기준!)
        // >>> Statyscide (200~300 succes / struct 잘 담겨있는가)
        AF.request(url).responseDecodable(of: Media.self) { response in
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                if self.list.page == 1 {
                    self.list = value
                    print("리스트만듬")
                    print(self.list)
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
            return 20
        }
        
        // 1) API Call
        // 2) Success --> list를 변경
        
        // 3) list가 변경되면 tableview를 reload
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("############")
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaInfoTableViewCell.identifire , for:  indexPath) as! MediaInfoTableViewCell
            //let data = list.results[indexPath.row]
            //print("waojfaopjfpoafjpoajfpojaofjapofjoawjpfajwfajfpjjfpoajwpfaj\(list)")
//            let imageURL = URL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2"+data?.poster_path)
//            cell.movieImage.kf.setImage(with: imageURL)
            return cell
        }
    }
    

