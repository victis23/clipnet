//
//  RoleSelectViewModel.swift
//  ClipNet
//
//  Created by Scott Leonard on 4/17/26.
//
import SwiftUI
import Foundation
import Combine


final class RoleSelectViewModel: ObservableObject {
	@Published var selectedRole: AppRole? = nil
	var subscriberBag: AnyCancellable?

	func saveUserRoleSelection() {
		subscriberBag = $selectedRole
			.receive(on: DispatchQueue.main)
			.sink { role in
				UserDefaults.standard.set(role?.rawValue, forKey: "role")
			}
	}

	deinit {
		subscriberBag?.cancel()
		subscriberBag = nil
	}
}
