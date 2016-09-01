#!/usr/bin/swift

import AppKit

let Xcode = "Xcode"

// Get all arguments and remove the first one which is the name of the executable itself.
var arguments = Process.arguments
arguments.removeAtIndex(0)


// Get current directory path and assigne the last element of the path to the projectFolder
let fileManager = NSFileManager.defaultManager()
let path = fileManager.currentDirectoryPath
let url = NSURL(fileURLWithPath: path)

guard let projectFolder = url.pathComponents?.last else {
    print("Somehow this tool was executed with no PWD.")
    exit(EXIT_FAILURE)
}

// Given the projectFolder, derive what the expected project and workspace files would be.
let workspacePath = "\(path)/\(projectFolder).xcworkspace"
let projectPath = "\(path)/\(projectFolder).xcodeproj"

// Helper function of open up files if they exist. can optionally exit the script on success.
func openFile(fullPath:String, withApplication application:String, exitOnSuccess:Bool) -> Bool {
    let success = NSWorkspace.sharedWorkspace().openFile(fullPath, withApplication:application)
    if exitOnSuccess && success {
        exit(EXIT_SUCCESS)
    }
    return success
}


// If arguments were passed, attempt to open each one, one at a time, in Xcode.
if arguments.count > 0 {
    for file in arguments {
        // First try opening the argument as a relative path. If that doesn't work,
        // Try it again as an absolute path.
        let relativeFilePath = "\(path)/\(file)"
        
        if openFile(relativeFilePath, withApplication:Xcode, exitOnSuccess:false) == false {
            openFile(file, withApplication:Xcode, exitOnSuccess:false)
        }
    }
    
// If not arguments were passed open Xcode with some sensical default.
} else {
    // Try to open the workspace first, and quit if success.
    openFile(workspacePath, withApplication:Xcode, exitOnSuccess:true)

    // Now, try to open the project, and quit if that succeeds.
    openFile(projectPath, withApplication:Xcode, exitOnSuccess:true)
    
    // Finally, just attempt to launch Xcode.
    NSWorkspace.sharedWorkspace().launchApplication(Xcode)
}
