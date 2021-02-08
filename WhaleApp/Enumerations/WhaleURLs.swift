//
//  WhaleURLs.swift
//  WhaleApp
//
//  Created by Horacio Alexandro Sanchez on 2/6/21.
//

import Foundation

enum WhaleURLs : String, CaseIterable {
    
    
    //This enum contains eight whale URLs used in this app.
    //It also declares a stored property to match the whale URL to its
    //appropiate name.
    
    case beluga = "https://media.fisheries.noaa.gov/styles/original/s3/dam-migration/640x427-beluga-whale.png?null&itok=KcnZO3rE"
    case orca = "https://media.fisheries.noaa.gov/styles/original/s3/dam-migration/640x427-killer-whale.png?null&itok=mpHhEa6Y"
    case humpback = "https://media.fisheries.noaa.gov/styles/original/s3/dam-migration/640x427-humpback.png?null&itok=xJdovo_r"
    case sei = "https://media.fisheries.noaa.gov/styles/original/s3/dam-migration/640x427-sei-whale.png?null&itok=aV7zzhmQ"
    case gray = "https://media.fisheries.noaa.gov/styles/original/s3/dam-migration/640x427-gray-whale.png?null&itok=r5uMVbmg"
    case fin = "https://media.fisheries.noaa.gov/styles/original/s3/2020-09/640x4270-fin-whale-v2.jpg?null&itok=q6QDTYa_"
    case brydes = "https://media.fisheries.noaa.gov/styles/original/s3/dam-migration/64-x427-brydes-whale.png?null&itok=dJsH4hLg"
    case blue = "https://media.fisheries.noaa.gov/styles/original/s3/dam-migration/640x427-blue-whale.jpg?null&itok=Ffb4BA78"
    
    var whaleName : String {
        
        switch self {
        
        case .beluga:
            return "Beluga Whale"
        case .orca:
            return "Orca"
        case .humpback:
            return "Humpback Whale"
        case .sei:
            return "Sei Whale"
        case .gray:
            return "Gray Whale"
        case .fin:
            return "Fin Whale"
        case .brydes:
            return "Bryde's Whale"
        case .blue:
            return "Blue Whale"
            
        }
        
    }//End of whaleName
    
}//End of WhaleURLs
