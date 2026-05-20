'use client';
import { useEffect, useRef, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { Search, Clock, MapPin } from 'lucide-react';
import { searchLocations } from '@/lib/openMeteo';
import type { GeoResult } from '@/types/weather';
import { useWeatherStore } from '@/store/useWeatherStore';
import { countryFlag } from '@/lib/utils';

export function SearchCommand({ open, onClose }: { open: boolean; onClose: () => void }) {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<GeoResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [activeIdx, setActiveIdx] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const { setLocation, recentSearches, pushRecent } = useWeatherStore();

  useEffect(() => {
    if (open) setTimeout(() => inputRef.current?.focus(), 50);
    else { setQuery(''); setResults([]); setActiveIdx(0); }
  }, [open]);

  useEffect(() => {
    const q = query.trim();
    if (q.length < 2) { setResults([]); return; }
    setLoading(true);
    const t = setTimeout(async () => {
      const r = await searchLocations(q);
      setResults(r); setActiveIdx(0); setLoading(false);
    }, 250);
    return () => clearTimeout(t);
  }, [query]);

  const pick = (r: { lat: number; lon: number; name: string; country: string }) => {
    setLocation({ lat: r.lat, lon: r.lon, name: r.name, country: r.country });
    pushRecent(r);
    onClose();
  };

  const list = results.length
    ? results.map((r) => ({ lat: r.latitude, lon: r.longitude, name: r.name, country: r.country, admin: r.admin1, code: r.country_code }))
    : query.length < 2
      ? recentSearches.map((r) => ({ ...r, admin: undefined, code: undefined }))
      : [];

  const onKey = (e: React.KeyboardEvent) => {
    if (e.key === 'ArrowDown') { e.preventDefault(); setActiveIdx((i) => Math.min(i + 1, list.length - 1)); }
    if (e.key === 'ArrowUp')   { e.preventDefault(); setActiveIdx((i) => Math.max(i - 1, 0)); }
    if (e.key === 'Enter' && list[activeIdx]) pick(list[activeIdx]);
  };

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          className="fixed inset-0 z-50 flex items-start justify-center pt-[15vh] px-4"
          initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
          onClick={onClose}
        >
          <div className="absolute inset-0 bg-black/60 backdrop-blur-md" />
          <motion.div
            initial={{ opacity: 0, y: 12, scale: 0.98 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 12, scale: 0.98 }}
            transition={{ duration: 0.18, ease: [0.22, 1, 0.36, 1] }}
            onClick={(e) => e.stopPropagation()}
            className="relative w-full max-w-xl overflow-hidden rounded-2xl border border-surface-border bg-surface-elevated shadow-glass-dark"
          >
            <div className="flex items-center gap-3 border-b border-surface-border px-4 py-3">
              <Search size={16} className="text-ink-muted" />
              <input
                ref={inputRef}
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                onKeyDown={onKey}
                placeholder="Search for a city, town, or place…"
                className="w-full bg-transparent text-sm text-ink-primary placeholder:text-ink-muted focus:outline-none"
              />
              <kbd className="rounded border border-surface-border px-1.5 py-0.5 font-mono text-[10px] text-ink-muted">ESC</kbd>
            </div>

            <div className="max-h-[55vh] overflow-y-auto scroll-thin py-2">
              {loading && <div className="px-4 py-3 text-xs text-ink-muted">Searching…</div>}
              {!loading && list.length === 0 && (
                <div className="px-4 py-6 text-center text-xs text-ink-muted">
                  {query.length < 2 ? 'Start typing to search 200,000+ cities.' : 'No results.'}
                </div>
              )}
              {!loading && query.length < 2 && recentSearches.length > 0 && (
                <div className="px-4 pb-1 text-[10px] uppercase tracking-wider text-ink-muted">Recent</div>
              )}
              {list.map((r, i) => (
                <button
                  key={`${r.lat}-${r.lon}-${i}`}
                  onMouseEnter={() => setActiveIdx(i)}
                  onClick={() => pick(r)}
                  className={`flex w-full items-center justify-between gap-3 px-4 py-2.5 text-left text-sm transition-colors ${
                    i === activeIdx ? 'bg-surface-hover' : ''
                  }`}
                >
                  <span className="inline-flex items-center gap-2.5 min-w-0">
                    {query.length < 2 ? <Clock size={14} className="text-ink-muted" /> : <MapPin size={14} className="text-ink-muted" />}
                    <span className="truncate">
                      <span className="font-medium text-ink-primary">{r.name}</span>
                      {r.admin && <span className="text-ink-muted">, {r.admin}</span>}
                      <span className="text-ink-muted">, {r.country}</span>
                    </span>
                  </span>
                  <span className="shrink-0 inline-flex items-center gap-2 font-mono text-[10px] text-ink-muted">
                    {r.code && <span>{countryFlag(r.code)}</span>}
                    {r.lat.toFixed(2)}, {r.lon.toFixed(2)}
                  </span>
                </button>
              ))}
            </div>

            <div className="flex items-center justify-between border-t border-surface-border px-4 py-2 text-[10px] text-ink-muted">
              <span>↑↓ navigate · ↵ select</span>
              <span>Powered by Open-Meteo</span>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
