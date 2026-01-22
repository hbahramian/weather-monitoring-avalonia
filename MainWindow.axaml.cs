using Avalonia.Controls;
using Avalonia.Controls.Primitives;
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
                float pressure = (float)(pressureBox.Value ?? 30);

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
