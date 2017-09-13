//
//  MasterViewController.swift
//  OKRoger-v1
//
//  Created by Ash Sharma on 4/4/16.
//  Copyright © 2016 Ash Sharma. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchResultsUpdating {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var airports = [Airport]()
    var filteredAirports = [Airport]()

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        loadAirportData()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        title = "Airports & Airlines"
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let airport: Airport
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if searchController.isActive && searchController.searchBar.text != "" {
                    airport = filteredAirports[indexPath.row]
                } else {
                    airport = airports[indexPath.row]
                }
                if let controller = segue.destination as? DetailViewController {
                    controller.detailItem = airport
                    
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredAirports.count
        }
        return airports.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AirportTableViewCell
        var airportAtIndex: Airport
        if searchController.isActive && searchController.searchBar.text != "" {
            airportAtIndex = filteredAirports[indexPath.row]
        } else {
            airportAtIndex = airports[indexPath.row]
        }
        cell.airport = airportAtIndex
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }


    // MARK: - Search Results Updating

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredAirports = airports.filter { airport in
            return airport.longdescription.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func loadAirportData() {
        let delimiter = CharacterSet(charactersIn: ",")
        let bundle = Bundle.main
        let path = bundle.path(forResource: "airports", ofType: "txt")
        do {
           // var startTime = CFAbsoluteTimeGetCurrent()
            let rawData = try CSV(name: path!, delimiter: delimiter, encoding: String.Encoding.utf8)
            //var endTime = CFAbsoluteTimeGetCurrent()
           // print("reading CSV took ",endTime - startTime)
            var airport =  Airport()
            //startTime = CFAbsoluteTimeGetCurrent()
            for row in rawData.rows {
                airport.name = row["Name"]!
                airport.city = row["City"]!
                airport.country = row["Country"]!
                airport.codeIATA = row["IATA"]!
                airport.timezoneOffset = Float(row["TimeZone"]!)!
                airport.twitterHandle = row["Twitter"]!
                airport.websiteAddress = row["Website"]!
                airports.insert(airport, at: 0)
            }
            airports.sort(by: { (ap1: Airport , ap2: Airport) -> Bool in
                ap1.country == ap2.country ? ap1.city < ap2.city : ap1.country > ap2.country
            })
           // endTime = CFAbsoluteTimeGetCurrent()
            //print("loading to objects took ",endTime - startTime)

        } catch {
            print("error")
        }
    }
}

