# Weather Monitoring Station

A desktop application demonstrating weather monitoring with three displays: Current Conditions, Statistics, and Forecast.

**Note**: This version uses direct method calls instead of the Observer pattern to show the difference in design approaches.

## Features
- 🌡️ Real-time weather monitoring
- 📊 Statistics tracking (avg, min, max temperature)
- 🌤️ Forecast based on pressure trends
- 🎲 Random weather generator
- 🔄 Auto-update mode

## Running in VS Code Dev Container

1. Open this folder in VS Code
2. Press F1 or Cmd+Shift+P
3. Select "Dev Containers: Reopen in Container"
4. Wait for the container to build
5. Open browser to http://localhost:6080 (password: vscode)
6. In the virtual desktop terminal:
   ```bash
   cd /workspaces/WeatherMonitoring
   export DISPLAY=:1
   dotnet run
   ```

## Running on Mac (without container)

1. Install .NET SDK 8.0 from https://dotnet.microsoft.com/download
2. Navigate to this folder
3. Run:
   ```bash
   dotnet restore
   dotnet run
   ```

## Architecture

This application demonstrates a **non-observer pattern** approach:
- WeatherData stores sensor measurements
- Three display classes show different views
- MainWindow manually calls each display's update method
- Tight coupling between MainWindow and displays

Compare this to the Observer pattern where displays would automatically update when WeatherData changes!
