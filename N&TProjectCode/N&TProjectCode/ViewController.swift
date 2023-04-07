//
//  ViewController.swift
//  N&TProjectCode
//
//  Created by 최우영 on 2023/04/07.
//

import UIKit

class ViewController: UIViewController {

    // 로그인 버튼
    private let nextButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
    }
    
    private func configureButton() {
        nextButton.backgroundColor = .blue
        nextButton.setTitle("Login", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func nextButtonTapped() {
        // creation tab bar controller
        let tabBarViewController = UITabBarController()
        
        let vc1 = UINavigationController(rootViewController: FirstViewController())
        let vc2 = SecondViewController()
        let vc3 = ThirdViewController()
        let vc4 = FourthViewController()
        let vc5 = FifthViewController()
        
        // set tab bar's title
        vc1.title = "Main"
        vc2.title = "Search"
        vc3.title = "Post"
        vc4.title = "Likes"
        vc5.title = "Me"
        
        // set view controllers
        tabBarViewController.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        tabBarViewController.modalPresentationStyle = .fullScreen
        tabBarViewController.tabBar.backgroundColor = .white
        
        // set icon
        guard let items = tabBarViewController.tabBar.items else { return }
        items[0].image = UIImage(systemName: "trash")
        items[1].image = UIImage(systemName: "folder")
        items[2].image = UIImage(systemName: "paperplane")
        items[3].image = UIImage(systemName: "doc")
        items[4].image = UIImage(systemName: "note")
        
        // tab bar present
        present(tabBarViewController, animated: true)
    }
}

