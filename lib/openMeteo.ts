import type { WeatherBundle, GeoResult } from '@/types/weather';

const FORECAST = 'https://api.open-meteo.com/v1/forecast';
const GEOCODE  = 'https://geocoding-api.open-meteo.com/v1/search';

export async function getWeather(lat: number, lon: number): Promise<WeatherBundle> {
  const url = new URL(FORECAST);
  url.searchParams.set('latitude',  String(lat));
  url.searchParams.set('longitude', String(lon));
  url.searchParams.set('current',
    'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,cloud_cover,pressure_msl,wind_speed_10m,wind_direction_10m,wind_gusts_10m,uv_index');
  url.searchParams.set('hourly',
    'temperature_2m,apparent_temperature,precipitation_probability,precipitation,weather_code,cloud_cover,wind_speed_10m,relative_humidity_2m,uv_index,visibility');
  url.searchParams.set('daily',
    'weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,daylight_duration,uv_index_max,precipitation_sum,precipitation_probability_max,wind_speed_10m_max,wind_gusts_10m_max');
  url.searchParams.set('timezone', 'auto');
  url.searchParams.set('forecast_days', '7');

  const res = await fetch(url.toString(), { next: { revalidate: 600 } });
  if (!res.ok) throw new Error(`Open-Meteo error: ${res.status}`);
  const j = await res.json();

  return {
    latitude: j.latitude,
    longitude: j.longitude,
    timezone: j.timezone,
    current: {
      time: j.current.time,
      temperature: j.current.temperature_2m,
      apparentTemperature: j.current.apparent_temperature,
      humidity: j.current.relative_humidity_2m,
      precipitation: j.current.precipitation,
      weatherCode: j.current.weather_code,
      cloudCover: j.current.cloud_cover,
      pressure: j.current.pressure_msl,
      windSpeed: j.current.wind_speed_10m,
      windDirection: j.current.wind_direction_10m,
      windGusts: j.current.wind_gusts_10m,
      visibility: (j.hourly?.visibility?.[0] ?? 10000) / 1000,
      uvIndex: j.current.uv_index ?? 0,
      isDay: !!j.current.is_day,
    },
    hourly: {
      time: j.hourly.time,
      temperature: j.hourly.temperature_2m,
      apparentTemperature: j.hourly.apparent_temperature,
      precipitationProbability: j.hourly.precipitation_probability,
      precipitation: j.hourly.precipitation,
      weatherCode: j.hourly.weather_code,
      cloudCover: j.hourly.cloud_cover,
      windSpeed: j.hourly.wind_speed_10m,
      humidity: j.hourly.relative_humidity_2m,
      uvIndex: j.hourly.uv_index,
      visibility: j.hourly.visibility,
    },
    daily: {
      time: j.daily.time,
      weatherCode: j.daily.weather_code,
      tempMax: j.daily.temperature_2m_max,
      tempMin: j.daily.temperature_2m_min,
      apparentMax: j.daily.apparent_temperature_max,
      apparentMin: j.daily.apparent_temperature_min,
      sunrise: j.daily.sunrise,
      sunset: j.daily.sunset,
      daylightDuration: j.daily.daylight_duration,
      uvIndexMax: j.daily.uv_index_max,
      precipitationSum: j.daily.precipitation_sum,
      precipitationProbabilityMax: j.daily.precipitation_probability_max,
      windSpeedMax: j.daily.wind_speed_10m_max,
      windGustsMax: j.daily.wind_gusts_10m_max,
    },
  };
}

export async function searchLocations(query: string): Promise<GeoResult[]> {
  if (!query || query.length < 2) return [];
  const url = new URL(GEOCODE);
  url.searchParams.set('name', query);
  url.searchParams.set('count', '8');
  url.searchParams.set('language', 'en');
  url.searchParams.set('format', 'json');
  const res = await fetch(url.toString(), { next: { revalidate: 3600 } });
  if (!res.ok) return [];
  const j = await res.json();
  return (j.results ?? []) as GeoResult[];
}

export async function getCurrentTemp(lat: number, lon: number): Promise<number | null> {
  try {
    const url = new URL(FORECAST);
    url.searchParams.set('latitude',  String(lat));
    url.searchParams.set('longitude', String(lon));
    url.searchParams.set('current', 'temperature_2m');
    const res = await fetch(url.toString());
    if (!res.ok) return null;
    const j = await res.json();
    return j.current?.temperature_2m ?? null;
  } catch { return null; }
}
