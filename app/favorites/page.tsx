'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Star, Trash2, MapPin } from 'lucide-react';
import { useWeatherStore } from '@/store/useWeatherStore';
import { getWeather } from '@/lib/openMeteo';
import { describeWeather } from '@/lib/weatherCodes';
import { computeAllScores } from '@/lib/scores';
import { Skeleton } from '@/components/ui/Skeleton';
import { GradientText } from '@/components/ui/GradientText';
import { Footer } from '@/components/layout/Footer';

interface FavData { temp: number; code: number; topScore: { emoji: string; name: string; score: number } }

export default function FavoritesPage() {
  const { favorites, removeFavorite, setLocation } = useWeatherStore();
  const router = useRouter();
  const [data, setData] = useState<Record<string, FavData | null>>({});

  useEffect(() => {
    favorites.forEach(async (f) => {
      const key = `${f.lat},${f.lon}`;
      if (data[key]) return;
      try {
        const w = await getWeather(f.lat, f.lon);
        const scores = computeAllScores(w);
        const top = scores.reduce((a, b) => (b.result.score > a.result.score ? b : a));
        setData((d) => ({ ...d, [key]: { temp: w.current.temperature, code: w.current.weatherCode,
          topScore: { emoji: top.emoji, name: top.name, score: top.result.score } } }));
      } catch {
        setData((d) => ({ ...d, [key]: null }));
      }
    });
  }, [favorites, data]);

  const open = (lat: number, lon: number, name: string, country: string) => {
    setLocation({ lat, lon, name, country });
    router.push('/');
  };

  return (
    <main className="min-h-screen pt-24">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <header className="mb-8">
          <p className="text-xs uppercase tracking-[0.2em] text-ink-muted">Saved locations</p>
          <h1 className="mt-1 text-3xl font-semibold tracking-tight sm:text-4xl">
            <GradientText>Favorites</GradientText>
          </h1>
        </header>

        {favorites.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-surface-border p-12 text-center">
            <Star size={36} className="mx-auto text-ink-muted" />
            <p className="mt-4 text-sm text-ink-secondary">No favorites yet.</p>
            <p className="text-xs text-ink-muted">Click the ⭐ button after exploring a location.</p>
            <Link href="/" className="mt-6 inline-flex items-center gap-2 rounded-lg bg-brand-gradient px-4 py-2 text-xs font-medium text-white shadow-brand-glow">
              Open the map
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {favorites.map((f) => {
              const key = `${f.lat},${f.lon}`;
              const d = data[key];
              const meta = d ? describeWeather(d.code) : null;
              return (
                <div key={key} className="group relative overflow-hidden rounded-2xl border border-surface-border bg-surface-raised/60 p-5 transition-all hover:border-brand-purple/40 hover:shadow-brand-glow">
                  <button
                    aria-label="Remove"
                    onClick={() => removeFavorite(f.lat, f.lon)}
                    className="absolute right-3 top-3 inline-flex h-7 w-7 items-center justify-center rounded-md text-ink-muted opacity-0 transition-opacity hover:bg-surface-hover hover:text-red-400 group-hover:opacity-100"
                  >
                    <Trash2 size={13} />
                  </button>
                  <button
                    onClick={() => open(f.lat, f.lon, f.name, f.country)}
                    className="block w-full text-left"
                  >
                    <p className="text-xs text-ink-muted inline-flex items-center gap-1.5"><MapPin size={11} /> {f.country}</p>
                    <h3 className="mt-1 text-xl font-semibold tracking-tight">{f.name}</h3>
                    <p className="font-mono text-[10px] text-ink-muted">{f.lat.toFixed(2)}, {f.lon.toFixed(2)}</p>
                    <div className="mt-4 flex items-center justify-between">
                      {d === undefined ? (
                        <Skeleton className="h-10 w-20" />
                      ) : d ? (
                        <div className="font-mono text-3xl text-ink-primary">{Math.round(d.temp)}°</div>
                      ) : (
                        <span className="text-xs text-ink-muted">—</span>
                      )}
                      {meta && <meta.Icon size={32} className="text-ink-primary/70" strokeWidth={1.25} />}
                    </div>
                    {d && (
                      <div className="mt-3 inline-flex items-center gap-1.5 rounded-full border border-surface-border px-2.5 py-1 text-[10px]">
                        <span>{d.topScore.emoji}</span>
                        <span className="text-ink-secondary">{d.topScore.name}</span>
                        <span className="font-mono text-ink-primary">{d.topScore.score}</span>
                      </div>
                    )}
                  </button>
                </div>
              );
            })}
          </div>
        )}
      </div>
      <Footer />
    </main>
  );
}
