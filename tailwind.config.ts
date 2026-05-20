import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: 'class',
  content: ['./app/**/*.{ts,tsx}', './components/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        brand: {
          cyan:   '#22D3EE',
          purple: '#A855F7',
          pink:   '#EC4899',
        },
        surface: {
          base:     'var(--surface-base)',
          raised:   'var(--surface-raised)',
          elevated: 'var(--surface-elevated)',
          border:   'var(--surface-border)',
          hover:    'var(--surface-hover)',
        },
        ink: {
          primary:   'var(--ink-primary)',
          secondary: 'var(--ink-secondary)',
          muted:     'var(--ink-muted)',
        },
      },
      fontFamily: {
        sans: ['var(--font-inter)', 'system-ui', 'sans-serif'],
        mono: ['var(--font-jetbrains-mono)', 'ui-monospace', 'monospace'],
      },
      backgroundImage: {
        'brand-gradient': 'linear-gradient(135deg, #22D3EE 0%, #A855F7 50%, #EC4899 100%)',
        'brand-radial':   'radial-gradient(circle at top left, rgba(34,211,238,0.15), transparent 50%), radial-gradient(circle at bottom right, rgba(236,72,153,0.12), transparent 50%)',
      },
      boxShadow: {
        'glass-dark':  '0 8px 32px rgba(0,0,0,0.4)',
        'glass-light': '0 8px 32px rgba(0,0,0,0.08)',
        'brand-glow':  '0 0 40px -10px rgba(168,85,247,0.5)',
      },
      animation: {
        'pulse-slow':  'pulse 3s cubic-bezier(0.4,0,0.6,1) infinite',
        'fade-in':     'fadeIn 0.4s ease-out',
        'slide-up':    'slideUp 0.5s cubic-bezier(0.22,1,0.36,1)',
        'shimmer':     'shimmer 2.4s linear infinite',
        'gradient-x':  'gradientX 8s ease infinite',
      },
      keyframes: {
        fadeIn:    { '0%': { opacity: '0' }, '100%': { opacity: '1' } },
        slideUp:   { '0%': { opacity: '0', transform: 'translateY(8px)' }, '100%': { opacity: '1', transform: 'translateY(0)' } },
        shimmer:   { '0%': { backgroundPosition: '-200% 0' }, '100%': { backgroundPosition: '200% 0' } },
        gradientX: { '0%,100%': { backgroundPosition: '0% 50%' }, '50%': { backgroundPosition: '100% 50%' } },
      },
    },
  },
  plugins: [],
};
export default config;
