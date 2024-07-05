//
//  NasaViewController.swift
//  mediaproject
//
//  Created by 여누 on 7/5/24.
//

import UIKit
import SnapKit

final class NasaViewController : UIViewController {
    
    enum Nasa: String, CaseIterable {
        
        static let baseURL = "https://apod.nasa.gov/apod/image/"
        
        case one = "2308/sombrero_spitzer_3000.jpg"
        case two = "2212/NGC1365-CDK24-CDK17.jpg"
        case three = "2307/M64Hubble.jpg"
        case four = "2306/BeyondEarth_Unknown_3000.jpg"
        case five = "2307/NGC6559_Block_1311.jpg"
        case six = "2304/OlympusMons_MarsExpress_6000.jpg"
        case seven = "2305/pia23122c-16.jpg"
        case eight = "2308/SunMonster_Wenz_960.jpg"
        case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
         
        static var photo: URL {
            return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
        }
    }
    
    private let buffuerLabel = UILabel()
    private let imageView = UIImageView()
    private let nasaButton = UIButton()
    
    var session: URLSession!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        nasaButton.addTarget(self, action: #selector(nasaButtonClicekd), for: .touchUpInside)
    }
    
    @objc func nasaButtonClicekd() {
        
        callRequest()
    }
    
    func configureHierarchy() {
        view.addSubview(buffuerLabel)
        view.addSubview(imageView)
        view.addSubview(nasaButton)
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        nasaButton.backgroundColor = .blue
    }
    
    func configureView() {
        nasaButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        buffuerLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(nasaButton.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(buffuerLabel.snp.bottom).offset(10)
            make.height.equalTo(500)
        }
    }
    
    func callRequest() {
        let request = URLRequest(url: Nasa.photo)
        
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        session.dataTask(with: request).resume()
    }
}

extension NasaViewController : URLSessionDataDelegate {
    
}
