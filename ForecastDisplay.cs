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
