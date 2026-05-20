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
