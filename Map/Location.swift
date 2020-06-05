//
//  Location.swift
//  Map
//
//  Created by Aakash Adhikari on 5/11/20.
//  Copyright © 2020 Aakash Adhikari. All rights reserved.


import Foundation
import MapKit

class Artwork: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

  init(
    coordinate: CLLocationCoordinate2D
  ) {
    self.coordinate = coordinate
    
    
    super.init()
  }
  init?(feature: MKGeoJSONFeature) {
    // 1
    guard
      let point = feature.geometry.first as? MKPointAnnotation,
      // 2
      let propertiesData = feature.properties,
      let json = try? JSONSerialization.jsonObject(with: propertiesData),
      let properties = json as? [String: Any]
      else {
        return nil
    }
    // 3
    coordinate = point.coordinate
    super.init()
  }
}
