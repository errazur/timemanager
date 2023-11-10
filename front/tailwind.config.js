/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        beige: "#FCF5ED",
        orange: "#F4BF96",
        red: "#CE5A67",
        black: "#1F1717",
      },
      backgroundImage: {
        backgroundLogin: 'url("/src/assets/images/backgroundLogin.jpg")',
      },
    },
    fontFamily: {
      sans: ["Gotham", "sans-serif"],
    },
  },
  plugins: [
    require('autoprefixer'),
  ],
};
