//
//  CountrySearchField.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import SwiftUI

struct CountrySearchField: View {
    @Binding var selectedCountry: String
    @State private var query: String = ""
    @State private var isExpanded: Bool = false

    private let countries: [String] = Locale.Region.isoRegions.compactMap {
        Locale.current.localizedString(forRegionCode: $0.identifier)
    }.sorted()

    private var filtered: [String] {
        query.isEmpty ? [] : countries.filter {
            $0.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("🌍")
                Text("Country")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 0) {
                HStack {
                    TextField("", text: $query, prompt: Text("Search country...").foregroundStyle(Color.gray))
                        .foregroundStyle(.white)

                    if !selectedCountry.isEmpty {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.system(size: 16))
                    } else if !query.isEmpty {
                        Button {
                            query = ""
                            selectedCountry = ""
                            isExpanded = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.gray)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(16)
                .background(Color(red: 0.18, green: 0.18, blue: 0.22))
                .clipShape(RoundedRectangle(cornerRadius: isExpanded && !filtered.isEmpty ? 12 : 12, style: .continuous))

                if isExpanded && !filtered.isEmpty {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(filtered.prefix(6), id: \.self) { country in
                                Button {
                                    selectedCountry = country
                                    query = country
                                    isExpanded = false
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                } label: {
                                    HStack {
                                        Text(country)
                                            .font(.system(size: 14))
                                            .foregroundStyle(.white)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color(red: 0.18, green: 0.18, blue: 0.22))
                                }

                                if country != filtered.prefix(6).last {
                                    Divider()
                                        .background(Color.white.opacity(0.08))
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 220)
                    .background(Color(red: 0.18, green: 0.18, blue: 0.22))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
        }
        .onAppear {
            if !selectedCountry.isEmpty {
                query = selectedCountry
            }
        }
        .onChange(of: query) { _, newValue in
            if newValue != selectedCountry {
                selectedCountry = ""
                isExpanded = !newValue.isEmpty
            }
        }
    }
}
