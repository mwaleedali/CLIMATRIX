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
