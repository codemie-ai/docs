// Import all SVG icons as React components
import AwsLogo from '@site/static/img/cloud-providers/aws.svg';
import GcpLogo from '@site/static/img/cloud-providers/gcp.svg';
import AzureLogo from '@site/static/img/cloud-providers/azure.svg';

// Icon registry - map paths to components
export const iconRegistry: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  '/img/cloud-providers/aws.svg': AwsLogo,
  '/img/cloud-providers/gcp.svg': GcpLogo,
  '/img/cloud-providers/azure.svg': AzureLogo,
};

// Helper to get icon component by path
export function getIconComponent(
  path: string
): React.ComponentType<React.SVGProps<SVGSVGElement>> | null {
  return iconRegistry[path] || null;
}
