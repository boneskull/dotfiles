/**
 * Weather Widget for Übersicht
 * Uses Open-Meteo free API for weather data
 *
 * Theme: Retro Synth Matrix
 * Font: 3270 Nerd Font Mono
 */

import { theme, tahoe, synth, glowBox, textGlow, labelGlow } from "../shared/theme.jsx";

// ============================================================================
// CONFIGURATION - Edit this to customize your location and units
// ============================================================================
const config = {
  latitude: 45.8151,
  longitude: -122.7426,
  locationName: "RIDGEFIELD, WA",
  // Units: fahrenheit or celsius
  temperatureUnit: "fahrenheit",
  // Units: mph, kmh, ms, kn
  windSpeedUnit: "mph",
  // Timezone (IANA format)
  timezone: "America/Los_Angeles",
};

// Build the API URL
const apiUrl = `https://api.open-meteo.com/v1/forecast?latitude=${config.latitude}&longitude=${config.longitude}&current=temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,cloud_cover,wind_speed_10m,is_day&daily=weather_code,temperature_2m_max,temperature_2m_min&temperature_unit=${config.temperatureUnit}&wind_speed_unit=${config.windSpeedUnit}&timezone=${config.timezone}&forecast_days=1`;

// Shell command to fetch weather data
export const command = `curl -s "${apiUrl}"`;

// Refresh every 10 minutes (weather doesn't change that fast)
export const refreshFrequency = 600000;

// ============================================================================
// WMO Weather Code Mapping
// https://open-meteo.com/en/docs#api_documentation
// ============================================================================
const weatherCodes = {
  0: { description: "Clear Sky", icon: "☀️" },
  1: { description: "Mainly Clear", icon: "🌤️" },
  2: { description: "Partly Cloudy", icon: "⛅" },
  3: { description: "Overcast", icon: "☁️" },
  45: { description: "Fog", icon: "🌫️" },
  48: { description: "Depositing Rime Fog", icon: "🌫️" },
  51: { description: "Light Drizzle", icon: "🌧️" },
  53: { description: "Moderate Drizzle", icon: "🌧️" },
  55: { description: "Dense Drizzle", icon: "🌧️" },
  56: { description: "Light Freezing Drizzle", icon: "🌧️" },
  57: { description: "Dense Freezing Drizzle", icon: "🌧️" },
  61: { description: "Slight Rain", icon: "🌧️" },
  63: { description: "Moderate Rain", icon: "🌧️" },
  65: { description: "Heavy Rain", icon: "🌧️" },
  66: { description: "Light Freezing Rain", icon: "🌧️" },
  67: { description: "Heavy Freezing Rain", icon: "🌧️" },
  71: { description: "Slight Snow", icon: "🌨️" },
  73: { description: "Moderate Snow", icon: "🌨️" },
  75: { description: "Heavy Snow", icon: "❄️" },
  77: { description: "Snow Grains", icon: "❄️" },
  80: { description: "Slight Rain Showers", icon: "🌦️" },
  81: { description: "Moderate Rain Showers", icon: "🌦️" },
  82: { description: "Violent Rain Showers", icon: "⛈️" },
  85: { description: "Slight Snow Showers", icon: "🌨️" },
  86: { description: "Heavy Snow Showers", icon: "🌨️" },
  95: { description: "Thunderstorm", icon: "⛈️" },
  96: { description: "Thunderstorm w/ Slight Hail", icon: "⛈️" },
  99: { description: "Thunderstorm w/ Heavy Hail", icon: "⛈️" },
};

/**
 * Get weather info from WMO code
 * @param {number} code - WMO weather code
 * @param {boolean} isDay - Whether it's daytime
 * @returns {{ description: string, icon: string }}
 */
const getWeatherInfo = (code, isDay) => {
  const info = weatherCodes[code] || { description: "Unknown", icon: "❓" };
  // Swap sun for moon at night for clear/partly cloudy
  if (!isDay && code <= 2) {
    return {
      ...info,
      icon: code === 0 ? "🌙" : "🌙",
    };
  }
  return info;
};

// ============================================================================
// Styles
// ============================================================================
export const className = `
  right: 10px;
  top: 50px;

  * {
    box-sizing: border-box;
  }

  .weather-widget {
    background: ${theme.background};
    ${glowBox(theme.magenta)}
    padding: 20px 24px;
    font-family: ${synth.font};
    min-width: 280px;
  }

  .location {
    font-size: 18px;
    font-weight: bold;
    color: ${theme.orange};
    letter-spacing: 2px;
    text-transform: uppercase;
    text-shadow: ${labelGlow()};
    margin-bottom: 8px;
    border-bottom: 1px solid ${theme.magenta}33;
    padding-bottom: 8px;
  }

  .main-temp {
    display: flex;
    align-items: flex-start;
    gap: 16px;
    margin-bottom: 12px;
  }

  .temperature {
    font-size: 68px;
    font-weight: bold;
    color: ${theme.green};
    text-shadow: ${textGlow(theme.green)};
    line-height: 1;
  }

  .temp-unit {
    font-size: 28px;
    color: ${theme.green};
    opacity: 0.7;
  }

  .condition-block {
    display: flex;
    flex-direction: column;
    justify-content: center;
  }

  .condition-icon {
    font-size: 36px;
    line-height: 1;
  }

  .condition-text {
    font-size: 16px;
    color: ${theme.cyan};
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-top: 4px;
  }

  .feels-like {
    font-size: 18px;
    color: ${theme.magenta};
    margin-bottom: 16px;
    text-shadow: ${labelGlow(theme.magenta)};
  }

  .details {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
    border-top: 1px solid ${theme.magenta}33;
    padding-top: 12px;
  }

  .detail-item {
    display: flex;
    flex-direction: column;
  }

  .detail-label {
    font-size: 14px;
    color: ${theme.orange};
    text-transform: uppercase;
    letter-spacing: 1px;
    opacity: 0.8;
  }

  .detail-value {
    font-size: 22px;
    color: ${theme.cyan};
    text-shadow: ${textGlow(theme.cyan, theme.blue)};
  }

  .hi-lo {
    display: flex;
    gap: 12px;
  }

  .hi {
    color: ${theme.red};
    text-shadow: ${textGlow(theme.red, theme.orange)};
  }

  .lo {
    color: ${theme.blue};
    text-shadow: ${textGlow(theme.blue, theme.cyan)};
  }

  .error-message {
    color: ${theme.orange};
    font-size: 18px;
    padding: 10px;
  }

  .loading {
    color: ${theme.cyan};
    font-size: 18px;
    animation: pulse 1.5s ease-in-out infinite;
  }

  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.4; }
  }
`;

// ============================================================================
// Render
// ============================================================================
export const render = ({ output }) => {
  if (!output) {
    return (
      <div className="weather-widget">
        <div className="location">{config.locationName}</div>
        <span className="loading">Loading weather data...</span>
      </div>
    );
  }

  let data;
  try {
    data = JSON.parse(output);
  } catch (ex) {
    return (
      <div className="weather-widget">
        <div className="location">{config.locationName}</div>
        <span className="error-message">Error parsing weather data</span>
      </div>
    );
  }

  // Handle API errors
  if (data.error) {
    return (
      <div className="weather-widget">
        <div className="location">{config.locationName}</div>
        <span className="error-message">{data.reason || "API Error"}</span>
      </div>
    );
  }

  // Extract current conditions
  const current = data.current;
  const daily = data.daily;

  if (!current) {
    return (
      <div className="weather-widget">
        <div className="location">{config.locationName}</div>
        <span className="error-message">No weather data available</span>
      </div>
    );
  }

  const temperature = Math.round(current.temperature_2m);
  const feelsLike = Math.round(current.apparent_temperature);
  const humidity = current.relative_humidity_2m;
  const windSpeed = Math.round(current.wind_speed_10m);
  const weatherCode = current.weather_code;
  const isDay = current.is_day === 1;

  const weatherInfo = getWeatherInfo(weatherCode, isDay);

  // Daily high/low (first day in the array)
  const highTemp = daily?.temperature_2m_max?.[0] ? Math.round(daily.temperature_2m_max[0]) : null;
  const lowTemp = daily?.temperature_2m_min?.[0] ? Math.round(daily.temperature_2m_min[0]) : null;

  const tempUnit = config.temperatureUnit === "fahrenheit" ? "°F" : "°C";
  const windUnit = config.windSpeedUnit;

  return (
    <div className="weather-widget">
      <div className="location">{config.locationName}</div>

      <div className="main-temp">
        <div className="temperature">
          {temperature}
          <span className="temp-unit">{tempUnit}</span>
        </div>
        <div className="condition-block">
          <span className="condition-icon">{weatherInfo.icon}</span>
          <span className="condition-text">{weatherInfo.description}</span>
        </div>
      </div>

      <div className="feels-like">Feels like {feelsLike}{tempUnit}</div>

      <div className="details">
        <div className="detail-item">
          <span className="detail-label">Hi / Lo</span>
          <div className="hi-lo">
            {highTemp !== null && <span className="detail-value hi">{highTemp}°</span>}
            {lowTemp !== null && <span className="detail-value lo">{lowTemp}°</span>}
          </div>
        </div>

        <div className="detail-item">
          <span className="detail-label">Wind</span>
          <span className="detail-value">{windSpeed} {windUnit}</span>
        </div>

        <div className="detail-item">
          <span className="detail-label">Humidity</span>
          <span className="detail-value">{humidity}%</span>
        </div>

        <div className="detail-item">
          <span className="detail-label">Cloud Cover</span>
          <span className="detail-value">{current.cloud_cover}%</span>
        </div>
      </div>
    </div>
  );
};

