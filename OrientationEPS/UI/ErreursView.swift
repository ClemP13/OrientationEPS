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
                            Stepper(value: Binding(
                                        get: { self.listActuelle.arrayValid[index] },
                                        set: { (newValue) in
                                            if newValue >= 0 {
                                            UpdateValid(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(newValue))
                                                listActuelle.listReal = DetailManager(groupe: objGroupe).actuReaList()
                                                self.listActuelle.arrayValid = erreurManager.ArrayNbValid(parcoursRealiseList: listActuelle.listReal)
                                            }else{
                                                self.listActuelle.arrayValid[index] = 0
                                            }})) {
                                Text(" \(listActuelle.arrayValid[index]) ")
                            }
                        }else{
                            Stepper(value: Binding(
                                        get: { self.listActuelle.arrayErr[index] },
                                        set: { (newValue) in
                                            if newValue >= 0 {
                                            UpdateErr(det: DetailManager(groupe: objGroupe).parcoursRealiseList[index], nb: Int(newValue))
                                                listActuelle.listReal = DetailManager(groupe: objGroupe).actuReaList()
                                                self.listActuelle.arrayErr = erreurManager.ArrayNbErreur(parcoursRealiseList: listActuelle.listReal)
                                            }else{
                                                self.listActuelle.arrayErr[index] = 0
                                            }})) {
                                Text(" \(listActuelle.arrayErr[index]) ")
                            }
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
            listActuelle.arrayErr = erreurManager.ArrayNbErreur(parcoursRealiseList: listActuelle.listReal)
            listActuelle.arrayValid = erreurManager.ArrayNbValid(parcoursRealiseList: listActuelle.listReal)
        }
        
    }
    
    func UpdateErr(det : Detail, nb : Int) {
        erreurManager.updateNbErreur(detail: det, nbErreur: Int16(nb), parcoursRealiseList: listActuelle.listReal)
        listActuelle.arrayErr = erreurManager.ArrayNbErreur(parcoursRealiseList: listActuelle.listReal)
    }
    
    func UpdateValid(det : Detail, nb : Int) {
        erreurManager.updateNbValidation(detail: det, nbValid: Int16(nb), parcoursRealiseList: listActuelle.listReal)
        listActuelle.arrayValid = erreurManager.ArrayNbValid(parcoursRealiseList: listActuelle.listReal)
        
    }
}
