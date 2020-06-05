# What is this?
This is a custom indicator for Ubuntu Touch to toggle a proof of concept of a new mode for the desktop environment Lomiri wherein some system gestures are disabled to help the user focus on the current app they're using without much distractions.

This is specially useful for apps that require different in-app gestures that could conflict with system gestures such as painting/drawing apps and games.

I call this "Immersive mode" because I feel like it best describes its purpose.
However, it's somewhat borrowed from Android so if you can think of a better name then let me know :)

# What does it exactly do?
When Immersive mode is enabled, left and right edge gestures are disabled. This means you can't swipe from the left to open the launcher or the app drawer and you can't open the app spread from the right edge. This is all it does at the moment but if ever this actually gets into Lomiri officially, maybe some other gestures can also be disbaled such as the 3-finger gestures in tablets.

# How does it work?
Left and right egdes are disabled by simply setting Lomiri's GSettings key "Edge Drag Width" to 0. This settings can also be adjusted via UT Tweak Tool but the range there is only limited to 1-6.

# Anything else?
- Some devices such as the Nexus 5 and Meizu MX4 has an issue wherein one edge is still active even with Immersive mode enabled. The still active edge depends on the orientation and possibly an "invisible bug" on these devices."
- Disabling Immersive mode will reset the settings "Edge Drag Width" to its default value which is 2. So take note for those users who changed this value especially those who use a phone case.

# How to compile?
You can use clickable <https://clickable-ut.dev> to compile however, I used an older version so the clickable.json file might not work on newer version anymore. Sorry 😅
