# SpriteSheetToQuad
Convert Compact Sprite Sheet to Grid/Quad
Love2D 11.4 required to run 

png is hardcoded in pnginput.lua atm

## Features

- **Frame Editing**: Users can add, delete, and edit frames in their animation project.
- **Animation Control**: Enable or disable animation playback with ease.
- **Persistent Image**: Toggle the persistence of images across frames to maintain background or consistent elements.
- **Frame Navigation**: Navigate through frames using intuitive keyboard controls.
- **Selection Box Movement**: Move the selection box around to focus on different parts of the frame.
- **Frame Alignment**: Align sprites to the bottom left corner for consistency.
- **Frame Movement**: Control the movement of frames within the canvas box for precise placement.

## Help Commands

![screenshot](https://github.com/Atomfusion1/SpriteSheetToQuad/screenshot.png?raw=true "screenshot")


Below are the commands available in the application:

- `q`: Delete the currently selected frame.
- `r`: Add a new frame to your animation.
- `e`: Edit the currently selected frame.
- `space`: Enable or disable animation playback.
- `p`: Enable or disable persistent image display across frames.
- `s`: Save the current frame into `appdata.love`.
- `arrows`: Move the selection box around the canvas.
- `kp+`: Increase the current frame number, moving to the next frame.
- `kp-`: Decrease the current frame number, moving to the previous frame.
- `ctrl` + `arrows`: Hold ctrl and use arrow keys to move the frame inside the canvas box for precise alignment.

