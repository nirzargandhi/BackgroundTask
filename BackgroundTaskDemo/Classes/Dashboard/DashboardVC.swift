//
//  DashboardVC.swift
//  BackgroundTaskDemo
//
//  Created by Nirzar Gandhi on 05/12/24.
//

import UIKit

class DashboardVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var homeBtn: UIButton!
    
    
    // MARK: - Properties
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dashboard"
        
        self.setControlsProperty()
    }
    
    fileprivate func setControlsProperty() {
        
        // Home Buttton
        self.homeBtn.backgroundColor = .black
        self.homeBtn.setTitleColor(.white, for: .normal)
        self.homeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.homeBtn.titleLabel?.lineBreakMode = .byClipping
        self.homeBtn.layer.masksToBounds = true
        self.homeBtn.showsTouchWhenHighlighted = false
        self.homeBtn.adjustsImageWhenHighlighted = false
        self.homeBtn.adjustsImageWhenDisabled = false
        self.homeBtn.setTitle("HomeVC", for: .normal)
    }
}


// MARK: - Button Touch & Action
extension DashboardVC {
    
    @IBAction func homeBtnTouch(_ sender: Any) {
        
        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}
