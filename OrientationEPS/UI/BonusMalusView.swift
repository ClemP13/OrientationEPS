//
//  BonusMalusView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 06/11/2020.
//

import SwiftUI

struct BonusMalusView: View {
    @Binding var objCourse: Course
    @State var tempsMalus : Int16 = 0
    @State var tempsBonus : Int16 = 0
    @State var selectedMalus : Int = 0
    @State var selectedBonus : Int = 0
    let tempsBonusMalusEnSec : [Int] = [0,5,10,15,30,45,60,90,120,180,240,300,600,1200,1800]
    
    
    var body: some View {
        Form{
            Section(header: Text("ajout/retrait temps - carton de contrôle")){
                HStack{
                    Picker(selection: Binding(
                            get: { self.selectedMalus },
                            set: { (newValue) in
                                self.selectedMalus = newValue
                                objCourse = CourseManager().updateMalus(course: objCourse, malus: Int16(tempsBonusMalusEnSec[selectedMalus]))
                                tempsMalus = Int16(tempsBonusMalusEnSec[selectedMalus])
                            }), label: labE()) {
                        let count = tempsBonusMalusEnSec.count
                        ForEach (0 ..< count, id: \.self) {
                            Text("+ \(String(TempsAffichable().secondsToMinutesSeconds(temps: Int32(tempsBonusMalusEnSec[$0]))))")
                                .foregroundColor(.red)
                        }
                    }
                }
                HStack{
                    Picker(selection: Binding(
                            get: { self.selectedBonus },
                            set: { (newValue) in
                                self.selectedBonus = newValue
                                objCourse = CourseManager().updateBonus(course: objCourse, bonus: Int16(tempsBonusMalusEnSec[selectedBonus]))
                                tempsBonus = Int16(tempsBonusMalusEnSec[selectedBonus])
                            }), label: labV()) {
                        let count = tempsBonusMalusEnSec.count
                        ForEach (0 ..< count, id: \.self) {
                            Text("- \(String(TempsAffichable().secondsToMinutesSeconds(temps: Int32(tempsBonusMalusEnSec[$0]))))")
                                .foregroundColor(.green)
                        }
                    }
                }
                
            }
            HStack{
                Spacer()
                Image(systemName: "info.circle")
                Text("Info")
                Image(systemName: "info.circle")
                Spacer()
            }
            VStack{
                Text("Dans la page de résultats d'un coureur, en haut à droite, pour ajouter des erreurs et validations, sélectionner le bouton :")
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                Text("L'ensemble des temps, RK, classements seront automatiquement modifiés")
            }
        }
        .onAppear(){
            tempsBonus = objCourse.tempsBonus
            tempsMalus = objCourse.tempsMalus
            selectedBonus = tempsBonusMalusEnSec.firstIndex(of: Int(tempsBonus))!
            selectedMalus = tempsBonusMalusEnSec.firstIndex(of: Int(tempsMalus))!
            
        }
        Spacer()
    }
}

