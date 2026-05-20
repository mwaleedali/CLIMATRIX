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
