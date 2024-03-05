dotnet tool install --global dotnet-serve

godot_console.exe --headless --export-release "Web" --quiet 2>$null

dotnet serve --directory C:\Users\matte\Documents\Games\Fading-Sanity\Web\ -h "Cross-Origin-Opener-Policy: same-origin" -h "Cross-Origin-Embedder-Policy: require-corp" -h "Access-Control-Allow-Origin: *" --open-browser
