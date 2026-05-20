import { Footer } from '@/components/layout/Footer';
import { GradientText } from '@/components/ui/GradientText';

const STACK = [
  'Next.js 14','TypeScript','Tailwind CSS','Framer Motion',
  'Recharts','MapLibre GL','Zustand','Open-Meteo','CARTO',
];

export default function AboutPage() {
  return (
    <main className="min-h-screen pt-24">
      <div className="mx-auto max-w-3xl px-4 sm:px-6">
        <header className="mb-10">
          <p className="text-xs uppercase tracking-[0.2em] text-ink-muted">About</p>
          <h1 className="mt-1 text-4xl font-semibold tracking-tight sm:text-5xl">
            <GradientText>CLIMATRIX</GradientText>
          </h1>
          <p className="mt-3 text-sm uppercase tracking-[0.18em] text-ink-secondary">Weather, decoded.</p>
        </header>

        <section className="space-y-5 text-sm leading-relaxed text-ink-secondary">
          <p>
            CLIMATRIX is an ultra-premium weather intelligence dashboard built around a simple idea:
            raw numbers don&apos;t tell you whether <em>today</em> is good for your run, your match,
            your farm, or your telescope. We decode meteorology into intent.
          </p>
          <p>
            Every score updates with every refresh of the forecast, drawing from a transparent
            blend of temperature, precipitation, wind, humidity, cloud cover, UV, and lunar data.
            No black boxes, no paywalls.
          </p>
        </section>

        <section className="mt-10">
          <h2 className="text-xs font-medium uppercase tracking-wider text-ink-muted">Tech Stack</h2>
          <div className="mt-3 flex flex-wrap gap-2">
            {STACK.map((s) => (
              <span key={s} className="rounded-full border border-surface-border bg-surface-raised/60 px-3 py-1 text-xs font-medium">
                {s}
              </span>
            ))}
          </div>
        </section>

        <section className="mt-10 rounded-2xl border border-surface-border bg-surface-raised/60 p-6">
          <h2 className="text-xs font-medium uppercase tracking-wider text-ink-muted">Data Attribution</h2>
          <p className="mt-2 text-sm text-ink-secondary">
            Weather data by <a className="text-ink-primary underline-offset-2 hover:underline" href="https://open-meteo.com" target="_blank" rel="noreferrer">Open-Meteo</a>.
            Map tiles by <a className="text-ink-primary underline-offset-2 hover:underline" href="https://carto.com" target="_blank" rel="noreferrer">CARTO</a>.
          </p>
          <p className="mt-4 text-xs text-ink-muted">Built by Waleed · <a className="hover:text-ink-primary" href="#">GitHub</a></p>
        </section>
      </div>
      <Footer />
    </main>
  );
}
