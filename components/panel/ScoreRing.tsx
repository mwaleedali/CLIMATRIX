'use client';
import { motion } from 'framer-motion';

export function ScoreRing({ value, color, size = 56, stroke = 6 }: { value: number; color: string; size?: number; stroke?: number }) {
  const r = (size - stroke) / 2;
  const C = 2 * Math.PI * r;
  const offset = C - (value / 100) * C;
  const id = `g-${Math.round(value)}-${color.slice(1)}`;

  return (
    <svg width={size} height={size} className="-rotate-90">
      <defs>
        <linearGradient id={id} x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor="#22D3EE" />
          <stop offset="50%" stopColor="#A855F7" />
          <stop offset="100%" stopColor="#EC4899" />
        </linearGradient>
      </defs>
      <circle cx={size/2} cy={size/2} r={r} stroke="currentColor" className="text-surface-border" strokeWidth={stroke} fill="none" />
      <motion.circle
        cx={size/2} cy={size/2} r={r}
        stroke={value >= 60 ? `url(#${id})` : color}
        strokeWidth={stroke} strokeLinecap="round" fill="none"
        strokeDasharray={C}
        initial={{ strokeDashoffset: C }}
        animate={{ strokeDashoffset: offset }}
        transition={{ duration: 1.0, ease: [0.22, 1, 0.36, 1] }}
      />
    </svg>
  );
}
