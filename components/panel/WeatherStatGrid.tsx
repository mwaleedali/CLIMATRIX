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
