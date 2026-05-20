'use client';
import dynamic from 'next/dynamic';
import { LayerSwitcher } from '@/components/map/LayerSwitcher';
import { MapStyleToggle } from '@/components/map/MapStyleToggle';
import { LocationPanel } from '@/components/panel/LocationPanel';
import { useWeatherStore } from '@/store/useWeatherStore';
import { AnimatePresence, motion } from 'framer-motion';
import { GradientText } from '@/components/ui/GradientText';
import { MousePointerClick } from 'lucide-react';

const WeatherMap = dynamic(() => import('@/components/map/WeatherMap').then((m) => m.WeatherMap), {
  ssr: false,
  loading: () => <div className="absolute inset-0 bg-surface-base brand-grid opacity-50" />,
});

export default function Page() {
  const selectedLocation = useWeatherStore((s) => s.selectedLocation);

  return (
    <main className="relative h-screen w-screen overflow-hidden pt-16">
      <WeatherMap />

      <AnimatePresence>
        {!selectedLocation && (
          <motion.div
            initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: 12 }}
            transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] }}
            className="pointer-events-none absolute inset-0 z-20 flex items-center justify-center px-6"
          >
            <div className="pointer-events-auto max-w-md text-center">
              <div className="mx-auto mb-5 flex justify-center"><span className="pulse-dot" /></div>
              <h1 className="text-5xl font-semibold tracking-tight sm:text-6xl">
                <GradientText>CLIMATRIX</GradientText>
              </h1>
              <p className="mt-3 text-sm tracking-[0.18em] uppercase text-ink-secondary">
                Weather, decoded.
              </p>
              <p className="mt-6 inline-flex items-center gap-2 rounded-full border border-surface-border bg-surface-raised/60 px-4 py-1.5 text-xs text-ink-secondary backdrop-blur-xl">
                <MousePointerClick size={12} /> Click anywhere on the map or press <kbd className="font-mono">⌘K</kbd>
              </p>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      <div className="pointer-events-none absolute left-4 top-20 z-30">
        <LayerSwitcher />
      </div>

      <div className="pointer-events-none absolute bottom-6 left-4 z-30">
        <MapStyleToggle />
      </div>

      <LocationPanel />
    </main>
  );
}
