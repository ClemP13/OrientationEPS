//
//  Parameters.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 10/10/2020.
//

import SwiftUI


struct Settings: View {
    @EnvironmentObject var objCourse : CourseActuelle
    @State var groupeManager : GroupeManager
    @State private var action: Int? = 0
    @Binding var timerOn : Bool
    @State var selectedIndex = 0
    @State var timerIsRunning : Bool = false
    @EnvironmentObject var stopwatch : Stopwatch
    
    
    var body: some View {
        VStack{
        NavigationLink(destination: CourseListView(), tag: 1, selection: $action){}
        HStack{
            
            Button(action: {
                self.action = 1
            },label: {
                Image(systemName: "house.fill")
                Text("Retour page d'accueil")
                Image(systemName: "house.fill")
            })
            .foregroundColor(Color("ColorDarkLight"))
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.orange)
            )
        }.padding()
        Form{
            Section(header: Text("Gestion de la course")){
                List{
                HStack{
                    NavigationLink(destination: ReglagesView(ReprendreLaCourse: true, groupeManager: groupeManager, parcoursManager: ParcoursManager(courseId: objCourse.id!)).environmentObject(objCourse), label: {
                        Image(systemName: "map.fill")
                        Text("Parcours")
                    })
                    Spacer()
                }
                HStack{
                    NavigationLink(destination: GestionListeGroupeView(groupeManager: groupeManager).environmentObject(objCourse), label: {
                        Image(systemName: "person.fill.badge.plus")
                        Text("Coureurs")
                    })
                    Spacer()
                }}}
            
            Section(header: Text("Carton de contrôle")){
                List{
                    HStack{
                        NavigationLink(destination: BonusMalusView(), label: {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            Text("Bonus / Malus")
                        })
                        Spacer()
                    }}}
            Section(header: Text("Outil"), footer: FooterChrono(timerOn: timerOn)){
                List{
                HStack{
                    NavigationLink(destination: DepartsSimultanesView(groupeManager: groupeManager), label: {
                        Image(systemName: "flag.badge.ellipsis.fill")
                        Text("Départs simultanés")
                    })
                    Spacer()
                }
                    /* HStack{
                        Toggle(isOn: Binding(
                                get: { self.timerOn },
                                set: {(newValue) in
                                    if newValue == false {
                                        self.stopwatch.stop()
                                        self.stopwatch.reset()
                                        
                                    }else{
                                        self.stopwatch.reset()
                                        
                                    }
                                    timerOn = newValue
                                    UserDefaults.standard.setValue(timerOn, forKey: "timerOn")
                                }), label: {
                            Image(systemName: "stopwatch.fill")
                            Text("Timer")
                            if timerOn{
                                HStack{
                                    Spacer()
                                    if self.stopwatch.timerIsRunning{
                                    Image(systemName: "pause.fill")
                                        .foregroundColor(.orange)
                                        .onTapGesture {
                                            self.stopwatch.stop()
                                            
                                        }
                                }else{
                                    if self.stopwatch.restant != 0{
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.orange)
                                        .onTapGesture {
                                            self.stopwatch.start()
                                    }
                                    }
                                }
                                Spacer()
                                    Text(TempsAffichable().secondsToMinutesSeconds(temps: Int32(self.stopwatch.restant)) )
                                    Spacer()
                                    if !self.stopwatch.timerIsRunning && self.stopwatch.restant != self.stopwatch.duree {
                                    Image(systemName: "gobackward")
                                        .foregroundColor(.orange)
                                        .onTapGesture {
                                            self.stopwatch.reset()
                                            
                                        }
                            }
                                    Spacer()
                                }
                        }
                        })
                        
                    }
                    if timerOn {
                        HStack{
                            Picker(selection: Binding(
                                   get: { self.selectedIndex },
                                   set: { (newValue) in
                                    stopwatch.stop()
                                    stopwatch.reset()
                                    self.selectedIndex = newValue
                                    self.stopwatch.duree = newValue * 60
                                    UserDefaults.standard.setValue(self.stopwatch.duree, forKey: "duree")
                                   }), label: HStack{
                                Image(systemName: "arrow.turn.down.right")
                                Text("Durée")
                            }
                            ) {
                                ForEach (0 ..< 121, id: \.self) { num in
                                    HStack{
                                        Text(TempsAffichable().secondsToMinutesSeconds(temps: Int32(num * 60)))
                                    
                                    }}
                                }
                        }
                        }*/
                }
                
            }
            .onAppear(){
                timerOn = UserDefaults.standard.bool(forKey: "timerOn")
                if !self.stopwatch.timerIsRunning{
                    if  self.stopwatch.duree == 0 {
                                            
                if UserDefaults.standard.integer(forKey: "duree") == 0{
                    self.stopwatch.duree = 600
                    self.stopwatch.restant = 600
                    UserDefaults.standard.setValue(self.stopwatch.duree, forKey: "duree")
                    print(self.stopwatch.duree)
                }else{
                    self.stopwatch.restant = UserDefaults.standard.integer(forKey: "duree")
                    self.stopwatch.duree = UserDefaults.standard.integer(forKey: "duree")
                    
                }
                selectedIndex = self.stopwatch.duree/60
                print(selectedIndex)
                }
                }}
        }.navigationBarHidden(true)
    }
}

}

struct FooterChrono: View {
    let timerOn: Bool
    var body: some View {
        if timerOn {
        HStack {
            Image(systemName: "speaker.wave.2.circle")
            Text("Pensez à monter le volume de l'Iphone")
        }
        }
    }
}
