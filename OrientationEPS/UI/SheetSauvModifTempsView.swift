//
//  SheetSauvModifTempsView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 30/10/2020.
//

import SwiftUI

struct SheetSauvModifTempsView: View {
    let parcoursModif : ParcoursModificationTemps
    let objGroupe : Groupe
    @State var nomMaquette : String = ""
    @State var maquetteManager = MaquetteManager()
    @State var ancienTemps : Int32 = 0
    @State var nouveauTemps = 0
    @Binding var list: [ParcoursModificationTemps]
    @Binding var listReal : [Detail]
    @State var bonFormatSec = true
    @State var bonFormatMin = true
    @State var min = ""
    @State var sec = ""
    @State var detailManager : DetailManager
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var errValList : ErrValList
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                Text("Temps enregistré")
                    Image(systemName: "arrow.right")
                    Text("\(TempsAffichable().secondsToMinutesSeconds(temps: ancienTemps))")
                    
                }
                .padding()
                Text("Nouveau temps")
                HStack{
                    VStack{
                        Text("Minutes")
                    TextField("00", text: Binding(
                                get: { self.min },
                                set: { (newValue) in
                                    self.min = newValue
                                    let minInt = Int(self.min) ?? -1
                                    if  minInt == -1 {
                                        bonFormatMin = false
                                    }else{
                                        bonFormatMin = true
                                    }
                                    if min == ""{
                                        bonFormatMin = true
                                    }
                                    
                                }))
                        .foregroundColor(bonFormatMin ? Color("ColorDarkLight") : .red )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        }
                    VStack{
                        Text("Secondes")
                    TextField("00", text: Binding(
                            get: { self.sec },
                            set: { (newValue) in
                                self.sec = newValue
                                let secInt = Int(self.sec) ?? -1
                                if self.sec.count > 2 || secInt > 59 || secInt == -1 {
                                    bonFormatSec = false
                                }else{
                                    bonFormatSec = true
                                }
                                if sec == ""{
                                    bonFormatSec = true
                                }
                                
                            })).foregroundColor(bonFormatSec ? Color("ColorDarkLight") : .red )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        }
                    VStack{
                        Text(" ")

                    Button(action: {
                        sauvModif()
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(Font.title.weight(.bold))
                    }).disabled(bonFormatMin == false || bonFormatSec == false)
                    }
                }.padding()
                
                VStack{
                    HStack{
                        Image(systemName: "info.circle")
                        Text(" Astuce ").underline()
                        Image(systemName: "info.circle")
                        
                    }
                    Text("Pour supprimer un temps, deux possibilités :")
                    Text("- Laisser les minutes et secondes vides et valider\n- Faire glisser vers la gauche le parcours souhaité dans la liste précédente")
                }.padding()
                Spacer()
                    .onAppear(){
                        detailManager = DetailManager(groupe: objGroupe)
                        ancienTemps = parcoursModif.detail.temps
                        let tpsArr = TempsAffichable().secondsToMinutesSeconds(temps: parcoursModif.detail.temps).components(separatedBy: ":")
                        if tpsArr.count == 2{
                        min = tpsArr[0]
                        sec = tpsArr[1]
                        }else{
                            let h = Int(tpsArr[0]) ?? 0
                            let m = Int(tpsArr[1]) ?? 0
                            let tot = h * 60 + m
                            min = String(tot)
                            sec = tpsArr[2]
                        }
                    }
                    .navigationBarTitle(Text("Modifier les temps"), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Fermer ")
                        Image(systemName: "xmark")
                    }))
            }
        }
        
    }

    func sauvModif(){
        if min == "" {
            min = "0"
        }
        if sec == "" {
            sec = "0"
        }
        let minInt = Int(min) ?? 0
        let secInt = Int(sec) ?? 0
        if minInt > 0 || secInt > 0{
            let tps = Int32(minInt * 60 + secInt)
            if parcoursModif.detail.depart != nil {
                print("actu")
                detailManager.updateDetailTemps(detailId: parcoursModif.detail.id, temps: tps)
            }else{
                print("creation")
                detailManager.creerDetailParModifTemps(courseId:parcoursModif.detail.courseId, groupeId: parcoursModif.detail.groupeId, parcoursId: parcoursModif.detail.parcoursId, nomGroupe: parcoursModif.detail.nomGroupe, nomParcours: parcoursModif.detail.nomParcours, temps: tps)
            }
           
        }else{
            print("suppession")
            DetailManager(groupe: objGroupe).removeDetail(detail: parcoursModif.detail)
        }
        listReal = detailManager.parcoursRealiseList
        errValList.arrayValid = ErreurManager().ArrayNbValid(parcoursRealiseList: listReal)
        errValList.arrayErr = ErreurManager().ArrayNbErreur(parcoursRealiseList: listReal)
        list = ModificationTempsManager().getModificationTempsList(crsId: objGroupe.courseId, grId: objGroupe.id)
        self.presentationMode.wrappedValue.dismiss()
    }
}
