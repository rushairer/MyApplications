//
//  ApplicationInfoView.swift
//  
//
//  Created by Abenx on 2023/2/16.
//

import SwiftUI
import StoreKit

public struct ApplicationInfoView: View {
    
    @State private var applicationInfoList: [LookUpResponseResult.Result]?
    @State private var appIdentifier: String?
    
#if !targetEnvironment(simulator)
    private let productViewController = SKStoreProductViewController()
#endif
    
    private let artistId: String!
    private var idList: [Int64]?
    
    public init(artistId: String = "976495345", idList: [Int64]? = [
        1669986452,
        1538268059,
        1151401197,
        977226591,
        6443592678
    ]) {
        self.artistId = artistId
        self.idList = idList
    }
    
    private func requestApplicationInfoList(
        idList: [Int64]? = nil
    ) async -> [LookUpResponseResult.Result]? {
        let service = ITunesLookUpService()
        guard let responseResult = await service.request(id: artistId) else { return nil }
        
        if let idList {
            return idList.compactMap { trackId in
                responseResult.results.first { $0.trackId == trackId }
            }
        } else {
            return responseResult.results.filter { $0.wrapperType == .software }
        }
    }
    
#if !targetEnvironment(simulator)
    private func showAppStoreProductPage(appIdentifier: String) {
        productViewController.loadProduct(
            withParameters: [
                SKStoreProductParameterITunesItemIdentifier: appIdentifier,
            ]
        )
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.keyWindow?.rootViewController?.present(productViewController, animated: false)
        }
    }
#endif
    
    public var body: some View {
        ScrollView {
            VStack {
                if let applicationInfoList {
                    ForEach(applicationInfoList, id: \.trackId) { applicationInfo in
                        ApplicationInfoCellView(
                            appIdentifier: $appIdentifier,
                            applicationInfo: applicationInfo
                        )
                        .padding()
                        Divider()
                    }
                }
                Spacer()
            }
#if targetEnvironment(simulator)
            .appStoreOverlay(isPresented: .init(get: { appIdentifier != nil }, set: { _ in }), configuration: {
                return SKOverlay.AppConfiguration(appIdentifier: appIdentifier ?? "", position: .bottom)
            })
#else
            .onChange(of: appIdentifier, perform: { newValue in
                if let newValue {
                    showAppStoreProductPage(appIdentifier: newValue)
                }
            })
#endif
            .task {
                applicationInfoList = await requestApplicationInfoList(idList: idList)
            }
        }
    }
}

struct ApplicationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationInfoView()
    }
}
