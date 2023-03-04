//
//  Population.swift
//  Machine_Test
//
//  Created by Mac on 04/03/23.
//

import Foundation




struct Population : Decodable{
    var Population : Int
    var year : Int
    enum mainContainerKey : CodingKey{
        case Population,year
    }
    init(from decoder : Decoder)throws{
        let mainContainer = try decoder.container(keyedBy: mainContainerKey.self)
        Population = try! mainContainer.decode(Int.self, forKey: .Population)
        year = try! mainContainer.decode(Int.self, forKey: .year)
        
        
    }
}
