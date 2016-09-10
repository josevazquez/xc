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

##Installation
To actually use `xc`, you have a couple of choices

###Binary Executable
You can open `xc.xcodeproj` and simply hit build. If you look in your products, you should be able to find the resulting `xc` executable. You can then copy that somewhere in your search path and you should be good to go. Nice thing about this approach is that, someday, in the future, Apple will once again change Swift. If you use the compiled version of `xc`, your tool will not break when that day comes.

###Interpreted script
If you search in the project, you can find the file `main.swift`. You can copy that file, and rename it to `xc` and move it somewhere in your search path. For it to be executable, you will need to make sure to set it's permissions. You can do that with this command:
```
$ chmod +x xc
```
The nice thing to this approch is that you can easily hack on `xc`. Simply edit the file with your favorite editor (Xcode? probably not :-P) Any changes you make to the script should be in effect the next time you run the script. neat!

###Symbolic link
You can also create a link in your executalbe path. This allows you to keep the `main.siwft` file in your project, probalby outside of your executable path and have a link that lets you use `xc` whereever you need it. to create the symbolic link do:
```
$ ln -s <path_to_project>/xc/xc/main.swift xc 
```
Again, make sure that link is created somewhere in your search path and that it has executable permissions. This is a wierd in between case. I like it becuase it let's me hack in the xcode project with debugger and all, while still be able to run the `xc` script anywhere the command line takes me.


Let me know if you find any bugs or have suggestions. I can also be reached on twitter as @josevazquez
