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
