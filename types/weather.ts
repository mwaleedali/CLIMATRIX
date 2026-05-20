export interface CurrentWeather {
  time: string;
  temperature: number;
  apparentTemperature: number;
  humidity: number;
  precipitation: number;
  weatherCode: number;
  cloudCover: number;
  pressure: number;
  windSpeed: number;
  windDirection: number;
  windGusts: number;
  visibility: number;
  uvIndex: number;
  isDay: boolean;
}

export interface HourlyData {
  time: string[];
  temperature: number[];
  apparentTemperature: number[];
  precipitationProbability: number[];
  precipitation: number[];
  weatherCode: number[];
  cloudCover: number[];
  windSpeed: number[];
  humidity: number[];
  uvIndex: number[];
  visibility: number[];
}

export interface DailyData {
  time: string[];
  weatherCode: number[];
  tempMax: number[];
  tempMin: number[];
  apparentMax: number[];
  apparentMin: number[];
  sunrise: string[];
  sunset: string[];
  daylightDuration: number[];
  uvIndexMax: number[];
  precipitationSum: number[];
  precipitationProbabilityMax: number[];
  windSpeedMax: number[];
  windGustsMax: number[];
}

export interface WeatherBundle {
  latitude: number;
  longitude: number;
  timezone: string;
  current: CurrentWeather;
  hourly: HourlyData;
  daily: DailyData;
}

export interface GeoResult {
  id: number;
  name: string;
  latitude: number;
  longitude: number;
  country: string;
  country_code: string;
  admin1?: string;
  timezone?: string;
  population?: number;
}

export type LayerKey =
  | 'temperature' | 'precipitation' | 'wind'
  | 'clouds' | 'humidity' | 'pressure' | 'uv';

export interface ScoreResult {
  score: number;
  label: 'Excellent' | 'Good' | 'Fair' | 'Poor' | 'Bad';
  color: string;
  reasons: string[];
}
