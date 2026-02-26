import { generateThemes } from './src/utils/themeHelpers';

// Simple color token palette
const c = {
  'full-transparent': 'transparent',

  black: {
    DEFAULT: '#000000',
    a05: 'rgba(0, 0, 0, 0.05)',
    a10: 'rgba(0, 0, 0, 0.1)',
    a30: 'rgba(0, 0, 0, 0.3)',
  },

  white: {
    DEFAULT: '#FFFFFF',
    a05: 'rgba(255, 255, 255, 0.05)',
    a10: 'rgba(255, 255, 255, 0.1)',
  },

  neutral: {
    '0': '#FFFFFF',
    '5': 'rgb(250, 250, 250)',
    '10': '#FAFAFC',
    '25': '#EEEEEE',
    '88': 'rgb(82, 88, 96)',
    '100': '#dadde1',
    '180': 'rgb(180, 180, 180)',
    '200': '#CCCCCC',
    '300': '#333333',
    '400': '#47485A',
    '650': '#666666',
    '675': '#47484A',
    '770': '#606770',
    '800': '#27272A',
    '900': 'rgb(24, 25, 26)',
    '930': '#2E3033',
    '980': '#18181B',
    '1000': '#333436',
  },

  blue: {
    '24': '#002442',
    '39': '#003A69',
    '229': '#2297F6',
    '400': '#007AFF',
    '0': '#C9E7FF',
  },

  purple: {
    '166': '#461e66',
    '257': '#53257a',
    '283': '#5c2883',
    '400': '#8B5CF6',
    '478': '#A78BFA',
    '539': '#7539a3',
    '672': '#672d92',
    '739': '#7a3fa6',
    '782': '#a782cd',
    '800': '#F3E8FF',
    '834': '#8346ac',
    '964': '#9b64bb',
    '969': '#9b6fc4',
    '981': '#C981DF',
    '0': '#bea0db',
    '1': '#2D1B3D',
    '7': '#7C3AAD',
    '084': '#C084FC',
  },

  red: {
    '3': '#FE3B4C',
    '5': '#FFE5E7',
    '29': '#3D2A29',
    '450': '#FE3B4C',
  },

  yellow: {
    '0': '#492B00',
    '3': '#663B00',
    '27': '#FAF2E7',
    '534': '#F5A534',
  },

  green: {
    '0': '#00A902',
    '1': '#1B271F',
    '6': '#e6f7e6',
    '259': '#259F4C',
    '500': '#259F4C',
  },

  shadow: {
    'card-light': 'rgba(0, 0, 0, 0.1)',
    'card-hover-light': 'rgba(103, 45, 146, 0.2)',
    'card-dark': 'rgba(0, 0, 0, 0.3)',
    'card-hover-dark': 'rgba(92, 40, 131, 0.3)',
  },

  // Brand is the exception to the simple color structure
  brand: {
    primary: '#007AFF',
  },
} as const;

type ExtractTokens<T> = T extends string ? T : T extends object ? ExtractTokens<T[keyof T]> : never;
type ValidToken = ExtractTokens<typeof c>;
type ThemeConfig = {
  [key: string]: ValidToken | [ValidToken, ValidToken] | ThemeConfig;
};

// Theme token configuration - generates dark and light themes
const themeTokens: ThemeConfig = {
  primary: {
    DEFAULT: [c.purple['981'], c.blue['400']],
    dark: [c.purple['834'], c.purple['283']],
    darker: [c.purple['739'], c.purple['257']],
    darkest: [c.purple['672'], c.purple['166']],
    light: [c.purple['969'], c.purple['539']],
    lighter: [c.purple['782'], c.purple['834']],
    lightest: [c.purple['0'], c.purple['964']],
  },
  border: {
    primary: [c.neutral['1000'], c.neutral['200']],
    control: [c.neutral['800'], c.neutral['200']],
    sidebar: [c.neutral['770'], c.neutral['100']],
    specific: {
      interactive: {
        outline: [c.neutral['675'], c.neutral['200']],
      },
    },
  },
  background: {
    DEFAULT: [c.neutral['900'], c.neutral['0']],
    'action-hover': [c.white.a05, c.black.a05],
    primary: [c.neutral['930'], c.neutral['25']],
  },
  surface: {
    DEFAULT: c.neutral['5'],
    elevated: [c.neutral['800'], c.neutral['0']],
    navigation: [c.neutral['980'], c.neutral['10']],
    control: [c.neutral['800'], c.white.DEFAULT],
  },
  text: {
    primary: [c.white.DEFAULT, c.neutral['300']],
    secondary: [c.neutral['180'], c.neutral['88']],
    tertiary: [c.neutral['200'], c.neutral['300']],
    quaternary: [c.neutral['300'], c.neutral['650']],
    accent: [c.purple['981'], c.blue['400']],
    'accent-secondary': [c.white.DEFAULT, c.blue['400']],
    contrast: [c.white.DEFAULT, c.black.DEFAULT],
  },
  icon: {
    primary: [c.white.DEFAULT, c.neutral['400']],
  },
  info: {
    main: c.blue['229'],
    secondary: [c.blue['24'], c.blue['0']],
    border: [c.blue['39'], c.blue['229']],
  },
  advanced: {
    main: [c.purple['084'], c.purple['400']],
    secondary: [c.purple['1'], c.purple['800']],
    border: [c.purple['7'], c.purple['478']],
  },
  error: {
    main: c.red['3'],
    secondary: [c.red['29'], c.red['5']],
    border: c.red['3'],
  },
  warning: {
    main: c.yellow['534'],
    secondary: [c.yellow['0'], c.yellow['27']],
    border: [c.yellow['3'], c.yellow['534']],
  },
  success: {
    main: [c.green['259'], c.green['0']],
    primary: [c.green['500'], c.green['500']],
    secondary: [c.green['1'], c.green['6']],
    border: [c.green['259'], c.green['0']],
  },
  failed: {
    primary: [c.red['3'], c.red['450']],
    secondary: [c.red['450'], c.red['450']],
  },
  backgroundColor: {
    'collapse-btn': [c.white.a05, c['full-transparent']],
    'collapse-btn-hover': [c.white.a10, c.black.a10],
  },
};

// Generate dark and light themes from tokens
const themes = generateThemes(themeTokens);

export default {
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
      borderWidth: {
        1: '1px',
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
    },
  },

  plugins: [
    require('tailwindcss-themer')({
      defaultTheme: {
        extend: {
          colors: {
            ...c,
            ...themes.dark,
          },
          backgroundImage: {
            magical: 'linear-gradient(90deg, #672D92 0%, #5677C8 100%)',
          },
          boxShadow: {
            card: `0 4px 12px ${c.shadow['card-dark']}`,
            'card-hover': `0 4px 12px ${c.shadow['card-hover-dark']}`,
          },
        },
      },
      themes: [
        {
          name: 'lightTheme',
          selectors: ['[data-theme="light"]', '[data-theme="lightTheme"]'],
          extend: {
            colors: {
              ...themes.light,
            },
            backgroundImage: {
              magical: 'linear-gradient(90deg, #3676f7 0%, #cc22f2 100%)',
            },
            boxShadow: {
              card: `0 4px 12px ${c.shadow['card-light']}`,
              'card-hover': `0 4px 12px ${c.shadow['card-hover-light']}`,
            },
          },
        },
        {
          name: 'darkTheme',
          selectors: ['[data-theme="dark"]', '[data-theme="darkTheme"]'],
          extend: {},
        },
      ],
    }),
  ],

  corePlugins: {
    preflight: false,
  },
};
