#!/bin/bash

# Weather Monitoring Application Setup Script
echo "Creating Weather Monitoring application..."



# Create WeatherMonitoring.csproj
cat > WeatherMonitoring.csproj << 'EOF'
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>WinExe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <BuiltInComInteropSupport>true</BuiltInComInteropSupport>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Avalonia" Version="11.0.10" />
    <PackageReference Include="Avalonia.Desktop" Version="11.0.10" />
    <PackageReference Include="Avalonia.Themes.Fluent" Version="11.0.10" />
  </ItemGroup>
</Project>
EOF

# Create Program.cs
cat > Program.cs << 'EOF'
using Avalonia;
using System;

namespace WeatherMonitoring
{
    class Program
    {
        [STAThread]
        public static void Main(string[] args) => BuildAvaloniaApp()
            .StartWithClassicDesktopLifetime(args);

        public static AppBuilder BuildAvaloniaApp()
            => AppBuilder.Configure<App>()
                .UsePlatformDetect()
                .LogToTrace();
    }
}
EOF

# Create App.axaml.cs
cat > App.axaml.cs << 'EOF'
using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;

namespace WeatherMonitoring
{
    public class App : Application
    {
        public override void Initialize()
        {
            AvaloniaXamlLoader.Load(this);
        }

        public override void OnFrameworkInitializationCompleted()
        {
            if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
            {
                desktop.MainWindow = new MainWindow();
            }
            base.OnFrameworkInitializationCompleted();
        }
    }
}
EOF

# Create App.axaml
cat > App.axaml << 'EOF'
<Application xmlns="https://github.com/avaloniaui"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             x:Class="WeatherMonitoring.App">
    <Application.Styles>
        <FluentTheme />
    </Application.Styles>
</Application>
EOF

# Create WeatherData.cs
cat > WeatherData.cs << 'EOF'
namespace WeatherMonitoring
{
    public class WeatherData
    {
        private float temperature;
        private float humidity;
        private float pressure;

        public float GetTemperature() => temperature;
        public float GetHumidity() => humidity;
        public float GetPressure() => pressure;

        public void SetMeasurements(float temperature, float humidity, float pressure)
        {
            this.temperature = temperature;
            this.humidity = humidity;
            this.pressure = pressure;
        }
    }
}
EOF

# Create CurrentConditionsDisplay.cs
cat > CurrentConditionsDisplay.cs << 'EOF'
namespace WeatherMonitoring
{
    public class CurrentConditionsDisplay
    {
        private float temperature;
        private float humidity;
        private float pressure;

        public void Update(float temperature, float humidity, float pressure)
        {
            this.temperature = temperature;
            this.humidity = humidity;
            this.pressure = pressure;
        }

        public string GetDisplayText()
        {
            string pressureTrend = pressure < 29.92f ? "↓" : pressure > 30.20f ? "↑" : "→";
            return $"Current Conditions\n☀️\nTemp: {temperature}°F\nHumidity: {humidity}%\nPressure: {pressureTrend}";
        }
    }
}
EOF

# Create StatisticsDisplay.cs
cat > StatisticsDisplay.cs << 'EOF'
namespace WeatherMonitoring
{
    public class StatisticsDisplay
    {
        private float maxTemp = float.MinValue;
        private float minTemp = float.MaxValue;
        private float tempSum = 0.0f;
        private int numReadings = 0;

        public void Update(float temperature, float humidity, float pressure)
        {
            tempSum += temperature;
            numReadings++;

            if (temperature > maxTemp)
                maxTemp = temperature;

            if (temperature < minTemp)
                minTemp = temperature;
        }

        public string GetDisplayText()
        {
            if (numReadings == 0)
                return "Weather Stats\n📊\nNo data yet";

            float avgTemp = tempSum / numReadings;
            return $"Weather Stats\n📊\nAvg temp: {avgTemp:F1}°F\nMin temp: {minTemp:F1}°F\nMax temp: {maxTemp:F1}°F";
        }
    }
}
EOF

# Create ForecastDisplay.cs
cat > ForecastDisplay.cs << 'EOF'
namespace WeatherMonitoring
{
    public class ForecastDisplay
    {
        private float currentPressure = 29.92f;
        private float lastPressure;

        public void Update(float temperature, float humidity, float pressure)
        {
            lastPressure = currentPressure;
            currentPressure = pressure;
        }

        public string GetDisplayText()
        {
            string forecast;
            if (currentPressure > lastPressure)
            {
                forecast = "Improving weather\non the way! ☀️";
            }
            else if (currentPressure == lastPressure)
            {
                forecast = "More of the same\nweather ahead 🌤️";
            }
            else
            {
                forecast = "Watch out for\ncooler, rainy\nweather 🌧️";
            }

            return $"Forecast\n{forecast}";
        }
    }
}
EOF

# Create MainWindow.axaml.cs
cat > MainWindow.axaml.cs << 'EOF'
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Markup.Xaml;
using Avalonia.Threading;
using System;

namespace WeatherMonitoring
{
    public partial class MainWindow : Window
    {
        private WeatherData weatherData;
        private CurrentConditionsDisplay currentDisplay;
        private StatisticsDisplay statsDisplay;
        private ForecastDisplay forecastDisplay;
        private Random random;
        private DispatcherTimer? autoUpdateTimer;

        public MainWindow()
        {
            InitializeComponent();
            random = new Random();

            // Create weather data object
            weatherData = new WeatherData();

            // Create displays
            currentDisplay = new CurrentConditionsDisplay();
            statsDisplay = new StatisticsDisplay();
            forecastDisplay = new ForecastDisplay();

            // Set initial values
            UpdateWeatherData(72, 65, 30.4f);
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }

        private void UpdateWeatherData(float temp, float humidity, float pressure)
        {
            // Update the weather data
            weatherData.SetMeasurements(temp, humidity, pressure);
            
            // Manually call each display's update method
            currentDisplay.Update(temp, humidity, pressure);
            statsDisplay.Update(temp, humidity, pressure);
            forecastDisplay.Update(temp, humidity, pressure);
            
            // Manually refresh each display
            UpdateCurrentDisplay();
            UpdateStatsDisplay();
            UpdateForecastDisplay();
        }

        private void UpdateCurrentDisplay()
        {
            var textBlock = this.FindControl<TextBlock>("CurrentConditionsText");
            if (textBlock != null)
            {
                textBlock.Text = currentDisplay.GetDisplayText();
            }
        }

        private void UpdateStatsDisplay()
        {
            var textBlock = this.FindControl<TextBlock>("StatisticsText");
            if (textBlock != null)
            {
                textBlock.Text = statsDisplay.GetDisplayText();
            }
        }

        private void UpdateForecastDisplay()
        {
            var textBlock = this.FindControl<TextBlock>("ForecastText");
            if (textBlock != null)
            {
                textBlock.Text = forecastDisplay.GetDisplayText();
            }
        }

        private void OnUpdateWeatherClick(object? sender, RoutedEventArgs e)
        {
            var tempBox = this.FindControl<NumericUpDown>("TemperatureInput");
            var humidityBox = this.FindControl<NumericUpDown>("HumidityInput");
            var pressureBox = this.FindControl<NumericUpDown>("PressureInput");

            if (tempBox != null && humidityBox != null && pressureBox != null)
            {
                float temp = (float)(tempBox.Value ?? 72);
                float humidity = (float)(humidityBox.Value ?? 65);
                float pressure = (float)(pressureBox.Value ?? 30.4);

                UpdateWeatherData(temp, humidity, pressure);
            }
        }

        private void OnRandomWeatherClick(object? sender, RoutedEventArgs e)
        {
            float temp = 50 + (float)(random.NextDouble() * 50); // 50-100°F
            float humidity = 30 + (float)(random.NextDouble() * 60); // 30-90%
            float pressure = 29.5f + (float)(random.NextDouble() * 1.5f); // 29.5-31.0

            var tempBox = this.FindControl<NumericUpDown>("TemperatureInput");
            var humidityBox = this.FindControl<NumericUpDown>("HumidityInput");
            var pressureBox = this.FindControl<NumericUpDown>("PressureInput");

            if (tempBox != null && humidityBox != null && pressureBox != null)
            {
                tempBox.Value = (decimal)temp;
                humidityBox.Value = (decimal)humidity;
                pressureBox.Value = (decimal)pressure;
            }

            UpdateWeatherData(temp, humidity, pressure);
        }

        private void OnAutoUpdateToggle(object? sender, RoutedEventArgs e)
        {
            var toggleButton = sender as ToggleButton;
            if (toggleButton?.IsChecked == true)
            {
                // Start auto-update timer
                autoUpdateTimer = new DispatcherTimer
                {
                    Interval = TimeSpan.FromSeconds(3)
                };
                autoUpdateTimer.Tick += (s, args) => OnRandomWeatherClick(null, new RoutedEventArgs());
                autoUpdateTimer.Start();
            }
            else
            {
                // Stop auto-update timer
                autoUpdateTimer?.Stop();
                autoUpdateTimer = null;
            }
        }
    }
}
EOF

# Create MainWindow.axaml
cat > MainWindow.axaml << 'EOF'
<Window xmlns="https://github.com/avaloniaui"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Class="WeatherMonitoring.MainWindow"
        Title="Weather Monitoring Station"
        Width="900" Height="600"
        Background="#F0F0F0">
    
    <Grid Margin="20" RowDefinitions="Auto,*,Auto">
        
        <!-- Header -->
        <Border Grid.Row="0" 
                Background="#2C5F2D" 
                CornerRadius="8" 
                Padding="20"
                Margin="0,0,0,20">
            <StackPanel>
                <TextBlock Text="🌡️ Weather Monitoring Station"
                           FontSize="28"
                           FontWeight="Bold"
                           Foreground="White"
                           HorizontalAlignment="Center"/>
                <TextBlock Text="Direct Method Calls (No Observer Pattern)"
                           FontSize="14"
                           Foreground="#E0E0E0"
                           HorizontalAlignment="Center"
                           Margin="0,5,0,0"/>
            </StackPanel>
        </Border>

        <!-- Display Panels -->
        <Grid Grid.Row="1" ColumnDefinitions="*,*,*" Margin="0,0,0,20">
            
            <!-- Current Conditions Display -->
            <Border Grid.Column="0"
                    Background="White"
                    CornerRadius="8"
                    BoxShadow="0 2 10 0 #20000000"
                    Padding="20"
                    Margin="0,0,10,0">
                <TextBlock Name="CurrentConditionsText"
                           Text="Current Conditions"
                           FontSize="16"
                           TextAlignment="Center"
                           TextWrapping="Wrap"/>
            </Border>

            <!-- Statistics Display -->
            <Border Grid.Column="1"
                    Background="White"
                    CornerRadius="8"
                    BoxShadow="0 2 10 0 #20000000"
                    Padding="20"
                    Margin="5,0,5,0">
                <TextBlock Name="StatisticsText"
                           Text="Weather Stats"
                           FontSize="16"
                           TextAlignment="Center"
                           TextWrapping="Wrap"/>
            </Border>

            <!-- Forecast Display -->
            <Border Grid.Column="2"
                    Background="White"
                    CornerRadius="8"
                    BoxShadow="0 2 10 0 #20000000"
                    Padding="20"
                    Margin="10,0,0,0">
                <TextBlock Name="ForecastText"
                           Text="Forecast"
                           FontSize="16"
                           TextAlignment="Center"
                           TextWrapping="Wrap"/>
            </Border>
        </Grid>

        <!-- Weather Station Controls -->
        <Border Grid.Row="2"
                Background="White"
                CornerRadius="8"
                BoxShadow="0 2 10 0 #20000000"
                Padding="20">
            <StackPanel Spacing="15">
                <TextBlock Text="Weather Station Controls"
                           FontSize="18"
                           FontWeight="SemiBold"
                           HorizontalAlignment="Center"/>

                <Grid ColumnDefinitions="*,*,*" RowDefinitions="Auto,Auto">
                    <!-- Temperature -->
                    <StackPanel Grid.Column="0" Grid.Row="0" Margin="0,0,10,10">
                        <TextBlock Text="Temperature (°F)" FontSize="14" Margin="0,0,0,5"/>
                        <NumericUpDown Name="TemperatureInput"
                                     Value="72"
                                     Minimum="0"
                                     Maximum="120"
                                     Increment="1"
                                     FormatString="F1"/>
                    </StackPanel>

                    <!-- Humidity -->
                    <StackPanel Grid.Column="1" Grid.Row="0" Margin="5,0,5,10">
                        <TextBlock Text="Humidity (%)" FontSize="14" Margin="0,0,0,5"/>
                        <NumericUpDown Name="HumidityInput"
                                     Value="65"
                                     Minimum="0"
                                     Maximum="100"
                                     Increment="1"
                                     FormatString="F1"/>
                    </StackPanel>

                    <!-- Pressure -->
                    <StackPanel Grid.Column="2" Grid.Row="0" Margin="10,0,0,10">
                        <TextBlock Text="Pressure (inHg)" FontSize="14" Margin="0,0,0,5"/>
                        <NumericUpDown Name="PressureInput"
                                     Value="30.4"
                                     Minimum="28"
                                     Maximum="32"
                                     Increment="0.1"
                                     FormatString="F2"/>
                    </StackPanel>
                </Grid>

                <UniformGrid Columns="3" Rows="1">
                    <Button Content="📡 Update Weather"
                            Click="OnUpdateWeatherClick"
                            Padding="15,10"
                            FontSize="14"
                            Margin="0,0,5,0"/>
                    
                    <Button Content="🎲 Random Weather"
                            Click="OnRandomWeatherClick"
                            Padding="15,10"
                            FontSize="14"
                            Margin="5,0,5,0"/>
                    
                    <ToggleButton Content="🔄 Auto-Update"
                                  Click="OnAutoUpdateToggle"
                                  Padding="15,10"
                                  FontSize="14"
                                  Margin="5,0,0,0"/>
                </UniformGrid>

                <TextBlock Text="💡 Note: Updates are done through direct method calls, not observer pattern"
                           FontSize="12"
                           FontStyle="Italic"
                           Foreground="#666"
                           TextWrapping="Wrap"
                           TextAlignment="Center"
                           Margin="0,10,0,0"/>
            </StackPanel>
        </Border>
    </Grid>
</Window>
EOF

# Create README.md
cat > README.md << 'EOF'
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
EOF

echo ""
echo "✅ Weather Monitoring application created successfully!"
echo ""
echo "📁 Location: $(pwd)"
echo ""
echo "Next steps:"
echo "1. Open VS Code"
echo "2. File > Open Folder > Select the WeatherMonitoring folder"
echo "3. When prompted, click 'Reopen in Container'"
echo "4. Wait for container to build"
echo "5. Open browser to http://localhost:6080 (password: vscode)"
echo "6. In the virtual desktop terminal:"
echo "   cd /workspaces/WeatherMonitoring"
echo "   export DISPLAY=:1"
echo "   dotnet run"
echo ""
echo "🌡️ Enjoy your Weather Monitoring Station!"
echo ""