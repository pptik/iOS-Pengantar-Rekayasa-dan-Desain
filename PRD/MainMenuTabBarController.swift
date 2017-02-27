//
//  MainMenuTabBarController.swift
//  PRD
//
//  Created by Ilham on 2/27/17.
//  Copyright © 2017 Ilham. All rights reserved.
//

import UIKit

class MainMenuTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Kustomisasi tombol kembali
        self.navigationItem.setHidesBackButton(true, animated:true)
        //self.navigationController?.navigationBar.backItem?.title = "Keluar"
        
        //Memberikan tombol berupa icon
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func debugs(){
        print("debug")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
