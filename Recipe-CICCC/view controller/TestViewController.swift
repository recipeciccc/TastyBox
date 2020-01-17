//
//  TestViewController.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var numImg = CGFloat(2.0) // depends on how many pictures user want to use, it is gonna change.


    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 30.0, y: -30.0, width: UIScreen.main.bounds.width - 60.0 , height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * numImg, height: UIScreen.main.bounds.height)
        scrollView.isPagingEnabled = true

        // 1枚目の画像
        let firstImageView = UIImageView(image: UIImage(named: "breakfast-450x310"))
        firstImageView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width - 60.0, height: UIScreen.main.bounds.height)
        firstImageView.contentMode = UIView.ContentMode.scaleAspectFit
        scrollView.addSubview(firstImageView)

        // 2枚目の画像
        let secondImageView = UIImageView(image: UIImage(named: "images"))
        secondImageView.frame = CGRect(x: UIScreen.main.bounds.width - 60.0 * 1.0, y: 0.0, width: UIScreen.main.bounds.width - 60.0 , height: UIScreen.main.bounds.height)
        secondImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        scrollView.addSubview(secondImageView)
        
        self.view.addSubview(scrollView)
        
        // Do any additional setup after loading the view.
    }
    
    
    
//    func addPictureScrollView(pictureName named: String, numberOfPicture num: CGFloat) {
//
//        let firstImageView = UIImageView(image: UIImage(named: named))
//        firstImageView.frame = CGRect(x: UIScreen.main.bounds.width * 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        firstImageView.contentMode = UIView.ContentMode.scaleAspectFit
//        scrollView.addSubview(firstImageView)
//    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
