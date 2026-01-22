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
