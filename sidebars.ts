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
      label: 'Getting Started',
      link: {
        type: 'doc',
        id: 'user-guide/getting-started/index',
      },
      collapsed: false,
      items: [
        'user-guide/getting-started/what-is-codemie',
        'user-guide/getting-started/codemie-capabilities',
        'user-guide/getting-started/meet-faq-assistant',
        'user-guide/getting-started/help-center',
        'user-guide/getting-started/glossary',
      ],
    },
    {
      type: 'category',
      label: 'Guides',
      collapsed: true,
      items: [
        {
          type: 'category',
          label: 'User Guides',
          link: {
            type: 'doc',
            id: 'user-guide/index',
          },
          collapsed: true,
          items: [
            {
              type: 'category',
              label: 'Assistants',
              link: {
                type: 'doc',
                id: 'user-guide/assistants/assistants-overview',
              },
              collapsed: true,
              items: [
                'user-guide/assistants/assistant-templates',
                'user-guide/assistants/create-assistant-from-a-template',
                'user-guide/assistants/create-custom-assistants',
                'user-guide/assistants/edit-assistants',
                'user-guide/assistants/delete-assistants-and-chats',
                'user-guide/assistants/sharing-assistants',
                'user-guide/assistants/restore-system-instructions',
                'user-guide/assistants/group-chats',
                'user-guide/assistants/folders-overview',
                'user-guide/assistants/supported-file-formats-and-csv-handling-in-chat-assistant',
                'user-guide/assistants/share-assistant-chat-with-other-users',
                'user-guide/assistants/export-assistant-chat-messages-to-word-and-pdf-formats',
                'user-guide/assistants/marketplace-overview',
                'user-guide/assistants/marketplace-publishing',
                'user-guide/assistants/clone-assistant-from-marketplace',
                'user-guide/assistants/sub-assistants-multi-assistant-orchestrator',
                'user-guide/assistants/html-preview',
              ],
            },
            {
              type: 'category',
              label: 'Workflows',
              link: {
                type: 'doc',
                id: 'user-guide/workflows/workflows-index',
              },
              collapsed: true,
              items: [
                'user-guide/workflows/workflows-overview',
                'user-guide/workflows/create-workflow',
                'user-guide/workflows/create-workflow-from-template',
                'user-guide/workflows/workflow-templates',
                'user-guide/workflows/share-workflow-execution',
                'user-guide/workflows/exporting-workflow-execution',
                'user-guide/workflows/llm-model-name-in-workflow',
                {
                  type: 'category',
                  label: 'Workflow Configuration',
                  link: {
                    type: 'doc',
                    id: 'user-guide/workflows/configuration/workflow-configuration-overview',
                  },
                  collapsed: true,
                  items: [
                    'user-guide/workflows/configuration/introduction',
                    'user-guide/workflows/configuration/configuration-reference',
                    'user-guide/workflows/configuration/workflow-states',
                    'user-guide/workflows/configuration/state-transitions',
                    'user-guide/workflows/configuration/context-management',
                    'user-guide/workflows/configuration/advanced-features',
                    'user-guide/workflows/configuration/specialized-nodes',
                    'user-guide/workflows/configuration/integration-capabilities',
                    'user-guide/workflows/configuration/best-practices',
                    'user-guide/workflows/configuration/examples',
                    'user-guide/workflows/configuration/troubleshooting',
                  ],
                },
              ],
            },
            {
              type: 'category',
              label: 'Tools',
              link: {
                type: 'doc',
                id: 'user-guide/tools/overview',
              },
              collapsed: true,
              items: [
                'user-guide/tools/keycloak',
                'user-guide/tools/sonarqube',
                'user-guide/tools/sql',
                'user-guide/tools/telegram',
                'user-guide/tools/azure',
                'user-guide/tools/gcp',
                'user-guide/tools/aws',
                'user-guide/tools/kubernetes',
                'user-guide/tools/webhook',
                'user-guide/tools/elastic',
                'user-guide/tools/codebase-tools',
                'user-guide/tools/email-sender-tool',
                'user-guide/tools/openapi-tool',
                'user-guide/tools/quality-assurance-with-jira-zephyr-scale-addon',
                'user-guide/tools/servicenow',
                'user-guide/tools/scheduler',
                'user-guide/tools/plugin',
                {
                  type: 'category',
                  label: 'Git',
                  collapsed: true,
                  items: [
                    'user-guide/tools/git-github-gitlab-bitbucket',
                    'user-guide/tools/git-azuredevops',
                  ],
                },
                'user-guide/tools/adding-an-mcp-server',
                'user-guide/tools/using-mcp-tools-in-assistants',
              ],
            },
            {
              type: 'doc',
              id: 'user-guide/integrations/integrations',
              label: 'Integrations',
            },
            {
              type: 'category',
              label: 'Data Sources',
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
                  label: 'DataSources Types',
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
              label: 'Applications',
              link: {
                type: 'doc',
                id: 'user-guide/applications/index',
              },
              collapsed: true,
              items: ['user-guide/applications/ai-testmate'],
            },
          ],
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
                    'deployment-guide/aws/components-deployment/manual-deployment/data-layer',
                    'deployment-guide/aws/components-deployment/manual-deployment/security-and-identity',
                    'deployment-guide/aws/components-deployment/manual-deployment/plugin-engine',
                    'deployment-guide/aws/components-deployment/manual-deployment/core-components',
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
                id: 'deployment-guide/aws/ai-models-integration/ai-models-integration-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/aws/ai-models-integration/aws-bedrock',
                'deployment-guide/aws/ai-models-integration/azure-openai',
              ],
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/update-version',
              label: 'Update Version',
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
                {
                  type: 'category',
                  label: 'Manual Deployment',
                  link: {
                    type: 'doc',
                    id: 'deployment-guide/azure/components-deployment/manual-deployment/manual-deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'deployment-guide/azure/components-deployment/manual-deployment/storage-and-ingress',
                    'deployment-guide/azure/components-deployment/manual-deployment/data-layer',
                    'deployment-guide/azure/components-deployment/manual-deployment/security-and-identity',
                    'deployment-guide/azure/components-deployment/manual-deployment/plugin-engine',
                    'deployment-guide/azure/components-deployment/manual-deployment/core-components',
                    'deployment-guide/azure/components-deployment/manual-deployment/observability',
                  ],
                },
              ],
            },
            {
              type: 'category',
              label: 'Post-Installation',
              link: {
                type: 'doc',
                id: 'deployment-guide/azure/post-installation/post-installation-overview',
              },
              collapsed: true,
              items: [
                {
                  type: 'category',
                  label: 'User Configuration',
                  link: {
                    type: 'doc',
                    id: 'deployment-guide/azure/post-installation/user-configuration/user-configuration-overview',
                  },
                  collapsed: true,
                  items: [
                    'deployment-guide/azure/post-installation/user-configuration/initial-realm-setup',
                    {
                      type: 'category',
                      label: 'User Provisioning',
                      link: {
                        type: 'doc',
                        id: 'deployment-guide/azure/post-installation/user-configuration/user-provisioning/user-provisioning-overview',
                      },
                      collapsed: true,
                      items: [
                        'deployment-guide/azure/post-installation/user-configuration/user-provisioning/manual-creation',
                        'deployment-guide/azure/post-installation/user-configuration/user-provisioning/keycloak-assistant',
                        'deployment-guide/azure/post-installation/user-configuration/user-provisioning/keycloak-entra-id',
                        'deployment-guide/azure/post-installation/user-configuration/user-provisioning/entra-id-only',
                      ],
                    },
                    {
                      type: 'category',
                      label: 'User Authorization',
                      link: {
                        type: 'doc',
                        id: 'deployment-guide/azure/post-installation/user-configuration/user-authorization/user-authorization-overview',
                      },
                      collapsed: true,
                      items: [
                        'deployment-guide/azure/post-installation/user-configuration/user-authorization/assign-roles',
                        'deployment-guide/azure/post-installation/user-configuration/user-authorization/assign-attributes',
                      ],
                    },
                    'deployment-guide/azure/post-installation/user-configuration/platform-administration',
                  ],
                },
                'deployment-guide/azure/post-installation/datasources-configuration',
                'deployment-guide/azure/post-installation/ui-customization',
              ],
            },
            {
              type: 'category',
              label: 'AI Models Integration',
              link: {
                type: 'doc',
                id: 'deployment-guide/azure/ai-models-integration/ai-models-integration-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/azure/ai-models-integration/aws-bedrock',
                'deployment-guide/azure/ai-models-integration/azure-openai',
              ],
            },
            {
              type: 'doc',
              id: 'deployment-guide/azure/update-version',
              label: 'Update Version',
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
              type: 'category',
              label: 'Infrastructure Deployment',
              link: {
                type: 'doc',
                id: 'deployment-guide/gcp/infrastructure-deployment/infrastructure-deployment-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/gcp/infrastructure-deployment/infrastructure-manual-deployment',
              ],
            },
            {
              type: 'category',
              label: 'Components Deployment',
              link: {
                type: 'doc',
                id: 'deployment-guide/gcp/components-deployment/components-deployment-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/gcp/components-deployment/components-scripted-deployment',
                'deployment-guide/gcp/components-deployment/components-manual-deployment',
              ],
            },
            {
              type: 'category',
              label: 'Post-Installation',
              link: {
                type: 'doc',
                id: 'deployment-guide/gcp/post-installation/post-installation-overview',
              },
              collapsed: true,
              items: [
                {
                  type: 'category',
                  label: 'User Configuration',
                  link: {
                    type: 'doc',
                    id: 'deployment-guide/gcp/post-installation/user-configuration/user-configuration-overview',
                  },
                  collapsed: true,
                  items: [
                    'deployment-guide/gcp/post-installation/user-configuration/initial-realm-setup',
                    {
                      type: 'category',
                      label: 'User Provisioning',
                      link: {
                        type: 'doc',
                        id: 'deployment-guide/gcp/post-installation/user-configuration/user-provisioning/user-provisioning-overview',
                      },
                      collapsed: true,
                      items: [
                        'deployment-guide/gcp/post-installation/user-configuration/user-provisioning/manual-creation',
                        'deployment-guide/gcp/post-installation/user-configuration/user-provisioning/keycloak-assistant',
                        'deployment-guide/gcp/post-installation/user-configuration/user-provisioning/keycloak-entra-id',
                        'deployment-guide/gcp/post-installation/user-configuration/user-provisioning/entra-id-only',
                      ],
                    },
                    {
                      type: 'category',
                      label: 'User Authorization',
                      link: {
                        type: 'doc',
                        id: 'deployment-guide/gcp/post-installation/user-configuration/user-authorization/user-authorization-overview',
                      },
                      collapsed: true,
                      items: [
                        'deployment-guide/gcp/post-installation/user-configuration/user-authorization/assign-roles',
                        'deployment-guide/gcp/post-installation/user-configuration/user-authorization/assign-attributes',
                      ],
                    },
                    'deployment-guide/gcp/post-installation/user-configuration/platform-administration',
                  ],
                },
                'deployment-guide/gcp/post-installation/datasources-configuration',
                'deployment-guide/gcp/post-installation/ui-customization',
              ],
            },
            {
              type: 'category',
              label: 'AI Models Integration',
              link: {
                type: 'doc',
                id: 'deployment-guide/gcp/ai-models-integration/ai-models-integration-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/gcp/ai-models-integration/aws-bedrock',
                'deployment-guide/gcp/ai-models-integration/azure-openai',
              ],
            },
            {
              type: 'doc',
              id: 'deployment-guide/gcp/update-version',
              label: 'Update Version',
            },
          ],
        },
        {
          type: 'category',
          label: 'Extensions',
          link: {
            type: 'doc',
            id: 'deployment-guide/extensions/extensions-overview',
          },
          collapsed: true,
          items: [
            {
              type: 'category',
              label: 'LiteLLM Proxy',
              link: {
                type: 'doc',
                id: 'deployment-guide/extensions/litellm-proxy/litellm-proxy-overview',
              },
              collapsed: true,
              items: [
                'deployment-guide/extensions/litellm-proxy/postgres-setup',
                'deployment-guide/extensions/litellm-proxy/configure-values',
                'deployment-guide/extensions/litellm-proxy/auth-secrets',
                'deployment-guide/extensions/litellm-proxy/model-config',
                {
                  type: 'category',
                  label: 'Deployment',
                  link: {
                    type: 'doc',
                    id: 'deployment-guide/extensions/litellm-proxy/deployment/deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'deployment-guide/extensions/litellm-proxy/deployment/automated-deployment',
                    'deployment-guide/extensions/litellm-proxy/deployment/manual-deployment',
                  ],
                },
                'deployment-guide/extensions/litellm-proxy/migration-guide',
              ],
            },
            {
              type: 'category',
              label: 'Assistants Evaluation',
              link: {
                type: 'doc',
                id: 'deployment-guide/extensions/assistants-evaluation/assistants-evaluation',
              },
              collapsed: true,
              items: [
                'deployment-guide/extensions/assistants-evaluation/prerequisites',
                'deployment-guide/extensions/assistants-evaluation/system-requirements',
                'deployment-guide/extensions/assistants-evaluation/deployment-prerequisites',
                {
                  type: 'category',
                  label: 'Deployment',
                  link: {
                    type: 'doc',
                    id: 'deployment-guide/extensions/assistants-evaluation/deployment/deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'deployment-guide/extensions/assistants-evaluation/deployment/automated-deployment',
                    'deployment-guide/extensions/assistants-evaluation/deployment/manual-deployment',
                  ],
                },
                'deployment-guide/extensions/assistants-evaluation/post-deployment',
                'deployment-guide/extensions/assistants-evaluation/troubleshooting',
              ],
            },
            'deployment-guide/extensions/ai-code-explorer/ai-code-explorer',
            'deployment-guide/extensions/angular-upgrade-assistant/angular-upgrade-assistant',
            'deployment-guide/extensions/salesforce-devforce-ai/salesforce-devforce-ai',
          ],
        },
        {
          type: 'category',
          label: 'Additional Resources',
          collapsed: true,
          items: [
            'deployment-guide/additional-resources/api-configuration',
            'deployment-guide/additional-resources/elasticsearch-kibana-upgrade',
          ],
        },
        {
          type: 'doc',
          id: 'deployment-guide/faq',
          label: 'FAQ',
        },
      ],
    },
  ],
};

sidebars.userGuideSidebar = sidebars.mainSidebar;
sidebars.deploymentGuideSidebar = sidebars.mainSidebar;

export default sidebars;
