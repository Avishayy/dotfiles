# install dmg by file
installdmg() {
  # Check if a file path argument was passed
  if [ -z "$1" ]; then
    echo "Please provide the path to a .dmg file."
    return 1
  fi

  dmg_path="$1"

  # Check if the file exists
  if [ ! -f "$dmg_path" ]; then
    echo "File not found: $dmg_path"
    return 1
  fi

  # Mount the .dmg file
  echo "Mounting $dmg_path..."
  volume=$(hdiutil attach "$dmg_path" | grep "/Volumes/" | awk '{print $3}')
  
  if [ -z "$volume" ]; then
    echo "Failed to mount the .dmg file."
    return 1
  fi

  echo "Mounted at $volume"

  # Find the .app file in the mounted volume
  app_path=$(find "$volume" -name "*.app" -maxdepth 1)

  if [ -z "$app_path" ]; then
    echo "No .app file found in $volume"
    hdiutil detach "$volume"
    return 1
  fi

  # Copy the app to /Applications using rsync to preserve metadata
  echo "Copying $app_path to /Applications..."
  sudo rsync -a "$app_path" /Applications/

  if [ $? -eq 0 ]; then
    echo "Application copied successfully."
  else
    echo "Failed to copy the application."
  fi

  # Unmount the .dmg file
  echo "Unmounting $volume..."
  hdiutil detach "$volume"

  echo "Done!"
}
