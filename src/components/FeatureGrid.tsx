import React from 'react';
import styles from './FeatureGrid.module.css';

interface FeatureGridProps {
  children: React.ReactNode;
}

export default function FeatureGrid({
  children,
}: FeatureGridProps): JSX.Element {
  return <div className={styles.featureGrid}>{children}</div>;
}
