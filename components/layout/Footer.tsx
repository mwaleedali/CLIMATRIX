export function Footer() {
  return (
    <footer className="border-t border-surface-border py-6 text-center text-xs text-ink-muted">
      <p>
        Weather data by{' '}
        <a className="underline-offset-2 hover:text-ink-primary hover:underline" href="https://open-meteo.com" target="_blank" rel="noreferrer">
          Open-Meteo
        </a>{' '}· Tiles by{' '}
        <a className="underline-offset-2 hover:text-ink-primary hover:underline" href="https://carto.com" target="_blank" rel="noreferrer">
          CARTO
        </a>{' '}· Built by Waleed
      </p>
    </footer>
  );
}
