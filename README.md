# CharacterPixels
Processing code to demo the use of text characters as pixels
# Check out the Video!
[Character Pixels: The COOL Film](https://youtu.be/D1C81xTckc4) (with 12px Characters)

[Character Pixels: The BIG Film](https://youtu.be/enDxRxBbZ-4) (with 48px Characters)


# Usage
- **Mouse click** will toggle the display of the underlying image,
- **'+' key** will start incrementing the number of squares on the checkerboard
- **'-' key** will start decrementing the number of squares on the checkerboard
- **'t' or 'T' keys** will toggle use of true or standard character bounding box for character color computation, the type of box is displayed in the console.
- **Any other key** will pause the inc/decrementing

# Notes
 - Rounding errors can cause wrong colored pixels!
 - current version uses individual character bounding boxes to sample the underlying image and average the result.
