echo "Cleaning up previous build..."

# Delete everything inside the bin folder except the folder itself
rm -r bin/*

echo "Creating .love file..."

# Create a .love file
cp -r . /tmp/lava-jump > /dev/null
rm -r /tmp/lava-jump/bin
rm -rf /tmp/lava-jump/.git
rm -rf /tmp/lava-jump/.github
rm -rf /tmp/lava-jump/.vscode

(cd /tmp/lava-jump/src && zip -9 -r ../../lava-jump.love . > /dev/null)

mv /tmp/lava-jump.love bin

echo "Downloading Love2D for Windows..."

# Download the Love2D binaries (windows32, will run on 64-bit windows as well as linux and macos)
wget -q -P bin https://github.com/love2d/love/releases/download/11.5/love-11.5-win32.zip

echo "Extracting Love2D for Windows..."

# Unzip the love2d binaries
unzip bin/love-11.5-win32.zip -d bin

echo "Building .exe file..."

# Create a .exe file from the .love file
cat bin/love-11.5-win32/love.exe bin/lava-jump.love > bin/love-11.5-win32/game.exe

echo "Customizing..."

# Rename and remove objects
mv bin/love-11.5-win32 bin/lava-jump
rm bin/love-11.5-win32.zip
rm bin/lava-jump/love.exe
rm bin/lava-jump/lovec.exe

# Change the icons, etc in the future

echo "Zipping..."

# Zip the game
(cd bin && zip -r lava-jump-windows-x86_64.zip lava-jump > /dev/null)
rm -r bin/lava-jump

echo "Finished building for Windows!"
echo "Downloading Love2D for MacOS..."

# Download the Love2D binaries (macos)
wget -q -P bin https://github.com/love2d/love/releases/download/11.5/love-11.5-macos.zip

echo "Unzipping..."

# Unzip
mkdir bin/lava-jump
unzip bin/love-11.5-macos.zip -d bin/lava-jump
rm bin/love-11.5-macos.zip

echo "Copying files..."

# Copy the love file into the love.app/Contents/Resources folder
cp bin/lava-jump.love bin/lava-jump/love.app/Contents/Resources

# TODO: Change the icons, name, in the plist file

# Zip
echo "Zipping..."

# (cd bin && zip -r lava-jump-macos.zip lava-jump > /dev/null) # Commented out .zip, file was too big
(cd bin && tar -czvf lava-jump-macos.tar.gz lava-jump)
rm -r bin/lava-jump

echo "Finished building for MacOS!"
echo "Creating Linux version..."

# Zip
cp build_assets/linux_readme.txt bin/readme.txt
# (cd bin && zip -r lava-jump-linux-x86_64.zip lava-jump.love readme.txt) # Used tar instead of zip to be more consistent and reduce file size
(cd bin && tar -czvf lava-jump-linux-x86_64.tar.gz lava-jump.love readme.txt)
rm bin/lava-jump.love
rm bin/readme.txt

echo "Cleaning up..."

# Clean up
rm -rf /tmp/lava-jump

echo "Done! All files are in the bin folder."
