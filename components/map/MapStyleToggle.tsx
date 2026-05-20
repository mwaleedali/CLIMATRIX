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
