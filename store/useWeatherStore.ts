import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import type { LayerKey } from '@/types/weather';

export interface Favorite { lat: number; lon: number; name: string; country: string; }
export interface SelectedLocation { lat: number; lon: number; name?: string; country?: string; }

interface UnitState { temperature: 'C' | 'F'; wind: 'kmh' | 'mph'; pressure: 'hPa' | 'inHg'; }

interface WeatherStore {
  selectedLocation: SelectedLocation | null;
  activeLayer: LayerKey;
  mapStyle: 'dark' | 'light';
  units: UnitState;
  favorites: Favorite[];
  recentSearches: Favorite[];

  setLocation: (l: SelectedLocation | null) => void;
  setActiveLayer: (l: LayerKey) => void;
  setMapStyle: (s: 'dark' | 'light') => void;
  toggleUnit: (k: keyof UnitState) => void;
  addFavorite: (f: Favorite) => void;
  removeFavorite: (lat: number, lon: number) => void;
  isFavorite: (lat: number, lon: number) => boolean;
  pushRecent: (f: Favorite) => void;
}

export const useWeatherStore = create<WeatherStore>()(
  persist(
    (set, get) => ({
      selectedLocation: null,
      activeLayer: 'temperature',
      mapStyle: 'dark',
      units: { temperature: 'C', wind: 'kmh', pressure: 'hPa' },
      favorites: [],
      recentSearches: [],

      setLocation: (l) => set({ selectedLocation: l }),
      setActiveLayer: (l) => set({ activeLayer: l }),
      setMapStyle: (s) => set({ mapStyle: s }),
      toggleUnit: (k) =>
        set((s) => ({
          units: {
            ...s.units,
            [k]:
              k === 'temperature' ? (s.units.temperature === 'C' ? 'F' : 'C') :
              k === 'wind'        ? (s.units.wind        === 'kmh' ? 'mph' : 'kmh') :
                                    (s.units.pressure    === 'hPa' ? 'inHg' : 'hPa'),
          },
        })),
      addFavorite: (f) =>
        set((s) =>
          s.favorites.find((x) => x.lat === f.lat && x.lon === f.lon)
            ? s
            : { favorites: [...s.favorites, f] }
        ),
      removeFavorite: (lat, lon) =>
        set((s) => ({ favorites: s.favorites.filter((x) => x.lat !== lat || x.lon !== lon) })),
      isFavorite: (lat, lon) => !!get().favorites.find((f) => f.lat === lat && f.lon === lon),
      pushRecent: (f) =>
        set((s) => {
          const filtered = s.recentSearches.filter((x) => x.lat !== f.lat || x.lon !== f.lon);
          return { recentSearches: [f, ...filtered].slice(0, 5) };
        }),
    }),
    {
      name: 'climatrix:store',
      storage: createJSONStorage(() => (typeof window !== 'undefined' ? localStorage : (undefined as never))),
      partialize: (s) => ({
        units: s.units, favorites: s.favorites, mapStyle: s.mapStyle, recentSearches: s.recentSearches,
      }),
    }
  )
);
