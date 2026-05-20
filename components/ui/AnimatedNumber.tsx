'use client';
import { motion, useMotionValue, useTransform, animate } from 'framer-motion';
import { useEffect } from 'react';

export function AnimatedNumber({
  value, decimals = 0, suffix = '', duration = 0.8,
}: { value: number; decimals?: number; suffix?: string; duration?: number }) {
  const mv = useMotionValue(0);
  const rounded = useTransform(mv, (latest) => latest.toFixed(decimals));

  useEffect(() => {
    const controls = animate(mv, value, { duration, ease: [0.22, 1, 0.36, 1] });
    return () => controls.stop();
  }, [value, duration, mv]);

  return (
    <span className="tabular-nums font-mono">
      <motion.span>{rounded}</motion.span>{suffix}
    </span>
  );
}
