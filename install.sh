#!/bin/bash

# Install the Light/Dark Theme Toggle Plasma widget

WIDGET_NAME="io.github.dscafati.lightdarktoggle"
INSTALL_DIR="$HOME/.local/share/plasma/plasmoids"

echo "Installing Light/Dark Theme Toggle Plasma widget..."

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Remove old version if it exists
if [ -d "$INSTALL_DIR/$WIDGET_NAME" ]; then
    echo "Removing old version..."
    rm -rf "$INSTALL_DIR/$WIDGET_NAME"
fi

# Copy the widget
echo "Copying widget files..."
cp -r "$WIDGET_NAME" "$INSTALL_DIR/"

echo "Installation complete!"
echo ""
echo "To test the widget, run:"
echo "  plasmawindowed $WIDGET_NAME"
echo ""
echo "To add it to your panel:"
echo "  1. Right-click on your panel"
echo "  2. Select 'Add Widgets...'"
echo "  3. Search for 'Light/Dark Theme Toggle'"
echo "  4. Drag it to your panel or desktop"
echo ""
echo "You may need to restart Plasma for changes to take effect:"
echo "  kquitapp6 plasmashell && kstart plasmashell"
echo ""
echo "Or test without installing into the panel:"
echo "  plasmoidviewer6 -a $WIDGET_NAME"

