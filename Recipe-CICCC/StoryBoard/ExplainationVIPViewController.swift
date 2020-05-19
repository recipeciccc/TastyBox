//
//  ExplainationVIPViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Crashlytics

class ExplainationVIPViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thereeMonthsFreeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    let expiredDate =  Calendar.current.date(byAdding: .month, value: 3, to: Date())
    
    
    let dataManager = ExplainationVIPDatamanager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let formatter = DateFormatter()
           // initially set the format based on your datepicker date / server String
          //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        formatter.timeZone = TimeZone.current

        let stringExpiredDate = formatter.string(from: expiredDate!) // string purpose I add here
           // convert your string to date
        
        titleLabel.text = "Get 3 months Free\nVIP Membership!"
        thereeMonthsFreeLabel.text = "* You can see VIP recipes of your following creators if you sign up VIP membership!  \n\n\n* Only now it cost free in 3 months. if you sign up membership now, your free membership will be expired on \(stringExpiredDate) Click register and you can get 3 months free membership."
        priceLabel.text = "$3.0 + tax -> $0!"
    }
    
    @IBAction func registerVIP(sender: UIButton) {
        
//        let timeStampExpiredDate = DateFormatter.localizedString(from: expiredDate!, dateStyle: .short, timeStyle: .none)
        dataManager.registerVIP(expiredDate: expiredDate!)
       
        
        let alertController = UIAlertController(title: "Thank you!", message: "Now You got 3 months free menbership! Enjoy VIP membership!", preferredStyle: .alert)
            
        let defaultAction = UIAlertAction(title: "Yes! Hoooo!", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VIP_page") as! VIPViewController
            
            
        })
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
         
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
