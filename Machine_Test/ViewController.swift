//
//  ViewController.swift
//  Machine_Test
//
//  Created by Mac on 04/03/23.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var PopulationTabelView: UITableView!
    @IBOutlet weak var UsersCollectionView: UICollectionView!
   
    @IBOutlet weak var mapView: GMSMapView!
    
    
    var url : URL?
    var urlString : String?
    var urlRequest :URLRequest?
    var urlSession : URLSession?
    var jsonDecoder : JSONDecoder?
    
    var users = [Users]()
    var populations = [Population]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let uinibName = UINib(nibName: "UsersCollectionViewCell", bundle: nil)
        self.UsersCollectionView.register(uinibName, forCellWithReuseIdentifier: "UsersCollectionViewCell")
        UsersCollectionView.delegate = self
        UsersCollectionView.dataSource = self
        
        PopulationTabelView.delegate = self
        PopulationTabelView.dataSource = self
        let tabelNib = UINib(nibName: "PopulationTableViewCell", bundle: nil)
        PopulationTabelView.register(tabelNib, forCellReuseIdentifier: "PopulationTableViewCell")

        
        
        getUsers()
        jsonPassingDecoder()
        // Do any additional setup after loading the view.
    }
    
    func getUsers(){
        var urlString = "https://gorest.co.in/public/v2/users"
       url = URL(string: urlString)
        urlRequest = URLRequest(url: url!)
        urlRequest?.httpMethod = "GET"
        
        urlSession = URLSession(configuration:.default)
        
        var dataTask = urlSession?.dataTask(with: urlRequest!){
            data, response,error in
            let jsonObject = try! JSONSerialization.jsonObject(with: data!)as![[String : Any]]
            //let usersArray = jsonObject["users"] as![[String : Any]]
            for eachUser in jsonObject{
                let userId = eachUser["id"] as! Int
                let userName = eachUser["name"] as! String
                let userGender = eachUser["gender"] as! String
                
                let newUser = Users(id: userId, name: userName, gender: userGender)
               
                self.users.append(newUser)
                
             }
            DispatchQueue.main.async {
                self.UsersCollectionView.reloadData()
            }
            
            
        }.resume()
        
        
    }
    func jsonPassingDecoder(){
        urlString =  "https://datausa.io/api/data?drilldowns=Nation&measures=Population"
 
     url = URL(string: urlString!)
        urlRequest = URLRequest(url: url!)
        URLSession.shared.dataTask(with: urlRequest!){
            data,response,error in
            if (error == nil ){
                do{
                    self.jsonDecoder = JSONDecoder()
                    let populationResponse = try self.jsonDecoder?.decode([Population].self, from: data!)
                    self.populations = populationResponse!
                }catch{
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.PopulationTabelView.reloadData()
            }
        }.resume()
    }
}
extension  ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return populations.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = populations[indexPath.row]
        let cell = PopulationTabelView.dequeueReusableCell(withIdentifier: "PopulationTableViewCell",for:indexPath)as! PopulationTableViewCell
        cell.YearLabel.text = String(data.year)
        cell.PopulationLabel.text = String(data.Population)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.00
    }
}


extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewHeight = view.frame.size.height
        let viewWidth = view.frame.size.width
        return CGSize(width: viewWidth , height: viewHeight)
    }
}
extension ViewController : UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let usercollectionviewcell = self.UsersCollectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath)as! UsersCollectionViewCell
        
        let eachUser = users[indexPath.row]
        usercollectionviewcell.idLabel.text = String(eachUser.id)
        usercollectionviewcell.nameLabel.text = String(eachUser.name)
        usercollectionviewcell.genderLabel.text = String(eachUser.gender)
        return usercollectionviewcell
        
    }
    
    
    }
   
    

 
