//
//  Timer.swift
//  ARMultiuser
//
//  Created by NMI Capstone on 10/22/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

extension ViewController{
    
    
    func smallTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(wait), userInfo: nil, repeats: true)
    }
    
    
    
    @objc
    func wait()
    {
        countdown -= 1
       
        
        if countdown == 0{
            timer.invalidate()
            print("done waiting")
            
        }
        
    }
    
    
    
}
