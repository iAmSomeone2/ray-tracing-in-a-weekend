import SwiftUI

struct NumberInput: View {
    var title: String
    var imageName: String
    
    @Binding var value: Int
    
    private let formatter = NumberFormatter()
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16, alignment: .center)
            TextField(title, value: $value, formatter: formatter)
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
    @Binding var samples: CGFloat
    
    var body: some View {
        GroupBox("Settings") {
            VStack(alignment: .leading, spacing: 4) {
                Text("Resolution")
                NumberInput(title: "width", imageName: "arrow.left.and.right.square", value: $width)
                NumberInput(title: "height", imageName: "arrow.up.and.down.square", value: $height)
            }
            .padding()
            VStack(alignment: .leading, spacing: 4){
                Text("Samples: \(Int(samples))")
                Slider(value: $samples, in: 5...200, step: 15) {
                    Text("")
                } minimumValueLabel: {
                    Text("5")
                } maximumValueLabel: {
                    Text("200")
                }
                .frame(width: 240, alignment: .leading)
            }
            .padding()
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
