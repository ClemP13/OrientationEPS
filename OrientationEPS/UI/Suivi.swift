//
//  Suivi.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 17/10/2020.
//

import SwiftUI

struct Suivi: View {
    let courseId : UUID
    @State var suiviManager : SuiviManager
    
    var body: some View {
        VStack{
        Form{
            Section(header: Text("Groupes en course")) {
                List{
                    ForEach(suiviManager.groupeEnCourseList()) { cr in
                        Text(cr.detail.nomGroupe)
                    }
                }
            }
            Section(header: Text("Groupes en attente")) {
                Text("Blibli")
            }
            Section(header: Text("Groupes ayant terminé")) {
                Text("Blibli")
            }

        }.navigationBarHidden(true)
        .onAppear{
            suiviManager = SuiviManager(courseId: courseId)
        }
        }
    }
}
