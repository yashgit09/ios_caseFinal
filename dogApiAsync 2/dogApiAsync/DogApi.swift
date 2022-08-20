//
//  DogApi.swift
//  dogApiAsync
//
//  Created by user221908 on 7/13/22.
//

import Foundation

struct DogApi: Decodable {
    let localized_name: String
    //let primary_attr: String
    //let attack_type: String
    var id: Int
    let img: String
}
