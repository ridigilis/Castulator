struct DynamicImage: View {
    @Environment(\.colorScheme) private var colorScheme
    let image: String
    init(_ image: String) {
        self.image = image
    }

    var body: some View {
        if colorScheme == .dark {
            Image(image).resizable().scaledToFit().colorInvert()
        } else {
            Image(image).resizable().scaledToFit()
        }
    }
}
