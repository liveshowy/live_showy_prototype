module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      boxShadow: {
        "inner-lg": "inset 0 10px 10px -5px rgb(0 0 0 / 0.1)"
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require("@tailwindcss/aspect-ratio"),
  ],
}
