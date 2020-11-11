//
//  TempsAffichable.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 17/10/2020.
//

import Foundation

struct TempsAffichable {
    
    func secondsToMinutesSeconds (temps : Int32) -> (String) {
        var tempsAffichable : String
        let h = temps / 3600
        var min = String((temps % 3600) / 60)
        var sec = String((temps % 3600) % 60)
        if sec.count == 1 {
            sec = "0\(sec)"
        }
        if min.count == 1 {
            min = "0\(min)"
        }
        if h >= 1 {
        tempsAffichable = "\(h):\(min):\(sec)"
        }else{
        tempsAffichable = "\(min):\(sec)"
        }
        return tempsAffichable
    }
    
    func TempsAvecBonusMalus (detail : Detail, course: Course) -> Int32 {
        var temps = detail.temps
        let malus = Int32(detail.nbErreur * course.tempsMalus)
        let bonus = Int32(detail.nbValidation * course.tempsBonus)
        temps += malus
        temps -= bonus
        
        if temps < 0 {
            temps = 0
        }
        return temps
    }
}
