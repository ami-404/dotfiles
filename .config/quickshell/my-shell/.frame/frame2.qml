import QtQuick
import Quickshell.Widgets

ClippingRectangle {
    width: 300
    height: 300
    radius: -20 // Negative radius generates an inward/inverted corner curve
    color: "black"

    contentInsideBorder: true
    
    // Child elements here will be clipped to the negative radius
}
