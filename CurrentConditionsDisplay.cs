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
