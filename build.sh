#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# CLIMATRIX — build.sh
# Writes every source file. Run AFTER setup.sh.
# ──────────────────────────────────────────────────────────────────────────────
set -e

CYAN='\033[0;36m'; GREEN='\033[0;32m'; PURPLE='\033[0;35m'; YELLOW='\033[1;33m'; RESET='\033[0m'
log() { echo -e "${CYAN}▸${RESET} $1"; }
ok()  { echo -e "${GREEN}✓${RESET} $1"; }

# ════════════════════════════════════════════════════════════════════════════
# CONFIG FILES
# ════════════════════════════════════════════════════════════════════════════

log "Writing config files…"

cat << 'CLIMATRIX_EOF' > package.json
{
  "name": "climatrix",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "clsx": "^2.1.1",
    "framer-motion": "^11.11.0",
    "lucide-react": "^0.453.0",
    "maplibre-gl": "^4.7.1",
    "next": "14.2.15",
    "next-themes": "^0.3.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "recharts": "^2.13.0",
    "tailwind-merge": "^2.5.4",
    "zustand": "^4.5.5"
  },
  "devDependencies": {
    "@types/node": "^20.16.10",
    "@types/react": "^18.3.11",
    "@types/react-dom": "^18.3.0",
    "autoprefixer": "^10.4.20",
    "eslint": "^8.57.1",
    "eslint-config-next": "14.2.15",
    "postcss": "^8.4.47",
    "tailwindcss": "^3.4.13",
    "typescript": "^5.6.2"
  }
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": false,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > next.config.mjs
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: { remotePatterns: [{ protocol: 'https', hostname: '**' }] },
};
export default nextConfig;
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > postcss.config.mjs
export default {
  plugins: { tailwindcss: {}, autoprefixer: {} },
};
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > tailwind.config.ts
import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: 'class',
  content: ['./app/**/*.{ts,tsx}', './components/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        brand: {
          cyan:   '#22D3EE',
          purple: '#A855F7',
          pink:   '#EC4899',
        },
        surface: {
          base:     'var(--surface-base)',
          raised:   'var(--surface-raised)',
          elevated: 'var(--surface-elevated)',
          border:   'var(--surface-border)',
          hover:    'var(--surface-hover)',
        },
        ink: {
          primary:   'var(--ink-primary)',
          secondary: 'var(--ink-secondary)',
          muted:     'var(--ink-muted)',
        },
      },
      fontFamily: {
        sans: ['var(--font-inter)', 'system-ui', 'sans-serif'],
        mono: ['var(--font-jetbrains-mono)', 'ui-monospace', 'monospace'],
      },
      backgroundImage: {
        'brand-gradient': 'linear-gradient(135deg, #22D3EE 0%, #A855F7 50%, #EC4899 100%)',
        'brand-radial':   'radial-gradient(circle at top left, rgba(34,211,238,0.15), transparent 50%), radial-gradient(circle at bottom right, rgba(236,72,153,0.12), transparent 50%)',
      },
      boxShadow: {
        'glass-dark':  '0 8px 32px rgba(0,0,0,0.4)',
        'glass-light': '0 8px 32px rgba(0,0,0,0.08)',
        'brand-glow':  '0 0 40px -10px rgba(168,85,247,0.5)',
      },
      animation: {
        'pulse-slow':  'pulse 3s cubic-bezier(0.4,0,0.6,1) infinite',
        'fade-in':     'fadeIn 0.4s ease-out',
        'slide-up':    'slideUp 0.5s cubic-bezier(0.22,1,0.36,1)',
        'shimmer':     'shimmer 2.4s linear infinite',
        'gradient-x':  'gradientX 8s ease infinite',
      },
      keyframes: {
        fadeIn:    { '0%': { opacity: '0' }, '100%': { opacity: '1' } },
        slideUp:   { '0%': { opacity: '0', transform: 'translateY(8px)' }, '100%': { opacity: '1', transform: 'translateY(0)' } },
        shimmer:   { '0%': { backgroundPosition: '-200% 0' }, '100%': { backgroundPosition: '200% 0' } },
        gradientX: { '0%,100%': { backgroundPosition: '0% 50%' }, '50%': { backgroundPosition: '100% 50%' } },
      },
    },
  },
  plugins: [],
};
export default config;
CLIMATRIX_EOF

ok "Config files written"

# ════════════════════════════════════════════════════════════════════════════
# TYPES
# ════════════════════════════════════════════════════════════════════════════

log "Writing types…"

cat << 'CLIMATRIX_EOF' > types/weather.ts
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
CLIMATRIX_EOF

ok "Types written"

# ════════════════════════════════════════════════════════════════════════════
# LIB
# ════════════════════════════════════════════════════════════════════════════

log "Writing lib/…"

cat << 'CLIMATRIX_EOF' > lib/utils.ts
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function debounce<T extends (...args: never[]) => unknown>(fn: T, ms: number) {
  let t: ReturnType<typeof setTimeout> | null = null;
  return (...args: Parameters<T>) => {
    if (t) clearTimeout(t);
    t = setTimeout(() => fn(...args), ms);
  };
}

export function clamp(n: number, min: number, max: number) {
  return Math.max(min, Math.min(max, n));
}

export function countryFlag(code?: string) {
  if (!code || code.length !== 2) return '🌐';
  return code
    .toUpperCase()
    .replace(/./g, (c) => String.fromCodePoint(127397 + c.charCodeAt(0)));
}

export function formatTime(iso: string, tz?: string) {
  try {
    return new Date(iso).toLocaleTimeString('en-US', {
      hour: '2-digit', minute: '2-digit', hour12: false, timeZone: tz,
    });
  } catch { return iso; }
}

export function formatDay(iso: string) {
  return new Date(iso).toLocaleDateString('en-US', { weekday: 'short' });
}

export function durationFromSeconds(s: number) {
  const h = Math.floor(s / 3600);
  const m = Math.floor((s % 3600) / 60);
  return `${h}h ${m}m`;
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > lib/units.ts
export const cToF = (c: number) => (c * 9) / 5 + 32;
export const kmhToMph = (k: number) => k * 0.621371;
export const hpaToInHg = (h: number) => h * 0.02953;

export function formatTemp(c: number, unit: 'C' | 'F') {
  const v = unit === 'C' ? c : cToF(c);
  return `${Math.round(v)}°`;
}

export function formatWind(kmh: number, unit: 'kmh' | 'mph') {
  const v = unit === 'kmh' ? kmh : kmhToMph(kmh);
  return `${Math.round(v)} ${unit === 'kmh' ? 'km/h' : 'mph'}`;
}

export function formatPressure(hpa: number, unit: 'hPa' | 'inHg') {
  return unit === 'hPa' ? `${Math.round(hpa)} hPa` : `${hpaToInHg(hpa).toFixed(2)} inHg`;
}

export function uvRisk(uv: number) {
  if (uv < 3)  return 'Low';
  if (uv < 6)  return 'Moderate';
  if (uv < 8)  return 'High';
  if (uv < 11) return 'Very High';
  return 'Extreme';
}

export function windDirLabel(deg: number) {
  const dirs = ['N','NE','E','SE','S','SW','W','NW'];
  return dirs[Math.round(deg / 45) % 8];
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > lib/weatherCodes.ts
import {
  Sun, Cloud, CloudSun, CloudFog, CloudDrizzle, CloudRain, CloudSnow,
  CloudLightning, CloudHail, Snowflake, type LucideIcon,
} from 'lucide-react';

export interface WeatherCodeInfo {
  label: string;
  Icon: LucideIcon;
  gradient: string;
}

const C: Record<number, WeatherCodeInfo> = {
  0:  { label: 'Clear sky',           Icon: Sun,            gradient: 'from-amber-300/40 to-orange-500/20' },
  1:  { label: 'Mainly clear',        Icon: Sun,            gradient: 'from-amber-200/30 to-sky-400/20' },
  2:  { label: 'Partly cloudy',       Icon: CloudSun,       gradient: 'from-sky-300/30 to-slate-400/20' },
  3:  { label: 'Overcast',            Icon: Cloud,          gradient: 'from-slate-400/30 to-slate-600/20' },
  45: { label: 'Fog',                 Icon: CloudFog,       gradient: 'from-slate-300/40 to-slate-500/20' },
  48: { label: 'Rime fog',            Icon: CloudFog,       gradient: 'from-slate-300/40 to-slate-500/20' },
  51: { label: 'Light drizzle',       Icon: CloudDrizzle,   gradient: 'from-sky-300/30 to-sky-600/20' },
  53: { label: 'Drizzle',             Icon: CloudDrizzle,   gradient: 'from-sky-400/30 to-sky-600/20' },
  55: { label: 'Heavy drizzle',       Icon: CloudDrizzle,   gradient: 'from-sky-500/40 to-sky-700/20' },
  56: { label: 'Freezing drizzle',    Icon: CloudDrizzle,   gradient: 'from-cyan-300/40 to-cyan-600/20' },
  57: { label: 'Freezing drizzle',    Icon: CloudDrizzle,   gradient: 'from-cyan-300/40 to-cyan-600/20' },
  61: { label: 'Light rain',          Icon: CloudRain,      gradient: 'from-blue-400/30 to-blue-600/20' },
  63: { label: 'Rain',                Icon: CloudRain,      gradient: 'from-blue-500/40 to-blue-700/20' },
  65: { label: 'Heavy rain',          Icon: CloudRain,      gradient: 'from-blue-600/50 to-indigo-700/30' },
  66: { label: 'Freezing rain',       Icon: CloudRain,      gradient: 'from-cyan-400/40 to-blue-700/20' },
  67: { label: 'Freezing rain',       Icon: CloudRain,      gradient: 'from-cyan-400/40 to-blue-700/20' },
  71: { label: 'Light snow',          Icon: CloudSnow,      gradient: 'from-sky-200/30 to-slate-400/20' },
  73: { label: 'Snow',                Icon: Snowflake,      gradient: 'from-sky-100/40 to-slate-300/20' },
  75: { label: 'Heavy snow',          Icon: Snowflake,      gradient: 'from-white/40 to-slate-300/30' },
  77: { label: 'Snow grains',         Icon: CloudSnow,      gradient: 'from-sky-200/30 to-slate-400/20' },
  80: { label: 'Rain showers',        Icon: CloudRain,      gradient: 'from-blue-400/30 to-blue-700/20' },
  81: { label: 'Heavy showers',       Icon: CloudRain,      gradient: 'from-blue-500/40 to-indigo-700/20' },
  82: { label: 'Violent showers',     Icon: CloudRain,      gradient: 'from-indigo-600/50 to-purple-700/30' },
  85: { label: 'Snow showers',        Icon: CloudSnow,      gradient: 'from-sky-200/30 to-slate-400/20' },
  86: { label: 'Heavy snow showers',  Icon: Snowflake,      gradient: 'from-sky-100/40 to-slate-300/20' },
  95: { label: 'Thunderstorm',        Icon: CloudLightning, gradient: 'from-purple-500/40 to-indigo-700/30' },
  96: { label: 'Thunderstorm + hail', Icon: CloudHail,      gradient: 'from-purple-500/40 to-pink-600/30' },
  99: { label: 'Severe thunderstorm', Icon: CloudHail,      gradient: 'from-pink-600/50 to-purple-800/30' },
};

export function describeWeather(code: number): WeatherCodeInfo {
  return C[code] ?? { label: 'Unknown', Icon: Cloud, gradient: 'from-slate-400/30 to-slate-600/20' };
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > lib/openMeteo.ts
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
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > lib/geocoding.ts
export { searchLocations } from './openMeteo';
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > lib/calculations.ts
export function heatIndex(tempC: number, humidity: number): number {
  const T = (tempC * 9) / 5 + 32;
  const R = humidity;
  if (T < 80) return tempC;
  const HI =
    -42.379 +
    2.04901523 * T +
    10.14333127 * R -
    0.22475541 * T * R -
    6.83783e-3 * T * T -
    5.481717e-2 * R * R +
    1.22874e-3 * T * T * R +
    8.5282e-4 * T * R * R -
    1.99e-6 * T * T * R * R;
  return ((HI - 32) * 5) / 9;
}

export function windChill(tempC: number, windKmh: number): number {
  if (tempC >= 10 || windKmh <= 4.8) return tempC;
  const v = Math.pow(windKmh, 0.16);
  return 13.12 + 0.6215 * tempC - 11.37 * v + 0.3965 * tempC * v;
}

export function dewPoint(tempC: number, humidity: number): number {
  const a = 17.27, b = 237.7;
  const alpha = (a * tempC) / (b + tempC) + Math.log(Math.max(humidity, 1) / 100);
  return (b * alpha) / (a - alpha);
}

export function beaufort(windKmh: number): { scale: number; label: string } {
  const tiers: [number, string][] = [
    [1,   'Calm'],         [5,   'Light air'],
    [11,  'Light breeze'], [19,  'Gentle breeze'],
    [28,  'Moderate'],     [38,  'Fresh breeze'],
    [49,  'Strong breeze'],[61,  'Near gale'],
    [74,  'Gale'],         [88,  'Strong gale'],
    [102, 'Storm'],        [117, 'Violent storm'],
  ];
  for (let i = 0; i < tiers.length; i++) if (windKmh < tiers[i][0]) return { scale: i, label: tiers[i][1] };
  return { scale: 12, label: 'Hurricane' };
}

export function moonPhase(date: Date): { phase: string; illumination: number; emoji: string } {
  const y = date.getUTCFullYear();
  const m = date.getUTCMonth() + 1;
  const d = date.getUTCDate();
  let r = y % 100;
  r %= 19;
  if (r > 9) r -= 19;
  r = ((r * 11) % 30) + (m < 3 ? m + 2 : m) + d;
  if (m < 3) r += 2;
  r -= y < 2000 ? 4 : 8.3;
  let phaseAge = (((r + 30) % 30) / 29.53);
  if (phaseAge < 0) phaseAge += 1;

  const labels = ['New Moon','Waxing Crescent','First Quarter','Waxing Gibbous','Full Moon','Waning Gibbous','Last Quarter','Waning Crescent'];
  const emojis = ['🌑','🌒','🌓','🌔','🌕','🌖','🌗','🌘'];
  const idx = Math.floor(phaseAge * 8) % 8;
  const illum = (1 - Math.cos(phaseAge * 2 * Math.PI)) / 2;
  return { phase: labels[idx], illumination: Math.round(illum * 100), emoji: emojis[idx] };
}

export function feelsLike(tempC: number, humidity: number, windKmh: number): number {
  if (tempC >= 27 && humidity >= 40) return heatIndex(tempC, humidity);
  if (tempC <= 10 && windKmh > 4.8) return windChill(tempC, windKmh);
  return tempC;
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > lib/scores.ts
import type { WeatherBundle, ScoreResult } from '@/types/weather';
import { feelsLike, moonPhase } from './calculations';
import { clamp } from './utils';

const labelFor = (s: number): ScoreResult['label'] =>
  s >= 80 ? 'Excellent' : s >= 60 ? 'Good' : s >= 40 ? 'Fair' : s >= 20 ? 'Poor' : 'Bad';

const colorFor = (s: number): string =>
  s >= 80 ? '#10B981' : s >= 60 ? '#A3E635' : s >= 40 ? '#F59E0B' : s >= 20 ? '#F97316' : '#EF4444';

const wrap = (raw: number, reasons: string[]): ScoreResult => {
  const score = Math.round(clamp(raw, 0, 100));
  return { score, label: labelFor(score), color: colorFor(score), reasons };
};

function rangeScore(v: number, lo: number, hi: number, falloff = 1): number {
  if (v >= lo && v <= hi) return 1;
  const dist = v < lo ? lo - v : v - hi;
  return clamp(1 - dist / (falloff * (hi - lo || 1)), 0, 1);
}

export function cricketScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const next6h = (w.hourly.precipitationProbability ?? []).slice(0, 6);
  const pop = next6h.length ? Math.max(...next6h) : 0;
  const reasons: string[] = [];

  const temp = rangeScore(cur.temperature, 18, 32, 1) * 30;
  if (cur.temperature >= 18 && cur.temperature <= 32) reasons.push('Ideal playing temperature');
  else reasons.push(cur.temperature > 32 ? 'Too hot for comfort' : 'Chilly for play');

  const dry = pop < 20 ? 30 : pop < 50 ? 15 : 0;
  if (pop < 20) reasons.push('Dry skies ahead');
  else if (pop >= 50) reasons.push('Rain likely');

  const wind = cur.windSpeed < 25 ? 20 : cur.windSpeed < 40 ? 10 : 0;
  if (cur.windSpeed < 25) reasons.push('Light winds');

  const hum = cur.humidity < 70 ? 10 : 5;
  const vis = cur.visibility > 5 ? 10 : 5;

  return wrap(temp + dry + wind + hum + vis, reasons.slice(0, 3));
}

export function solarScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const dailyUv = w.daily.uvIndexMax?.[0] ?? 0;
  const daylight = w.daily.daylightDuration?.[0] ?? 0;
  const reasons: string[] = [];

  const cloudPart = ((100 - cur.cloudCover) / 100) * 50;
  if (cur.cloudCover < 30) reasons.push('Clear skies');
  else if (cur.cloudCover > 70) reasons.push('Heavy cloud cover');

  const uvPart = clamp(dailyUv / 10, 0, 1) * 30;
  if (dailyUv >= 6) reasons.push('Strong sunlight');

  const dlPart = clamp(daylight / 50400, 0, 1) * 20;
  if (daylight > 43200) reasons.push('Long daylight hours');

  return wrap(cloudPart + uvPart + dlPart, reasons.slice(0, 3));
}

export function runningScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const next6h = (w.hourly.precipitationProbability ?? []).slice(0, 6);
  const pop = next6h.length ? Math.max(...next6h) : 0;
  const feels = feelsLike(cur.temperature, cur.humidity, cur.windSpeed);
  const reasons: string[] = [];

  const temp = rangeScore(feels, 10, 25, 1.2) * 40;
  if (feels >= 10 && feels <= 25) reasons.push('Perfect running temperature');
  else reasons.push(feels < 10 ? 'A bit cold' : 'Quite warm');

  const dry = pop < 20 ? 25 : pop < 50 ? 12 : 0;
  if (pop < 20) reasons.push('Low rain chance');

  const hum = cur.humidity < 75 ? 15 : 5;
  const uv = cur.uvIndex < 6 ? 10 : 4;
  const wind = cur.windSpeed < 30 ? 10 : 3;
  if (cur.windSpeed > 30) reasons.push('Gusty conditions');

  return wrap(temp + dry + hum + uv + wind, reasons.slice(0, 3));
}

export function farmingScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const precip = w.daily.precipitationSum?.[0] ?? 0;
  const reasons: string[] = [];

  const temp = rangeScore(cur.temperature, 15, 28, 1) * 30;
  if (cur.temperature >= 15 && cur.temperature <= 28) reasons.push('Good growing temperature');

  const precipPart = precip >= 1 && precip <= 10 ? 30 : precip < 1 ? 12 : precip > 25 ? 0 : 18;
  if (precip >= 1 && precip <= 10) reasons.push('Balanced rainfall');
  else if (precip > 25) reasons.push('Flood risk');
  else if (precip < 1) reasons.push('Dry conditions');

  const wind = cur.windSpeed < 25 ? 20 : 10;
  const hum = cur.humidity >= 50 && cur.humidity <= 80 ? 20 : 8;

  return wrap(temp + precipPart + wind + hum, reasons.slice(0, 3));
}

export function picnicScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const next6h = (w.hourly.precipitationProbability ?? []).slice(0, 6);
  const pop = next6h.length ? Math.max(...next6h) : 0;
  const reasons: string[] = [];

  const temp = rangeScore(cur.temperature, 18, 28, 1) * 30;
  if (cur.temperature >= 18 && cur.temperature <= 28) reasons.push('Pleasant temperature');

  const dry = pop < 15 ? 30 : pop < 40 ? 15 : 0;
  if (pop < 15) reasons.push('Very low rain chance');

  const wind = cur.windSpeed < 20 ? 20 : 8;
  const cloud = cur.cloudCover < 60 ? 10 : 4;
  const uv = cur.uvIndex < 8 ? 10 : 4;
  if (cur.cloudCover < 30) reasons.push('Sunny skies');

  return wrap(temp + dry + wind + cloud + uv, reasons.slice(0, 3));
}

export function stargazingScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const moon = moonPhase(new Date());
  const reasons: string[] = [];

  const cloudPart = ((100 - cur.cloudCover) / 100) * 50;
  if (cur.cloudCover < 20) reasons.push('Crystal clear skies');
  else if (cur.cloudCover > 60) reasons.push('Cloudy night');

  const moonPart = ((100 - moon.illumination) / 100) * 30;
  if (moon.illumination < 30) reasons.push('Dark moon — great visibility');
  else if (moon.illumination > 80) reasons.push('Bright moon washes out stars');

  const humPart = ((100 - cur.humidity) / 100) * 20;
  if (cur.humidity < 50) reasons.push('Low humidity');

  return wrap(cloudPart + moonPart + humPart, reasons.slice(0, 3));
}

export interface ScoredActivity {
  key: string;
  emoji: string;
  name: string;
  result: ScoreResult;
}

export function computeAllScores(w: WeatherBundle): ScoredActivity[] {
  return [
    { key: 'cricket',    emoji: '🏏', name: 'Cricket',    result: cricketScore(w) },
    { key: 'solar',      emoji: '☀️', name: 'Solar Power',result: solarScore(w) },
    { key: 'running',    emoji: '🏃', name: 'Running',    result: runningScore(w) },
    { key: 'farming',    emoji: '🌾', name: 'Farming',    result: farmingScore(w) },
    { key: 'picnic',     emoji: '🧺', name: 'Picnic',     result: picnicScore(w) },
    { key: 'stargazing', emoji: '🔭', name: 'Stargazing', result: stargazingScore(w) },
  ];
}
CLIMATRIX_EOF

ok "lib/ written"

# ════════════════════════════════════════════════════════════════════════════
# STORE
# ════════════════════════════════════════════════════════════════════════════

log "Writing store…"

cat << 'CLIMATRIX_EOF' > store/useWeatherStore.ts
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import type { LayerKey } from '@/types/weather';

export interface Favorite { lat: number; lon: number; name: string; country: string; }
export interface SelectedLocation { lat: number; lon: number; name?: string; country?: string; }

interface UnitState { temperature: 'C' | 'F'; wind: 'kmh' | 'mph'; pressure: 'hPa' | 'inHg'; }

interface WeatherStore {
  selectedLocation: SelectedLocation | null;
  activeLayer: LayerKey;
  mapStyle: 'dark' | 'light';
  units: UnitState;
  favorites: Favorite[];
  recentSearches: Favorite[];

  setLocation: (l: SelectedLocation | null) => void;
  setActiveLayer: (l: LayerKey) => void;
  setMapStyle: (s: 'dark' | 'light') => void;
  toggleUnit: (k: keyof UnitState) => void;
  addFavorite: (f: Favorite) => void;
  removeFavorite: (lat: number, lon: number) => void;
  isFavorite: (lat: number, lon: number) => boolean;
  pushRecent: (f: Favorite) => void;
}

export const useWeatherStore = create<WeatherStore>()(
  persist(
    (set, get) => ({
      selectedLocation: null,
      activeLayer: 'temperature',
      mapStyle: 'dark',
      units: { temperature: 'C', wind: 'kmh', pressure: 'hPa' },
      favorites: [],
      recentSearches: [],

      setLocation: (l) => set({ selectedLocation: l }),
      setActiveLayer: (l) => set({ activeLayer: l }),
      setMapStyle: (s) => set({ mapStyle: s }),
      toggleUnit: (k) =>
        set((s) => ({
          units: {
            ...s.units,
            [k]:
              k === 'temperature' ? (s.units.temperature === 'C' ? 'F' : 'C') :
              k === 'wind'        ? (s.units.wind        === 'kmh' ? 'mph' : 'kmh') :
                                    (s.units.pressure    === 'hPa' ? 'inHg' : 'hPa'),
          },
        })),
      addFavorite: (f) =>
        set((s) =>
          s.favorites.find((x) => x.lat === f.lat && x.lon === f.lon)
            ? s
            : { favorites: [...s.favorites, f] }
        ),
      removeFavorite: (lat, lon) =>
        set((s) => ({ favorites: s.favorites.filter((x) => x.lat !== lat || x.lon !== lon) })),
      isFavorite: (lat, lon) => !!get().favorites.find((f) => f.lat === lat && f.lon === lon),
      pushRecent: (f) =>
        set((s) => {
          const filtered = s.recentSearches.filter((x) => x.lat !== f.lat || x.lon !== f.lon);
          return { recentSearches: [f, ...filtered].slice(0, 5) };
        }),
    }),
    {
      name: 'climatrix:store',
      storage: createJSONStorage(() => (typeof window !== 'undefined' ? localStorage : (undefined as never))),
      partialize: (s) => ({
        units: s.units, favorites: s.favorites, mapStyle: s.mapStyle, recentSearches: s.recentSearches,
      }),
    }
  )
);
CLIMATRIX_EOF

ok "store/ written"

# ════════════════════════════════════════════════════════════════════════════
# APP — GLOBALS / LAYOUT / PROVIDERS
# ════════════════════════════════════════════════════════════════════════════

log "Writing app/globals.css, layout, providers…"

cat << 'CLIMATRIX_EOF' > app/globals.css
@import 'maplibre-gl/dist/maplibre-gl.css';
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --surface-base:     #FAFAFB;
  --surface-raised:   #FFFFFF;
  --surface-elevated: #FFFFFF;
  --surface-border:   #E5E5EA;
  --surface-hover:    #F4F4F6;
  --ink-primary:      #0A0A0F;
  --ink-secondary:    #52525B;
  --ink-muted:        #71717A;
}

.dark {
  --surface-base:     #07070A;
  --surface-raised:   #0F0F14;
  --surface-elevated: #16161D;
  --surface-border:   #1F1F28;
  --surface-hover:    #1A1A22;
  --ink-primary:      #FAFAFA;
  --ink-secondary:    #A1A1AA;
  --ink-muted:        #71717A;
}

* { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }
html, body { background: var(--surface-base); color: var(--ink-primary); }

::selection { background: rgba(168,85,247,0.30); color: inherit; }

.scroll-thin::-webkit-scrollbar { width: 6px; height: 6px; }
.scroll-thin::-webkit-scrollbar-thumb { background: var(--surface-border); border-radius: 999px; }
.scroll-thin::-webkit-scrollbar-thumb:hover { background: #A855F7; }
.scroll-thin::-webkit-scrollbar-track { background: transparent; }

.maplibregl-ctrl-attrib { background: rgba(0,0,0,0.4) !important; color: #fff !important; }
.maplibregl-ctrl-attrib a { color: #fff !important; }
.dark .maplibregl-canvas { filter: contrast(1.02) brightness(0.95); }

.brand-grid {
  background-image:
    linear-gradient(var(--surface-border) 1px, transparent 1px),
    linear-gradient(90deg, var(--surface-border) 1px, transparent 1px);
  background-size: 32px 32px;
}

.text-gradient {
  background: linear-gradient(135deg, #22D3EE 0%, #A855F7 50%, #EC4899 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.gradient-border {
  position: relative;
  background: var(--surface-raised);
}
.gradient-border::before {
  content: '';
  position: absolute; inset: 0;
  padding: 1px; border-radius: inherit;
  background: linear-gradient(135deg, #22D3EE, #A855F7, #EC4899);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor; mask-composite: exclude;
  pointer-events: none;
}

.climatrix-marker {
  width: 22px; height: 22px; border-radius: 999px; cursor: pointer;
  background: linear-gradient(135deg, #22D3EE, #A855F7, #EC4899);
  box-shadow: 0 0 0 4px rgba(168,85,247,0.18), 0 0 24px rgba(168,85,247,0.6);
  position: relative;
}
.climatrix-marker::after {
  content: ''; position: absolute; inset: -8px; border-radius: 999px;
  border: 2px solid rgba(168,85,247,0.5); animation: ringPulse 1.8s ease-out infinite;
}
@keyframes ringPulse {
  0% { transform: scale(0.6); opacity: 1; }
  100% { transform: scale(1.8); opacity: 0; }
}

.pulse-dot {
  width: 10px; height: 10px; border-radius: 999px;
  background: linear-gradient(135deg, #22D3EE, #A855F7, #EC4899);
  box-shadow: 0 0 24px rgba(168,85,247,0.6);
  animation: dotPulse 1.6s ease-in-out infinite;
}
@keyframes dotPulse {
  0%,100% { transform: scale(1); opacity: 1; }
  50%     { transform: scale(1.4); opacity: 0.6; }
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/providers.tsx
'use client';
import { ThemeProvider } from 'next-themes';
import type { ReactNode } from 'react';

export function Providers({ children }: { children: ReactNode }) {
  return (
    <ThemeProvider attribute="class" defaultTheme="dark" enableSystem={false}>
      {children}
    </ThemeProvider>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > app/layout.tsx
import type { Metadata, Viewport } from 'next';
import { Inter, JetBrains_Mono } from 'next/font/google';
import './globals.css';
import { Providers } from '@/components/providers';
import { Navbar } from '@/components/layout/Navbar';

const inter = Inter({ subsets: ['latin'], variable: '--font-inter', display: 'swap' });
const jb    = JetBrains_Mono({ subsets: ['latin'], variable: '--font-jetbrains-mono', display: 'swap' });

export const metadata: Metadata = {
  title: 'CLIMATRIX — Weather, decoded.',
  description: 'Ultra-premium weather intelligence dashboard. Real-time forecasts, activity scores, and interactive maps.',
  icons: { icon: '/favicon.svg' },
};

export const viewport: Viewport = {
  themeColor: [
    { media: '(prefers-color-scheme: dark)',  color: '#07070A' },
    { media: '(prefers-color-scheme: light)', color: '#FAFAFB' },
  ],
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning className={`${inter.variable} ${jb.variable}`}>
      <body className="min-h-screen font-sans bg-surface-base text-ink-primary">
        <Providers>
          <Navbar />
          {children}
        </Providers>
      </body>
    </html>
  );
}
CLIMATRIX_EOF

ok "app shell written"

# ════════════════════════════════════════════════════════════════════════════
# UI PRIMITIVES
# ════════════════════════════════════════════════════════════════════════════

log "Writing components/ui/…"

cat << 'CLIMATRIX_EOF' > components/ui/GlassCard.tsx
'use client';
import { cn } from '@/lib/utils';
import type { HTMLAttributes, ReactNode } from 'react';

interface Props extends HTMLAttributes<HTMLDivElement> {
  children: ReactNode;
  gradientBorder?: boolean;
}

export function GlassCard({ children, className, gradientBorder, ...rest }: Props) {
  return (
    <div
      className={cn(
        'relative rounded-xl border border-surface-border bg-surface-raised/70 backdrop-blur-xl',
        'shadow-glass-light dark:shadow-glass-dark',
        'transition-colors hover:border-brand-purple/40',
        gradientBorder && 'gradient-border',
        className
      )}
      {...rest}
    >
      {children}
    </div>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/ui/GradientText.tsx
'use client';
import { cn } from '@/lib/utils';
import type { ReactNode } from 'react';

export function GradientText({ children, className }: { children: ReactNode; className?: string }) {
  return <span className={cn('text-gradient', className)}>{children}</span>;
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/ui/GradientButton.tsx
'use client';
import { cn } from '@/lib/utils';
import type { ButtonHTMLAttributes, ReactNode } from 'react';

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  variant?: 'gradient' | 'ghost' | 'outline';
}

export function GradientButton({ children, className, variant = 'gradient', ...rest }: Props) {
  return (
    <button
      className={cn(
        'inline-flex items-center justify-center gap-2 rounded-lg px-4 py-2 text-sm font-medium',
        'transition-all duration-200 hover:scale-[1.02] active:scale-[0.98]',
        'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-purple/60',
        variant === 'gradient' && 'text-white bg-brand-gradient shadow-brand-glow',
        variant === 'ghost'    && 'text-ink-primary hover:bg-surface-hover',
        variant === 'outline'  && 'border border-surface-border text-ink-primary hover:border-brand-purple/50',
        className
      )}
      {...rest}
    >
      {children}
    </button>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/ui/AnimatedNumber.tsx
'use client';
import { motion, useMotionValue, useTransform, animate } from 'framer-motion';
import { useEffect } from 'react';

export function AnimatedNumber({
  value, decimals = 0, suffix = '', duration = 0.8,
}: { value: number; decimals?: number; suffix?: string; duration?: number }) {
  const mv = useMotionValue(0);
  const rounded = useTransform(mv, (latest) => latest.toFixed(decimals));

  useEffect(() => {
    const controls = animate(mv, value, { duration, ease: [0.22, 1, 0.36, 1] });
    return () => controls.stop();
  }, [value, duration, mv]);

  return (
    <span className="tabular-nums font-mono">
      <motion.span>{rounded}</motion.span>{suffix}
    </span>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/ui/Skeleton.tsx
import { cn } from '@/lib/utils';

export function Skeleton({ className }: { className?: string }) {
  return (
    <div
      className={cn(
        'rounded-md bg-gradient-to-r from-surface-hover via-surface-border to-surface-hover',
        'bg-[length:200%_100%] animate-shimmer',
        className
      )}
    />
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/ui/Tooltip.tsx
'use client';
import { useState, type ReactNode } from 'react';
import { AnimatePresence, motion } from 'framer-motion';

export function Tooltip({ children, content }: { children: ReactNode; content: string }) {
  const [open, setOpen] = useState(false);
  return (
    <span className="relative inline-flex" onMouseEnter={() => setOpen(true)} onMouseLeave={() => setOpen(false)}>
      {children}
      <AnimatePresence>
        {open && (
          <motion.span
            initial={{ opacity: 0, y: -4 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -4 }}
            className="pointer-events-none absolute left-1/2 -translate-x-1/2 -top-9 whitespace-nowrap rounded-md border border-surface-border bg-surface-elevated px-2 py-1 text-xs text-ink-primary shadow-glass-dark"
          >
            {content}
          </motion.span>
        )}
      </AnimatePresence>
    </span>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/ui/WeatherIcon.tsx
'use client';
import { describeWeather } from '@/lib/weatherCodes';
import { cn } from '@/lib/utils';

export function WeatherIcon({ code, className, size = 24 }: { code: number; className?: string; size?: number }) {
  const { Icon } = describeWeather(code);
  return <Icon className={cn('shrink-0', className)} size={size} />;
}
CLIMATRIX_EOF

ok "ui/ written"

# ════════════════════════════════════════════════════════════════════════════
# LAYOUT (Navbar, Footer, ThemeToggle)
# ════════════════════════════════════════════════════════════════════════════

log "Writing components/layout/…"

cat << 'CLIMATRIX_EOF' > components/layout/ThemeToggle.tsx
'use client';
import { useTheme } from 'next-themes';
import { useEffect, useState } from 'react';
import { Moon, Sun } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  const isDark = theme === 'dark';

  return (
    <button
      aria-label="Toggle theme"
      onClick={() => setTheme(isDark ? 'light' : 'dark')}
      className="relative inline-flex h-9 w-9 items-center justify-center rounded-lg border border-surface-border bg-surface-raised/60 backdrop-blur-xl text-ink-secondary transition-all hover:scale-[1.05] hover:text-ink-primary hover:border-brand-purple/40"
    >
      {mounted && (
        <AnimatePresence mode="wait">
          <motion.span
            key={isDark ? 'moon' : 'sun'}
            initial={{ rotate: -45, opacity: 0 }} animate={{ rotate: 0, opacity: 1 }} exit={{ rotate: 45, opacity: 0 }}
            transition={{ duration: 0.2 }}
          >
            {isDark ? <Moon size={16} /> : <Sun size={16} />}
          </motion.span>
        </AnimatePresence>
      )}
    </button>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/layout/Navbar.tsx
'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Star, Info, Activity, LocateFixed } from 'lucide-react';
import { ThemeToggle } from './ThemeToggle';
import { SearchTrigger } from '@/components/search/SearchTrigger';
import { useWeatherStore } from '@/store/useWeatherStore';
import { cn } from '@/lib/utils';

export function Navbar() {
  const pathname = usePathname();
  const setLocation = useWeatherStore((s) => s.setLocation);

  const geolocate = () => {
    if (!navigator.geolocation) return;
    navigator.geolocation.getCurrentPosition(
      (pos) => setLocation({ lat: pos.coords.latitude, lon: pos.coords.longitude }),
      () => {}
    );
  };

  const link = (href: string, label: string, Icon: typeof Star) => (
    <Link
      href={href}
      className={cn(
        'inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-xs font-medium transition-colors',
        pathname === href ? 'text-ink-primary bg-surface-hover' : 'text-ink-secondary hover:text-ink-primary hover:bg-surface-hover'
      )}
    >
      <Icon size={14} /> <span className="hidden sm:inline">{label}</span>
    </Link>
  );

  return (
    <header className="fixed inset-x-0 top-0 z-40 h-16 border-b border-surface-border/80 bg-surface-base/70 backdrop-blur-xl">
      <div className="mx-auto flex h-full max-w-[1600px] items-center justify-between px-4 sm:px-6">
        <Link href="/" className="group inline-flex items-center gap-2">
          <span className="relative inline-block h-2.5 w-2.5 rounded-full bg-brand-gradient shadow-brand-glow" />
          <span className="font-semibold tracking-[0.18em] text-sm">CLIMATRIX</span>
        </Link>

        <div className="hidden md:block w-[420px] max-w-[50vw]">
          <SearchTrigger />
        </div>

        <div className="flex items-center gap-1.5">
          <button
            aria-label="Use my location"
            onClick={geolocate}
            className="inline-flex h-9 w-9 items-center justify-center rounded-lg border border-surface-border bg-surface-raised/60 backdrop-blur-xl text-ink-secondary transition-all hover:text-ink-primary hover:border-brand-purple/40 hover:scale-[1.05]"
          >
            <LocateFixed size={16} />
          </button>
          {link('/favorites', 'Favorites', Star)}
          {link('/scores', 'Scores', Activity)}
          {link('/about', 'About', Info)}
          <ThemeToggle />
        </div>
      </div>
      <div className="md:hidden border-t border-surface-border/80 bg-surface-base/70 backdrop-blur-xl px-4 py-2">
        <SearchTrigger />
      </div>
    </header>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/layout/Footer.tsx
export function Footer() {
  return (
    <footer className="border-t border-surface-border py-6 text-center text-xs text-ink-muted">
      <p>
        Weather data by{' '}
        <a className="underline-offset-2 hover:text-ink-primary hover:underline" href="https://open-meteo.com" target="_blank" rel="noreferrer">
          Open-Meteo
        </a>{' '}· Tiles by{' '}
        <a className="underline-offset-2 hover:text-ink-primary hover:underline" href="https://carto.com" target="_blank" rel="noreferrer">
          CARTO
        </a>{' '}· Built by Waleed
      </p>
    </footer>
  );
}
CLIMATRIX_EOF

ok "layout/ written"

# ════════════════════════════════════════════════════════════════════════════
# SEARCH
# ════════════════════════════════════════════════════════════════════════════

log "Writing components/search/…"

cat << 'CLIMATRIX_EOF' > components/search/SearchTrigger.tsx
'use client';
import { useEffect, useState } from 'react';
import { Search } from 'lucide-react';
import { SearchCommand } from './SearchCommand';

export function SearchTrigger() {
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault(); setOpen((o) => !o);
      }
      if (e.key === 'Escape') setOpen(false);
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, []);

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="group flex w-full items-center justify-between rounded-lg border border-surface-border bg-surface-raised/60 backdrop-blur-xl px-3 py-2 text-left text-sm text-ink-muted transition-all hover:border-brand-purple/40 hover:text-ink-secondary"
      >
        <span className="inline-flex items-center gap-2">
          <Search size={14} />
          <span>Search any city…</span>
        </span>
        <kbd className="hidden sm:inline-flex items-center gap-1 rounded border border-surface-border bg-surface-elevated px-1.5 py-0.5 font-mono text-[10px] text-ink-muted">
          ⌘ K
        </kbd>
      </button>
      <SearchCommand open={open} onClose={() => setOpen(false)} />
    </>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/search/SearchCommand.tsx
'use client';
import { useEffect, useRef, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { Search, Clock, MapPin } from 'lucide-react';
import { searchLocations } from '@/lib/openMeteo';
import type { GeoResult } from '@/types/weather';
import { useWeatherStore } from '@/store/useWeatherStore';
import { countryFlag } from '@/lib/utils';

export function SearchCommand({ open, onClose }: { open: boolean; onClose: () => void }) {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<GeoResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [activeIdx, setActiveIdx] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const { setLocation, recentSearches, pushRecent } = useWeatherStore();

  useEffect(() => {
    if (open) setTimeout(() => inputRef.current?.focus(), 50);
    else { setQuery(''); setResults([]); setActiveIdx(0); }
  }, [open]);

  useEffect(() => {
    const q = query.trim();
    if (q.length < 2) { setResults([]); return; }
    setLoading(true);
    const t = setTimeout(async () => {
      const r = await searchLocations(q);
      setResults(r); setActiveIdx(0); setLoading(false);
    }, 250);
    return () => clearTimeout(t);
  }, [query]);

  const pick = (r: { lat: number; lon: number; name: string; country: string }) => {
    setLocation({ lat: r.lat, lon: r.lon, name: r.name, country: r.country });
    pushRecent(r);
    onClose();
  };

  const list = results.length
    ? results.map((r) => ({ lat: r.latitude, lon: r.longitude, name: r.name, country: r.country, admin: r.admin1, code: r.country_code }))
    : query.length < 2
      ? recentSearches.map((r) => ({ ...r, admin: undefined, code: undefined }))
      : [];

  const onKey = (e: React.KeyboardEvent) => {
    if (e.key === 'ArrowDown') { e.preventDefault(); setActiveIdx((i) => Math.min(i + 1, list.length - 1)); }
    if (e.key === 'ArrowUp')   { e.preventDefault(); setActiveIdx((i) => Math.max(i - 1, 0)); }
    if (e.key === 'Enter' && list[activeIdx]) pick(list[activeIdx]);
  };

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          className="fixed inset-0 z-50 flex items-start justify-center pt-[15vh] px-4"
          initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
          onClick={onClose}
        >
          <div className="absolute inset-0 bg-black/60 backdrop-blur-md" />
          <motion.div
            initial={{ opacity: 0, y: 12, scale: 0.98 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 12, scale: 0.98 }}
            transition={{ duration: 0.18, ease: [0.22, 1, 0.36, 1] }}
            onClick={(e) => e.stopPropagation()}
            className="relative w-full max-w-xl overflow-hidden rounded-2xl border border-surface-border bg-surface-elevated shadow-glass-dark"
          >
            <div className="flex items-center gap-3 border-b border-surface-border px-4 py-3">
              <Search size={16} className="text-ink-muted" />
              <input
                ref={inputRef}
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                onKeyDown={onKey}
                placeholder="Search for a city, town, or place…"
                className="w-full bg-transparent text-sm text-ink-primary placeholder:text-ink-muted focus:outline-none"
              />
              <kbd className="rounded border border-surface-border px-1.5 py-0.5 font-mono text-[10px] text-ink-muted">ESC</kbd>
            </div>

            <div className="max-h-[55vh] overflow-y-auto scroll-thin py-2">
              {loading && <div className="px-4 py-3 text-xs text-ink-muted">Searching…</div>}
              {!loading && list.length === 0 && (
                <div className="px-4 py-6 text-center text-xs text-ink-muted">
                  {query.length < 2 ? 'Start typing to search 200,000+ cities.' : 'No results.'}
                </div>
              )}
              {!loading && query.length < 2 && recentSearches.length > 0 && (
                <div className="px-4 pb-1 text-[10px] uppercase tracking-wider text-ink-muted">Recent</div>
              )}
              {list.map((r, i) => (
                <button
                  key={`${r.lat}-${r.lon}-${i}`}
                  onMouseEnter={() => setActiveIdx(i)}
                  onClick={() => pick(r)}
                  className={`flex w-full items-center justify-between gap-3 px-4 py-2.5 text-left text-sm transition-colors ${
                    i === activeIdx ? 'bg-surface-hover' : ''
                  }`}
                >
                  <span className="inline-flex items-center gap-2.5 min-w-0">
                    {query.length < 2 ? <Clock size={14} className="text-ink-muted" /> : <MapPin size={14} className="text-ink-muted" />}
                    <span className="truncate">
                      <span className="font-medium text-ink-primary">{r.name}</span>
                      {r.admin && <span className="text-ink-muted">, {r.admin}</span>}
                      <span className="text-ink-muted">, {r.country}</span>
                    </span>
                  </span>
                  <span className="shrink-0 inline-flex items-center gap-2 font-mono text-[10px] text-ink-muted">
                    {r.code && <span>{countryFlag(r.code)}</span>}
                    {r.lat.toFixed(2)}, {r.lon.toFixed(2)}
                  </span>
                </button>
              ))}
            </div>

            <div className="flex items-center justify-between border-t border-surface-border px-4 py-2 text-[10px] text-ink-muted">
              <span>↑↓ navigate · ↵ select</span>
              <span>Powered by Open-Meteo</span>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
CLIMATRIX_EOF

ok "search/ written"

# ════════════════════════════════════════════════════════════════════════════
# MAP
# ════════════════════════════════════════════════════════════════════════════

log "Writing components/map/…"

cat << 'CLIMATRIX_EOF' > components/map/WeatherMap.tsx
'use client';
import { useEffect, useRef } from 'react';
import maplibregl from 'maplibre-gl';
import { useWeatherStore } from '@/store/useWeatherStore';

const STYLES = {
  dark:  'https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json',
  light: 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json',
};

export function WeatherMap() {
  const ref = useRef<HTMLDivElement>(null);
  const mapRef = useRef<maplibregl.Map | null>(null);
  const markerRef = useRef<maplibregl.Marker | null>(null);

  const { selectedLocation, mapStyle, setLocation } = useWeatherStore();

  useEffect(() => {
    if (!ref.current || mapRef.current) return;
    const map = new maplibregl.Map({
      container: ref.current,
      style: STYLES[mapStyle],
      center: [30, 20],
      zoom: 2,
      attributionControl: { compact: true },
      dragRotate: false,
      pitchWithRotate: false,
    });
    map.touchZoomRotate.disableRotation();
    map.addControl(new maplibregl.NavigationControl({ showCompass: false }), 'bottom-right');
    map.on('click', (e) => {
      setLocation({ lat: e.lngLat.lat, lon: e.lngLat.lng });
    });
    mapRef.current = map;
    return () => { map.remove(); mapRef.current = null; };
  }, [setLocation, mapStyle]);

  useEffect(() => {
    const m = mapRef.current;
    if (!m) return;
    m.setStyle(STYLES[mapStyle]);
  }, [mapStyle]);

  useEffect(() => {
    const m = mapRef.current;
    if (!m || !selectedLocation) return;

    if (markerRef.current) markerRef.current.remove();
    const el = document.createElement('div');
    el.className = 'climatrix-marker';
    markerRef.current = new maplibregl.Marker({ element: el })
      .setLngLat([selectedLocation.lon, selectedLocation.lat])
      .addTo(m);

    m.flyTo({
      center: [selectedLocation.lon, selectedLocation.lat],
      zoom: Math.max(m.getZoom(), 6),
      speed: 0.9, curve: 1.4, essential: true,
    });
  }, [selectedLocation]);

  return (
    <div ref={ref} className="absolute inset-0 h-full w-full">
      <div className="pointer-events-none absolute inset-x-0 top-0 h-24 bg-gradient-to-b from-surface-base/80 to-transparent" />
      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-24 bg-gradient-to-t from-surface-base/60 to-transparent" />
    </div>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/map/LayerSwitcher.tsx
'use client';
import { Thermometer, CloudRain, Wind, Cloud, Droplets, Gauge, Sun } from 'lucide-react';
import { useWeatherStore } from '@/store/useWeatherStore';
import { cn } from '@/lib/utils';
import type { LayerKey } from '@/types/weather';
import { Tooltip } from '@/components/ui/Tooltip';

const LAYERS: { key: LayerKey; label: string; Icon: typeof Thermometer }[] = [
  { key: 'temperature',   label: 'Temperature',  Icon: Thermometer },
  { key: 'precipitation', label: 'Precipitation',Icon: CloudRain },
  { key: 'wind',          label: 'Wind',         Icon: Wind },
  { key: 'clouds',        label: 'Clouds',       Icon: Cloud },
  { key: 'humidity',      label: 'Humidity',     Icon: Droplets },
  { key: 'pressure',      label: 'Pressure',     Icon: Gauge },
  { key: 'uv',            label: 'UV Index',     Icon: Sun },
];

export function LayerSwitcher() {
  const { activeLayer, setActiveLayer } = useWeatherStore();
  return (
    <div className="pointer-events-auto flex flex-col gap-1.5 rounded-2xl border border-surface-border bg-surface-raised/70 backdrop-blur-xl p-1.5 shadow-glass-dark">
      {LAYERS.map(({ key, label, Icon }) => {
        const active = activeLayer === key;
        return (
          <Tooltip key={key} content={label}>
            <button
              aria-label={label}
              onClick={() => setActiveLayer(key)}
              className={cn(
                'relative inline-flex h-9 w-9 items-center justify-center rounded-lg transition-all',
                active
                  ? 'text-white bg-brand-gradient shadow-brand-glow'
                  : 'text-ink-secondary hover:text-ink-primary hover:bg-surface-hover'
              )}
            >
              <Icon size={16} />
            </button>
          </Tooltip>
        );
      })}
    </div>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/map/MapStyleToggle.tsx
'use client';
import { useWeatherStore } from '@/store/useWeatherStore';
import { Moon, Sun } from 'lucide-react';
import { cn } from '@/lib/utils';

export function MapStyleToggle() {
  const { mapStyle, setMapStyle } = useWeatherStore();
  return (
    <div className="pointer-events-auto inline-flex rounded-xl border border-surface-border bg-surface-raised/70 backdrop-blur-xl p-1 shadow-glass-dark">
      {(['dark', 'light'] as const).map((s) => {
        const Icon = s === 'dark' ? Moon : Sun;
        const active = mapStyle === s;
        return (
          <button
            key={s}
            onClick={() => setMapStyle(s)}
            className={cn(
              'inline-flex h-8 items-center gap-1.5 rounded-lg px-3 text-xs font-medium transition-all',
              active
                ? 'text-white bg-brand-gradient shadow-brand-glow'
                : 'text-ink-secondary hover:text-ink-primary'
            )}
          >
            <Icon size={12} /> {s === 'dark' ? 'Dark' : 'Light'}
          </button>
        );
      })}
    </div>
  );
}
CLIMATRIX_EOF

ok "map/ written"

# ════════════════════════════════════════════════════════════════════════════
# PANEL COMPONENTS
# ════════════════════════════════════════════════════════════════════════════

log "Writing components/panel/…"

cat << 'CLIMATRIX_EOF' > components/panel/ScoreRing.tsx
'use client';
import { motion } from 'framer-motion';

export function ScoreRing({ value, color, size = 56, stroke = 6 }: { value: number; color: string; size?: number; stroke?: number }) {
  const r = (size - stroke) / 2;
  const C = 2 * Math.PI * r;
  const offset = C - (value / 100) * C;
  const id = `g-${Math.round(value)}-${color.slice(1)}`;

  return (
    <svg width={size} height={size} className="-rotate-90">
      <defs>
        <linearGradient id={id} x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor="#22D3EE" />
          <stop offset="50%" stopColor="#A855F7" />
          <stop offset="100%" stopColor="#EC4899" />
        </linearGradient>
      </defs>
      <circle cx={size/2} cy={size/2} r={r} stroke="currentColor" className="text-surface-border" strokeWidth={stroke} fill="none" />
      <motion.circle
        cx={size/2} cy={size/2} r={r}
        stroke={value >= 60 ? `url(#${id})` : color}
        strokeWidth={stroke} strokeLinecap="round" fill="none"
        strokeDasharray={C}
        initial={{ strokeDashoffset: C }}
        animate={{ strokeDashoffset: offset }}
        transition={{ duration: 1.0, ease: [0.22, 1, 0.36, 1] }}
      />
    </svg>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/panel/CurrentWeather.tsx
'use client';
import type { WeatherBundle } from '@/types/weather';
import { describeWeather } from '@/lib/weatherCodes';
import { AnimatedNumber } from '@/components/ui/AnimatedNumber';
import { useWeatherStore } from '@/store/useWeatherStore';
import { cToF } from '@/lib/units';
import { feelsLike } from '@/lib/calculations';

export function CurrentWeather({ data }: { data: WeatherBundle }) {
  const unit = useWeatherStore((s) => s.units.temperature);
  const cur = data.current;
  const { Icon, label, gradient } = describeWeather(cur.weatherCode);
  const t = unit === 'C' ? cur.temperature : cToF(cur.temperature);
  const f = feelsLike(cur.temperature, cur.humidity, cur.windSpeed);
  const fl = unit === 'C' ? f : cToF(f);

  return (
    <div className={`relative overflow-hidden rounded-2xl border border-surface-border p-5 bg-gradient-to-br ${gradient}`}>
      <div className="relative z-10 flex items-start justify-between">
        <div>
          <div className="text-7xl font-light leading-none tracking-tight">
            <AnimatedNumber value={t} />
            <span className="font-mono text-2xl align-top text-ink-secondary">°{unit}</span>
          </div>
          <p className="mt-2 text-sm text-ink-primary">{label}</p>
          <p className="text-xs text-ink-muted">
            Feels like <span className="font-mono">{Math.round(fl)}°{unit}</span>
          </p>
        </div>
        <Icon size={64} className="text-ink-primary/80" strokeWidth={1.25} />
      </div>
    </div>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/panel/WeatherStatGrid.tsx
'use client';
import type { WeatherBundle } from '@/types/weather';
import { Wind, Droplets, Gauge, Eye, Sun, Cloud } from 'lucide-react';
import { useWeatherStore } from '@/store/useWeatherStore';
import { formatWind, formatPressure, uvRisk, windDirLabel } from '@/lib/units';

export function WeatherStatGrid({ data }: { data: WeatherBundle }) {
  const units = useWeatherStore((s) => s.units);
  const c = data.current;

  const stats = [
    { Icon: Wind, label: 'Wind', value: formatWind(c.windSpeed, units.wind), sub: `${windDirLabel(c.windDirection)} · gust ${Math.round(c.windGusts)} km/h`, dir: c.windDirection },
    { Icon: Droplets, label: 'Humidity', value: `${Math.round(c.humidity)}%`, sub: `Dew ${Math.round(c.temperature - ((100 - c.humidity)/5))}°` },
    { Icon: Gauge, label: 'Pressure', value: formatPressure(c.pressure, units.pressure), sub: c.pressure > 1015 ? 'High' : c.pressure < 1005 ? 'Low' : 'Steady' },
    { Icon: Eye, label: 'Visibility', value: `${c.visibility.toFixed(1)} km`, sub: c.visibility > 10 ? 'Excellent' : c.visibility > 5 ? 'Good' : 'Reduced' },
    { Icon: Sun, label: 'UV Index', value: c.uvIndex.toFixed(1), sub: uvRisk(c.uvIndex) },
    { Icon: Cloud, label: 'Cloud Cover', value: `${Math.round(c.cloudCover)}%`, sub: c.cloudCover < 30 ? 'Clear' : c.cloudCover < 70 ? 'Partly' : 'Overcast' },
  ];

  return (
    <div className="grid grid-cols-2 gap-2.5 sm:grid-cols-3">
      {stats.map((s) => (
        <div key={s.label} className="group rounded-xl border border-surface-border bg-surface-raised/60 p-3 transition-colors hover:border-brand-purple/40">
          <div className="flex items-center justify-between">
            <s.Icon size={14} className="text-ink-muted" style={s.dir != null ? { transform: `rotate(${s.dir}deg)` } : undefined} />
            <span className="text-[10px] uppercase tracking-wider text-ink-muted">{s.label}</span>
          </div>
          <div className="mt-2 font-mono text-lg text-ink-primary">{s.value}</div>
          <div className="text-[10px] text-ink-muted">{s.sub}</div>
        </div>
      ))}
    </div>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/panel/HourlyChart.tsx
'use client';
import { AreaChart, Area, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from 'recharts';
import type { WeatherBundle } from '@/types/weather';
import { useWeatherStore } from '@/store/useWeatherStore';
import { cToF } from '@/lib/units';

export function HourlyChart({ data }: { data: WeatherBundle }) {
  const unit = useWeatherStore((s) => s.units.temperature);
  const rows = data.hourly.time.slice(0, 24).map((t, i) => {
    const c = data.hourly.temperature[i];
    return {
      hour: new Date(t).toLocaleTimeString('en-US', { hour: '2-digit', hour12: false }),
      temp: unit === 'C' ? Math.round(c) : Math.round(cToF(c)),
      pop:  data.hourly.precipitationProbability?.[i] ?? 0,
    };
  });

  return (
    <div className="rounded-xl border border-surface-border bg-surface-raised/60 p-4">
      <div className="mb-3 flex items-center justify-between">
        <h3 className="text-xs font-medium uppercase tracking-wider text-ink-muted">Next 24 hours</h3>
        <span className="font-mono text-[10px] text-ink-muted">°{unit}</span>
      </div>
      <div className="h-44">
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={rows} margin={{ top: 6, right: 6, bottom: 0, left: -28 }}>
            <defs>
              <linearGradient id="tempGrad" x1="0" y1="0" x2="1" y2="0">
                <stop offset="0%" stopColor="#22D3EE" />
                <stop offset="50%" stopColor="#A855F7" />
                <stop offset="100%" stopColor="#EC4899" />
              </linearGradient>
              <linearGradient id="tempFill" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#A855F7" stopOpacity={0.35} />
                <stop offset="100%" stopColor="#A855F7" stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid stroke="var(--surface-border)" strokeDasharray="3 3" vertical={false} />
            <XAxis dataKey="hour" stroke="var(--ink-muted)" fontSize={10} tickLine={false} axisLine={false} interval={3} />
            <YAxis stroke="var(--ink-muted)" fontSize={10} tickLine={false} axisLine={false} width={36} />
            <Tooltip
              contentStyle={{ background: 'var(--surface-elevated)', border: '1px solid var(--surface-border)', borderRadius: 8, fontSize: 12 }}
              labelStyle={{ color: 'var(--ink-muted)' }}
              formatter={(v: number, name: string) => name === 'temp' ? [`${v}°${unit}`, 'Temp'] : [`${v}%`, 'Rain']}
            />
            <Area type="monotone" dataKey="temp" stroke="url(#tempGrad)" strokeWidth={2.5} fill="url(#tempFill)" />
          </AreaChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/panel/DailyForecast.tsx
'use client';
import type { WeatherBundle } from '@/types/weather';
import { describeWeather } from '@/lib/weatherCodes';
import { useWeatherStore } from '@/store/useWeatherStore';
import { cToF } from '@/lib/units';
import { formatDay } from '@/lib/utils';

export function DailyForecast({ data }: { data: WeatherBundle }) {
  const unit = useWeatherStore((s) => s.units.temperature);
  const mins = data.daily.tempMin.map((v) => (unit === 'C' ? v : cToF(v)));
  const maxs = data.daily.tempMax.map((v) => (unit === 'C' ? v : cToF(v)));
  const lo = Math.min(...mins);
  const hi = Math.max(...maxs);
  const range = hi - lo || 1;

  return (
    <div className="rounded-xl border border-surface-border bg-surface-raised/60 p-4">
      <h3 className="mb-3 text-xs font-medium uppercase tracking-wider text-ink-muted">7-Day Forecast</h3>
      <div className="space-y-2">
        {data.daily.time.map((day, i) => {
          const { Icon } = describeWeather(data.daily.weatherCode[i]);
          const lMin = ((mins[i] - lo) / range) * 100;
          const lMax = ((maxs[i] - lo) / range) * 100;
          return (
            <div key={day} className="grid grid-cols-[44px_24px_36px_1fr_36px] items-center gap-3 text-sm">
              <span className="text-ink-secondary">{i === 0 ? 'Today' : formatDay(day)}</span>
              <Icon size={16} className="text-ink-primary/80" />
              <span className="text-right font-mono text-xs text-ink-muted">{Math.round(mins[i])}°</span>
              <div className="relative h-1.5 rounded-full bg-surface-border">
                <div
                  className="absolute h-full rounded-full bg-brand-gradient"
                  style={{ left: `${lMin}%`, width: `${Math.max(lMax - lMin, 4)}%` }}
                />
              </div>
              <span className="text-right font-mono text-xs text-ink-primary">{Math.round(maxs[i])}°</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/panel/ActivityScores.tsx
'use client';
import { useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { ChevronDown } from 'lucide-react';
import type { WeatherBundle } from '@/types/weather';
import { computeAllScores } from '@/lib/scores';
import { ScoreRing } from './ScoreRing';

export function ActivityScores({ data }: { data: WeatherBundle }) {
  const scores = computeAllScores(data);
  const [open, setOpen] = useState<string | null>(null);

  return (
    <div className="rounded-xl border border-surface-border bg-surface-raised/60 p-4">
      <h3 className="mb-3 text-xs font-medium uppercase tracking-wider text-ink-muted">Activity Scores</h3>
      <div className="divide-y divide-surface-border/60">
        {scores.map(({ key, emoji, name, result }) => {
          const isOpen = open === key;
          return (
            <button
              key={key}
              onClick={() => setOpen(isOpen ? null : key)}
              className="group flex w-full flex-col py-3 text-left transition-colors"
            >
              <div className="flex items-center gap-3">
                <ScoreRing value={result.score} color={result.color} />
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium text-ink-primary">{emoji} {name}</span>
                    <ChevronDown size={14} className={`text-ink-muted transition-transform ${isOpen ? 'rotate-180' : ''}`} />
                  </div>
                  <div className="mt-1 flex items-baseline gap-2">
                    <span className="font-mono text-xl text-ink-primary">{result.score}</span>
                    <span className="text-[10px] uppercase tracking-wider" style={{ color: result.color }}>{result.label}</span>
                  </div>
                </div>
              </div>
              <AnimatePresence initial={false}>
                {isOpen && (
                  <motion.ul
                    initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: 'auto' }} exit={{ opacity: 0, height: 0 }}
                    className="ml-[68px] mt-2 space-y-1 overflow-hidden text-xs text-ink-secondary"
                  >
                    {result.reasons.map((r, i) => (
                      <li key={i} className="flex items-start gap-2">
                        <span className="mt-1.5 inline-block h-1 w-1 shrink-0 rounded-full" style={{ background: result.color }} />
                        {r}
                      </li>
                    ))}
                  </motion.ul>
                )}
              </AnimatePresence>
            </button>
          );
        })}
      </div>
    </div>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/panel/SunMoonInfo.tsx
'use client';
import type { WeatherBundle } from '@/types/weather';
import { Sunrise, Sunset } from 'lucide-react';
import { formatTime, durationFromSeconds } from '@/lib/utils';
import { moonPhase } from '@/lib/calculations';

export function SunMoonInfo({ data }: { data: WeatherBundle }) {
  const sr = data.daily.sunrise?.[0];
  const ss = data.daily.sunset?.[0];
  const dl = data.daily.daylightDuration?.[0] ?? 0;
  const moon = moonPhase(new Date());

  return (
    <div className="grid grid-cols-2 gap-2.5">
      <div className="rounded-xl border border-surface-border bg-surface-raised/60 p-4">
        <div className="flex items-center gap-2 text-[10px] uppercase tracking-wider text-ink-muted">
          <Sunrise size={12} /> Sunrise · Sunset
        </div>
        <div className="mt-2 font-mono text-base text-ink-primary">{formatTime(sr, data.timezone)}</div>
        <div className="font-mono text-xs text-ink-secondary">
          <Sunset size={10} className="inline mr-1" />{formatTime(ss, data.timezone)}
        </div>
        <div className="mt-1 text-[10px] text-ink-muted">Daylight {durationFromSeconds(dl)}</div>
      </div>
      <div className="rounded-xl border border-surface-border bg-surface-raised/60 p-4">
        <div className="text-[10px] uppercase tracking-wider text-ink-muted">Moon Phase</div>
        <div class="mt-2 flex items-center gap-2">
          <span className="text-3xl leading-none">{moon.emoji}</span>
          <div>
            <div className="text-sm text-ink-primary">{moon.phase}</div>
            <div className="font-mono text-[10px] text-ink-muted">{moon.illumination}% illuminated</div>
          </div>
        </div>
      </div>
    </div>
  );
}
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > components/panel/LocationPanel.tsx
'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { AnimatePresence, motion } from 'framer-motion';
import { X, Star, Share2, ExternalLink } from 'lucide-react';
import { useWeatherStore } from '@/store/useWeatherStore';
import { getWeather } from '@/lib/openMeteo';
import type { WeatherBundle } from '@/types/weather';
import { CurrentWeather } from './CurrentWeather';
import { WeatherStatGrid } from './WeatherStatGrid';
import { HourlyChart } from './HourlyChart';
import { DailyForecast } from './DailyForecast';
import { ActivityScores } from './ActivityScores';
import { SunMoonInfo } from './SunMoonInfo';
import { Skeleton } from '@/components/ui/Skeleton';
import { cn } from '@/lib/utils';

export function LocationPanel() {
  const { selectedLocation, setLocation, addFavorite, removeFavorite, isFavorite } = useWeatherStore();
  const [data, setData] = useState<WeatherBundle | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    if (!selectedLocation) { setData(null); return; }
    setLoading(true); setError(null);
    getWeather(selectedLocation.lat, selectedLocation.lon)
      .then(setData)
      .catch(() => setError('Could not load weather'))
      .finally(() => setLoading(false));
  }, [selectedLocation]);

  const fav = selectedLocation ? isFavorite(selectedLocation.lat, selectedLocation.lon) : false;

  const share = async () => {
    if (!selectedLocation) return;
    const url = `${location.origin}/location/${selectedLocation.lat.toFixed(4)}/${selectedLocation.lon.toFixed(4)}`;
    await navigator.clipboard.writeText(url);
    setCopied(true); setTimeout(() => setCopied(false), 1400);
  };

  const toggleFav = () => {
    if (!selectedLocation) return;
    const name = selectedLocation.name ?? `${selectedLocation.lat.toFixed(2)}, ${selectedLocation.lon.toFixed(2)}`;
    const country = selectedLocation.country ?? '';
    if (fav) removeFavorite(selectedLocation.lat, selectedLocation.lon);
    else addFavorite({ lat: selectedLocation.lat, lon: selectedLocation.lon, name, country });
  };

  return (
    <AnimatePresence>
      {selectedLocation && (
        <motion.aside
          initial={{ x: '100%', opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          exit={{ x: '100%', opacity: 0 }}
          transition={{ duration: 0.35, ease: [0.22, 1, 0.36, 1] }}
          className={cn(
            'fixed z-30 flex flex-col',
            'right-0 top-16 bottom-0 w-full md:w-[440px]',
            'border-l border-surface-border bg-surface-base/85 backdrop-blur-2xl shadow-glass-dark'
          )}
        >
          <div className="flex items-start justify-between gap-3 border-b border-surface-border p-4">
            <div className="min-w-0">
              <h2 className="truncate text-lg font-semibold tracking-tight">
                {selectedLocation.name ?? 'Pinned location'}
              </h2>
              <p className="truncate text-xs text-ink-muted">
                {selectedLocation.country && <span>{selectedLocation.country} · </span>}
                <span className="font-mono">{selectedLocation.lat.toFixed(4)}, {selectedLocation.lon.toFixed(4)}</span>
              </p>
            </div>
            <button
              aria-label="Close panel"
              onClick={() => setLocation(null)}
              className="inline-flex h-8 w-8 items-center justify-center rounded-lg text-ink-muted hover:bg-surface-hover hover:text-ink-primary"
            >
              <X size={16} />
            </button>
          </div>

          <div className="flex-1 space-y-4 overflow-y-auto scroll-thin p-4">
            {loading && (
              <>
                <Skeleton className="h-40" />
                <Skeleton className="h-28" />
                <Skeleton className="h-48" />
              </>
            )}
            {error && <p className="text-sm text-red-400">{error}</p>}
            {data && !loading && (
              <>
                <CurrentWeather data={data} />
                <WeatherStatGrid data={data} />
                <HourlyChart data={data} />
                <DailyForecast data={data} />
                <ActivityScores data={data} />
                <SunMoonInfo data={data} />
              </>
            )}
          </div>

          <div className="flex items-center gap-2 border-t border-surface-border p-3">
            <button
              onClick={toggleFav}
              className={cn(
                'inline-flex flex-1 items-center justify-center gap-2 rounded-lg border px-3 py-2 text-xs font-medium transition-all hover:scale-[1.01]',
                fav
                  ? 'border-transparent bg-brand-gradient text-white shadow-brand-glow'
                  : 'border-surface-border text-ink-primary hover:border-brand-purple/40'
              )}
            >
              <Star size={14} className={fav ? 'fill-white' : ''} />
              {fav ? 'Saved' : 'Save'}
            </button>
            <button
              onClick={share}
              className="inline-flex items-center justify-center gap-2 rounded-lg border border-surface-border px-3 py-2 text-xs font-medium text-ink-primary hover:border-brand-purple/40"
            >
              <Share2 size={14} /> {copied ? 'Copied' : 'Share'}
            </button>
            {selectedLocation && (
              <Link
                href={`/location/${selectedLocation.lat.toFixed(4)}/${selectedLocation.lon.toFixed(4)}`}
                className="inline-flex items-center justify-center gap-2 rounded-lg border border-surface-border px-3 py-2 text-xs font-medium text-ink-primary hover:border-brand-purple/40"
              >
                <ExternalLink size={14} /> Detail
              </Link>
            )}
          </div>
        </motion.aside>
      )}
    </AnimatePresence>
  );
}
CLIMATRIX_EOF

ok "panel/ written"

# ════════════════════════════════════════════════════════════════════════════
# APP — MAIN DASHBOARD
# ════════════════════════════════════════════════════════════════════════════

log "Writing app/page.tsx (main dashboard)…"

cat << 'CLIMATRIX_EOF' > app/page.tsx
'use client';
import dynamic from 'next/dynamic';
import { LayerSwitcher } from '@/components/map/LayerSwitcher';
import { MapStyleToggle } from '@/components/map/MapStyleToggle';
import { LocationPanel } from '@/components/panel/LocationPanel';
import { useWeatherStore } from '@/store/useWeatherStore';
import { AnimatePresence, motion } from 'framer-motion';
import { GradientText } from '@/components/ui/GradientText';
import { MousePointerClick } from 'lucide-react';

const WeatherMap = dynamic(() => import('@/components/map/WeatherMap').then((m) => m.WeatherMap), {
  ssr: false,
  loading: () => <div className="absolute inset-0 bg-surface-base brand-grid opacity-50" />,
});

export default function Page() {
  const selectedLocation = useWeatherStore((s) => s.selectedLocation);

  return (
    <main className="relative h-screen w-screen overflow-hidden pt-16">
      <WeatherMap />

      <AnimatePresence>
        {!selectedLocation && (
          <motion.div
            initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: 12 }}
            transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] }}
            className="pointer-events-none absolute inset-0 z-20 flex items-center justify-center px-6"
          >
            <div className="pointer-events-auto max-w-md text-center">
              <div className="mx-auto mb-5 flex justify-center"><span className="pulse-dot" /></div>
              <h1 className="text-5xl font-semibold tracking-tight sm:text-6xl">
                <GradientText>CLIMATRIX</GradientText>
              </h1>
              <p className="mt-3 text-sm tracking-[0.18em] uppercase text-ink-secondary">
                Weather, decoded.
              </p>
              <p className="mt-6 inline-flex items-center gap-2 rounded-full border border-surface-border bg-surface-raised/60 px-4 py-1.5 text-xs text-ink-secondary backdrop-blur-xl">
                <MousePointerClick size={12} /> Click anywhere on the map or press <kbd className="font-mono">⌘K</kbd>
              </p>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      <div className="pointer-events-none absolute left-4 top-20 z-30">
        <LayerSwitcher />
      </div>

      <div className="pointer-events-none absolute bottom-6 left-4 z-30">
        <MapStyleToggle />
      </div>

      <LocationPanel />
    </main>
  );
}
CLIMATRIX_EOF

ok "main dashboard written"

# ════════════════════════════════════════════════════════════════════════════
# APP — FAVORITES
# ════════════════════════════════════════════════════════════════════════════

log "Writing app/favorites/page.tsx…"

cat << 'CLIMATRIX_EOF' > app/favorites/page.tsx
'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Star, Trash2, MapPin } from 'lucide-react';
import { useWeatherStore } from '@/store/useWeatherStore';
import { getWeather } from '@/lib/openMeteo';
import { describeWeather } from '@/lib/weatherCodes';
import { computeAllScores } from '@/lib/scores';
import { Skeleton } from '@/components/ui/Skeleton';
import { GradientText } from '@/components/ui/GradientText';
import { Footer } from '@/components/layout/Footer';

interface FavData { temp: number; code: number; topScore: { emoji: string; name: string; score: number } }

export default function FavoritesPage() {
  const { favorites, removeFavorite, setLocation } = useWeatherStore();
  const router = useRouter();
  const [data, setData] = useState<Record<string, FavData | null>>({});

  useEffect(() => {
    favorites.forEach(async (f) => {
      const key = `${f.lat},${f.lon}`;
      if (data[key]) return;
      try {
        const w = await getWeather(f.lat, f.lon);
        const scores = computeAllScores(w);
        const top = scores.reduce((a, b) => (b.result.score > a.result.score ? b : a));
        setData((d) => ({ ...d, [key]: { temp: w.current.temperature, code: w.current.weatherCode,
          topScore: { emoji: top.emoji, name: top.name, score: top.result.score } } }));
      } catch {
        setData((d) => ({ ...d, [key]: null }));
      }
    });
  }, [favorites, data]);

  const open = (lat: number, lon: number, name: string, country: string) => {
    setLocation({ lat, lon, name, country });
    router.push('/');
  };

  return (
    <main className="min-h-screen pt-24">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <header className="mb-8">
          <p className="text-xs uppercase tracking-[0.2em] text-ink-muted">Saved locations</p>
          <h1 className="mt-1 text-3xl font-semibold tracking-tight sm:text-4xl">
            <GradientText>Favorites</GradientText>
          </h1>
        </header>

        {favorites.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-surface-border p-12 text-center">
            <Star size={36} className="mx-auto text-ink-muted" />
            <p className="mt-4 text-sm text-ink-secondary">No favorites yet.</p>
            <p className="text-xs text-ink-muted">Click the ⭐ button after exploring a location.</p>
            <Link href="/" className="mt-6 inline-flex items-center gap-2 rounded-lg bg-brand-gradient px-4 py-2 text-xs font-medium text-white shadow-brand-glow">
              Open the map
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {favorites.map((f) => {
              const key = `${f.lat},${f.lon}`;
              const d = data[key];
              const meta = d ? describeWeather(d.code) : null;
              return (
                <div key={key} className="group relative overflow-hidden rounded-2xl border border-surface-border bg-surface-raised/60 p-5 transition-all hover:border-brand-purple/40 hover:shadow-brand-glow">
                  <button
                    aria-label="Remove"
                    onClick={() => removeFavorite(f.lat, f.lon)}
                    className="absolute right-3 top-3 inline-flex h-7 w-7 items-center justify-center rounded-md text-ink-muted opacity-0 transition-opacity hover:bg-surface-hover hover:text-red-400 group-hover:opacity-100"
                  >
                    <Trash2 size={13} />
                  </button>
                  <button
                    onClick={() => open(f.lat, f.lon, f.name, f.country)}
                    className="block w-full text-left"
                  >
                    <p className="text-xs text-ink-muted inline-flex items-center gap-1.5"><MapPin size={11} /> {f.country}</p>
                    <h3 className="mt-1 text-xl font-semibold tracking-tight">{f.name}</h3>
                    <p className="font-mono text-[10px] text-ink-muted">{f.lat.toFixed(2)}, {f.lon.toFixed(2)}</p>
                    <div className="mt-4 flex items-center justify-between">
                      {d === undefined ? (
                        <Skeleton className="h-10 w-20" />
                      ) : d ? (
                        <div className="font-mono text-3xl text-ink-primary">{Math.round(d.temp)}°</div>
                      ) : (
                        <span className="text-xs text-ink-muted">—</span>
                      )}
                      {meta && <meta.Icon size={32} className="text-ink-primary/70" strokeWidth={1.25} />}
                    </div>
                    {d && (
                      <div className="mt-3 inline-flex items-center gap-1.5 rounded-full border border-surface-border px-2.5 py-1 text-[10px]">
                        <span>{d.topScore.emoji}</span>
                        <span className="text-ink-secondary">{d.topScore.name}</span>
                        <span className="font-mono text-ink-primary">{d.topScore.score}</span>
                      </div>
                    )}
                  </button>
                </div>
              );
            })}
          </div>
        )}
      </div>
      <Footer />
    </main>
  );
}
CLIMATRIX_EOF

ok "favorites written"

# ════════════════════════════════════════════════════════════════════════════
# APP — SCORES PAGE
# ════════════════════════════════════════════════════════════════════════════

log "Writing app/scores/page.tsx…"

cat << 'CLIMATRIX_EOF' > app/scores/page.tsx
import { Footer } from '@/components/layout/Footer';
import { GradientText } from '@/components/ui/GradientText';

const SCORES = [
  { emoji: '🏏', name: 'Cricket',     desc: 'How playable is the pitch right now?',
    factors: ['Temp 18–32°C → 30%', 'Rain prob next 6h <20% → 30%', 'Wind <25 km/h → 20%', 'Humidity <70% → 10%', 'Visibility >5 km → 10%'] },
  { emoji: '☀️', name: 'Solar Power',  desc: 'Expected photovoltaic yield for today.',
    factors: ['Cloud cover (inverted) → 50%', 'Daily UV max → 30%', 'Daylight duration → 20%'] },
  { emoji: '🏃', name: 'Running',     desc: 'Comfort and safety for outdoor runs.',
    factors: ['Feels-like 10–25°C → 40%', 'Rain prob <20% → 25%', 'Humidity <75% → 15%', 'UV <6 → 10%', 'Wind <30 km/h → 10%'] },
  { emoji: '🌾', name: 'Farming',     desc: 'Crop-friendly conditions, balanced rain.',
    factors: ['Temp 15–28°C → 30%', 'Precip 1–10 mm/day → 30%', 'Wind <25 km/h → 20%', 'Humidity 50–80% → 20%'] },
  { emoji: '🧺', name: 'Picnic',      desc: 'Pleasant outdoor weather for a meal.',
    factors: ['Temp 18–28°C → 30%', 'Rain prob <15% → 30%', 'Wind <20 km/h → 20%', 'Cloud <60% → 10%', 'UV <8 → 10%'] },
  { emoji: '🔭', name: 'Stargazing',  desc: 'Dark, clear, dry skies for astronomy.',
    factors: ['Cloud cover (inverted) → 50%', 'Moon illumination (inverted) → 30%', 'Humidity (inverted) → 20%'] },
];

export default function ScoresPage() {
  return (
    <main className="min-h-screen pt-24">
      <div className="mx-auto max-w-4xl px-4 sm:px-6">
        <header className="mb-12">
          <p className="text-xs uppercase tracking-[0.2em] text-ink-muted">Methodology</p>
          <h1 className="mt-1 text-4xl font-semibold tracking-tight sm:text-5xl">
            How <GradientText>CLIMATRIX</GradientText> scores your day
          </h1>
          <p className="mt-4 max-w-2xl text-sm leading-relaxed text-ink-secondary">
            Each activity score is a weighted composite of meteorological factors normalized to a 0–100 scale.
            Scores update with every forecast refresh and are computed entirely on-device.
          </p>
        </header>

        <div className="space-y-4">
          {SCORES.map((s) => (
            <section key={s.name} className="rounded-2xl border border-surface-border bg-surface-raised/60 p-6 transition-colors hover:border-brand-purple/40">
              <div className="flex items-start gap-4">
                <span className="text-3xl">{s.emoji}</span>
                <div className="flex-1">
                  <h2 className="text-lg font-semibold tracking-tight">{s.name}</h2>
                  <p className="text-sm text-ink-secondary">{s.desc}</p>
                  <ul className="mt-4 space-y-1.5 text-xs text-ink-secondary">
                    {s.factors.map((f) => (
                      <li key={f} className="font-mono">
                        <span className="text-brand-purple">▸</span> {f}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </section>
          ))}
        </div>

        <p className="mt-12 text-xs text-ink-muted">
          Label thresholds: 80+ Excellent · 60–79 Good · 40–59 Fair · 20–39 Poor · &lt;20 Bad
        </p>
      </div>
      <Footer />
    </main>
  );
}
CLIMATRIX_EOF

ok "scores page written"

# ════════════════════════════════════════════════════════════════════════════
# APP — ABOUT
# ════════════════════════════════════════════════════════════════════════════

log "Writing app/about/page.tsx…"

cat << 'CLIMATRIX_EOF' > app/about/page.tsx
import { Footer } from '@/components/layout/Footer';
import { GradientText } from '@/components/ui/GradientText';

const STACK = [
  'Next.js 14','TypeScript','Tailwind CSS','Framer Motion',
  'Recharts','MapLibre GL','Zustand','Open-Meteo','CARTO',
];

export default function AboutPage() {
  return (
    <main className="min-h-screen pt-24">
      <div className="mx-auto max-w-3xl px-4 sm:px-6">
        <header className="mb-10">
          <p className="text-xs uppercase tracking-[0.2em] text-ink-muted">About</p>
          <h1 className="mt-1 text-4xl font-semibold tracking-tight sm:text-5xl">
            <GradientText>CLIMATRIX</GradientText>
          </h1>
          <p className="mt-3 text-sm uppercase tracking-[0.18em] text-ink-secondary">Weather, decoded.</p>
        </header>

        <section className="space-y-5 text-sm leading-relaxed text-ink-secondary">
          <p>
            CLIMATRIX is an ultra-premium weather intelligence dashboard built around a simple idea:
            raw numbers don&apos;t tell you whether <em>today</em> is good for your run, your match,
            your farm, or your telescope. We decode meteorology into intent.
          </p>
          <p>
            Every score updates with every refresh of the forecast, drawing from a transparent
            blend of temperature, precipitation, wind, humidity, cloud cover, UV, and lunar data.
            No black boxes, no paywalls.
          </p>
        </section>

        <section className="mt-10">
          <h2 className="text-xs font-medium uppercase tracking-wider text-ink-muted">Tech Stack</h2>
          <div className="mt-3 flex flex-wrap gap-2">
            {STACK.map((s) => (
              <span key={s} className="rounded-full border border-surface-border bg-surface-raised/60 px-3 py-1 text-xs font-medium">
                {s}
              </span>
            ))}
          </div>
        </section>

        <section className="mt-10 rounded-2xl border border-surface-border bg-surface-raised/60 p-6">
          <h2 className="text-xs font-medium uppercase tracking-wider text-ink-muted">Data Attribution</h2>
          <p className="mt-2 text-sm text-ink-secondary">
            Weather data by <a className="text-ink-primary underline-offset-2 hover:underline" href="https://open-meteo.com" target="_blank" rel="noreferrer">Open-Meteo</a>.
            Map tiles by <a className="text-ink-primary underline-offset-2 hover:underline" href="https://carto.com" target="_blank" rel="noreferrer">CARTO</a>.
          </p>
          <p className="mt-4 text-xs text-ink-muted">Built by Waleed · <a className="hover:text-ink-primary" href="#">GitHub</a></p>
        </section>
      </div>
      <Footer />
    </main>
  );
}
CLIMATRIX_EOF

ok "about page written"

# ════════════════════════════════════════════════════════════════════════════
# APP — LOCATION DETAIL
# ════════════════════════════════════════════════════════════════════════════

log "Writing app/location/[lat]/[lon]/page.tsx…"

cat << 'CLIMATRIX_EOF' > "app/location/[lat]/[lon]/page.tsx"
'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { ArrowLeft } from 'lucide-react';
import { getWeather } from '@/lib/openMeteo';
import type { WeatherBundle } from '@/types/weather';
import { CurrentWeather } from '@/components/panel/CurrentWeather';
import { WeatherStatGrid } from '@/components/panel/WeatherStatGrid';
import { HourlyChart } from '@/components/panel/HourlyChart';
import { DailyForecast } from '@/components/panel/DailyForecast';
import { ActivityScores } from '@/components/panel/ActivityScores';
import { SunMoonInfo } from '@/components/panel/SunMoonInfo';
import { Skeleton } from '@/components/ui/Skeleton';
import { Footer } from '@/components/layout/Footer';

export default function LocationDetailPage({ params }: { params: { lat: string; lon: string } }) {
  const lat = parseFloat(params.lat);
  const lon = parseFloat(params.lon);
  const [data, setData] = useState<WeatherBundle | null>(null);

  useEffect(() => {
    if (Number.isNaN(lat) || Number.isNaN(lon)) return;
    getWeather(lat, lon).then(setData).catch(() => setData(null));
  }, [lat, lon]);

  return (
    <main className="min-h-screen pt-24">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <Link href="/" className="inline-flex items-center gap-1.5 text-xs text-ink-muted hover:text-ink-primary">
          <ArrowLeft size={12} /> Back to map
        </Link>
        <header className="mt-4 mb-8">
          <p className="text-xs uppercase tracking-[0.2em] text-ink-muted">Detailed view</p>
          <h1 className="mt-1 text-3xl font-semibold tracking-tight sm:text-4xl font-mono">
            {lat.toFixed(4)}, {lon.toFixed(4)}
          </h1>
        </header>

        {!data && (
          <div className="space-y-4">
            <Skeleton className="h-48" />
            <Skeleton className="h-32" />
          </div>
        )}

        {data && (
          <div className="grid grid-cols-1 gap-5 lg:grid-cols-[1fr_360px]">
            <div className="space-y-5">
              <CurrentWeather data={data} />
              <WeatherStatGrid data={data} />
              <HourlyChart data={data} />
              <DailyForecast data={data} />
              <SunMoonInfo data={data} />
            </div>
            <div className="space-y-5 lg:sticky lg:top-24 lg:self-start">
              <ActivityScores data={data} />
            </div>
          </div>
        )}
      </div>
      <Footer />
    </main>
  );
}
CLIMATRIX_EOF

ok "location detail written"

# ════════════════════════════════════════════════════════════════════════════
# PUBLIC ASSETS & README
# ════════════════════════════════════════════════════════════════════════════

log "Writing favicon and README…"

cat << 'CLIMATRIX_EOF' > public/favicon.svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <defs>
    <linearGradient id="g" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#22D3EE"/>
      <stop offset="50%" stop-color="#A855F7"/>
      <stop offset="100%" stop-color="#EC4899"/>
    </linearGradient>
  </defs>
  <rect x="6" y="6" width="52" height="52" rx="14" fill="#0F0F14"/>
  <circle cx="32" cy="32" r="14" fill="url(#g)"/>
  <circle cx="32" cy="32" r="6" fill="#0F0F14"/>
</svg>
CLIMATRIX_EOF

cat << 'CLIMATRIX_EOF' > README.md
# CLIMATRIX

> Weather, decoded. Ultra-premium weather intelligence dashboard.

CLIMATRIX is an interactive, full-screen weather platform that turns raw meteorological data into actionable intent.

## Features

- Interactive MapLibre map with dark + light CARTO tiles
- Click any point on Earth for instant weather
- Command-palette search powered by Open-Meteo Geocoding
- 24-hour temperature chart + 7-day forecast
- Six activity scores (Cricket, Solar, Running, Farming, Picnic, Stargazing)
- Moon phase, sunrise / sunset, daylight duration
- Favorites with live previews, persisted to localStorage
- Dark + light theme with custom design tokens

## Tech Stack

Next.js 14, TypeScript, Tailwind CSS, Framer Motion, Recharts, MapLibre GL, Zustand, Open-Meteo.

## Local Setup

    npm install
    npm run dev

Open http://localhost:3000

## Data Attribution

- Weather: Open-Meteo
- Map tiles: CARTO

Built by Waleed.
CLIMATRIX_EOF

ok "public assets written"

# ════════════════════════════════════════════════════════════════════════════
# FINAL NPM INSTALL
# ════════════════════════════════════════════════════════════════════════════

log "Reconciling dependencies (npm install)…"
npm install --silent
ok "Dependencies reconciled"

echo ""
echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${RESET}"
echo -e "${PURPLE}║${RESET}   ${CYAN}CLIMATRIX build complete.${RESET}                       ${PURPLE}║${RESET}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "Start the dev server with:  ${CYAN}npm run dev${RESET}"
echo -e "Then open:                  ${CYAN}http://localhost:3000${RESET}"
echo ""