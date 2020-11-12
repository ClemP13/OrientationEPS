//
//  ErreursView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 20/10/2020.
//

import SwiftUI

struct ErreursView: View {
    
    let objGroupe : Groupe
    @State var parcoursManager : ParcoursManager
    @State var erreurManager = ErreurManager()
    @State var selectorIndex = 0
    let choix = ["Erreurs","Validations"]
    let icon = ["xmark","checkmark"]
    let choixText = ["Nombre de balises fausses","Nombre de balises correctes"]
    let color: [Color] = [.red,.green]
    @EnvironmentObject var listActuelle : ListActuelle
    @State var listReal: [Detail] = []
    
    var body: some View {
        Picker("Correction", selection: $selectorIndex) {
            Text("Erreurs")
                .foregroundColor(.red)
                .tag(0)
            Text("Validations")
                .foregroundColor(.red)
                .tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        HStack{
            Image(systemName : icon[selectorIndex])
            Text(choixText[selectorIndex])
            Image(systemName : icon[selectorIndex])
        }.foregroundColor(color[selectorIndex])
        
        List{
            if DetailManager(groupe: objGroupe).parcoursRealiseList.count > 0{
                ForEach(0 ..< DetailManager(groupe: objGroupe).parcoursRealiseList.count) { index in
                    HStack{
                        Text(DetailManager(groupe: objGroupe).parcoursRealiseList[index].nomParcours)
                        Image(systemName: "arrow.right")
                            .foregroundColor(color[selectorIndex])
                        Spacer()
                        
                        if selectorIndex > 0 {
                            Stepper(
                                onIncrement: {
                                    let value = errValList.arrayValid[index] + 1
                                    print(value)
                                    UpdateValid(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(value))
                                    errValList.arrayValid[index] = value
                                },
                                onDecrement: {
                                    if errValList.arrayValid[index] > 0{
                                        let value = errValList.arrayValid[index] - 1
                                        UpdateValid(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(value))
                                        errValList.arrayValid[index] = value
                                    }else{
                                        errValList.arrayValid[index] = 0
                                    }
                                    
                                },
                                label: { Text(" \(errValList.arrayValid[index]) ")})
                            
                        }else{
                            Stepper(
                                onIncrement: {
                                    let value = errValList.arrayErr[index] + 1
                                    print(errValList.arrayErr)
                                    UpdateErr(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(value))
                                    errValList.arrayErr[index] = value
                                },
                                onDecrement: {
                                    if errValList.arrayErr[index] > 0{
                                        let value = errValList.arrayErr[index] - 1
                                        UpdateErr(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(value))
                                        errValList.arrayErr[index] = value
                                        
                                    }else{
                                        errValList.arrayErr[index] = 0
                                    }
                                    
                                },
                                label: { Text(" \(errValList.arrayErr[index]) ")})
                        }
                    }
                }
            }else{
                Text("Aucun parcours réalisé actuellement")
            }
        }
        .navigationTitle("Carton de contrôle")
        .onAppear(){
            parcoursManager = ParcoursManager(courseId: objGroupe.courseId)
            errValList.arrayErr = erreurManager.ArrayNbErreur(parcoursRealiseList: listReal)
            errValList.arrayValid = erreurManager.ArrayNbValid(parcoursRealiseList: listReal)
        }
        
    }
    
    func UpdateErr(det : Detail, nb : Int) {
        erreurManager.updateNbErreur(detail: det, nbErreur: Int16(nb), parcoursRealiseList: listReal)
        errValList.arrayErr = erreurManager.ArrayNbErreur(parcoursRealiseList: listReal)
    }
    
    func UpdateValid(det : Detail, nb : Int) {
        erreurManager.updateNbValidation(detail: det, nbValid: Int16(nb), parcoursRealiseList: listReal)
        errValList.arrayValid = erreurManager.ArrayNbValid(parcoursRealiseList: listReal)
        
    }
}
