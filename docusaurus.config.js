// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Fullstack Dart with gRPC',
  tagline: 'One Language for your serverside and clientside needs.',
  url: 'https://grpc-dart-docs.pages.dev/',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/flutter-grpc-dart-removebg-preview.png',
  customFields: {
    description: "Your go-to site when building gRPC servers in Dart",
  },


  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'Flutter Community', // Usually your GitHub org/user name.
  projectName: 'grpc-with-dart', // Usually your repo name.

  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        title: 'gRPC Dart',
        logo: {
          alt: 'gRPC Dart Logo',
          src: 'img/flutter-grpc-dart-removebg-preview.png',
        },
        items: [
          {
            type: 'doc',
            docId: 'why-grpc',
            position: 'left',
            label: 'Explore Docs',
          },
          // {
          //   type: 'doc',
          //   docId: 'why-grpc',
          //   position: 'left',
          //   label: 'gRPC Tutorials',
          // },
          { to: '/blog', label: 'Blog', position: 'left', },
          {
            href: 'https://github.com/bettdouglas/grpc-dart-docs',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          // {
          //   title: 'Docs',
          //   items: [
          //     // {
          //     //   label: 'Tutorial',
          //     //   to: '/docs/intro',
          //     // },
          //   ],
          // },
          {
            title: 'Community',
            items: [
              {
                label: 'Stack Overflow',
                href: 'https://stackoverflow.com/questions/tagged/grpc+dart',
              },
              // {
              //   label: 'Discord',
              //   href: 'https://discordapp.com/invite/docusaurus',
              // },
              // {
              //   label: 'Twitter',
              //   href: 'https://twitter.com/docusaurus',
              // },
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'Blog',
                to: '/blog',
              },
              {
                label: 'GitHub',
                href: 'https://github.com/bettdouglas/grpc-dart-docs',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} gRPC Dart Community, Inc. Built with Docusaurus.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
        additionalLanguages: ['protobuf','dart','java'],
      },
    }),
};

module.exports = config;
