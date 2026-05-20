'use client';
import { useEffect, useRef } from 'react';
import maplibregl from 'maplibre-gl';
import { useWeatherStore } from '@/store/useWeatherStore';

const STYLES = {
  dark:  'https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json',
  light: 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json',
};

export function WeatherMap() {
  const ref = useRef<HTMLDivElement>(null);
  const mapRef = useRef<maplibregl.Map | null>(null);
  const markerRef = useRef<maplibregl.Marker | null>(null);

  const { selectedLocation, mapStyle, setLocation } = useWeatherStore();

  useEffect(() => {
    if (!ref.current || mapRef.current) return;
    const map = new maplibregl.Map({
      container: ref.current,
      style: STYLES[mapStyle],
      center: [30, 20],
      zoom: 2,
      attributionControl: { compact: true },
      dragRotate: false,
      pitchWithRotate: false,
    });
    map.touchZoomRotate.disableRotation();
    map.addControl(new maplibregl.NavigationControl({ showCompass: false }), 'bottom-right');
    map.on('click', (e) => {
      setLocation({ lat: e.lngLat.lat, lon: e.lngLat.lng });
    });
    mapRef.current = map;
    return () => { map.remove(); mapRef.current = null; };
  }, [setLocation, mapStyle]);

  useEffect(() => {
    const m = mapRef.current;
    if (!m) return;
    m.setStyle(STYLES[mapStyle]);
  }, [mapStyle]);

  useEffect(() => {
    const m = mapRef.current;
    if (!m || !selectedLocation) return;

    if (markerRef.current) markerRef.current.remove();
    const el = document.createElement('div');
    el.className = 'climatrix-marker';
    markerRef.current = new maplibregl.Marker({ element: el })
      .setLngLat([selectedLocation.lon, selectedLocation.lat])
      .addTo(m);

    m.flyTo({
      center: [selectedLocation.lon, selectedLocation.lat],
      zoom: Math.max(m.getZoom(), 6),
      speed: 0.9, curve: 1.4, essential: true,
    });
  }, [selectedLocation]);

  return (
    <div ref={ref} className="absolute inset-0 h-full w-full">
      <div className="pointer-events-none absolute inset-x-0 top-0 h-24 bg-gradient-to-b from-surface-base/80 to-transparent" />
      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-24 bg-gradient-to-t from-surface-base/60 to-transparent" />
    </div>
  );
}
