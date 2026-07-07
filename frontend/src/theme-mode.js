import { createContext, useContext } from 'react'

export const ThemeModeContext = createContext({
  themeMode: 'maple',
  toggleThemeMode: () => {},
})

export function useThemeMode() {
  return useContext(ThemeModeContext)
}
