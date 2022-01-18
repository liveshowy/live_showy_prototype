const colors = require("tailwindcss/colors")

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
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
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
