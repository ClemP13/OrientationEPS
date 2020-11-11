//
//  ChronoView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 07/11/2020.
//

import SwiftUI

struct ChronoView: View {

    @EnvironmentObject var stopwatch : Stopwatch
    
    var body: some View {
        VStack{
        Image(systemName: "stopwatch.fill")
            .font(.system(size: 60))
            .padding()
        Text(TempsAffichable().secondsToMinutesSeconds(temps: Int32(stopwatch.restant)) )
            .font(.system(size: 60))
        }
    }
}
