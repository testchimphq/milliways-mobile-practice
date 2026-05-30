//
//  OrderManager.swift
//  Milliways
//
//  Created by gilm on 05/11/2025.
//

import SwiftUI
import Combine

struct OrderItem: Identifiable {
    let id = UUID()
    let menuItem: MenuItem
    var quantity: Int
    var sectionKey: String

    var totalPrice: Double {
        Double(quantity) * menuItem.price
    }
}

class OrderManager: ObservableObject {
    @Published var items: [OrderItem] = []
    @Published var submittedOrder: BackendOrder?
    @Published var latestOrderStatus: BackendOrderStatus?

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }

    var totalQuantity: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    func addItem(_ item: MenuItem, quantity: Int, sectionKey: String = "unknown") {
        items.append(OrderItem(menuItem: item, quantity: quantity, sectionKey: sectionKey))
    }

    /// Low-cardinality slug from a menu section title (e.g. "Main Dishes" → `main_dishes`).
    static func sectionKey(from title: String) -> String {
        let parts = title.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
        return parts.isEmpty ? "unknown" : parts.joined(separator: "_")
    }

    func removeItem(at index: Int) {
        items.remove(at: index)
    }

    func clearOrder() {
        items.removeAll()
        submittedOrder = nil
        latestOrderStatus = nil
    }

    @MainActor
    func submitOrder(token: String) async throws -> BackendOrder {
        let requestItems = items.map {
            CreateOrderItem(menuItemId: $0.menuItem.id, quantity: $0.quantity)
        }
        let order = try await APIClient.shared.createOrder(items: requestItems, token: token)
        submittedOrder = order
        latestOrderStatus = BackendOrderStatus(id: order.id, status: order.status, updatedAt: order.createdAt)
        return order
    }

    @MainActor
    func refreshSubmittedOrderStatus(token: String) async throws {
        guard let orderId = submittedOrder?.id else { return }
        latestOrderStatus = try await APIClient.shared.fetchOrderStatus(orderId: orderId, token: token)
    }
}
