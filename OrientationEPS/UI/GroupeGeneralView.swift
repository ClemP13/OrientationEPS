//
//  ViewGeneralGroup.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 10/10/2020.
//

import SwiftUI

struct GroupeGeneralView: View {
    @EnvironmentObject var objCourse : CourseActuelle
    @State var groupeManager : GroupeManager
    var flexibleLayout = [GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        ScrollView{
            if groupeManager.groupeList.count == 0 {
                Text("Aucun groupe dans cette course")
                    .padding()
            }
            LazyVGrid(columns: flexibleLayout){
                
                ForEach(0 ..< groupeManager.groupeList.count, id:\.self) { gr in
                    BtComponentView(objGroupe: groupeManager.groupeList[gr], num: gr)
                }
                
            }.padding()
            Spacer()
                .onAppear(perform: {
                    groupeManager = GroupeManager(courseId: objCourse.id!)
                })
        }.navigationBarHidden(true)
    }
    
}


