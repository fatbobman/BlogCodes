//
//  Transcription.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Foundation

struct Transcription: Equatable, Identifiable {
    let id = UUID()
    let startTime: String
    var context: String
}

let regexPattern = "Fireflies"

let transcriptionFakeResult: [Transcription] = [
    .init(startTime: "06:32", context: "*fiRefLIes As you use fiRefLIes to Fireflies record and transcribe meetings, please ensure that you are followfiRefLIesing all FIREFLIEscountry, state, local, and org level laws around consent."),
    .init(startTime: "08:42", context: "*fiRefLIes Record any call in Google Meet or Zoom with our simple Chrome Extension. Access the recordfirefliesing immediately after finishing the call."),
    .init(startTime: "11:42", context: "As you use to record and transcribe meetings, please ensure that you are following all country, state, local, and org level laws around consent."),
    .init(startTime: "13:42", context: "As you use Fireflies to record and transcribe meetings, please ensure that you are following all country, statFirefliesfdfdFirefliese, local, and org level laws around consent."),
    .init(startTime: "14:56", context: "Analytics screen reporting is enabled. Call +[FIRAnalytics logEventWithName:FIREventScreenView parameters:] Fireflies to log a screen view event. To disable Fireflies automatic screen reporting, set the flag FirebaseAutomaticScreenReportingEnabled to NO (boolean) in the Info.plist"),
    .init(startTime: "20:31", context: "As you use Fireflies to record."),
    .init(startTime: "43:00", context: "that you are following afiRefLIesll country, Fireflies!"),
    .init(startTime: "44:51", context: "2022-07-08 14:43Fireflies, :48.854879+0800 SentifiRefLIesment Stag[79888:3754813] [Amplify] Adding plugin:"),
    .init(startTime: "84:11", context: "2022-07-08 14:, :48.854879+043Fireflies800 Sentiment Stag[79888:3754813] [Amplify] Adding plugfiRefLIesin:"),


        .init(startTime: "06:32", context: "*fiRefLIes As you use fiRefLIes to Fireflies record and transcribe meetings, please ensure that you are followfiRefLIesing all FIREFLIEscountry, state, local, and org level laws around consent."),
        .init(startTime: "08:42", context: "*fiRefLIes Record any call in Google Meet or Zoom with our simple Chrome Extension. Access the recordfirefliesing immediately after finishing the call."),
        .init(startTime: "11:42", context: "As you use to record and transcribe meetings, please ensure that you are following all country, state, local, and org level laws around consent."),
        .init(startTime: "13:42", context: "As you use Fireflies to record and transcribe meetings, please ensure that you are following all country, statFirefliesfdfdFirefliese, local, and org level laws around consent."),
        .init(startTime: "14:56", context: "Analytics screen reporting is enabled. Call +[FIRAnalytics logEventWithName:FIREventScreenView parameters:] Fireflies to log a screen view event. To disable Fireflies automatic screen reporting, set the flag FirebaseAutomaticScreenReportingEnabled to NO (boolean) in the Info.plist"),
        .init(startTime: "20:31", context: "As you use Fireflies to record."),
        .init(startTime: "43:00", context: "that you are following afiRefLIesll country, Fireflies!"),
        .init(startTime: "44:51", context: "2022-07-08 14:43Fireflies, :48.854879+0800 SentifiRefLIesment Stag[79888:3754813] [Amplify] Adding plugin:"),
        .init(startTime: "84:11", context: "2022-07-08 14:, :48.854879+043Fireflies800 Sentiment Stag[79888:3754813] [Amplify] Adding plugfiRefLIesin:"),
    .init(startTime: "06:32", context: "*fiRefLIes As you use fiRefLIes to Fireflies record and transcribe meetings, please ensure that you are followfiRefLIesing all FIREFLIEscountry, state, local, and org level laws around consent."),
    .init(startTime: "08:42", context: "*fiRefLIes Record any call in Google Meet or Zoom with our simple Chrome Extension. Access the recordfirefliesing immediately after finishing the call."),
    .init(startTime: "11:42", context: "As you use to record and transcribe meetings, please ensure that you are following all country, state, local, and org level laws around consent."),
    .init(startTime: "13:42", context: "As you use Fireflies to record and transcribe meetings, please ensure that you are following all country, statFirefliesfdfdFirefliese, local, and org level laws around consent."),
    .init(startTime: "14:56", context: "Analytics screen reporting is enabled. Call +[FIRAnalytics logEventWithName:FIREventScreenView parameters:] Fireflies to log a screen view event. To disable Fireflies automatic screen reporting, set the flag FirebaseAutomaticScreenReportingEnabled to NO (boolean) in the Info.plist"),
    .init(startTime: "20:31", context: "As you use Fireflies to record."),
    .init(startTime: "43:00", context: "that you are following afiRefLIesll country, Fireflies!"),
    .init(startTime: "44:51", context: "2022-07-08 14:43Fireflies, :48.854879+0800 SentifiRefLIesment Stag[79888:3754813] [Amplify] Adding plugin:"),
    .init(startTime: "84:11", context: "2022-07-08 14:, :48.854879+043Fireflies800 Sentiment Stag[79888:3754813] [Amplify] Adding plugfiRefLIesin:"),
    .init(startTime: "06:32", context: "*fiRefLIes As you use fiRefLIes to Fireflies record and transcribe meetings, please ensure that you are followfiRefLIesing all FIREFLIEscountry, state, local, and org level laws around consent."),
    .init(startTime: "08:42", context: "*fiRefLIes Record any call in Google Meet or Zoom with our simple Chrome Extension. Access the recordfirefliesing immediately after finishing the call."),
    .init(startTime: "11:42", context: "As you use to record and transcribe meetings, please ensure that you are following all country, state, local, and org level laws around consent."),
    .init(startTime: "13:42", context: "As you use Fireflies to record and transcribe meetings, please ensure that you are following all country, statFirefliesfdfdFirefliese, local, and org level laws around consent."),
    .init(startTime: "14:56", context: "Analytics screen reporting is enabled. Call +[FIRAnalytics logEventWithName:FIREventScreenView parameters:] Fireflies to log a screen view event. To disable Fireflies automatic screen reporting, set the flag FirebaseAutomaticScreenReportingEnabled to NO (boolean) in the Info.plist"),
    .init(startTime: "20:31", context: "As you use Fireflies to record."),
    .init(startTime: "43:00", context: "that you are following afiRefLIesll country, Fireflies!"),
    .init(startTime: "44:51", context: "2022-07-08 14:43Fireflies, :48.854879+0800 SentifiRefLIesment Stag[79888:3754813] [Amplify] Adding plugin:"),
    .init(startTime: "84:11", context: "2022-07-08 14:, :48.854879+043Fireflies800 Sentiment Stag[79888:3754813] [Amplify] Adding plugfiRefLIesin:"),
    .init(startTime: "06:32", context: "*fiRefLIes As you use fiRefLIes to Fireflies record and transcribe meetings, please ensure that you are followfiRefLIesing all FIREFLIEscountry, state, local, and org level laws around consent."),
    .init(startTime: "08:42", context: "*fiRefLIes Record any call in Google Meet or Zoom with our simple Chrome Extension. Access the recordfirefliesing immediately after finishing the call."),
    .init(startTime: "11:42", context: "As you use to record and transcribe meetings, please ensure that you are following all country, state, local, and org level laws around consent."),
    .init(startTime: "13:42", context: "As you use Fireflies to record and transcribe meetings, please ensure that you are following all country, statFirefliesfdfdFirefliese, local, and org level laws around consent."),
    .init(startTime: "14:56", context: "Analytics screen reporting is enabled. Call +[FIRAnalytics logEventWithName:FIREventScreenView parameters:] Fireflies to log a screen view event. To disable Fireflies automatic screen reporting, set the flag FirebaseAutomaticScreenReportingEnabled to NO (boolean) in the Info.plist"),
    .init(startTime: "20:31", context: "As you use Fireflies to record."),
    .init(startTime: "43:00", context: "that you are following afiRefLIesll country, Fireflies!"),
    .init(startTime: "44:51", context: "2022-07-08 14:43Fireflies, :48.854879+0800 SentifiRefLIesment Stag[79888:3754813] [Amplify] Adding plugin:"),
    .init(startTime: "84:11", context: "2022-07-08 14:, :48.854879+043Fireflies800 Sentiment Stag[79888:3754813] [Amplify] Adding plugfiRefLIesin:"),
    
]
