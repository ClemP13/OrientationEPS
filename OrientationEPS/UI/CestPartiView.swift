//
//  CestPartiView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 18/10/2020.
//

import SwiftUI

struct CestPartiView: View {
    @EnvironmentObject var objCourse : CourseActuelle
    @State private var tempsPasse = 0
    let timerCP = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var action: Int? = 0
    
    var body: some View {
        ZStack{
            Color.orange
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Button(action: {
                        self.timerCP.upstream.connect().cancel()
                        self.action = 1
                    },
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
                }.padding()
                Spacer()
                HStack{
                    Image(systemName: "flag.fill")
                        .foregroundColor(.green)
                    Text("C'est parti !")
                    
                    Image(systemName: "flag.fill")
                        .foregroundColor(.green)
                }.padding()
                .font(.largeTitle)
                Text("\(TempsAffichable().secondsToMinutesSeconds(temps: Int32(tempsPasse)))")
                    .font(.title)
                    .onReceive(timerCP) { time in
                        self.tempsPasse += 1
                    }
                Spacer()
            }
            .foregroundColor(.white)
            NavigationLink(destination: GeneralView(groupeManager: GroupeManager(courseId: objCourse.id!), selectedTab: 2), tag: 1, selection: $action){}
        }.navigationBarHidden(true)
    }
}
