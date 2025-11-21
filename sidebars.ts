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
      label: 'User Guide',
      link: {
        type: 'doc',
        id: 'user-guide/index',
      },
      collapsed: true,
      items: [
        {
          type: 'doc',
          id: 'user-guide/getting-started/index',
          label: 'Getting Started',
        },
        {
          type: 'doc',
          id: 'user-guide/concepts/index',
          label: 'Concepts',
        },
        {
          type: 'doc',
          id: 'user-guide/assistants/index',
          label: 'Working With Assistants',
        },
        {
          type: 'doc',
          id: 'user-guide/workflows/index',
          label: 'Workflows',
        },
        {
          type: 'doc',
          id: 'user-guide/conversational-advice/index',
          label: 'Conversational Advice',
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
      label: 'Deployment Guides',
      link: {
        type: 'doc',
        id: 'deployment-guide/index',
      },
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
              type: 'category',
              label: 'Infrastructure Deployment',
              link: {
                type: 'doc',
                id: 'deployment-guide/aws/infrastructure-deployment/infrastructure-deployment-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/aws/infrastructure-deployment/infrastructure-scripted-deployment',
                'deployment-guide/aws/infrastructure-deployment/infrastructure-manual-deployment',
              ],
            },
            {
              type: 'category',
              label: 'Components Deployment',
              link: {
                type: 'doc',
                id: 'deployment-guide/aws/components-deployment/components-deployment-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/aws/components-deployment/components-scripted-deployment',
                {
                  type: 'category',
                  label: 'Manual Deployment',
                  link: {
                    type: 'doc',
                    id: 'deployment-guide/aws/components-deployment/manual-deployment/manual-deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'deployment-guide/aws/components-deployment/manual-deployment/storage-and-ingress',
                    'deployment-guide/aws/components-deployment/manual-deployment/security-and-identity',
                    'deployment-guide/aws/components-deployment/manual-deployment/data-layer',
                    'deployment-guide/aws/components-deployment/manual-deployment/core-components',
                    'deployment-guide/aws/components-deployment/manual-deployment/plugin-engine',
                    'deployment-guide/aws/components-deployment/manual-deployment/observability',
                  ],
                },
              ],
            },
            {
              type: 'category',
              label: 'Post-Installation',
              link: {
                type: 'doc',
                id: 'deployment-guide/aws/post-installation/post-installation-overview',
              },
              collapsed: true,
              items: [
                {
                  type: 'category',
                  label: 'User Configuration',
                  link: {
                    type: 'doc',
                    id: 'deployment-guide/aws/post-installation/user-configuration/user-configuration-overview',
                  },
                  collapsed: true,
                  items: [
                    'deployment-guide/aws/post-installation/user-configuration/initial-realm-setup',
                    {
                      type: 'category',
                      label: 'User Provisioning',
                      link: {
                        type: 'doc',
                        id: 'deployment-guide/aws/post-installation/user-configuration/user-provisioning/user-provisioning-overview',
                      },
                      collapsed: true,
                      items: [
                        'deployment-guide/aws/post-installation/user-configuration/user-provisioning/manual-creation',
                        'deployment-guide/aws/post-installation/user-configuration/user-provisioning/keycloak-assistant',
                        'deployment-guide/aws/post-installation/user-configuration/user-provisioning/keycloak-entra-id',
                        'deployment-guide/aws/post-installation/user-configuration/user-provisioning/entra-id-only',
                      ],
                    },
                    {
                      type: 'category',
                      label: 'User Authorization',
                      link: {
                        type: 'doc',
                        id: 'deployment-guide/aws/post-installation/user-configuration/user-authorization/user-authorization-overview',
                      },
                      collapsed: true,
                      items: [
                        'deployment-guide/aws/post-installation/user-configuration/user-authorization/assign-roles',
                        'deployment-guide/aws/post-installation/user-configuration/user-authorization/assign-attributes',
                      ],
                    },
                    'deployment-guide/aws/post-installation/user-configuration/platform-administration',
                  ],
                },
                'deployment-guide/aws/post-installation/datasources-configuration',
                'deployment-guide/aws/post-installation/ui-customization',
              ],
            },
            {
              type: 'category',
              label: 'AI Models Integration',
              link: {
                type: 'doc',
                id: 'deployment-guide/aws/ai-models-integration/ai-models-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/aws/ai-models-integration/aws-bedrock',
                'deployment-guide/aws/ai-models-integration/azure-openai',
              ],
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/update',
              label: 'Updates',
            },
            {
              type: 'category',
              label: 'Extensions',
              link: {
                type: 'doc',
                id: 'deployment-guide/aws/extensions/extensions-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/aws/extensions/litellm-proxy',
                'deployment-guide/aws/extensions/assistants-evaluation',
                'deployment-guide/aws/extensions/ai-code-explorer',
                'deployment-guide/aws/extensions/angular-upgrade-assistant',
                'deployment-guide/aws/extensions/salesforce-devforce-ai',
              ],
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
              type: 'category',
              label: 'Infrastructure Deployment',
              link: {
                type: 'doc',
                id: 'deployment-guide/azure/infrastructure-deployment/infrastructure-deployment-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/azure/infrastructure-deployment/infrastructure-scripted-deployment',
              ],
            },
            {
              type: 'category',
              label: 'Components Deployment',
              link: {
                type: 'doc',
                id: 'deployment-guide/azure/components-deployment/components-deployment-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/azure/components-deployment/components-scripted-deployment',
              ],
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
        {
          type: 'category',
          label: 'Additional Resources',
          collapsed: true,
          items: ['deployment-guide/api-configuration'],
        },
      ],
    },
  ],
};

// Use the same sidebar for all sections
sidebars.userGuideSidebar = sidebars.mainSidebar;
sidebars.deploymentGuideSidebar = sidebars.mainSidebar;

export default sidebars;
