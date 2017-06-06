//
//  GoogleDirections.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 5/30/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import GoogleMaps

extension GoogleSearch {

    func downloadDirections(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, TravelMode: TravelModes, completion: @escaping ([WayPoint]) -> ()) {
        let key = "key=\(apiKey)"
        let originString = "&origin=\(origin.latitude),\(origin.longitude)"
        let destinationString = "&destination=\(destination.latitude),\(destination.longitude)"
        let searchString = baseDirectionsString + key + originString + destinationString
        
        print(searchString)
        
        let urlString = URL(string: searchString)
        URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            var wayPoints = [WayPoint]()
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject] else { return }
            
            guard let routes = json?["routes"] as? [AnyObject] else { return }
            guard let route = routes.first else { return }
            guard let legs = route["legs"] as? [AnyObject] else { return }
            
            if let steps = legs.first?["steps"] as? [AnyObject] {
                for step in steps {
                    if let startLocation = step["start_location"] as? [String: AnyObject],
                        let endLocation = step["end_location"] as? [String: AnyObject],
                        let duration = step["duration"] as? [String: AnyObject],
                        let distance = step["distance"] as? [String: AnyObject],
                        let instructions = step["html_instructions"] as? String {
                        
                        print(startLocation)
                        guard let startLatitude = startLocation["lat"] as? Double else { return }
                        guard let startLongitude = startLocation["lng"] as? Double else { return }
                        let startCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(startLatitude), CLLocationDegrees(startLongitude))
                        
                        
                        print(endLocation)
                        guard let endLatitude = endLocation["lat"] as? Double else { return }
                        guard let endLongitude = endLocation["lng"] as? Double else { return }
                        let endCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(endLatitude), CLLocationDegrees(endLongitude))
                        
                        print(duration)
                        guard let durationString = duration["text"] as? String else { return }
                        
                        print(distance)
                        guard let distanceString = distance["text"] as? String else { return }
                        
                        print(instructions)
                        
                        let wayPoint = WayPoint(startCoordinate: startCoordinate, endCoordinate: endCoordinate, duration: durationString, distance: distanceString, direction: instructions)
                        wayPoints.append(wayPoint)
                    }
                    print("")
                }
            }
            
            DispatchQueue.main.async {
                completion(wayPoints)
            }
            }.resume()
    }

}
