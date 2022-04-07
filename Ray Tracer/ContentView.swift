//
//  ContentView.swift
//  Ray Tracer
//
//  Created by Brenden Davidson on 4/6/22.
//

import SwiftUI

struct ResolutionInput: View {
    @State var title: String
    @Binding var resolution: Int
    private let resFormatter = NumberFormatter()
    
    var body: some View {
        TextField(title, value: $resolution, formatter: resFormatter)
            .frame(width: 48, alignment: .center)
    }
}

struct ContentView: View {
    @State private var renderWidth = 720
    @State private var renderHeight = 480
    
    @State private var renderImg = Image(systemName: "photo")
    @State private var rendering = false
    @State private var renderOpacity: Double = 1.0
    
    @State private var progress: Double = 0.0
    @State private var progressOpacity: Double = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                renderImg
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(renderOpacity)
                ProgressView(value: progress, total: 1.0) {
                    Text("Rendering...")
                }
                .opacity(progressOpacity)
            }
            .frame(idealWidth: CGFloat(renderWidth), idealHeight: CGFloat(renderHeight), alignment: .center)
            
            Divider()
            
            ResolutionInput(title: "Width", resolution: $renderWidth)
            ResolutionInput(title: "Height", resolution: $renderHeight)
            
            Button("Render") {
                handleRenderPress()
            }
            .disabled(rendering)
        }
        .padding()
    }
    
    private func handleRenderPress() {
        self.rendering = true
        withAnimation(.easeInOut) {
            self.renderOpacity = 0.0
            self.progressOpacity = 1.0
        }
        
        let renderer = Renderer(width: UInt16(self.renderWidth), height: UInt16(self.renderHeight))
        let updateProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.033, repeats: true) { _ in
            Task {
                self.progress = await renderer.getProgress()
            }
        }
        
        Task {
            let renderResult = NSImage(cgImage: await renderer.render(), size: NSSize(width: renderWidth, height: renderHeight))
            
            updateProgressTimer.invalidate()
            self.renderImg = Image(nsImage: renderResult)
            self.rendering = false
            withAnimation(.easeInOut) {
                self.renderOpacity = 1.0
                self.progressOpacity = 0.0
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
