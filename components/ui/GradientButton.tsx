'use client';
import { cn } from '@/lib/utils';
import type { ButtonHTMLAttributes, ReactNode } from 'react';

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  variant?: 'gradient' | 'ghost' | 'outline';
}

export function GradientButton({ children, className, variant = 'gradient', ...rest }: Props) {
  return (
    <button
      className={cn(
        'inline-flex items-center justify-center gap-2 rounded-lg px-4 py-2 text-sm font-medium',
        'transition-all duration-200 hover:scale-[1.02] active:scale-[0.98]',
        'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-purple/60',
        variant === 'gradient' && 'text-white bg-brand-gradient shadow-brand-glow',
        variant === 'ghost'    && 'text-ink-primary hover:bg-surface-hover',
        variant === 'outline'  && 'border border-surface-border text-ink-primary hover:border-brand-purple/50',
        className
      )}
      {...rest}
    >
      {children}
    </button>
  );
}
