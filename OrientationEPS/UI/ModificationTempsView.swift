//
//  ModificationTempsView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 30/10/2020.
//

import SwiftUI

struct ModificationTempsView: View {
    let objGroupe : Groupe
    @EnvironmentObject var objCourse : CourseActuelle
    @State var detailManager : DetailManager
    @State var sheet = false
    @State var selectedParcoursModif: ParcoursModificationTemps?
    @State var listParcours : [ParcoursModificationTemps]
    @EnvironmentObject var listActuelle : ListActuelle
    
    var body: some View {
        Form{
            Section(header: Header(), footer: FooterZero(nb: listParcours.count)){
                List{
                    ForEach (listParcours){parc in
                        HStack{
                            if parc.detail.arrivee == nil && parc.detail.depart != nil {
                                Text(parc.parcours.parcoursNom)
                                Spacer()
                                Text("En cours")
                            }else{
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title)
                                    .onTapGesture {
                                        self.selectedParcoursModif = parc
                                    }
                                Text(parc.parcours.parcoursNom)
                                Spacer()
                                Text(TempsAffichable().secondsToMinutesSeconds(temps: parc.detail.temps))
                            }
                        }
                    }.onDelete(perform: { indexSet in
                        DeleteDetail(ind: indexSet)
                    })
                }
                
            }}
        Text("").hidden().sheet(item: self.$selectedParcoursModif, content: { sel in
            SheetSauvModifTempsView(parcoursModif: sel, objGroupe: objGroupe, list: $listParcours, detailManager : DetailManager(groupe: objGroupe))
        })
        .onAppear(){
            detailManager = DetailManager(groupe: objGroupe)
            listParcours = ModificationTempsManager().getModificationTempsList(crsId: objCourse.id!, grId: objGroupe.id)
            listActuelle.listReal = detailManager.actuReaList()
        }
        .navigationTitle("Modification de temps")
    }
    func DeleteDetail(ind : IndexSet){
        for i in ind {
            detailManager.removeDetail(detail: listParcours[i].detail)
        }
        listParcours = ModificationTempsManager().getModificationTempsList(crsId: objCourse.id!, grId: objGroupe.id)
        print(listActuelle.listReal)
        listActuelle.listReal = detailManager.actuReaList()
        listActuelle.arrayValid = ErreurManager().ArrayNbValid(parcoursRealiseList: listActuelle.listReal)
        listActuelle.arrayErr = ErreurManager().ArrayNbErreur(parcoursRealiseList: listActuelle.listReal)
    }
}

struct Header: View {
    var body: some View {
        HStack {
            Text("Parcours")
            Spacer()
            Text("Temps réalisé")
        }
    }
}

struct FooterZero: View {
    let nb: Int
    var body: some View {
        if nb > 0 {
            
            VStack{
                HStack {
                    
                    Image(systemName: "pencil.circle.fill")
                    Text("Appuyer sur le crayon pour modifier")
                    Spacer()
                    
                }
                HStack {
                    Image(systemName: "trash.circle.fill")
                    Text("Glisser vers la gauche pour remettre à zéro")
                    Spacer()
                }
            }
        }
    }
}



struct FooterSupp: View {
    let nb: Int
    let str : String
    var body: some View {
        if nb > 0 {
            VStack{
                HStack {
                    
                    Image(systemName: "pencil.circle.fill")
                    Text("Appuyer sur le crayon pour \(str)")
                    Spacer()
                    
                }
                HStack {
                    Image(systemName: "trash.circle.fill")
                    Text("Glisser vers la gauche pour supprimer")
                    Spacer()
                    
                }
            }
        }
            
        }
}
