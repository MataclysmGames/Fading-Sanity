godot_console.exe --headless --export-release "Windows Desktop" --quiet
godot_console.exe --headless --export-release "Linux" --quiet
godot_console.exe --headless --export-release "Web" --quiet

butler push C:\Users\matte\Documents\Games\Fading-Sanity\Linux\ mataclysm/Fading-Sanity:linux
butler push C:\Users\matte\Documents\Games\Fading-Sanity\Windows\ mataclysm/Fading-Sanity:windows
butler push C:\Users\matte\Documents\Games\Fading-Sanity\Web\ mataclysm/Fading-Sanity:html
