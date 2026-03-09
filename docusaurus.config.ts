import { themes as prismThemes } from 'prism-react-renderer';
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'AI/Run CodeMie',
  tagline: 'AI-powered development platform documentation',
  favicon: 'img/favicon.svg',

  // Use environment variables for PR previews, fallback to production values
  url: process.env.DOCUSAURUS_URL || 'https://docs.codemie.ai',
  baseUrl: process.env.DOCUSAURUS_BASE_URL || '/',

  organizationName: 'codemie-ai',
  projectName: 'docs',

  onBrokenLinks: 'throw',
  onBrokenAnchors: 'throw',
  onDuplicateRoutes: 'throw',

  markdown: {
    mermaid: true,
    hooks: {
      onBrokenMarkdownLinks: 'warn',
    },
  },

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          routeBasePath: '/',
          sidebarPath: './sidebars.ts',
          editUrl: 'https://github.com/codemie-ai/docs/tree/main/',
          sidebarCollapsible: true,
          sidebarCollapsed: false,
          lastVersion: 'current',
          versions: {
            current: {
              label: 'Latest',
              path: '/',
            },
          },
        },
        blog: false,
        theme: {
          customCss: ['./src/css/custom.css'],
        },
      } satisfies Preset.Options,
    ],
  ],

  plugins: [
    require.resolve('docusaurus-plugin-image-zoom'),
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      {
        hashed: true,
        language: ['en'],
        indexDocs: true,
        indexBlog: false,
        indexPages: false,
        docsRouteBasePath: '/',
        highlightSearchTermsOnTargetPage: true,
      },
    ],
    [
      '@docusaurus/plugin-client-redirects',
      {
        createRedirects(existingPath: string) {
          // Redirect any /docs/* path to /*
          if (!existingPath.startsWith('/docs')) {
            return [`/docs${existingPath}`];
          }
          return undefined;
        },
      },
    ],
  ],

  themes: ['@docusaurus/theme-mermaid'],

  themeConfig: {
    image: 'img/codemie-social-card.jpg',
    navbar: {
      title: '',
      logo: {
        alt: 'AI/Run CodeMie Logo',
        src: 'img/logo-full-light.svg',
        srcDark: 'img/logo-full-dark.svg',
      },
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
    zoom: {
      selector: '.markdown :not(em) > img:not(.no-zoom)',
      background: {
        light: 'rgb(255, 255, 255)',
        dark: 'rgb(50, 50, 50)',
      },
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
