//
//  NetworkManager.swift
//  WhaleApp
//
//  Created by Horacio Alexandro Sanchez on 2/6/21.
//

import UIKit

final class NetworkManager : NSObject, Fetcher{
    
    
    static let shared = NetworkManager()
    private var completion_block : ((UIImage, String) -> Void)?

    
    
    public func fetchWhales(urlString: String, completion: @escaping ((UIImage, String) -> Void)) {
        
        guard let url = URL(string: urlString) else {return}
        
        //Start configuring a url session ... ⚙️
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        self.completion_block = completion
        
        
        //Initialize a data task ... ✅
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            
            //Unwrap self ...
            guard self == self else{return}
            
            //Checking for errors in the dataTask.... ⚠️
            if error != nil{
                // We have an error...return
                print("Error Ocurred: \(String(describing: error))")
                return
            }
            
            //Checking for HTTP responses from the response object...
            //The 'guard let' sintax checks if the two booleans (as? & range.contains)
            //evaluate to false... ❔
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                
                //Status code dont fall within range 200-299. Handle here. We simply return.
                
                return
            }
            
            //Checking for MIME type responses... 🔍
            //Make sure our Content-Type is an image of either jpeg or png formats.
            guard let mime = response?.mimeType, (mime == "image/jpeg") || (mime == "image/png") else{
                
                //Not a png || jpeg mime type. Return for now ...
                print(response!.mimeType!)
                print("Wrong MIME type. Exptected JSON data...")
                return
            }
            
            //Make sure we have some image data ... 🔍
            if data != nil{
                
                //Convert the image data into an image object ... 🏞
                let image = UIImage(data: data!)
                
                DispatchQueue.main.async {[weak self] in
                    
                    guard self == self else {return}
                    
                    //unwrap the image object ...
                    if let unwrapped_image = image{
                        
                        //Initialize and enum w/ url string ...
                        if let whale_urls = WhaleURLs(rawValue: urlString){
                            
                            //Execute complaetion block passed to fetchWales().
                            //Pass in the name of the whale to download ...
                            self?.completion_block?(unwrapped_image,whale_urls.whaleName)

                        }
                        
                    }
                    
                }//End of main Queue
                
                
            }else{
                
                print("Empty image data. Return for now")
                return
            }
            
            }//End of dataTask session
        
            task.resume()
            
        }//End of fetchWales()
    
    
}//End of NetworkManager
