const themer = require('tailwindcss-themer');

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{js,jsx,ts,tsx,md,mdx}', './docs/**/*.{md,mdx}'],

  theme: {
    extend: {
      fontFamily: {
        geist: ['Geist', 'Arial', 'Helvetica', 'sans-serif'],
        sans: ['Geist', 'Arial', 'Helvetica', 'sans-serif'],
        'geist-mono': ['GeistMono', 'monospace'],
        mono: ['GeistMono', 'monospace'],
      },
      borderRadius: {
        DEFAULT: '8px',
      },
      spacing: {
        navbar: '3.75rem', // 60px - --ifm-navbar-height
        sidebar: '300px', // --doc-sidebar-width
      },
      width: {
        sidebar: '300px',
      },
      height: {
        navbar: '3.75rem',
      },
      minHeight: {
        navbar: '3.75rem',
      },
      maxHeight: {
        navbar: '3.75rem',
      },
      borderColor: {
        sidebar: '#dadde1', // light mode --ifm-toc-border-color
      },
      backgroundColor: {
        'collapse-btn': 'transparent',
        'collapse-btn-hover': 'rgba(0, 0, 0, 0.1)',
      },
    },
  },

  plugins: [
    themer({
      defaultTheme: {
        extend: {
          colors: {
            primary: {
              DEFAULT: '#007AFF',
              dark: '#5c2883',
              darker: '#53257a',
              darkest: '#461e66',
              light: '#7539a3',
              lighter: '#8346ac',
              lightest: '#9b64bb',
            },
            border: {
              primary: '#CCCCCC',
              control: '#CCCCCC',
            },
            background: 'rgb(255, 255, 255)',
            surface: {
              DEFAULT: 'rgb(250, 250, 250)',
              navigation: '#FAFAFC',
              control: '#ffffff',
            },
            text: {
              primary: '#333333',
              secondary: 'rgb(82, 88, 96)',
              tertiary: '#333333',
              accent: '#007AFF',
            },
            icon: {
              primary: '#47485A',
            },
          },
          boxShadow: {
            card: '0 4px 12px rgba(0, 0, 0, 0.1)',
            'card-hover': '0 4px 12px rgba(103, 45, 146, 0.2)',
          },
        },
      },
      themes: [
        {
          name: 'darkTheme',
          selectors: ['[data-theme="dark"]'],
          extend: {
            colors: {
              primary: {
                DEFAULT: '#C447EB',
                dark: '#8346ac',
                darker: '#7a3fa6',
                darkest: '#672d92',
                light: '#9b6fc4',
                lighter: '#a782cd',
                lightest: '#bea0db',
              },
              background: 'rgb(24, 25, 26)',
              border: {
                primary: '#333436',
                control: '#27272A',
              },
              surface: {
                DEFAULT: 'rgb(250, 250, 250)',
                navigation: '#18181B',
                control: '#27272A',
              },
              text: {
                primary: '#FFFFFF',
                secondary: 'rgb(180, 180, 180)',
                tertiary: '#CCCCCC',
                accent: '#C447EB',
              },
              icon: {
                primary: '#FFFFFF',
              },
            },
            borderColor: {
              sidebar: '#606770', // dark mode --ifm-toc-border-color
            },
            backgroundColor: {
              'collapse-btn': 'rgba(255, 255, 255, 0.05)',
              'collapse-btn-hover': 'rgba(255, 255, 255, 0.1)',
            },
            boxShadow: {
              card: '0 4px 12px rgba(0, 0, 0, 0.3)',
              'card-hover': '0 4px 12px rgba(92, 40, 131, 0.3)',
            },
          },
        },
      ],
    }),
  ],

  corePlugins: {
    preflight: false,
  },
};
