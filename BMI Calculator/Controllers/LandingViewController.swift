//
//  LandingViewController.swift
//  BMI Calculator
//
//  Created by Qing Liu on 10/25/22.
//  Copyright © 2022 Qing Liu. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var darkView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private let items:[OnboardingItem]=[
        .init(title: "Simulate the Flooding Scene",
              detail: "Use Downtown Providence as an example to showcase how Augmented Reality can visualize the flooding scene in a more relastic perspective.",
              bgImage: UIImage(named: "imTravel1")),
        .init(title: "Get to Know the Flooding Information",
              detail: "Mapping the most severely affected areas and Compare their current scenes and predicted scenes with flooding and the sea level rise to give audience a strong impresssion about the importance of environemental protection!",
              bgImage: UIImage(named: "imTravel2")),
        .init(title: "Experiment with AR flooding simulation",
              detail: "Based on the predications, you can rebuild your own city with Augmented Reality to decrease the influence of flooding issues.",
              bgImage: UIImage(named: "imTravel3"))
            
    ]
    
    private var currentPage: Int=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupPageControl()
        setupScreen(index: currentPage)
        updateBackgroundImage(index: currentPage)
        
        setupGestures()
        //修改bg的深度
        setupViews()
        
        
        // Do any additional setup after loading the view.
    }
    
    private func setupViews() {
        darkView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.5)
    }
    
    
    private func updateBackgroundImage(index: Int) {
        let image = items[index].bgImage
        UIView.transition(with: bgImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.bgImageView.image = image },
                          completion: nil)
        
    }
    
    
    
    private func setupPageControl(){
        pageControl.numberOfPages=items.count
    }
    
    //获取显示当前页面currentPage的内容
    private func setupScreen(index:Int){
        //1.更换内容
        titleLabel.text = items[index].title
        detailLabel.text = items[index].detail
        //2.更换pageControl的状态
        pageControl.currentPage = index
        
        //3.状态回到最初
        titleLabel.alpha = 1.0
        detailLabel.alpha = 1.0
        titleLabel.transform = .identity
        detailLabel.transform = .identity
    }
    
    private func setupGestures(){
        //获取tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapAnimation))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapAnimation(){
        
    //first animation - title label
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
        //1.先左移
            //during 0.5 seconds, the title will become a little bit transparent
            self.titleLabel.alpha = 0.8
            //move the position of the title
            // 30 to left
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        //2.左移完成再往上移
        }) { _ in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                //还是在0。5秒中
                //transparent->0
                //往上移动 直到消失
                self.titleLabel.alpha = 0
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -550)
            }, completion: nil)
        }
        
        
        // second animation - detail label
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            //1.和上面title label一样先往左移动
            self.detailLabel.alpha = 0.8
            self.detailLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        }) { _ in
            
            if self.currentPage < self.items.count - 1 {
                self.updateBackgroundImage(index: self.currentPage + 1)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                //2.和上面title label一样再往上移动
                self.detailLabel.alpha = 0
                self.detailLabel.transform = CGAffineTransform(translationX: 0, y: -550)
            }) { _ in
                //3.然后结束之后要到下个pageControl的部分 所以currentPage要+1
                self.currentPage += 1
                
                //但是要注意如果到了最后一个page再+1 已经不能显示内容了
                //所以下面的setupScreen就会报错了 所以在此之前要先检查一下
                
                if self.isOverLastItem() {
                    //如果超过了 就要开始展示app主界面了
                    self.showMainApp()
                } else {
                    self.setupScreen(index: self.currentPage)//展示currentPage的内容
                }
            }
        }
        
    }
    
    private func isOverLastItem() -> Bool {
        //如果是0，1,2,3都可以 如果是4就是超过了
        return currentPage == self.items.count
    }
    
    
    //“MainAppViewController”
    
    private func showMainApp() {
        
        let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainAppViewController")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let window = sceneDelegate.window {
            
            window.rootViewController = mainAppViewController
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
