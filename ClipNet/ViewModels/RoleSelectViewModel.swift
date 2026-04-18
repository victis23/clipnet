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
}
