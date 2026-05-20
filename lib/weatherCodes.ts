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
