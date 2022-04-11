//
//  RenderSettingsView.swift
//  Ray Tracer
//
//  Created by Brenden Davidson on 4/8/22.
//

import SwiftUI

struct DimensionInput: View {
    var title: String
    var imageName: String
    
    @Binding var resolution: Int
    
    private let resFormatter = NumberFormatter()
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16, alignment: .center)
            TextField(title, value: $resolution, formatter: resFormatter)
                .frame(width: 48, alignment: .center)
                .disableAutocorrection(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .lineLimit(/*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .dynamicTypeSize(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                .textFieldStyle(.automatic)
            Text("px")
                .font(.body)
        }
    }
}

struct RenderSettingsView: View {
    @Binding var width: Int
    @Binding var height: Int
    @Binding var samples: Int
    
    var body: some View {
        GroupBox("Settings") {
            DimensionInput(title: "width", imageName: "arrow.left.and.right.square", resolution: $width)
                .padding([.top, .leading, .trailing])
            DimensionInput(title: "height", imageName: "arrow.up.and.down.square", resolution: $height)
        }
    }
}

//struct RenderSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            RenderSettingsView(width: 240.0, height: 360.0)
//        }
//    }
//}
