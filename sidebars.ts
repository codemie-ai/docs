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
        'user-guide/getting-started/use-cases',
        'user-guide/getting-started/enterprise-features',
        'user-guide/getting-started/meet-faq-assistant',
        'user-guide/getting-started/help-center',
        'user-guide/getting-started/glossary',
      ],
    },
    {
      type: 'category',
      label: 'User Manuals',
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
            'user-guide/assistants/create-assistant',
            'user-guide/assistants/sharing-assistants',
            'user-guide/assistants/edit-assistants',
            'user-guide/assistants/restore-system-instructions',
            'user-guide/assistants/delete-assistants-and-chats',
            'user-guide/assistants/assistant-templates',
            'user-guide/assistants/create-assistant-from-a-template',
            'user-guide/assistants/marketplace-overview',
            'user-guide/assistants/marketplace-publishing',
            'user-guide/assistants/assistant-categories-management',
            'user-guide/assistants/clone-assistant-from-marketplace',
            'user-guide/assistants/sub-assistants-multi-assistant-orchestrator',
            'user-guide/assistants/favorites',
            'user-guide/assistants/pinned-assistants',
            {
              type: 'category',
              label: 'Organizing and Managing Communication with Assistants',
              collapsed: true,
              items: [
                'user-guide/assistants/search-chats',
                'user-guide/assistants/group-chats',
                'user-guide/assistants/folders-overview',
                'user-guide/assistants/supported-file-formats-and-csv-handling-in-chat-assistant',
                'user-guide/assistants/share-assistant-chat-with-other-users',
                'user-guide/assistants/export-assistant-chat-messages-to-word-and-pdf-formats',
                'user-guide/assistants/html-preview',
                'user-guide/assistants/chat-input-settings',
              ],
            },
          ],
        },
        {
          type: 'category',
          label: 'Skills',
          link: {
            type: 'doc',
            id: 'user-guide/skills/skills-index',
          },
          collapsed: true,
          items: [
            'user-guide/skills/skills-overview',
            'user-guide/skills/create-skill',
            'user-guide/skills/attach-skills-to-assistants',
            'user-guide/skills/manage-skills',
            'user-guide/skills/marketplace-skills',
            'user-guide/skills/skills-in-chat',
            'user-guide/skills/skills-in-workflow',
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
            'user-guide/workflows/llm-model-name-in-workflow',
            'user-guide/workflows/workflow-templates',
            'user-guide/workflows/create-workflow-from-template',
            'user-guide/workflows/share-workflow-execution',
            'user-guide/workflows/exporting-workflow-execution',
            'user-guide/workflows/marketplace-overview',
            'user-guide/workflows/marketplace-publishing',
            'user-guide/workflows/clone-workflow-from-marketplace',
            {
              type: 'category',
              label: 'YAML Configuration',
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
          label: 'Integrations and Tools',
          link: {
            type: 'doc',
            id: 'user-guide/tools_integrations/tools_integrations',
          },
          collapsed: true,
          items: [
            {
              type: 'doc',
              id: 'user-guide/tools_integrations/integrations/integrations',
              label: 'Integrations',
            },
            {
              type: 'category',
              label: 'Tools',
              link: {
                type: 'doc',
                id: 'user-guide/tools_integrations/tools/overview',
              },
              collapsed: true,
              items: [
                'user-guide/tools_integrations/tools/a2a',
                'user-guide/tools_integrations/tools/keycloak',
                'user-guide/tools_integrations/tools/sonarqube',
                'user-guide/tools_integrations/tools/sql',
                'user-guide/tools_integrations/tools/telegram',
                'user-guide/tools_integrations/tools/azure',
                'user-guide/tools_integrations/tools/gcp',
                'user-guide/tools_integrations/tools/aws',
                'user-guide/tools_integrations/tools/kubernetes',
                'user-guide/tools_integrations/tools/webhook',
                'user-guide/tools_integrations/tools/elastic',
                'user-guide/tools_integrations/tools/codebase-tools',
                'user-guide/tools_integrations/tools/email-sender-tool',
                'user-guide/tools_integrations/tools/openapi-tool',
                'user-guide/tools_integrations/tools/jira',
                'user-guide/tools_integrations/tools/litellm',
                'user-guide/tools_integrations/tools/confluence',
                'user-guide/tools_integrations/tools/reportportal',
                'user-guide/tools_integrations/tools/quality-assurance-with-jira-zephyr-scale-addon',
                'user-guide/tools_integrations/tools/servicenow',
                'user-guide/tools_integrations/tools/scheduler',
                'user-guide/tools_integrations/tools/xray',
                'user-guide/tools_integrations/tools/plugin',
                'user-guide/tools_integrations/tools/filesystem',
                {
                  type: 'category',
                  label: 'Git',
                  link: {
                    type: 'doc',
                    id: 'user-guide/tools_integrations/tools/git-overview',
                  },
                  collapsed: true,
                  items: [
                    'user-guide/tools_integrations/tools/git-github-gitlab-bitbucket',
                    'user-guide/tools_integrations/tools/git-azuredevops',
                  ],
                },
                {
                  type: 'category',
                  label: 'Azure DevOps',
                  link: {
                    type: 'doc',
                    id: 'user-guide/tools_integrations/tools/azure-devops/azure-devops',
                  },
                  collapsed: true,
                  items: [
                    'user-guide/tools_integrations/tools/azure-devops/azure-devops-work-items',
                    'user-guide/tools_integrations/tools/azure-devops/azure-devops-wiki',
                    'user-guide/tools_integrations/tools/azure-devops/azure-devops-test-plans',
                  ],
                },
                'user-guide/tools_integrations/tools/adding-an-mcp-server',
                'user-guide/tools_integrations/tools/using-mcp-tools-in-assistants',
              ],
            },
          ],
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
                'user-guide/data-source/datasources-types/add-xray-data-source',
                'user-guide/data-source/datasources-types/add-file-datasource',
                'user-guide/data-source/datasources-types/add-google-data-source',
                'user-guide/data-source/datasources-types/add-aws-knowledge-bases',
                'user-guide/data-source/datasources-types/add-azure-devops-wiki-data-source',
                'user-guide/data-source/datasources-types/add-provider-datasource',
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
        {
          type: 'category',
          label: 'AI Katas',
          link: {
            type: 'doc',
            id: 'user-guide/ai-katas/ai-katas',
          },
          collapsed: true,
          items: [
            'user-guide/ai-katas/katas-overview',
            'user-guide/ai-katas/working-with-katas',
            'user-guide/ai-katas/leaderboard',
            'user-guide/ai-katas/manage-katas-admin',
          ],
        },
        {
          type: 'category',
          label: '✨ CodeMie CLI',
          link: {
            type: 'doc',
            id: 'user-guide/codemie-cli/codemie-cli',
          },
          collapsed: true,
          items: [
            'user-guide/codemie-cli/assistants-integration',
            'user-guide/codemie-cli/skills-integration',
            'user-guide/codemie-cli/codemie-claude-skills',
            'user-guide/codemie-cli/sdk-cli-reference',
          ],
        },
        {
          type: 'category',
          label: 'IDE Extensions',
          link: {
            type: 'doc',
            id: 'user-guide/ide/index',
          },
          collapsed: true,
          items: [
            'user-guide/ide/jetbrains-plugin',
            'user-guide/ide/vscode-copilot-extension',
            'user-guide/ide/vscode-native-extension',
          ],
        },
        {
          type: 'category',
          label: 'Analytics',
          link: {
            type: 'doc',
            id: 'user-guide/analytics/analytics-overview',
          },
          collapsed: true,
          items: ['user-guide/analytics/ai-champions-leaderboard'],
        },
        {
          type: 'category',
          label: 'API',
          link: {
            type: 'doc',
            id: 'user-guide/api/index',
          },
          collapsed: true,
          items: ['user-guide/api/client-secret-access', 'user-guide/api/user-password-access'],
        },
        {
          type: 'category',
          label: 'Project & User Management',
          link: {
            type: 'doc',
            id: 'user-guide/project-user-management/index',
          },
          collapsed: true,
          items: [
            'user-guide/project-user-management/projects',
            'user-guide/project-user-management/users',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Administration',
      link: {
        type: 'doc',
        id: 'admin/index',
      },
      collapsed: true,
      items: [
        {
          type: 'category',
          label: 'Deployment',
          link: {
            type: 'doc',
            id: 'admin/deployment/index',
          },
          collapsed: true,
          items: [
            {
              type: 'category',
              label: 'AWS',
              link: {
                type: 'doc',
                id: 'admin/deployment/aws/overview',
              },
              collapsed: true,
              items: [
                {
                  type: 'doc',
                  id: 'admin/deployment/aws/prerequisites',
                  label: 'Prerequisites',
                },
                {
                  type: 'doc',
                  id: 'admin/deployment/aws/architecture',
                  label: 'Architecture',
                },
                {
                  type: 'category',
                  label: 'Infrastructure Deployment',
                  link: {
                    type: 'doc',
                    id: 'admin/deployment/aws/infrastructure-deployment/infrastructure-deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/deployment/aws/infrastructure-deployment/infrastructure-scripted-deployment',
                    'admin/deployment/aws/infrastructure-deployment/infrastructure-manual-deployment',
                  ],
                },
                {
                  type: 'category',
                  label: 'CodeMie Components Deployment',
                  link: {
                    type: 'doc',
                    id: 'admin/deployment/aws/components-deployment/components-deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/deployment/aws/components-deployment/components-scripted-deployment',
                    {
                      type: 'category',
                      label: 'CodeMie Manual Deployment',
                      link: {
                        type: 'doc',
                        id: 'admin/deployment/aws/components-deployment/manual-deployment/manual-deployment-overview',
                      },
                      collapsed: true,
                      items: [
                        'admin/deployment/aws/components-deployment/manual-deployment/k8s-components',
                        'admin/deployment/aws/components-deployment/manual-deployment/data-layer',
                        'admin/deployment/aws/components-deployment/manual-deployment/security-and-identity',
                        'admin/deployment/aws/components-deployment/manual-deployment/plugin-engine',
                        'admin/deployment/aws/components-deployment/manual-deployment/core-components',
                        'admin/deployment/aws/components-deployment/manual-deployment/observability',
                      ],
                    },
                  ],
                },
                {
                  type: 'doc',
                  id: 'admin/deployment/aws/accessing-applications',
                  label: 'Accessing Applications',
                },
              ],
            },
            {
              type: 'category',
              label: 'Azure',
              link: {
                type: 'doc',
                id: 'admin/deployment/azure/overview',
              },
              collapsed: true,
              items: [
                {
                  type: 'doc',
                  id: 'admin/deployment/azure/prerequisites',
                  label: 'Prerequisites',
                },
                {
                  type: 'doc',
                  id: 'admin/deployment/azure/architecture',
                  label: 'Architecture',
                },
                {
                  type: 'category',
                  label: 'Infrastructure Deployment',
                  link: {
                    type: 'doc',
                    id: 'admin/deployment/azure/infrastructure-deployment/infrastructure-deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/deployment/azure/infrastructure-deployment/infrastructure-scripted-deployment',
                  ],
                },
                {
                  type: 'category',
                  label: 'CodeMie Components Deployment',
                  link: {
                    type: 'doc',
                    id: 'admin/deployment/azure/components-deployment/components-deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/deployment/azure/components-deployment/components-scripted-deployment',
                    {
                      type: 'category',
                      label: 'CodeMie Manual Deployment',
                      link: {
                        type: 'doc',
                        id: 'admin/deployment/azure/components-deployment/manual-deployment/manual-deployment-overview',
                      },
                      collapsed: true,
                      items: [
                        'admin/deployment/azure/components-deployment/manual-deployment/k8s-components',
                        'admin/deployment/azure/components-deployment/manual-deployment/data-layer',
                        'admin/deployment/azure/components-deployment/manual-deployment/security-and-identity',
                        'admin/deployment/azure/components-deployment/manual-deployment/plugin-engine',
                        'admin/deployment/azure/components-deployment/manual-deployment/core-components',
                        'admin/deployment/azure/components-deployment/manual-deployment/observability',
                      ],
                    },
                  ],
                },
                {
                  type: 'doc',
                  id: 'admin/deployment/azure/accessing-applications',
                  label: 'Accessing Applications',
                },
              ],
            },
            {
              type: 'category',
              label: 'GCP',
              link: {
                type: 'doc',
                id: 'admin/deployment/gcp/overview',
              },
              collapsed: true,
              items: [
                {
                  type: 'doc',
                  id: 'admin/deployment/gcp/prerequisites',
                  label: 'Prerequisites',
                },
                {
                  type: 'doc',
                  id: 'admin/deployment/gcp/architecture',
                  label: 'Architecture',
                },
                {
                  type: 'category',
                  label: 'Infrastructure Deployment',
                  link: {
                    type: 'doc',
                    id: 'admin/deployment/gcp/infrastructure-deployment/infrastructure-deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/deployment/gcp/infrastructure-deployment/infrastructure-scripted-deployment',
                    'admin/deployment/gcp/infrastructure-deployment/infrastructure-manual-deployment',
                  ],
                },
                {
                  type: 'category',
                  label: 'CodeMie Components Deployment',
                  link: {
                    type: 'doc',
                    id: 'admin/deployment/gcp/components-deployment/components-deployment-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/deployment/gcp/components-deployment/components-scripted-deployment',
                    {
                      type: 'category',
                      label: 'CodeMie Manual Deployment',
                      link: {
                        type: 'doc',
                        id: 'admin/deployment/gcp/components-deployment/manual-deployment/manual-deployment-overview',
                      },
                      collapsed: true,
                      items: [
                        'admin/deployment/gcp/components-deployment/manual-deployment/k8s-components',
                        'admin/deployment/gcp/components-deployment/manual-deployment/data-layer',
                        'admin/deployment/gcp/components-deployment/manual-deployment/security-and-identity',
                        'admin/deployment/gcp/components-deployment/manual-deployment/plugin-engine',
                        'admin/deployment/gcp/components-deployment/manual-deployment/core-components',
                        'admin/deployment/gcp/components-deployment/manual-deployment/observability',
                      ],
                    },
                  ],
                },
                {
                  type: 'doc',
                  id: 'admin/deployment/gcp/accessing-applications',
                  label: 'Accessing Applications',
                },
              ],
            },
            {
              type: 'category',
              label: 'Extensions',
              link: {
                type: 'doc',
                id: 'admin/deployment/extensions/extensions-overview',
              },
              collapsed: true,
              items: [
                {
                  type: 'category',
                  label: '✨ LiteLLM Proxy',
                  link: {
                    type: 'doc',
                    id: 'admin/deployment/extensions/litellm-proxy/litellm-proxy-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/deployment/extensions/litellm-proxy/configure-values',
                    'admin/deployment/extensions/litellm-proxy/auth-secrets',
                    'admin/deployment/extensions/litellm-proxy/model-config',
                    {
                      type: 'category',
                      label: 'Deployment',
                      link: {
                        type: 'doc',
                        id: 'admin/deployment/extensions/litellm-proxy/deployment/deployment-overview',
                      },
                      collapsed: true,
                      items: [
                        'admin/deployment/extensions/litellm-proxy/deployment/automated-deployment',
                        'admin/deployment/extensions/litellm-proxy/deployment/manual-deployment',
                      ],
                    },
                    'admin/deployment/extensions/litellm-proxy/migration-guide',
                  ],
                },
                {
                  type: 'category',
                  label: '✨ Assistants Evaluation',
                  link: {
                    type: 'doc',
                    id: 'admin/deployment/extensions/assistants-evaluation/assistants-evaluation',
                  },
                  collapsed: true,
                  items: [
                    'admin/deployment/extensions/assistants-evaluation/prerequisites',
                    'admin/deployment/extensions/assistants-evaluation/system-requirements',
                    'admin/deployment/extensions/assistants-evaluation/deployment-prerequisites',
                    {
                      type: 'category',
                      label: 'Deployment',
                      link: {
                        type: 'doc',
                        id: 'admin/deployment/extensions/assistants-evaluation/deployment/deployment-overview',
                      },
                      collapsed: true,
                      items: [
                        'admin/deployment/extensions/assistants-evaluation/deployment/automated-deployment',
                        'admin/deployment/extensions/assistants-evaluation/deployment/manual-deployment',
                      ],
                    },
                    'admin/deployment/extensions/assistants-evaluation/post-deployment',
                    'admin/deployment/extensions/assistants-evaluation/troubleshooting',
                  ],
                },
                'admin/deployment/extensions/ai-code-explorer/ai-code-explorer',
                'admin/deployment/extensions/angular-upgrade-assistant/angular-upgrade-assistant',
                'admin/deployment/extensions/salesforce-devforce-ai/salesforce-devforce-ai',
                'admin/deployment/extensions/mf-lens/mf-lens',
              ],
            },
          ],
        },
        {
          type: 'category',
          label: 'Configuration',
          link: {
            type: 'doc',
            id: 'admin/configuration/index',
          },
          collapsed: true,
          items: [
            {
              type: 'category',
              label: 'CodeMie',
              collapsed: true,
              items: [
                'admin/configuration/codemie/datasources-configuration',
                'admin/configuration/codemie/customer-feature-configuration',
                'admin/configuration/codemie/code-executor-configuration',
                {
                  type: 'category',
                  label: 'AI Models Integration',
                  link: {
                    type: 'doc',
                    id: 'admin/configuration/codemie/ai-models-integration/ai-models-integration-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/configuration/codemie/ai-models-integration/codemie-native-llm-config',
                    {
                      type: 'category',
                      label: 'Enable LLM Models in Cloud accounts',
                      collapsed: true,
                      items: [
                        'admin/configuration/codemie/ai-models-integration/azure-openai',
                        'admin/configuration/codemie/ai-models-integration/aws-bedrock',
                        'admin/configuration/codemie/ai-models-integration/google-vertex-ai',
                      ],
                    },
                  ],
                },
                'admin/configuration/codemie/api-configuration',
                'admin/configuration/codemie/platform-administration',
                'admin/configuration/codemie/project-budget-management',
              ],
            },
            {
              type: 'category',
              label: 'Access Control',
              link: {
                type: 'doc',
                id: 'admin/configuration/access-control/access-control-overview',
              },
              collapsed: true,
              items: [
                'admin/configuration/access-control/initial-realm-setup',
                'admin/configuration/access-control/platform-managed-mode-configuration',
                {
                  type: 'category',
                  label: 'User Provisioning',
                  link: {
                    type: 'doc',
                    id: 'admin/configuration/access-control/user-provisioning/user-provisioning-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/configuration/access-control/user-provisioning/manual-creation',
                    'admin/configuration/access-control/user-provisioning/keycloak-assistant',
                    'admin/configuration/access-control/user-provisioning/keycloak-entra-id',
                  ],
                },
                {
                  type: 'category',
                  label: 'User Authorization',
                  link: {
                    type: 'doc',
                    id: 'admin/configuration/access-control/user-authorization/user-authorization-overview',
                  },
                  collapsed: true,
                  items: [
                    'admin/configuration/access-control/user-authorization/assign-roles',
                    'admin/configuration/access-control/user-authorization/assign-attributes',
                    'admin/configuration/access-control/user-authorization/configure-guest-mapper',
                  ],
                },
              ],
            },
            {
              type: 'category',
              label: 'Extensions',
              collapsed: true,
              items: [
                {
                  type: 'category',
                  label: '✨ Assistants Evaluation',
                  collapsed: true,
                  items: [
                    'admin/configuration/extensions/assistants-evaluation/data-volume-maintenance',
                  ],
                },
                {
                  type: 'category',
                  label: '✨ LiteLLM Proxy',
                  collapsed: true,
                  items: [
                    'admin/configuration/extensions/litellm-proxy/budget-configuration',
                    'admin/configuration/extensions/litellm-proxy/model-configuration',
                    'admin/configuration/extensions/litellm-proxy/spend-logs-retention',
                  ],
                },
                {
                  type: 'category',
                  label: 'AWS',
                  collapsed: true,
                  items: ['admin/configuration/extensions/aws-agentcore/agentcore'],
                },
              ],
            },
            {
              type: 'category',
              label: 'Observability',
              link: {
                type: 'doc',
                id: 'admin/configuration/observability/observability-overview',
              },
              collapsed: true,
              items: ['admin/configuration/observability/logs-retention'],
            },
          ],
        },
        {
          type: 'category',
          label: 'Security & Compliance',
          link: {
            type: 'doc',
            id: 'admin/security/index',
          },
          collapsed: true,
          items: [
            'admin/security/data-processing-storage',
            'admin/security/roles-rbac',
            {
              type: 'category',
              label: 'Network Policies',
              link: {
                type: 'doc',
                id: 'admin/security/network-policies/index',
              },
              collapsed: true,
              items: ['admin/security/network-policies/mcp-connect-service'],
            },
          ],
        },
        {
          type: 'category',
          label: 'Update',
          link: {
            type: 'doc',
            id: 'admin/update/update-overview',
          },
          collapsed: true,
          items: [
            'admin/update/release-notes',
            'admin/update/codemie/update-version',
            {
              type: 'category',
              label: 'Keycloak',
              collapsed: true,
              items: [
                {
                  type: 'category',
                  label: 'Keycloak Upgrade',
                  link: {
                    type: 'doc',
                    id: 'admin/update/keycloak/keycloak-upgrade/keycloak-upgrade',
                  },
                  collapsed: true,
                  items: ['admin/update/keycloak/keycloak-upgrade/keycloak-24-to-26'],
                },
                'admin/update/keycloak/keycloak-operator-upgrade',
                'admin/update/keycloak/keycloak-database-migration',
                'admin/update/keycloak/keycloak-theme-setup',
              ],
            },
            'admin/update/terraform-upgrade/terraform-upgrade',
            'admin/update/oauth2-proxy-upgrade',
            'admin/update/elasticsearch-kibana-upgrade',
            'admin/update/fluent-bit-upgrade',
            'admin/update/nats-upgrade',
          ],
        },
        {
          type: 'doc',
          id: 'admin/faq',
          label: 'FAQ',
        },
      ],
    },
  ],
};

sidebars.userGuideSidebar = sidebars.mainSidebar;
sidebars.deploymentGuideSidebar = sidebars.mainSidebar;

export default sidebars;
