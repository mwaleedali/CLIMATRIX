import { Footer } from '@/components/layout/Footer';
import { GradientText } from '@/components/ui/GradientText';

const SCORES = [
  { emoji: '🏏', name: 'Cricket',     desc: 'How playable is the pitch right now?',
    factors: ['Temp 18–32°C → 30%', 'Rain prob next 6h <20% → 30%', 'Wind <25 km/h → 20%', 'Humidity <70% → 10%', 'Visibility >5 km → 10%'] },
  { emoji: '☀️', name: 'Solar Power',  desc: 'Expected photovoltaic yield for today.',
    factors: ['Cloud cover (inverted) → 50%', 'Daily UV max → 30%', 'Daylight duration → 20%'] },
  { emoji: '🏃', name: 'Running',     desc: 'Comfort and safety for outdoor runs.',
    factors: ['Feels-like 10–25°C → 40%', 'Rain prob <20% → 25%', 'Humidity <75% → 15%', 'UV <6 → 10%', 'Wind <30 km/h → 10%'] },
  { emoji: '🌾', name: 'Farming',     desc: 'Crop-friendly conditions, balanced rain.',
    factors: ['Temp 15–28°C → 30%', 'Precip 1–10 mm/day → 30%', 'Wind <25 km/h → 20%', 'Humidity 50–80% → 20%'] },
  { emoji: '🧺', name: 'Picnic',      desc: 'Pleasant outdoor weather for a meal.',
    factors: ['Temp 18–28°C → 30%', 'Rain prob <15% → 30%', 'Wind <20 km/h → 20%', 'Cloud <60% → 10%', 'UV <8 → 10%'] },
  { emoji: '🔭', name: 'Stargazing',  desc: 'Dark, clear, dry skies for astronomy.',
    factors: ['Cloud cover (inverted) → 50%', 'Moon illumination (inverted) → 30%', 'Humidity (inverted) → 20%'] },
];

export default function ScoresPage() {
  return (
    <main className="min-h-screen pt-24">
      <div className="mx-auto max-w-4xl px-4 sm:px-6">
        <header className="mb-12">
          <p className="text-xs uppercase tracking-[0.2em] text-ink-muted">Methodology</p>
          <h1 className="mt-1 text-4xl font-semibold tracking-tight sm:text-5xl">
            How <GradientText>CLIMATRIX</GradientText> scores your day
          </h1>
          <p className="mt-4 max-w-2xl text-sm leading-relaxed text-ink-secondary">
            Each activity score is a weighted composite of meteorological factors normalized to a 0–100 scale.
            Scores update with every forecast refresh and are computed entirely on-device.
          </p>
        </header>

        <div className="space-y-4">
          {SCORES.map((s) => (
            <section key={s.name} className="rounded-2xl border border-surface-border bg-surface-raised/60 p-6 transition-colors hover:border-brand-purple/40">
              <div className="flex items-start gap-4">
                <span className="text-3xl">{s.emoji}</span>
                <div className="flex-1">
                  <h2 className="text-lg font-semibold tracking-tight">{s.name}</h2>
                  <p className="text-sm text-ink-secondary">{s.desc}</p>
                  <ul className="mt-4 space-y-1.5 text-xs text-ink-secondary">
                    {s.factors.map((f) => (
                      <li key={f} className="font-mono">
                        <span className="text-brand-purple">▸</span> {f}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </section>
          ))}
        </div>

        <p className="mt-12 text-xs text-ink-muted">
          Label thresholds: 80+ Excellent · 60–79 Good · 40–59 Fair · 20–39 Poor · &lt;20 Bad
        </p>
      </div>
      <Footer />
    </main>
  );
}
