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
    @State var erreurManager : ErreurManager
    @State var selectorIndex = 0
    let choix = ["Erreurs","Validations"]
    let icon = ["xmark","checkmark"]
    let choixText = ["Nombre de balises fausses","Nombre de balises correctes"]
    let color: [Color] = [.red,.green]
    @State var err: [Int16]
    @State var valid: [Int16]
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
                                    valid[index] += 1
                                    UpdateValid(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(valid[index])) },
                                onDecrement: {
                                    if valid[index] > 0{
                                        valid[index] -= 1
                                        UpdateValid(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(valid[index]))
                                        
                                    }else{
                                        valid[index] = 0
                                    }
                                    
                                },
                                label: { Text(" \(valid[index]) ")})
                            
                        }else{
                            Stepper(
                                onIncrement: {
                                    err[index] += 1
                                    UpdateErr(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(err[index])) },
                                onDecrement: {
                                    if err[index] > 0{
                                        err[index] -= 1
                                        UpdateErr(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(err[index]))
                                        
                                    }else{
                                        err[index] = 0
                                    }
                                    
                                },
                                label: { Text(" \(err[index]) ")})
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
            erreurManager = ErreurManager(listErr: err, listValid: valid)
        }
        
    }
    
    func UpdateErr(det : Detail, nb : Int) {
        erreurManager.updateNbErreur(detail: det, nbErreur: Int16(nb), parcoursRealiseList: listReal)
        err = erreurManager.ArrayNbErreur(parcoursRealiseList: listReal)
        print(err)
    }
    
    func UpdateValid(det : Detail, nb : Int) {
        erreurManager.updateNbValidation(detail: det, nbValid: Int16(nb), parcoursRealiseList: listReal)
        valid = erreurManager.ArrayNbValid(parcoursRealiseList: listReal)
        
    }
}
