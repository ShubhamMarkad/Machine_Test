//
//  ViewController.swift
//  Machine_Test
//
//  Created by Mac on 04/03/23.
//

import UIKit
import GoogleMaps
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var PopulationTabelView: UITableView!
    @IBOutlet weak var UsersCollectionView: UICollectionView!
   
    @IBOutlet weak var mapView: MKMapView!
   // @IBOutlet weak var mapView: GMSMapView!
     
    
    var url : URL?
    var urlString : String?
    var urlRequest :URLRequest?
    var urlSession : URLSession?
    var jsonDecoder : JSONDecoder?
    
    var users = [Users]()
    var populations = [PopulationData]()
    var loctionManager : CLLocationManager!

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
        fetchPopulationData()
        setMapView()
        // Do any additional setup after loading the view.
    }
    private func setMapView(){
            let latitude:CLLocationDegrees = 18.5091
            let longitude:CLLocationDegrees = 73.8326
        let letDelta:CLLocationDegrees = 45.0
        let lonDelta:CLLocationDegrees = 0.04
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let span:MKCoordinateSpan = .init(latitudeDelta: letDelta, longitudeDelta: lonDelta)
            let region:MKCoordinateRegion = .init(center: location, span: span)
            self.mapView.setRegion(region, animated: true)

            let annotation:MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Bitcode Technology"
            self.mapView.addAnnotation(annotation)
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
    private func fetchPopulationData(){
            let url = URL(string: "https://datausa.io/api/data?drilldowns=Nation&measures=Population")
            let request = URLRequest(url: url!)
            let dataTask = URLSession.shared.dataTask(with: request){
                data,response,error in
                if(error == nil){
                    do{
                        let jsonData = try JSONDecoder().decode(DataModelPopulation.self, from: data!)
                        self.populations = jsonData.data
                        print("Population Data:-",self.populations.count)
                        DispatchQueue.main.async {
                            self.PopulationTabelView.reloadData()
                        }
                    }
                    catch{
                        
                    }
                }
            }
            dataTask.resume()
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
        cell.PopulationLabel.text = String(data.population)
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
   
    
/*
 
func showMarker(position : CLLocationCoordinate2D){
    marker.position = position
    marker.title = "LiveLoction"
    marker.snippet = "LiveLoction"
    marker.rotation = 45.0
    marker.isDraggable = true
    marker.zIndex = 30
    marker.opacity = 0.4
    marker.map = mapView
}
func inializaMapSetting(){
    mapView.mapType = .normal
    mapView.settings.indoorPicker = true
    mapView.settings.myLocationButton = true
    mapView.settings.rotateGestures = true
    mapView.settings.scrollGestures = true
    mapView.settings.zoomGestures = true
    mapView.settings.tiltGestures = true
    
}
}
extension ViewController : GMSMapViewDelegate{
func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
    print("\(marker.position.latitude) --- \(marker.position.longitude)")
}
func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
    print("\(marker.position.latitude)--\(marker.position.longitude)")
}
func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    let infoWindowView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
    infoWindowView.backgroundColor = UIColor.blue
    infoWindowView.alpha = 0.0
    
    let label1 = UILabel(frame: CGRect(x: 10, y: 10, width: Int(infoWindowView.frame.width)-20, height: 30))
    label1.backgroundColor = UIColor(red: 0.25, green: 0.0, blue: 0.0, alpha: 0.6)
    label1.text = "This is live loction"
    label1.textColor = .white
    infoWindowView.addSubview(label1)
    return infoWindowView
}
}
*/
