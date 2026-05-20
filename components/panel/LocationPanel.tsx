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
