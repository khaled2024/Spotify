//
//  ViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(settingButtonTapped))
        fechData()
    }
    //MARK: - private func
    @objc func settingButtonTapped(){
        let vc = SettingViewController()
        vc.title = "Setting"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func fechData(){
        ApiCaller.shared.getRecommendationGenres { result in
            switch result {
            case .failure(let error):
                print(error)
            case.success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                print("seeds \(seeds)")
                print(model)
                ApiCaller.shared.getRecommendation(genres: seeds) { result in
                    
                }
            }
        }
        
    }
}

