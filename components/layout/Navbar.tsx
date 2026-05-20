'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Star, Info, Activity, LocateFixed } from 'lucide-react';
import { ThemeToggle } from './ThemeToggle';
import { SearchTrigger } from '@/components/search/SearchTrigger';
import { useWeatherStore } from '@/store/useWeatherStore';
import { cn } from '@/lib/utils';

export function Navbar() {
  const pathname = usePathname();
  const setLocation = useWeatherStore((s) => s.setLocation);

  const geolocate = () => {
    if (!navigator.geolocation) return;
    navigator.geolocation.getCurrentPosition(
      (pos) => setLocation({ lat: pos.coords.latitude, lon: pos.coords.longitude }),
      () => {}
    );
  };

  const link = (href: string, label: string, Icon: typeof Star) => (
    <Link
      href={href}
      className={cn(
        'inline-flex items-center gap-1.5 rounded-md px-2.5 py-1.5 text-xs font-medium transition-colors',
        pathname === href ? 'text-ink-primary bg-surface-hover' : 'text-ink-secondary hover:text-ink-primary hover:bg-surface-hover'
      )}
    >
      <Icon size={14} /> <span className="hidden sm:inline">{label}</span>
    </Link>
  );

  return (
    <header className="fixed inset-x-0 top-0 z-40 h-16 border-b border-surface-border/80 bg-surface-base/70 backdrop-blur-xl">
      <div className="mx-auto flex h-full max-w-[1600px] items-center justify-between px-4 sm:px-6">
        <Link href="/" className="group inline-flex items-center gap-2">
          <span className="relative inline-block h-2.5 w-2.5 rounded-full bg-brand-gradient shadow-brand-glow" />
          <span className="font-semibold tracking-[0.18em] text-sm">CLIMATRIX</span>
        </Link>

        <div className="hidden md:block w-[420px] max-w-[50vw]">
          <SearchTrigger />
        </div>

        <div className="flex items-center gap-1.5">
          <button
            aria-label="Use my location"
            onClick={geolocate}
            className="inline-flex h-9 w-9 items-center justify-center rounded-lg border border-surface-border bg-surface-raised/60 backdrop-blur-xl text-ink-secondary transition-all hover:text-ink-primary hover:border-brand-purple/40 hover:scale-[1.05]"
          >
            <LocateFixed size={16} />
          </button>
          {link('/favorites', 'Favorites', Star)}
          {link('/scores', 'Scores', Activity)}
          {link('/about', 'About', Info)}
          <ThemeToggle />
        </div>
      </div>
      <div className="md:hidden border-t border-surface-border/80 bg-surface-base/70 backdrop-blur-xl px-4 py-2">
        <SearchTrigger />
      </div>
    </header>
  );
}
