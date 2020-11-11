//
//  BtComponentView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 10/10/2020.
//

import SwiftUI

struct BtComponentView: View {
    let objGroupe: Groupe
    let objCourse: Course
    var num : Int
    
    var body: some View {
        let nom = objGroupe.nomGroupe.replacingOccurrences(of: " ", with: "\n")
        HStack{
            NavigationLink(
                destination: GroupeDetailsView(objGroupe: objGroupe,objCourse: objCourse, detailManager: DetailManager(groupe: objGroupe), parcoursManager: ParcoursManager(courseId: objGroupe.courseId), listeParcoursRestants: DetailManager(groupe: objGroupe).ListeParcoursRestants(), listReal: DetailManager(groupe: objGroupe).parcoursRealiseList),
                label: {
                    HStack{
                        Text("\(nom)")
                            .multilineTextAlignment(.center)
                    }.frame(maxWidth: .infinity, minHeight: 35, maxHeight: 50)
                    .foregroundColor(Color("ColorDarkLight"))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 2)
                    )
                })
        }
        
    }
    
}
