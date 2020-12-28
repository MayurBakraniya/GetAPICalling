//
//  ViewController.swift
//  GetAPICalling
//
//  Created by MAC on 18/12/20.
//

import UIKit

struct Welcome: Codable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct MRData: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let raceTable: RaceTable

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case raceTable = "RaceTable"
    }
}

// MARK: - RaceTable
struct RaceTable: Codable {
    let season, round: String
    let races: [Race]

    enum CodingKeys: String, CodingKey {
        case season, round
        case races = "Races"
    }
}

// MARK: - Race
struct Race: Codable {
    let season, round: String
    let url: String
    let raceName: String
    let circuit: Circuit
    let date: String
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date
        case results = "Results"
    }
}

// MARK: - Circuit
struct Circuit: Codable {
    let circuitID: String
    let url: String
    let circuitName: String
    let location: Location

    enum CodingKeys: String, CodingKey {
        case circuitID = "circuitId"
        case url, circuitName
        case location = "Location"
    }
}

// MARK: - Location
struct Location: Codable {
    let lat, long, locality, country: String
}

// MARK: - Result
struct Result: Codable {
    let number, position, positionText, points: String
    let driver: Driver
    let constructor: Constructor
    let grid, laps, status: String
    let time: ResultTime?
    let fastestLap: FastestLap

    enum CodingKeys: String, CodingKey {
        case number, position, positionText, points
        case driver = "Driver"
        case constructor = "Constructor"
        case grid, laps, status
        case time = "Time"
        case fastestLap = "FastestLap"
    }
}

// MARK: - Constructor
struct Constructor: Codable {
    let constructorID: String
    let url: String
    let name, nationality: String

    enum CodingKeys: String, CodingKey {
        case constructorID = "constructorId"
        case url, name, nationality
    }
}

// MARK: - Driver
struct Driver: Codable {
    let driverID: String
    let code: String?
    let url: String
    let givenName, familyName, dateOfBirth, nationality: String
    let permanentNumber: String?

    enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case code, url, givenName, familyName, dateOfBirth, nationality, permanentNumber
    }
}

// MARK: - FastestLap
struct FastestLap: Codable {
    let rank, lap: String
    let time: FastestLapTime
    let averageSpeed: AverageSpeed

    enum CodingKeys: String, CodingKey {
        case rank, lap
        case time = "Time"
        case averageSpeed = "AverageSpeed"
    }
}

// MARK: - AverageSpeed
struct AverageSpeed: Codable {
    let units: Units
    let speed: String
}

enum Units: String, Codable {
    case kph = "kph"
}

// MARK: - FastestLapTime
struct FastestLapTime: Codable {
    let time: String
}

// MARK: - ResultTime
struct ResultTime: Codable {
    let millis, time: String
}


class ViewController: UIViewController {

    var arrayData = [Driver]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        getData()
        // Do any additional setup after loading the view.
    }
    
    func getData(){
        let url = URL(string: "https://ergast.com/api/f1/2004/1/results.json")
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            do{
                if error == nil{
                let decodeData = try
                    JSONDecoder().decode(Result.self, from: data!)
                    
                    print(decodeData)
                    self.arrayData.append(decodeData.driver)
                    print(self.arrayData)
                    
                    for mainArr in self.arrayData{
                        print(mainArr.givenName, ":",mainArr.nationality)
                        
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                       
                    }
                    
                }
            }
            catch{
                print("Error in Get jsonData")
            }
           
        }.resume()
    }

    func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let id = String(arrayData[indexPath.row].givenName)
        
        cell.titleLbl.text = id
        cell.desLbl.text = arrayData[indexPath.row].nationality
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let detail:detailViewController = storyboard.instantiateViewController(withIdentifier: "detailViewController") as! detailViewController
        detail.strRegion = arrayData[indexPath.row].givenName
        detail.strPopulation = arrayData[indexPath.row].nationality
//        detail.strTimezones = arrayData[indexPath.row].alpha2Code
//        detail.strNumericCode = arrayData[indexPath.row].alpha3Code
        self.navigationController?.pushViewController(detail, animated: true )
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

