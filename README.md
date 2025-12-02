<h1 align="center"> WidgetToDo </h1> <br>

<p align="center">
  To do app with Live Activities and custom notifications!
</p>

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Introduction](#introduction)
- [Setup](#setup)
- [Tech/framework used](#tech/framework-used)
- [Features](#features)


<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

This app is one of <a href="https://www.saritasa.com/">Saritasa's</a> internal products to help developers learn to use LiveActivitiies, SwiftData, and UserNotifications using a simple ToDo app.

## Setup

This project does not include the Xcconfigs folder or any .xcconfig files in the repository for security reasons (e.g., avoiding exposure of bundle identifiers, signing settings, and private configuration values).
Before building the project, you must create and provide your own Xcode configuration files.
To do so, follow these steps:
- Create a Xcconfigs folder in `WidgetToDo/WidgetToDo`
- Inside Xcconfigs, add two files: `LocalDebug.xcconfig` and `LocalRelease.xcconfig`
- Each file should contain your local build settings. Example: `PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.widgettodo.dev`
- Link the .xcconfig files in Xcode:
    - In Xcode open the project settings
    - Select your project → Build Settings
    - Search for "Configurations" or "Build Settings File"
    - Assign each build configuration to the matching `.xcconfig` file

The project is preconfigured with the Saritasa LLC Team ID for local development.

## Tech/framework used
Built with:

- SwiftUI
- ActivityKit
- WidgetKit
- SwiftData
- UserNotifications

## Features

A few of the things you can do with WidgetToDo:

* Add activities to your to do list
* Get reminders letting you know that an activity is coming up
* Use LiveActivities to let you know which activity is currently taking place
