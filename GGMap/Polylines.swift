//
//  Polylines.swift
//  GGMap
//
//  Created by Quang Ly Hoang on 7/25/17.
//  Copyright © 2017 FenrirQ. All rights reserved.
//

import Foundation

struct Polylines: Codable {
    let routes: [Routes]
}

struct Routes: Codable {
    let overview_polyline: Overview_Polyline
    let legs: [Legs]
}

struct Overview_Polyline: Codable {
    let points: String
}

struct Legs: Codable {
    let end_adress: String
}

