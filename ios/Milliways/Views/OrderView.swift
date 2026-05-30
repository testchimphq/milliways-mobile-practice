//
//  OrderView.swift
//  Milliways
//
//  Created by gilm on 05/11/2025.
//

import SwiftUI

struct OrderView: View {
    @ObservedObject var orderManager: OrderManager
    @ObservedObject var sessionManager: SessionManager
    @Binding var popToRoot: Bool
    @Environment(\.dismiss) var dismiss
    @State private var showDelivery = false
    @State private var orderError: String? = nil
    @State private var isSubmittingOrder = false

    var body: some View {
        VStack(spacing: 0) {
            if orderManager.items.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "cart")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                    Text("Your order is empty")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))

                Button(action: {}) {
                    Text("Place Order")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .disabled(true)
            } else {
                List {
                    ForEach(Array(orderManager.items.enumerated()), id: \.offset) { index, orderItem in
                        HStack {
                            if let imageName = orderItem.menuItem.imageName {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(orderItem.menuItem.color)
                                    .frame(width: 50, height: 50)
                            }

                            VStack(alignment: .leading) {
                                Text(orderItem.menuItem.name)
                                    .font(.headline)
                                Text("\(orderItem.quantity) × ₭\(orderItem.menuItem.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Text("₭\(orderItem.totalPrice, specifier: "%.2f")")
                                .font(.headline)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                orderManager.removeItem(at: index)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }

                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text("₭\(orderManager.totalPrice, specifier: "%.2f")")
                            .font(.headline)
                    }
                    .listRowBackground(Color(.systemGroupedBackground))
                }
                .listStyle(.plain)

                VStack(spacing: 8) {
                    if let orderError {
                        Text(orderError)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    Button(action: {
                        Task {
                            await placeOrder()
                        }
                    }) {
                        if isSubmittingOrder {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Place Order")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.green)
                    .cornerRadius(12)
                    .disabled(isSubmittingOrder)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Your Order")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .fullScreenCover(isPresented: $showDelivery, onDismiss: {
            orderManager.clearOrder()
        }) {
            DeliveryView(orderManager: orderManager, sessionManager: sessionManager) {
                popToRoot = false
            }
        }
    }

    @MainActor
    private func placeOrder() async {
        guard let token = sessionManager.token else {
            orderError = "Please sign in first"
            return
        }

        isSubmittingOrder = true
        orderError = nil

        do {
            let cents = UInt(max(orderManager.totalPrice, 0) * 100)
            print("Processing payment of \(cents) cents")
            _ = try await orderManager.submitOrder(token: token)
            showDelivery = true
        } catch {
            orderError = error.localizedDescription
        }

        isSubmittingOrder = false
    }
}
