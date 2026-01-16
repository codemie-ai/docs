import React from 'react';
import Link from '@docusaurus/Link';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './FeatureCard.module.css';
import { getIconComponent } from './IconRegistry';

interface FeatureCardProps {
  title: string;
  description: string;
  link: string;
  icon?: string | React.ReactNode;
  iconType?: 'emoji' | 'image';
  invertInDarkTheme?: boolean;
  invertInLightTheme?: boolean;
}

export default function FeatureCard({
  title,
  description,
  link,
  icon = '📘',
  iconType = 'emoji',
  invertInDarkTheme = true,
  invertInLightTheme = false,
}: FeatureCardProps): React.JSX.Element {
  const iconUrl = useBaseUrl(typeof icon === 'string' ? icon : '');

  const renderIcon = () => {
    if (iconType === 'image') {
      if (typeof icon === 'string') {
        // Try to get SVG component from registry first
        const SvgComponent = getIconComponent(icon);
        if (SvgComponent) {
          return (
            <div
              className={`${styles.featureCardSvg} ${invertInDarkTheme ? styles.invertInDarkTheme : ''} ${invertInLightTheme ? styles.invertInLightTheme : ''}`}
            >
              <SvgComponent />
            </div>
          );
        }
        // Fallback to img tag for regular images or non-registered SVGs
        const imageClasses = `${styles.featureCardImage} ${invertInDarkTheme ? styles.invertInDarkTheme : ''} ${invertInLightTheme ? styles.invertInLightTheme : ''} no-zoom`;
        return <img src={iconUrl} alt={`${title} logo`} className={imageClasses} />;
      }
      // Render inline SVG React node
      return (
        <div
          className={`${styles.featureCardSvg} ${invertInDarkTheme ? styles.invertInDarkTheme : ''} ${invertInLightTheme ? styles.invertInLightTheme : ''}`}
        >
          {icon}
        </div>
      );
    }
    return <div className={styles.featureCardIcon}>{icon}</div>;
  };

  return (
    <div className={styles.featureCard}>
      <Link to={link} className={styles.featureCardLink}>
        {renderIcon()}
        <h3 className={styles.featureCardTitle}>{title}</h3>
        <p className={styles.featureCardDescription}>{description}</p>
        <span className={styles.featureCardArrow}>→</span>
      </Link>
    </div>
  );
}
