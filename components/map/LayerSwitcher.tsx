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
