import SwiftUI

struct ContentView: View {
    @State var renderWidth: Int = 720
    @State var renderHeight: Int = 480
    @State var renderSamples: Int = 100
    
    @State private var renderImg = Image(systemName: "photo")
    @State private var rendering = false
    @State private var renderOpacity: Double = 1.0
    
    @State private var progress: Double = 0.0
    @State private var progressOpacity: Double = 0.0
    @State private var infoMessage: String = ""
    
    var body: some View {
        HStack {
            VStack {
                RenderSettingsView(width: $renderWidth, height: $renderHeight, samples: $renderSamples)
                
                Spacer()
                
                Button("Render", action: handleRenderPress)
                    .accessibilityAddTraits([.isButton])
                    .accessibilityLabel("Render")
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .disabled(rendering)
            }
            
            Divider()
            
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
                
                Text(infoMessage)
                    .font(.body)
            }
        }
        .padding()
        .touchBar {
            Button("Render", action: handleRenderPress)
                .disabled(rendering)
        }
    }
    
    private func handleRenderPress() {
        self.rendering = true
        withAnimation(.easeInOut) {
            self.renderOpacity = 0.05
            self.progressOpacity = 1.0
        }
        
        let renderer = Renderer(width: UInt16(self.renderWidth), height: UInt16(self.renderHeight))
        let updateProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.033, repeats: true) { _ in
            Task {
                self.progress = await renderer.getProgress()
            }
        }
        
        Task {
            let startTime = DispatchTime.now()
            
            await renderer.render()
            
            let endTime = DispatchTime.now()
            let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
            let timeInterval = Double(elapsedTime) / 1_000_000_000
            self.infoMessage = "Render time: '\(timeInterval)' seconds"
            updateProgressTimer.invalidate()
            
            self.rendering = false
            
            let img = NSImage(
                cgImage: await renderer.getCGImage(),
                size: NSSize(width: renderWidth, height: renderHeight))
            self.renderImg = Image(nsImage: img)
            
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
