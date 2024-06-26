import Foundation
import MultipeerConnectivity

extension String {
    static var serviceName = "sushi-brawl"
}

class MPConnectionManager: NSObject, ObservableObject {
    let serviceType = String.serviceName
    let session: MCSession
    let myPeerId: MCPeerID
    let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    let nearbyServiceBrowser: MCNearbyServiceBrowser
    var game: GameService?
    var objective: Objective?

    func setupGame(game: GameService) {
        self.game = game
    }

    func setupObjective(objective: Objective) {
        self.objective = objective
    }

    @Published var availablePeers = [MCPeerID]()
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    @Published var paired: Bool = false
    @Published var isPlayAgain: Bool = false

    @Published var playerFinished: [Bool] = []

    var isAvailableToPlay: Bool = false {
        didSet {
            if isAvailableToPlay {
                startAdvertising()
            } else {
                stopAdvertising()
            }
        }
    }

    init(yourName: String) {
        myPeerId = MCPeerID(displayName: yourName)
        session = MCSession(peer: myPeerId)
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        super.init()
        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }

    deinit {
        stopBrowsing()
        stopAdvertising()
    }

    func addPlayerFinished() {
        playerFinished.append(true)
        print(playerFinished)
    }

    func addPlayerFailed() {
        playerFinished.append(false)
        print(playerFinished)
        print("Finished")
    }

    func startAdvertising() {
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }

    func stopAdvertising() {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
    }

    func startBrowsing() {
        nearbyServiceBrowser.startBrowsingForPeers()
    }

    func stopBrowsing() {
        nearbyServiceBrowser.stopBrowsingForPeers()
        availablePeers.removeAll()
    }

    func send(ingredient: MyIngredient) {
        if !session.connectedPeers.isEmpty {
            do {
                if let data = ingredient.data() {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                }
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

extension MPConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        DispatchQueue.main.async {
            if !self.availablePeers.contains(peerID) {
                self.availablePeers.append(peerID)
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = availablePeers.firstIndex(of: peerID) else { return }
        DispatchQueue.main.async {
            self.availablePeers.remove(at: index)
        }
    }
}

extension MPConnectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.receivedInvite = true
            self.receivedInviteFrom = peerID
            self.invitationHandler = invitationHandler
        }
    }
}

extension MPConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailableToPlay = true
            }
        case .connected:
            DispatchQueue.main.async {
                self.paired = true
                self.isAvailableToPlay = false
            }
        default:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailableToPlay = true
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let ingredient = try? JSONDecoder().decode(MyIngredient.self, from: data) {
            DispatchQueue.main.async {
//                print(ingredient.name)
                if ingredient.name == "finished" {
                    self.addPlayerFinished()
                } else if ingredient.name == "failed" {
                    self.addPlayerFailed()
                } else if ingredient.name == "end" {
                    self.session.disconnect()
                    self.isAvailableToPlay = true
                    self.isPlayAgain = true
                } else {
                    self.game?.appendItem(ingredient: ingredient.name)
                    self.game?.highestIdx += 1
                }
            }
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}
