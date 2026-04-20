import SwiftUI

struct RoleSelectView: View {
    var body: some View {
        ZStack {
            Color.cnNavy.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 2) {
					HStack(spacing: 0) {
						Text("Clip")
							.foregroundColor(.white)
						Text("PAY")
							.foregroundColor(.yellow)
					}
					.font(.system(size: 38, weight: .black))
					
                    Text("Growth OS for Creators")
                        .font(.cnBody())
                        .foregroundColor(.cnMuted)
						.italic()
						.fontWeight(.light)
                }
                .padding(.top, 72)

                Spacer()

                // Cards
                VStack(spacing: 14) {
                    RoleCard(
                        role: .brand,
                        icon: "bolt.fill",
                        title: "I'm a Creator",
                        subtitle: "Launch campaigns and amplify your reach across platforms.",
                        accentColor: .cnAmber
                    )

                    RoleCard(
                        role: .clipper,
                        icon: "scissors",
                        title: "I'm a Clipper",
                        subtitle: "Browse campaigns, submit clips, and earn per thousand views.",
                        accentColor: .cnTeal
                    )
                }
                .padding(.horizontal, 24)

                Spacer()

                Text("By continuing you agree to ClipPay's Terms of Service.")
                    .font(.cnCaption())
                    .foregroundColor(.cnMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 36)
            }
        }
    }
}

// MARK: - Role Card
private struct RoleCard: View {
    @EnvironmentObject var roleSelectViewModel: RoleSelectViewModel

    let role: AppRole
    let icon: String
    let title: String
    let subtitle: String
    let accentColor: Color

    @State private var isPressed = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
				roleSelectViewModel.selectedRole = role
            }
        } label: {
            HStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accentColor.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(accentColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.cnSubhead())
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.cnCaption())
                        .foregroundColor(.cnMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(accentColor)
            }
            .padding(20)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(accentColor.opacity(0.3), lineWidth: 1)
            )
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.12), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }
}
