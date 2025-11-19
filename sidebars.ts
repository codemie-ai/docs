import type { SidebarsConfig } from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  mainSidebar: [
    {
      type: 'doc',
      id: 'index',
      label: 'Home',
    },
    {
      type: 'category',
      label: 'Guides',
      link: {
        type: 'doc',
        id: 'user-guide/index',
      },
      collapsed: true,
      items: [
        {
          type: 'doc',
          id: 'user-guide/assistants/index',
          label: 'Assistants',
        },
        {
          type: 'doc',
          id: 'user-guide/concepts/integrations-overview',
          label: 'Integrations',
        },
        {
          type: 'doc',
          id: 'user-guide/internal-tools/internal-tools',
          label: 'Internal tools',
        },
        {
          type: 'doc',
          id: 'user-guide/external-tools/external-tools',
          label: 'External tools',
        },
        {
          type: 'doc',
          id: 'user-guide/data-source/data-source',
          label: 'Data Source',
        },
        {
          type: 'doc',
          id: 'user-guide/ai-documentation/index',
          label: 'AI Documentation',
        },
      ],
    },
    {
      type: 'category',
      label: 'Deployment Guide',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: 'AWS',
          link: {
            type: 'doc',
            id: 'deployment-guide/aws/overview',
          },
          collapsed: true,
          items: [
            {
              type: 'doc',
              id: 'deployment-guide/aws/prerequisites',
              label: 'Prerequisites',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/architecture',
              label: 'Architecture',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/infrastructure-deployment/index',
              label: 'Infrastructure Deployment',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/components-deployment/index',
              label: 'Components Deployment',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/post-installation',
              label: 'Post-Installation',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/ai-models-integration',
              label: 'AI Models Integration',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/update',
              label: 'Updates',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/extensions',
              label: 'Extensions',
            },
          ],
        },
        {
          type: 'category',
          label: 'Azure',
          link: {
            type: 'doc',
            id: 'deployment-guide/azure/overview',
          },
          collapsed: true,
          items: [
            {
              type: 'doc',
              id: 'deployment-guide/azure/prerequisites',
              label: 'Prerequisites',
            },
            {
              type: 'doc',
              id: 'deployment-guide/azure/architecture',
              label: 'Architecture',
            },
            {
              type: 'doc',
              id: 'deployment-guide/azure/infrastructure-deployment',
              label: 'Infrastructure Deployment',
            },
            {
              type: 'doc',
              id: 'deployment-guide/azure/components-deployment',
              label: 'Components Deployment',
            },
            {
              type: 'doc',
              id: 'deployment-guide/azure/post-installation',
              label: 'Post-Installation',
            },
            {
              type: 'doc',
              id: 'deployment-guide/azure/ai-models-integration',
              label: 'AI Models Integration',
            },
            {
              type: 'doc',
              id: 'deployment-guide/azure/update-version',
              label: 'Update Version',
            },
            {
              type: 'doc',
              id: 'deployment-guide/azure/extensions',
              label: 'Extensions',
            },
          ],
        },
        {
          type: 'category',
          label: 'GCP',
          link: {
            type: 'doc',
            id: 'deployment-guide/gcp/overview',
          },
          collapsed: true,
          items: [
            {
              type: 'doc',
              id: 'deployment-guide/gcp/prerequisites',
              label: 'Prerequisites',
            },
            {
              type: 'doc',
              id: 'deployment-guide/gcp/architecture',
              label: 'Architecture',
            },
            {
              type: 'doc',
              id: 'deployment-guide/gcp/infrastructure-deployment',
              label: 'Infrastructure Deployment',
            },
            {
              type: 'doc',
              id: 'deployment-guide/gcp/components-overview',
              label: 'Components Overview',
            },
            {
              type: 'doc',
              id: 'deployment-guide/gcp/scripted-installation',
              label: 'Scripted Installation',
            },
            {
              type: 'doc',
              id: 'deployment-guide/gcp/manual-installation',
              label: 'Manual Installation',
            },
            {
              type: 'doc',
              id: 'deployment-guide/gcp/post-installation',
              label: 'Post-Installation',
            },
            {
              type: 'doc',
              id: 'deployment-guide/gcp/ai-models',
              label: 'AI Models Integration',
            },
            {
              type: 'doc',
              id: 'deployment-guide/gcp/maintenance',
              label: 'Maintenance',
            },
          ],
        },
      ],
    },
  ],
  userGuideSidebar: [
    {
      type: 'doc',
      id: 'user-guide/index',
      label: 'Guides',
    },
    {
      type: 'category',
      label: 'Assistants',
      link: {
        type: 'doc',
        id: 'user-guide/assistants/index',
      },
      collapsed: true,
      items: [
        'user-guide/assistants/assistant-templates',
        'user-guide/assistants/create-assistant-from-a-template',
        'user-guide/assistants/marketplace-overview',
      ],
    },
    {
      type: 'category',
      label: 'Integrations',
      link: {
        type: 'doc',
        id: 'user-guide/concepts/integrations-overview',
      },
      collapsed: true,
      items: [
        'user-guide/concepts/integrations-overview',
      ],
    },
    {
      type: 'category',
      label: 'Internal tools',
      link: {
        type: 'doc',
        id: 'user-guide/internal-tools/internal-tools',
      },
      collapsed: true,
      items: [
        'user-guide/internal-tools/keycloak',
        'user-guide/internal-tools/sonarqube',
        'user-guide/internal-tools/sql',
        'user-guide/internal-tools/telegram',
        'user-guide/internal-tools/azure',
        'user-guide/internal-tools/gcp',
        'user-guide/internal-tools/aws',
        'user-guide/internal-tools/kubernetes',
        'user-guide/internal-tools/webhook',
        'user-guide/internal-tools/html-preview',
        'user-guide/internal-tools/elastic',
        'user-guide/internal-tools/codebase-tools',
        'user-guide/internal-tools/email-sender-tool',
        'user-guide/internal-tools/openapi-tool',
        'user-guide/internal-tools/quality-assurance-jira-zephyr',
        'user-guide/internal-tools/servicenow',
        'user-guide/internal-tools/scheduler',
        'user-guide/internal-tools/plugin',
        'user-guide/internal-tools/git',
        'user-guide/internal-tools/research-tools',
      ],
    },
    {
      type: 'category',
      label: 'External tools',
      link: {
        type: 'doc',
        id: 'user-guide/external-tools/external-tools',
      },
      collapsed: true,
      items: [
        'user-guide/external-tools/adding-mcp-server',
        'user-guide/external-tools/using-mcp-tools',
        'user-guide/external-tools/code-exploration-toolkit',
        'user-guide/external-tools/code-analysis-toolkit',
      ],
    },
    {
      type: 'category',
      label: 'Data Source',
      link: {
        type: 'doc',
        id: 'user-guide/data-source/data-source',
      },
      collapsed: true,
      items: [
        {
          type: 'category',
          label: 'Data Source Overview',
          link: {
            type: 'doc',
            id: 'user-guide/data-source/data-source-overview/data-source-overview',
          },
          collapsed: true,
          items: [
            'user-guide/data-source/data-source-overview/indexing-data-sources',
            'user-guide/data-source/data-source-overview/indexing-duration',
          ],
        },
        {
          type: 'category',
          label: 'DataSources types',
          link: {
            type: 'doc',
            id: 'user-guide/data-source/datasources-types/datasources-types',
          },
          collapsed: true,
          items: [
            'user-guide/data-source/datasources-types/add-git-data-sources',
            'user-guide/data-source/datasources-types/add-confluence-pages',
            'user-guide/data-source/datasources-types/add-jira-data-source',
            'user-guide/data-source/datasources-types/add-file-datasource',
            'user-guide/data-source/datasources-types/add-google-data-source',
            'user-guide/data-source/datasources-types/add-aws-knowledge-bases',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Workflows',
      link: {
        type: 'doc',
        id: 'user-guide/workflows/workflows',
      },
      collapsed: true,
      items: [
        'user-guide/workflows/41-workflows-overview',
        'user-guide/workflows/42-create-workflow',
        'user-guide/workflows/43-create-a-workflow-from-a-template',
        'user-guide/workflows/45-workflow-templates',
        'user-guide/workflows/49-context-management',
        {
          type: 'category',
          label: 'Advanced Topics',
          collapsed: true,
          items: [
            'user-guide/workflows/46-share-workflow-execution',
            'user-guide/workflows/410-specialized-nodes',
            'user-guide/workflows/47-exporting-workflow-execution',
          ],
        },
        {
          type: 'category',
          label: 'Best Practices & Troubleshooting',
          collapsed: true,
          items: [
            'user-guide/workflows/48-llmmodel-name-in-workflow',
            'user-guide/workflows/411-complete-examples',
            'user-guide/workflows/412-troubleshooting',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Projects overview',
      link: {
        type: 'doc',
        id: 'user-guide/concepts/projects-overview',
      },
      collapsed: true,
      items: [
        'user-guide/concepts/project-visibility-management',
      ],
    },
    {
      type: 'category',
      label: 'Access levels',
      link: {
        type: 'doc',
        id: 'user-guide/concepts/access-levels',
      },
      collapsed: true,
      items: [],
    },
    {
      type: 'category',
      label: 'Extensions (IDE)',
      link: {
        type: 'doc',
        id: 'user-guide/extensions/extensions-ide',
      },
      collapsed: true,
      items: [
        'user-guide/extensions/vscode',
        'user-guide/extensions/jetbrains',
      ],
    },
    {
      type: 'category',
      label: 'Administrative functionality',
      link: {
        type: 'doc',
        id: 'user-guide/concepts/administrative-functionality',
      },
      collapsed: true,
      items: [],
    },
    {
      type: 'category',
      label: 'Help resources',
      link: {
        type: 'doc',
        id: 'user-guide/help-resources/help-resources',
      },
      collapsed: true,
      items: [],
    },
    {
      type: 'category',
      label: 'Applications',
      link: {
        type: 'doc',
        id: 'user-guide/applications/applications',
      },
      collapsed: true,
      items: [],
    },
    {
      type: 'category',
      label: 'Plugins',
      link: {
        type: 'doc',
        id: 'user-guide/plugins/plugins',
      },
      collapsed: true,
      items: [],
    },
    {
      type: 'category',
      label: 'SDK',
      link: {
        type: 'doc',
        id: 'user-guide/sdk/sdk',
      },
      collapsed: true,
      items: [],
    },
  ],
  deploymentGuideSidebar: [
    {
      type: 'category',
      label: 'Deployment Guide',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: 'AWS',
          collapsed: true,
          items: [
            'deployment-guide/aws/overview',
            'deployment-guide/aws/prerequisites',
            'deployment-guide/aws/architecture',
            {
              type: 'category',
              label: 'Infrastructure Deployment',
              link: {
                type: 'doc',
                id: 'deployment-guide/aws/infrastructure-deployment/index',
              },
              collapsed: true,
              items: [
                'deployment-guide/aws/infrastructure-deployment/scripted-deployment',
                'deployment-guide/aws/infrastructure-deployment/manual-deployment',
              ],
            },
            {
              type: 'category',
              label: 'Components Deployment',
              link: {
                type: 'doc',
                id: 'deployment-guide/aws/components-deployment/index',
              },
              collapsed: true,
              items: [
                'deployment-guide/aws/components-deployment/scripted-deployment',
                'deployment-guide/aws/components-deployment/manual-deployment',
              ],
            },
            'deployment-guide/aws/post-installation',
            'deployment-guide/aws/ai-models-integration',
            'deployment-guide/aws/update',
            'deployment-guide/aws/extensions',
          ],
        },
        {
          type: 'category',
          label: 'Azure',
          collapsed: true,
          items: [
            'deployment-guide/azure/overview',
            'deployment-guide/azure/prerequisites',
            'deployment-guide/azure/architecture',
            'deployment-guide/azure/infrastructure-deployment',
            'deployment-guide/azure/components-deployment',
            'deployment-guide/azure/post-installation',
            'deployment-guide/azure/ai-models-integration',
            'deployment-guide/azure/update-version',
            'deployment-guide/azure/extensions',
          ],
        },
        {
          type: 'category',
          label: 'GCP',
          collapsed: true,
          items: [
            'deployment-guide/gcp/overview',
            'deployment-guide/gcp/prerequisites',
            'deployment-guide/gcp/architecture',
            'deployment-guide/gcp/infrastructure-deployment',
            'deployment-guide/gcp/components-overview',
            'deployment-guide/gcp/scripted-installation',
            'deployment-guide/gcp/manual-installation',
            'deployment-guide/gcp/post-installation',
            'deployment-guide/gcp/ai-models',
            'deployment-guide/gcp/maintenance',
          ],
        },
        'deployment-guide/faq',
      ],
    },
  ],
  conceptsSidebar: [
    {
      type: 'doc',
      id: 'concepts/concepts',
      label: 'Concepts',
    },
    'concepts/assistants',
    'concepts/integration',
    'concepts/data-sources',
    {
      type: 'category',
      label: 'Tools',
      link: {
        type: 'doc',
        id: 'concepts/tools/tools',
      },
      collapsed: true,
      items: [
        'concepts/tools/internal-tools',
        {
          type: 'category',
          label: 'External Tools',
          link: {
            type: 'doc',
            id: 'concepts/tools/external-tools/external-tools',
          },
          collapsed: true,
          items: [
            'concepts/tools/external-tools/mcps',
            'concepts/tools/external-tools/mcps-management',
            'concepts/tools/external-tools/code-exploration-toolkit',
            'concepts/tools/external-tools/code-analysis-toolkit',
          ],
        },
      ],
    },
    'concepts/plugins',
    'concepts/marketplace',
    'concepts/workflows',
    'concepts/applications',
    'concepts/extensions',
    'concepts/external-vendors',
    'concepts/sdk',
    'concepts/projects',
    'concepts/webhooks',
    'concepts/scheduler',
  ],
};

export default sidebars;
