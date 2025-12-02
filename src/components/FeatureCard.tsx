import React from 'react';
import Link from '@docusaurus/Link';
import styles from './FeatureCard.module.css';

interface FeatureCardProps {
  title: string;
  description: string;
  link: string;
  icon?: string;
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
  const renderIcon = () => {
    if (iconType === 'image') {
      const imageClasses = `${styles.featureCardImage} ${invertInDarkTheme ? styles.invertInDarkTheme : ''} ${invertInLightTheme ? styles.invertInLightTheme : ''} no-zoom`;
      return <img src={icon} alt={`${title} logo`} className={imageClasses} />;
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
