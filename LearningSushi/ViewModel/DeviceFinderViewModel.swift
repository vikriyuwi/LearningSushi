//
//  DeviceFinderViewModel.swift
//  Multipeer Chat
//
//  Created by Boris Bugor on 03/08/2023.
//

import MultipeerConnectivity
import Combine

class DeviceFinderViewModel: NSObject, ObservableObject {
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private let session: MCSession
    private let serviceType = "nearby-devices"

    @Published var permissionRequest: PermitionRequest?
    
    @Published var selectedPeer: PeerDevice? {
        didSet {
            connect()
        }
    }
    
    @Published var ava:String = "AvaDefault"
    
    @Published var peers: [PeerDevice] = []
    @Published var connectedPeers: [PeerDevice] = []
    let connectedPeersPublisher = PassthroughSubject<PeerDevice, Never>()
    
    @Published var isAdvertised: Bool = false {
        didSet {
            isAdvertised ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    
    @Published var ingredients: [MyIngredient] = []
    let ingredientPublisher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    func send(string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
                
        try? session.send(data, toPeers: [joinedPeer.last!.peerId], with: .reliable)

//        ingredientPublisher.send(string)
    }
    
    @Published var joinedPeer: [PeerDevice] = []
    
    override init() {
        let peer = MCPeerID(displayName: UserDefaults.standard.string(forKey: "SUSHI_AVA") ?? "AvaDefault")
        session = MCSession(peer: peer)
        
        advertiser = MCNearbyServiceAdvertiser(
            peer: peer,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        
        super.init()
        
        advertiser.delegate = self
        browser.delegate = self
        session.delegate = self
        
        ingredientPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.ingredients.append(MyIngredient(name: $0))
            }
            .store(in: &subscriptions)
        
        connectedPeersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.connectedPeers.append($0)
            }
            .store(in: &subscriptions)
    }

    func startBrowsing() {
        browser.startBrowsingForPeers()
    }
    
//    func addJoinedPeer() {
//        joinedPeer.append(PeerDevice(peerId: peerID))
//    }
    
    func finishBrowsing() {
        browser.stopBrowsingForPeers()
    }
    
    func show(peerId: MCPeerID) {
        guard let first = peers.first(where: { $0.peerId == peerId }) else {
            return
        }
        
        joinedPeer.append(first)
    }
    
    private func connect() {
        guard let selectedPeer else {
            return
        }
        
        if session.connectedPeers.contains(selectedPeer.peerId) {
            joinedPeer.append(selectedPeer)
        } else {
            browser.invitePeer(selectedPeer.peerId, to: session, withContext: nil, timeout: 60)
        }
    }
}

extension DeviceFinderViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        permissionRequest = PermitionRequest(
            peerId: peerID,
            onRequest: { [weak self] permission in
                invitationHandler(permission, permission ? self?.session : nil)
            }
        )
    }
}

extension DeviceFinderViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peers.append(PeerDevice(peerId: peerID))
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0.peerId == peerID })
    }
}

extension DeviceFinderViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        guard let last = joinedPeer.last, last.peerId == peerID
        else {
            return
        }
        switch state {
        case .connecting:
            // Peer is in the process of connecting
            print("Peer \(peerID) is connecting...")
        case .connected:
            // Peer has accepted the connection request
            print("Peer \(peerID) has accepted the connection.")
//               connectedPeersPublisher.send(PeerDevice(peerId: peerID))
//            connectedPeers.append(PeerDevice(peerId: peerID))
            connect()
            print(connectedPeers)
            // You can perform any additional actions here after the peer has accepted the invitation
        case .notConnected:
            // Peer has disconnected
            print("Peer \(peerID) has disconnected.")
        @unknown default:
            fatalError("Unknown state received: \(state)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let last = joinedPeer.last, last.peerId == peerID, let ingredientName = String(data: data, encoding: .utf8) else {
            return
        }
        
//        let newIngredient = MyIngredient(name: ingredientName)
        
        ingredientPublisher.send(
            ingredientName
        )
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //
    }
}
