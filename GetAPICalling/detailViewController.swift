//
//  detailViewController.swift
//  GetAPICalling
//
//  Created by MAC on 18/12/20.
//

import UIKit

class detailViewController: UIViewController {

    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var timezones: UILabel!
    @IBOutlet weak var numericCode: UILabel!
    
    var strRegion:String = ""
    var strPopulation:String = ""
    var strTimezones:String = ""
    var strNumericCode:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        region.text = strRegion
        population.text = strPopulation
        timezones.text = strTimezones
        numericCode.text = strNumericCode
        
        // Do any additional setup after loading the view.
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
