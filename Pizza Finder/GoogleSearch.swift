//
//  GoogleSearch.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 5/26/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import GoogleMaps

enum RankType: String {
    case distance = "distance"
    case location = "location"
}

enum TravelModes: String {
    case walking = "walking"
    case driving = "driving"
    case bicycling = "bicycling"
    case transit = "transit"
}

struct WayPoint {
    var startCoordinate: CLLocationCoordinate2D
    var endCoordinate: CLLocationCoordinate2D
    var duration: String
    var distance: String
    var direction: String
}

extension UIImageView {
    func pullRestaurantPhoto(establishment: EstablishmentsObj) {
        let urlString = GoogleSearch().googleEstablishmentPhotoSearchString(establishment: establishment, maxWidth: 280)
        let url = URL(string: urlString)
        let downloadedImage = try? UIImage(data: Data(contentsOf: url!))
        self.image = downloadedImage!
    }
}

class GoogleSearch: NSObject {

    let baseSearchString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let baseDirectionsString = "https://maps.googleapis.com/maps/api/directions/json?"
    let basePhotosString = "https://maps.googleapis.com/maps/api/place/photo?"
    let nycLatitude = 40.730610
    let nycLongitude = -73.935242
    let nycLatitude2 = 40.735345
    let nycLongitude2 = -73.9356295
    let apiKey = "AIzaSyCy5RT5v2qUzOGNirGVdBDnGIaV2ix9yJo"
    
    func googleSearchString(metersRadius: Double, isRankedByClosest: Bool, isRankedByType: RankType, latitude: Double, longitude: Double, keyword: String, openNow: Bool, type: String) -> String {
        
        //Required parameters
        let key = "key=\(apiKey)"
        var searchString = baseSearchString + key
        
        let location = "location=\(latitude),\(longitude)"
        var radius: String?
        var rankBy: String?
        
        //Optional parameters
        let keyword = "keyword=\(keyword)"
        let openNow = "opennow=\(openNow)"
        let type = "type=\(type)"
        
        
        var parameterArray = [location, keyword, openNow, type]
            
        if isRankedByClosest {
            rankBy = "rankby=\(isRankedByType)"
            parameterArray.append(rankBy!)
        } else {
            radius = "radius=\(metersRadius)"
            parameterArray.append(radius!)
        }
        
        for parameter in parameterArray {
            searchString.append("&")
            searchString.append(parameter)
        }
        
        print(searchString)
        return searchString
    }
    
    func googleEstablishmentPhotoSearchString(establishment: EstablishmentsObj, maxWidth: Int) -> String {
        //Required parameters
        let key = "key=\(apiKey)"
        var searchString = basePhotosString + key
        let width = "maxwidth=\(maxWidth)"
        let photoRef = "photoreference=\(establishment.photoRef!)"
        
        searchString.append("&")
        searchString.append(width)
        searchString.append("&")
        searchString.append(photoRef)
        
        return searchString
    }
    
    func retrieveData(htmlString: String, completion: @escaping ([EstablishmentsObj]) -> ()) {
        
        var establishmentsArray = [EstablishmentsObj]()
            
        let url = URL(string: htmlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            
            if let data = jsonData as? NSDictionary, let results = data["results"] as? [AnyObject] {
                for result in results {
                    if let name = result["name"] as? String,
                    let address = result["vicinity"] as? String,
                    let rating = result["rating"] as? Double,
                    let pricing = result["price_level"] as? Int,
                    let placeID = result["place_id"] as? String,
                    let photoRef = result["photos"] as? [AnyObject],
                    let photoReference = photoRef.first?["photo_reference"] as? String {
                        
                        if let geometry = result["geometry"] as? [String: AnyObject], let location = geometry["location"] as? [String: AnyObject] {
                            
                            if let latitude = location["lat"] as? Double,
                            let longitude = location["lng"] as? Double {
                                let establishment = EstablishmentsObj(name: name, address: address, rating: rating, priceTier: pricing, latitude: latitude, longitude: longitude, placeID: placeID, photoRef: photoReference)
                                establishmentsArray.append(establishment)
                                print(name)
                                print(placeID)
                                
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(establishmentsArray)
            }
            
        }.resume()
        
    }
    
    /*
     
     Required parameters
     
     key — Your application's API key. This key identifies your application for purposes of quota management and so that places added from your application are made immediately available to your app. See Get a key for more information.
     
     location — The latitude/longitude around which to retrieve place information. This must be specified as latitude,longitude.
     
     radius — Defines the distance (in meters) within which to return place results. The maximum allowed radius is 50 000 meters. Note that radius must not be included if rankby=distance (described under Optional parameters below) is specified.
     
     If rankby=distance (described under Optional parameters below) is specified, then one or more of keyword, name, or type is required.
     
     Optional parameters
     
     keyword — A term to be matched against all content that Google has indexed for this place, including but not limited to name, type, and address, as well as customer reviews and other third-party content.
     
     language — The language code, indicating in which language the results should be returned, if possible. See the list of supported languages and their codes. Note that we often update supported languages so this list may not be exhaustive.
     
     minprice and maxprice (optional) — Restricts results to only those places within the specified range. Valid values range between 0 (most affordable) to 4 (most expensive), inclusive. The exact amount indicated by a specific value will vary from region to region.
     
     name — A term to be matched against all content that Google has indexed for this place. Equivalent to keyword. The name field is no longer restricted to place names. Values in this field are combined with values in the keyword field and passed as part of the same search string. We recommend using only the keyword parameter for all search terms.
     
     opennow — Returns only those places that are open for business at the time the query is sent. Places that do not specify opening hours in the Google Places database will not be returned if you include this parameter in your query.
     
     rankby — Specifies the order in which results are listed. Note that rankby must not be included if radius (described under Required parameters above) is specified. Possible values are:
     
     prominence (default). This option sorts results based on their importance. Ranking will favor prominent places within the specified area. Prominence can be affected by a place's ranking in Google's index, global popularity, and other factors.
     
     distance. This option biases search results in ascending order by their distance from the specified location. When distance is specified, one or more of keyword, name, or type is required.
     
     type — Restricts the results to places matching the specified type. Only one type may be specified (if more than one type is provided, all types following the first entry are ignored). See the list of supported types.
     
     types (deprecated) — Restricts the results to places matching at least one of the specified types. Separate types with a pipe symbol, like this:
     
     type1|type2|etc.
     
     pagetoken — Returns the next 20 results from a previously run search. Setting a pagetoken parameter will execute a search with the same parameters used previously — all parameters other than pagetoken will be ignored.
     
     zagatselected (deprecated) — Add this parameter (just the parameter name, with no associated value) to restrict your search to locations that are Zagat selected businesses. This parameter must not include a true or false value. The zagatselected parameter is experimental, and is only available to Google Places API customers with a Premium Plan license.
 */
    
}
