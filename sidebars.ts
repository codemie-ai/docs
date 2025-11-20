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
              id: 'deployment-guide/aws/post-installation/post-installation-overview',
              label: 'Post-Installation',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/ai-models-integration/ai-models-overview',
              label: 'AI Models Integration',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/update',
              label: 'Updates',
            },
            {
              type: 'doc',
              id: 'deployment-guide/aws/extensions/extensions-overview',
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
