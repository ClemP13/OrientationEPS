//
//  BonusMalusView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 06/11/2020.
//

import SwiftUI

struct BonusMalusView: View {
    @EnvironmentObject var objCourse : CourseActuelle
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
                                CourseManager().updateMalus(courseId: objCourse.id!, malus: Int16(tempsBonusMalusEnSec[selectedMalus]))
                                objCourse.tempsMalus = Int16(tempsBonusMalusEnSec[selectedMalus])
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
                                CourseManager().updateBonus(courseId: objCourse.id!, bonus: Int16(tempsBonusMalusEnSec[selectedBonus]))
                                objCourse.tempsBonus = Int16(tempsBonusMalusEnSec[selectedBonus])
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
            selectedBonus = tempsBonusMalusEnSec.firstIndex(of: Int(objCourse.tempsBonus))!
            selectedMalus = tempsBonusMalusEnSec.firstIndex(of: Int(objCourse.tempsMalus))!
            
        }
        Spacer()
    }
}

struct labV : View{
    var body: some View {
        HStack{
            Text("Bonus pour balise correcte")
            Image(systemName:"checkmark")
                .foregroundColor(.green)
        }
    }
}

struct labE : View{
    var body: some View {
        HStack{
            Text("Malus pour balise fausse")
            Image(systemName:"xmark")
                .foregroundColor(.red)
        }
    }
}
