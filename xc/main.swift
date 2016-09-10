#!/usr/bin/swift

import AppKit

let Xcode = "Xcode"

// Get all arguments and remove the first one which is the name of the executable itself.
var arguments = CommandLine.arguments
arguments.remove(at: 0)


// Get current directory path and assigne the last element of the path to the projectFolder
let fileManager = FileManager.default
let path = fileManager.currentDirectoryPath
let url = URL(fileURLWithPath: path)

guard let projectFolder = url.pathComponents.last else {
    print("Somehow this tool was executed with no PWD.")
    exit(EXIT_FAILURE)
}

// Given the projectFolder, derive what the expected project and workspace files would be.
let workspacePath = "\(path)/\(projectFolder).xcworkspace"
let projectPath = "\(path)/\(projectFolder).xcodeproj"

/// Helper function of open up files if they exist. can optionally exit the script on success.
func open(file:String, application:String, exitOnSuccess:Bool) -> Bool {
    let success = NSWorkspace.shared().openFile(file, withApplication:application)
    if exitOnSuccess && success {
        exit(EXIT_SUCCESS)
    }
    return success
}

/// Helper function that opens any files that end with the passed extension. If
/// any matching files are found, we exit execution.
func open(filesWithExtension fileExtension:String) {
    var files = [String]()

    do {
        files = try fileManager.contentsOfDirectory(atPath: path)
    } catch {
        print("Failed to read contents of current directory: \(error)")
        NSWorkspace.shared().launchApplication(Xcode)
    }

    var fileFound = false
    for file in files.filter({$0.hasSuffix(fileExtension)}) {
        let fullPath = "\(path)/\(file)"
        fileFound = fileFound || open(file:fullPath, application:Xcode, exitOnSuccess:false)
    }

    if(fileFound) {
        exit(EXIT_SUCCESS)
    }
}


// If arguments were passed, attempt to open each one, one at a time, in Xcode.
if arguments.count > 0 {
    for file in arguments {
        // First try opening the argument as a relative path. If that doesn't work,
        // Try it again as an absolute path.
        let relativeFilePath = "\(path)/\(file)"

        if open(file:relativeFilePath, application:Xcode, exitOnSuccess:false) == false {
            _ = open(file:file, application:Xcode, exitOnSuccess:false)
        }
    }

// If not arguments were passed open Xcode with some sensical default.
} else {
    // Try to open the workspace first, and quit if success.
    _ = open(file:workspacePath, application:Xcode, exitOnSuccess:true)

    // Now, try to open the project, and quit if that succeeds.
    _ = open(file:projectPath, application:Xcode, exitOnSuccess:true)

    open(filesWithExtension:".xcworkspace")
    open(filesWithExtension:".xcodeproj")

    // Finally, just attempt to launch Xcode.
    NSWorkspace.shared().launchApplication(Xcode)
}

