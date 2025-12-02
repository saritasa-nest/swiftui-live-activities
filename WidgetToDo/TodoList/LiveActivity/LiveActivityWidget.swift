//
//  LiveActivity.swift
//  LiveActivity
//
//  Created by Nicolas Cobelo on 31/10/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI
import Intents

struct LiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TodoAttributes.self) { context in
            // Lock screen/banner UI goes here
            LiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    LiveActivityView(context: context)
                }
            } compactLeading: {
                Text(context.attributes.target.name)
            } compactTrailing: {
                Text(context.state.status.text)
            } minimal: {
                Text("")
            }
        }
    }
    
    @ViewBuilder
    func LiveActivityView(context: ActivityViewContext<TodoAttributes>) -> some View {
        ZStack{
            VStack(alignment: .leading) {
                HStack(alignment: .center){
                    Image("appLogo")
                        .resizable()
                        .frame(width:38,height: 38)
                        .clipShape(.circle)

                    VStack(alignment: .leading){
                        HStack{
                            Text(context.attributes.target.name)
                                .font(.system(size: 18,weight: .bold))
                            Spacer()
                        }
                        Text(DateHelper.Formatter.longDate.string(from: context.attributes.target.startTime))
                            .font(.system(size: 16,weight: .medium))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }

                ButtonView(context: context)
            }
            .padding(16)
            .activityBackgroundTint(Color.brandSecondary.opacity(0.5))
        }
    }
    
    @ViewBuilder
    func ButtonView(context: ActivityViewContext<TodoAttributes>) -> some View {
        Group {
            switch context.state.status {
            case .pending:
                Text("Pending")
            case .inProgress:
                LiveActivityActionButtonsView(recordID: context.attributes.target.id)
            case .completed:
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .frame(width: .infinity,height: 40)
                    .foregroundStyle(Color.brandSecondary.opacity(0.5))
                    .overlay(content: {
                        Text("Completed!")
                            .font(Font.system(size: 16,weight: .bold))
                    })
            }
        }
    }
}


struct LiveActivityActionButtonsView: View {
    let recordID:String
    var body: some View {
        HStack{
            Button(intent: LiveActivityButtonIntent(id: recordID), label: {
                Text("Complete")
            })
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity,minHeight:40,maxHeight:40)
            .background(Color.brandPrimary.gradient)
            .clipShape(Capsule())

        }
    }
}
