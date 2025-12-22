import { themes as prismThemes } from 'prism-react-renderer';
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'AI/Run CodeMie',
  tagline: 'AI-powered development platform documentation',
  favicon: 'img/favicon.svg',

  // Use environment variables for PR previews, fallback to production values
  url: process.env.DOCUSAURUS_URL || 'https://codemie-ai.github.io',
  baseUrl: process.env.DOCUSAURUS_BASE_URL || '/docs/',

  organizationName: 'codemie-ai',
  projectName: 'docs',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

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
          customCss: './src/css/custom.css',
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
  ],

  themeConfig: {
    image: 'img/codemie-social-card.jpg',
    navbar: {
      title: 'AI/Run CodeMie',
      logo: {
        alt: 'AI/Run CodeMie Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          to: 'user-guide/getting-started/',
          position: 'left',
          label: 'Getting Started',
        },
        {
          to: 'user-guide/',
          position: 'left',
          label: 'User Guides',
        },
        {
          to: 'deployment-guide/',
          position: 'left',
          label: 'Deployment Guides',
        },
        {
          type: 'docsVersionDropdown',
          position: 'right',
        },
        {
          href: 'https://github.com/codemie-ai/docs',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Documentation',
          items: [
            {
              label: 'User Guide',
              to: 'user-guide/',
            },
            {
              label: 'Administrator Guides',
              to: 'admin-guide/',
            },
            {
              label: 'Deployment Guides',
              to: 'deployment-guide/',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/codemie-ai/docs',
            },
            {
              label: 'YouTube',
              href: 'https://www.youtube.com/@EPAMAIRunCodeMie',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} AI/Run CodeMie. Built with Docusaurus.`,
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
