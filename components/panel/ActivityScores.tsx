'use client';
import { useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { ChevronDown } from 'lucide-react';
import type { WeatherBundle } from '@/types/weather';
import { computeAllScores } from '@/lib/scores';
import { ScoreRing } from './ScoreRing';

export function ActivityScores({ data }: { data: WeatherBundle }) {
  const scores = computeAllScores(data);
  const [open, setOpen] = useState<string | null>(null);

  return (
    <div className="rounded-xl border border-surface-border bg-surface-raised/60 p-4">
      <h3 className="mb-3 text-xs font-medium uppercase tracking-wider text-ink-muted">Activity Scores</h3>
      <div className="divide-y divide-surface-border/60">
        {scores.map(({ key, emoji, name, result }) => {
          const isOpen = open === key;
          return (
            <button
              key={key}
              onClick={() => setOpen(isOpen ? null : key)}
              className="group flex w-full flex-col py-3 text-left transition-colors"
            >
              <div className="flex items-center gap-3">
                <ScoreRing value={result.score} color={result.color} />
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium text-ink-primary">{emoji} {name}</span>
                    <ChevronDown size={14} className={`text-ink-muted transition-transform ${isOpen ? 'rotate-180' : ''}`} />
                  </div>
                  <div className="mt-1 flex items-baseline gap-2">
                    <span className="font-mono text-xl text-ink-primary">{result.score}</span>
                    <span className="text-[10px] uppercase tracking-wider" style={{ color: result.color }}>{result.label}</span>
                  </div>
                </div>
              </div>
              <AnimatePresence initial={false}>
                {isOpen && (
                  <motion.ul
                    initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: 'auto' }} exit={{ opacity: 0, height: 0 }}
                    className="ml-[68px] mt-2 space-y-1 overflow-hidden text-xs text-ink-secondary"
                  >
                    {result.reasons.map((r, i) => (
                      <li key={i} className="flex items-start gap-2">
                        <span className="mt-1.5 inline-block h-1 w-1 shrink-0 rounded-full" style={{ background: result.color }} />
                        {r}
                      </li>
                    ))}
                  </motion.ul>
                )}
              </AnimatePresence>
            </button>
          );
        })}
      </div>
    </div>
  );
}
