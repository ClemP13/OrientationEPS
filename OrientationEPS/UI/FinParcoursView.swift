//
//  FinParcoursView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 18/10/2020.
//

import SwiftUI

struct FinParcoursView: View {
    let objCourse: Course
    let objGroupe: Groupe
    @EnvironmentObject var stopwatch : Stopwatch
    @State var arriveeManager = ArriveeManager()
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        ZStack{
            Color.blue
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    NavigationLink(destination: GeneralView(objCourse: objCourse, groupeManager: GroupeManager(courseId: objCourse.id), selectedTab: 2).environmentObject(stopwatch),
                                   label: {
                                    HStack {
                                        Image(systemName: "arrow.left")
                                        Text("Retour")
                                    }
                                   })
                        
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 2))
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                HStack{
                    Image(systemName: "hand.thumbsup")
                        .foregroundColor(.white)
                    Text(" Terminé ")
                    
                    Image(systemName: "hand.thumbsup")
                        .foregroundColor(.white)
                }.padding()
                .font(.largeTitle)
                
                let dernierParcours = ArriveeManager().dernierParcours(groupeId : objGroupe.id)
                VStack{
                Text("Temps réalisé")
                Text(TempsAffichable().secondsToMinutesSeconds(temps: dernierParcours.temps))
                }.font(.largeTitle)
                let record = DetailManager(groupe: objGroupe).recordParcours(parcoursId: dernierParcours.parcoursId)
                
                Spacer()
                if record.temps != dernierParcours.temps{
                    VStack{
                        Text("Record Actuel").underline()
                    Text(record.nomParcours)
                    Text("\(record.nomGroupe)")
                    Text("\(TempsAffichable().secondsToMinutesSeconds(temps: record.temps))")
                    }.font(.largeTitle)
                }else{
                    HStack{
                        Spacer()
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(.orange)
                            .scaleEffect(animationAmount)
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true)
                            )
                        VStack{
                            Text(" Nouveau Record ")
                            Text(record.nomParcours)
                        }.foregroundColor(.orange)
                        
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(.orange)
                            .scaleEffect(animationAmount)
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true))
                        Spacer()
                    }.font(.largeTitle)
                    .background(Color.white)
                    
                    
                }
                Spacer()
                
            }.foregroundColor(.white)
            .onAppear(){
                animationAmount += 0.3
            }.navigationBarHidden(true)
            
        }
    }
}
