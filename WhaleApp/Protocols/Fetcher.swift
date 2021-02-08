//
//  Fetcher.swift
//  WhaleApp
//
//  Created by Horacio Alexandro Sanchez on 2/6/21.
//

import UIKit

protocol Fetcher{
    
    //This protocol defines the standard behavior of our Network Manager
    
    func fetchWhales(urlString: String, completion: @escaping ((UIImage, String) -> Void))
}
