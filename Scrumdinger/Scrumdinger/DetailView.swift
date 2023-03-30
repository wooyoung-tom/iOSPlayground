//
//  DetailView.swift
//  Scrumdinger
//
//  Created by 최우영 on 2023/03/30.
//

import SwiftUI

struct DetailView: View {
    let scrum: DailyScrum
    
    @State
    private var isPresentingEditView = false
    
    var body: some View {
        List {
            Section(header: Text("Meeting Info"), content: {
                NavigationLink(destination: MeetingView()) {
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                
                HStack {
                    Label("Length", systemImage: "clock")
                    
                    Spacer()
                    
                    Text("\(scrum.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    
                    Spacer()
                    
                    Text(scrum.theme.name)
                        .padding(4)
                        .foregroundColor(scrum.theme.accentColor)
                        .background(scrum.theme.mainColor)
                        .cornerRadius(4)
                }
                .accessibilityElement(children: .combine)
            })
            Section(header: Text("Attendees"), content: {
                ForEach(scrum.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            })
        }
        .navigationTitle(scrum.title)
        .toolbar {
            Button("Edit") {
                isPresentingEditView = true
            }
        }
        .sheet(isPresented: $isPresentingEditView, content: {
            NavigationView {
                DetailEditView()
                    .navigationTitle(scrum.title)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction, content: {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        })
                        
                        ToolbarItem(placement: .confirmationAction, content: {
                            Button("Done") {
                                isPresentingEditView = false
                            }
                        })
                    }
            }
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(scrum: DailyScrum.sampleData[0])
        }
    }
}
