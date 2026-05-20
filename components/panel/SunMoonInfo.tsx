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
        <div className="mt-2 flex items-center gap-2">
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
