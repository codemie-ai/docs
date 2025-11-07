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
            {
              type: 'doc',
              id: 'deployment-guide/aws/faq',
              label: 'FAQ',
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
      label: 'User Guide',
    },
    {
      type: 'category',
      label: 'Getting Started',
      link: {
        type: 'doc',
        id: 'user-guide/getting-started/index',
      },
      collapsed: true,
      items: [
        'user-guide/getting-started/what-is-airuncodemie',
        'user-guide/getting-started/what-are-airuncodemie-capabilities',
        'user-guide/getting-started/meet-the-airun-faq-assistant',
        'user-guide/getting-started/help-center',
      ],
    },
    {
      type: 'category',
      label: 'Concepts',
      link: {
        type: 'doc',
        id: 'user-guide/concepts/index',
      },
      collapsed: true,
      items: [
        'user-guide/concepts/projects-overview',
        'user-guide/concepts/data-source-overview',
        'user-guide/concepts/project-visibility-management',
        'user-guide/concepts/working-with-code-repositories',
        'user-guide/concepts/indexing-data-sources',
        'user-guide/concepts/integrations-overview',
        'user-guide/concepts/what-is-the-difference-between-a-data-source-and-an-assistant-tool-in-codemie',
        'user-guide/concepts/administrative-tools-overview',
        'user-guide/concepts/processing-pictures',
      ],
    },
    {
      type: 'category',
      label: 'Working With Assistants',
      link: {
        type: 'doc',
        id: 'user-guide/assistants/index',
      },
      collapsed: true,
      items: [
        'user-guide/assistants/assistant-templates',
        'user-guide/assistants/create-assistant-from-a-template',
        'user-guide/assistants/edit-assistants',
        'user-guide/assistants/delete-assistants-and-chats',
        'user-guide/assistants/how-to-report-bugfeature-to-the-airun-codemie-team',
        'user-guide/assistants/view-airun-codemie-updates',
        'user-guide/assistants/sharing-assistants',
        'user-guide/assistants/restore-system-instructions',
        'user-guide/assistants/group-chats',
        'user-guide/assistants/folders-overview',
        'user-guide/assistants/supported-file-formats-and-csv-handling-in-chat-assistant',
        'user-guide/assistants/share-assistant-chat-with-other-users',
        'user-guide/assistants/export-assistant-chat-messages-to-worddocx-and-pdf-formats',
        'user-guide/assistants/marketplace-overview',
        'user-guide/assistants/clone-assistant-from-marketplace',
        'user-guide/assistants/subassistants-multiassistant-orchestrator',
        'user-guide/assistants/research-tools',
      ],
    },
    {
      type: 'category',
      label: 'Workflows',
      link: {
        type: 'doc',
        id: 'user-guide/workflows/index',
      },
      collapsed: true,
      items: [
        'user-guide/workflows/workflows-overview',
        'user-guide/workflows/create-workflow',
        'user-guide/workflows/create-a-workflow-from-a-template',
        'user-guide/workflows/workflow-templates',
        'user-guide/workflows/share-workflow-execution',
        'user-guide/workflows/exporting-workflow-execution',
        'user-guide/workflows/llmmodel-name-in-workflow',
      ],
    },
    {
      type: 'category',
      label: 'Conversational Advice',
      link: {
        type: 'doc',
        id: 'user-guide/conversational-advice/index',
      },
      collapsed: true,
      items: [
        'user-guide/conversational-advice/conversational-support',
        'user-guide/conversational-advice/indexing-duration',
        'user-guide/conversational-advice/improve-response-diversity',
        'user-guide/conversational-advice/codemie-jetbrains-ide-plugin',
      ],
    },
    {
      type: 'category',
      label: 'AI Documentation',
      link: {
        type: 'doc',
        id: 'user-guide/ai-documentation/index',
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
            'deployment-guide/aws/faq',
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
};

export default sidebars;
