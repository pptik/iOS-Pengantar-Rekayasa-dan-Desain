//
//  TestingViewController.swift
//  PRD
//
//  Created by Ilham on 3/1/17.
//  Copyright © 2017 Ilham. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class TestingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var id_topik = [String]()
    var nama_topik = [String]()
    var thumbnail = [String]()
      let thumbnail2 = ["stroberi","jeruk","stroberi","jeruk","stroberi","jeruk"]
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        print("User ID anda:\(userId)")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print("XTV:\(loadTopics())")
        return 6
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
          //loadTopics()
        activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
        
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as! TestingViewControllerTableViewCell
        do {
            let opt = try HTTP.GET("http://prdapi.lskk.ee.itb.ac.id/public/topik")//HTTP GET untuk mengambil topik
            opt.start { response in //Mengolah hasil HTTP REST
                
                //Menguraikan kembalian berupa JSON ke dalam dictionary
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                
                if let dictionary = json as? [String: Any] {
                    if let rc = dictionary["RC"] as? String {//Mengambil objek RC
                        if(rc == "00"){//RC berhasil
                            
                            //Penguraian
                            let json = JSON(response.data)
                            
                            let count = json["data"].count;
                            
                            for index in 0...count{
                                self.id_topik.append(json["data"][index]["id"].stringValue)
                                self.nama_topik.append(json["data"][index]["nama_topik"].stringValue)
                                self.thumbnail.append(json["data"][index]["thumbnail"].stringValue)
                            }
                            //self.counter = count
                            cell.label.text = self.nama_topik[indexPath.row]
                            cell.thumbnail.image = UIImage(named: (self.thumbnail2[indexPath.row] + ".png"))
                            
                            //Menghentinkan tampilan loading
                            OperationQueue.main.addOperation{
                                                            self.activityIndicator.stopAnimating()
                                                            UIApplication.shared.endIgnoringInteractionEvents()
                            }
                        }
                    }
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
        
//        let url = URL(string: thumbnail[indexPath.row])
//        let data = try? Data(contentsOf: url!)
//        cell.thumbnail.image = UIImage(data: data!)
        //cell.label.text = nama_topik[indexPath.row]
        
        return (cell)
    }
    
    public func loadTopics() -> Int{
        //Menampilkan icon loading ketika proses ini dijalankan
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityIndicator)
//        
//        activityIndicator.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        
        var count = 0
        
        do {
            let opt = try HTTP.GET("http://prdapi.lskk.ee.itb.ac.id/public/topik")//HTTP GET untuk mengambil topik
            opt.start { response in //Mengolah hasil HTTP REST
                
                //Menguraikan kembalian berupa JSON ke dalam dictionary
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                
                if let dictionary = json as? [String: Any] {
                    if let rc = dictionary["RC"] as? String {//Mengambil objek RC
                        if(rc == "00"){//RC berhasil
                            //Menghentinkan tampilan loading
                            OperationQueue.main.addOperation{
//                            self.activityIndicator.stopAnimating()
//                            UIApplication.shared.endIgnoringInteractionEvents()
                            }
                            //Penguraian
                            let json = JSON(response.data)
                            
                            
//                            let name = json["data"][0]["id"].stringValue
//                            print("[STATUS]: \(name)")
                            // Update the UI on the main thread
                            DispatchQueue.main.async {
                                print("Executed!")
                                
                              //count += json["data"].count;
                                count = json["data"].count;
                                print("Count:\(count)")
                            }

                            
                            
                                //return count
                            
//                            for index in 0...count{
//                                self.id_topik.append(json["data"][index]["id"].stringValue)
//                                self.nama_topik.append(json["data"][index]["nama_topik"].stringValue)
//                                self.thumbnail.append(json["data"][index]["thumbnail"].stringValue)
//                            }
                            //self.counter = count
                            
                        }
                    }
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
            print("Count2:\(count)")
            return count
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
