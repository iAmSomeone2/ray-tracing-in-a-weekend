import SwiftUI

struct ContentView: View {
    @State var renderWidth: Int = 720
    @State var renderHeight: Int = 480
    @State var renderSamples: CGFloat = 10
    
    @State private var renderImg = Image(systemName: "photo")
    @State private var rendering = false
    @State private var renderOpacity: Double = 1.0
    
    @State private var progress: Double = 0.0
    @State private var progressStr = ""
    @State private var progressOpacity: Double = 0.0
    @State private var infoMessage: String = ""
    
    @State private var showFilePicker = false
    private var exportName = ""
    private var exportPath = ""
    
    var body: some View {
        HStack {
            VStack {
                RenderSettingsView(width: $renderWidth, height: $renderHeight, samples: $renderSamples)
                
                Spacer()
                HStack{
                    Button("Render", action: handleRenderPress)
                        .accessibilityAddTraits([.isButton])
                        .accessibilityLabel("Render")
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .disabled(rendering)
                        .frame(width: 104, alignment: .center)
                    Button("Export...", action: exportRender)
                        .accessibilityAddTraits([.isButton])
                        .accessibilityLabel("Export...")
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .disabled(rendering)
                        .frame(width: 104, alignment: .center)
                }
            }
            
            Divider()
            
            VStack {
                ZStack {
                    renderImg
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(renderOpacity)
                    ProgressView(value: progress, total: 1.0) {
                        Text("Rendering... (\(progressStr)%)")
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
    
    private func exportRender() {
        
    }
    
    private func handleRenderPress() {
        self.rendering = true
        withAnimation(.easeInOut) {
            self.renderOpacity = 0.05
            self.progressOpacity = 1.0
        }
        
        let renderer = Renderer(
            width: UInt16(self.renderWidth),
            height: UInt16(self.renderHeight),
            sampleCount: UInt16(self.renderSamples))
        
        let updateProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.033, repeats: true) { _ in
            Task {
                self.progress = await renderer.getProgress()
                let percent = Int(self.progress * 100)
                let tenths = Int(self.progress * 1000) % 100
                self.progressStr = "\(percent).\(tenths)"
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
