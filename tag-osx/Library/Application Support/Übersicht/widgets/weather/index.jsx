/**
 * Weather Widget for Übersicht
 * Uses Open-Meteo free API for weather data
 *
 * Theme: Retro Synth Matrix
 * Font: 3270 Nerd Font Mono
 */

import { theme, tahoe, synth, glowBox, textGlow, labelGlow } from "../shared/theme.jsx";
import { shouldRender, dockSlot, getLayout } from "../shared/layout.jsx";

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

// Build the API URLs
const weatherApiUrl = `https://api.open-meteo.com/v1/forecast?latitude=${config.latitude}&longitude=${config.longitude}&current=temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,cloud_cover,wind_speed_10m,is_day&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&temperature_unit=${config.temperatureUnit}&wind_speed_unit=${config.windSpeedUnit}&timezone=${config.timezone}&forecast_days=7`;

// NOAA NWS API for weather alerts
// https://www.weather.gov/documentation/services-web-api
const alertsApiUrl = `https://api.weather.gov/alerts/active?point=${config.latitude},${config.longitude}`;

// Shell command to fetch weather data AND NOAA alerts
// Combines both API responses into a single JSON object
export const command = `
  WEATHER=$(curl -s "${weatherApiUrl}")
  ALERTS=$(curl -s -H "User-Agent: (ubersicht-weather-widget, github.com/boneskull)" "${alertsApiUrl}")
  echo "{\\"weather\\": $WEATHER, \\"alerts\\": $ALERTS}"
`;

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
const getWeatherInfo = (code, isDay = true) => {
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

/**
 * Get short day name from ISO date string
 * @param {string} dateStr - ISO date string (YYYY-MM-DD)
 * @param {number} index - Day index (0 = today)
 * @returns {string} Short day name
 */
const getDayName = (dateStr, index) => {
  if (index === 0) return "TODAY";
  const date = new Date(dateStr + "T12:00:00");
  return date.toLocaleDateString("en-US", { weekday: "short" }).toUpperCase();
};

// ============================================================================
// Styles
// ============================================================================
export const className = `
  ${dockSlot(1)}

  * {
    box-sizing: border-box;
  }

  .weather-widget {
    background: ${theme.background};
    ${glowBox(theme.magenta)}
    padding: 20px 24px;
    font-family: ${synth.font};
    width: ${getLayout().leftColumnWidth}px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
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

  .forecast {
    margin-top: 16px;
    border-top: 1px solid ${theme.magenta}33;
    padding-top: 12px;
  }

  .forecast-title {
    font-size: 14px;
    color: ${theme.orange};
    text-transform: uppercase;
    letter-spacing: 2px;
    margin-bottom: 12px;
    text-shadow: ${labelGlow()};
  }

  .forecast-days {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .forecast-day {
    display: grid;
    grid-template-columns: 60px 36px 1fr 50px;
    align-items: center;
    gap: 8px;
    padding: 6px 0;
    border-bottom: 1px solid ${theme.magenta}22;
  }

  .forecast-day:last-child {
    border-bottom: none;
  }

  .forecast-day.today {
    background: ${theme.magenta}11;
    margin: 0 -8px;
    padding: 6px 8px;
    border-radius: 8px;
    border-bottom: none;
  }

  .day-name {
    font-size: 18px;
    color: ${theme.cyan};
    font-weight: bold;
    letter-spacing: 1px;
  }

  .forecast-day.today .day-name {
    color: ${theme.green};
    text-shadow: ${textGlow(theme.green)};
  }

  .day-icon {
    font-size: 24px;
    text-align: center;
  }

  .day-temps {
    display: flex;
    gap: 8px;
    justify-content: flex-start;
  }

  .day-hi {
    font-size: 22px;
    color: ${theme.red};
    min-width: 35px;
  }

  .day-lo {
    font-size: 22px;
    color: ${theme.blue};
    opacity: 0.8;
    min-width: 35px;
  }

  .day-precip {
    font-size: 18px;
    color: ${theme.cyan};
    text-align: right;
    opacity: 0.9;
  }

  .day-precip.has-precip {
    color: ${theme.blue};
    text-shadow: ${textGlow(theme.blue, theme.cyan)};
  }

  .alerts {
    margin-bottom: 16px;
  }

  .alert {
    background: ${theme.red}22;
    border: 2px solid ${theme.red};
    border-radius: 12px;
    padding: 12px;
    margin-bottom: 8px;
  }

  .alert:last-child {
    margin-bottom: 0;
  }

  .alert-header {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 6px;
  }

  .alert-icon {
    font-size: 20px;
  }

  .alert-event {
    font-size: 16px;
    font-weight: bold;
    color: ${theme.red};
    text-transform: uppercase;
    letter-spacing: 1px;
    text-shadow: ${textGlow(theme.red, theme.orange)};
  }

  .alert-severity {
    font-size: 12px;
    color: ${theme.orange};
    background: ${theme.orange}33;
    padding: 2px 6px;
    border-radius: 4px;
    margin-left: auto;
  }

  .alert-headline {
    font-size: 14px;
    color: ${theme.yellow};
    line-height: 1.3;
  }

  .alert-expires {
    font-size: 12px;
    color: ${theme.cyan};
    margin-top: 6px;
    opacity: 0.8;
  }

  .alert.warning {
    border-color: ${theme.orange};
    background: ${theme.orange}22;
  }

  .alert.warning .alert-event {
    color: ${theme.orange};
    text-shadow: ${textGlow(theme.orange, theme.yellow)};
  }

  .alert.watch {
    border-color: ${theme.yellow};
    background: ${theme.yellow}22;
  }

  .alert.watch .alert-event {
    color: ${theme.yellow};
    text-shadow: ${textGlow(theme.yellow, theme.orange)};
  }

  .alert.advisory {
    border-color: ${theme.cyan};
    background: ${theme.cyan}22;
  }

  .alert.advisory .alert-event {
    color: ${theme.cyan};
    text-shadow: ${textGlow(theme.cyan, theme.blue)};
  }
`;

/**
 * Get alert severity class
 * @param {string} severity - Alert severity from NWS
 * @returns {string} CSS class name
 */
const getAlertClass = (severity) => {
  switch (severity?.toLowerCase()) {
    case "extreme":
    case "severe":
      return "alert"; // Red (default)
    case "moderate":
      return "alert warning"; // Orange
    case "minor":
      return "alert watch"; // Yellow
    default:
      return "alert advisory"; // Cyan
  }
};

/**
 * Get alert icon based on event type
 * @param {string} event - Alert event type
 * @returns {string} Emoji icon
 */
const getAlertIcon = (event) => {
  const eventLower = event?.toLowerCase() || "";
  if (eventLower.includes("tornado")) return "🌪️";
  if (eventLower.includes("hurricane") || eventLower.includes("tropical")) return "🌀";
  if (eventLower.includes("flood")) return "🌊";
  if (eventLower.includes("thunder") || eventLower.includes("storm")) return "⛈️";
  if (eventLower.includes("winter") || eventLower.includes("snow") || eventLower.includes("ice") || eventLower.includes("freeze")) return "❄️";
  if (eventLower.includes("wind")) return "💨";
  if (eventLower.includes("fire")) return "🔥";
  if (eventLower.includes("heat")) return "🌡️";
  if (eventLower.includes("fog")) return "🌫️";
  return "⚠️";
};

/**
 * Format expiration time
 * @param {string} expires - ISO date string
 * @returns {string} Formatted expiration
 */
const formatExpires = (expires) => {
  if (!expires) return "";
  const date = new Date(expires);
  return `Expires: ${date.toLocaleDateString("en-US", { weekday: "short" })} ${date.toLocaleTimeString("en-US", { hour: "numeric", minute: "2-digit" })}`;
};

// ============================================================================
// Render
// ============================================================================
export const render = ({ output }) => {
  if (!shouldRender()) return null;

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

  // Extract weather and alerts from combined response
  const weatherData = data.weather || data; // Fallback if not wrapped
  const alertsData = data.alerts;

  // Handle weather API errors
  if (weatherData.error) {
    return (
      <div className="weather-widget">
        <div className="location">{config.locationName}</div>
        <span className="error-message">{weatherData.reason || "API Error"}</span>
      </div>
    );
  }

  // Extract current conditions
  const current = weatherData.current;
  const daily = weatherData.daily;

  // Extract active alerts (if any)
  const alerts = alertsData?.features?.slice(0, 3) || []; // Limit to 3 alerts

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

      {alerts.length > 0 && (
        <div className="alerts">
          {alerts.map((alert, i) => {
            const props = alert.properties;
            return (
              <div key={i} className={getAlertClass(props.severity)}>
                <div className="alert-header">
                  <span className="alert-icon">{getAlertIcon(props.event)}</span>
                  <span className="alert-event">{props.event}</span>
                  {props.severity && (
                    <span className="alert-severity">{props.severity}</span>
                  )}
                </div>
                {props.headline && (
                  <div className="alert-headline">{props.headline}</div>
                )}
                {props.expires && (
                  <div className="alert-expires">{formatExpires(props.expires)}</div>
                )}
              </div>
            );
          })}
        </div>
      )}

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

      {daily?.time?.length > 0 && (
        <div className="forecast">
          <div className="forecast-title">7-Day Forecast</div>
          <div className="forecast-days">
            {daily.time.map((date, i) => {
              const dayWeather = getWeatherInfo(daily.weather_code[i]);
              const hi = Math.round(daily.temperature_2m_max[i]);
              const lo = Math.round(daily.temperature_2m_min[i]);
              const precip = daily.precipitation_probability_max?.[i] ?? 0;
              const isToday = i === 0;

              return (
                <div key={date} className={`forecast-day ${isToday ? "today" : ""}`}>
                  <span className="day-name">{getDayName(date, i)}</span>
                  <span className="day-icon">{dayWeather.icon}</span>
                  <div className="day-temps">
                    <span className="day-hi">{hi}°</span>
                    <span className="day-lo">{lo}°</span>
                  </div>
                  <span className={`day-precip ${precip > 20 ? "has-precip" : ""}`}>
                    {precip}%
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
};

