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
