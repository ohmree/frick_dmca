module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js"
  ],
  darkMode: 'media', // or false or 'class'
  theme: {
    extend: {
      spacing: {
        128: '32rem'
      }
    }
  },
  variants: {
    extend: {}
  },
  plugins: []
};
