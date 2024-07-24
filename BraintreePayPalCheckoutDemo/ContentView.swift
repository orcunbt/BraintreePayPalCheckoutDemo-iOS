//
//  ContentView.swift
//  BraintreePayPalCheckoutDemo
//
//  Created by OK on 24/07/2024.
//
import SwiftUI
import BraintreeCore
import BraintreePayPal

struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}

struct ContentView: View {
    @State private var showPayPalCheckout = false
    @State private var braintreeClient: BTAPIClient?
    @State private var transactionResult: String?
    @State private var isProcessing: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Title
                Text("Braintree PayPal Checkout Flow")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .foregroundColor(Color.white)
                    .shadow(radius: 10)
                
                
                // Product Image
                Image("pptshirt") // Use your custom image here
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)

                // Product Price
                Text("$30")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 10)

                // PayPal Button with Custom Image
                Button(action: {
                    self.startPayPalCheckout()
                }) {
                    Image("ppbutton") // Replace with your PayPal button image name
                        .resizable()
                        .scaledToFill()
                        .frame(height: 50)
                        .padding()
                }
                .padding(.horizontal)

                if let result = transactionResult {
                    Text(result)
                        .padding()
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
            )
            
            if isProcessing {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                ActivityIndicator()
            }
        }
        .onAppear {
            self.braintreeClient = BTAPIClient(authorization: "sandbox_zjmbj683_926q7cx2s9rp5fh5") // Replace with your Braintree tokenization key
        }
    }
    
    func startPayPalCheckout() {
        guard let braintreeClient = braintreeClient else { return }
        let payPalClient = BTPayPalClient(apiClient: braintreeClient)
        let request = BTPayPalCheckoutRequest(amount: "30.00")
        request.currencyCode = "USD"
        
        isProcessing = true

        payPalClient.tokenize(request) { (tokenizedPayPalAccount, error) in
            isProcessing = false
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                let nonce = tokenizedPayPalAccount.nonce
                transactionResult = "Payment method nonce: \(nonce)"
            } else if let error = error {
                transactionResult = "Error: \(error.localizedDescription)"
            } else {
                transactionResult = "Buyer canceled payment approval"
            }
        }
    }
}




