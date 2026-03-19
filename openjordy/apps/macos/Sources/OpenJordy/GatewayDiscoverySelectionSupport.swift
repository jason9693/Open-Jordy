import OpenJordyDiscovery

@MainActor
enum GatewayDiscoverySelectionSupport {
    static func applyRemoteSelection(
        gateway: GatewayDiscoveryModel.DiscoveredGateway,
        state: AppState)
    {
        if state.remoteTransport == .direct {
            state.remoteUrl = GatewayDiscoveryHelpers.directUrl(for: gateway) ?? ""
        } else {
            state.remoteTarget = GatewayDiscoveryHelpers.sshTarget(for: gateway) ?? ""
        }
        if let endpoint = GatewayDiscoveryHelpers.serviceEndpoint(for: gateway) {
            OpenJordyConfigFile.setRemoteGatewayUrl(
                host: endpoint.host,
                port: endpoint.port)
        } else {
            OpenJordyConfigFile.clearRemoteGatewayUrl()
        }
    }
}
