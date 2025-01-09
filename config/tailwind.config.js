const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
<<<<<<< HEAD
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*",
=======
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
>>>>>>> dce5913b36f398dcdd2856307cc9fbe16fc33cbb
  ],
  theme: {
    extend: {
      fontFamily: {
<<<<<<< HEAD
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
=======
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
>>>>>>> dce5913b36f398dcdd2856307cc9fbe16fc33cbb
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
<<<<<<< HEAD
  ],
};
=======
  ]
}
>>>>>>> dce5913b36f398dcdd2856307cc9fbe16fc33cbb
