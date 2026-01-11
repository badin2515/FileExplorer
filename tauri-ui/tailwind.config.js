/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "#09090b", // Zinc 950
        surface: "#18181b",    // Zinc 900
        primary: "#8b5cf6",    // Violet 500
        secondary: "#27272a",  // Zinc 800
        text: "#e4e4e7",       // Zinc 200
        muted: "#a1a1aa",      // Zinc 400
      }
    },
  },
  plugins: [],
}
