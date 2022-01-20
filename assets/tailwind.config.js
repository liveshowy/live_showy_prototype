const colors = require("tailwindcss/colors")

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web/**/*.(*ex|sface)"],
  theme: {
    extend: {
      colors: {
        brand: colors.violet,
        success: colors.emerald,
        warning: colors.orange,
        danger: colors.rose,
        info: colors.sky,
        gray: colors.stone,
      },
      boxShadow: {
        "inner-lg": "inset 0 10px 10px -5px rgb(0 0 0 / 0.1), inset 0 -10px 10px -5px rgb(0 0 0 / 0.1)"
      },
      keyframes: {
        'fade-in': {
          from: {opacity: 0},
          to: {opacity: 100},
        },
        'fade-in-slide-down': {
          from: { opacity: 0, transform: 'translateY(-0.2rem)'},
          to: { opacity: 1, transform: 'initial'},
        },
      },
      animation: {
        'fade-in': 'fade-in 500ms ease-in-out',
        'fade-in-slide-down': 'fade-in-slide-down 250ms ease-in-out',
        'fade-out-slide-up': 'fade-in-slide-down 100ms ease-in-out reverse',
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
