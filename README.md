# xc
A command line utility written in swift used to launch Xcode with sensible default arguments. 

`xc` is a command line utility to launch Xcode. To open a file or project, you'd pass it as an argument. like so:
```
$ xc MyProj.xcodeproj
```

The more interesting case is executing `xc` without any arguments. In that case, `xc` makes an attempt to lauch Xcode 
with something reasonable. `xc` pays attention to the name of the current working directory, and to any workspaces and 
Xcode projects it can find in it. It searches for the following cases, and stops when it find the first such case:

1. If passed any arguments, it will open any files (as absolute or relative paths) it can find.
2. Open any workspace that matches the CWD, for example `~/MyProj/MyProj.xcworkspace`
3. Open any project that matches the CWD, for example `~/MyProj/Myproj.xcodeproj`
4. Open any workspace found, regardless of them matching the CWD or not
5. Open any project found, regardless of them matching the CWD or not
6. Just open Xcode.

Interesting note, if you already have several Xcode windows open, and you use `xc` to reopen one of them, Xcode will
simply bring that window to the front.

Let me know if you find any bugs or have suggestions. I can also be reached on twitter as @josevazquez
