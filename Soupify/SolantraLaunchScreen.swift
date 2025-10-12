
import SwiftUI


@available(iOS 14.0, *)
struct SolantraLaunchScreen: View {
    
    @StateObject private var validator = SolantraAccessCenter()
    @State private var remoteURL: URL?
    @State private var showLoader = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            if remoteURL == nil && !showLoader {
                SoupDashboardView().ignoresSafeArea()
            }
            
            if let url = remoteURL {
                SolantraWebViewBridge(url: url, loading: $showLoader)
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
            }
            
            if showLoader {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.8)
                    )
            }
        }
        .onReceive(validator.$state) { state in
            switch state {
            case .validating:
                showLoader = true
            case .approved(_, let url):
                remoteURL = url
                showLoader = false
            case .useNative:
                remoteURL = nil
                showLoader = false
            case .idle:
                break
            }
        }
        .onAppear {
            showLoader = true
            validator.initiateValidation()
        }
    }
}
