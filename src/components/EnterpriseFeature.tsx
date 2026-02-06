import React from 'react';
import styles from './EnterpriseFeature.module.css';

export default function EnterpriseFeature(): React.ReactElement {
  return (
    <div className={styles.enterpriseFeature}>
      <div className={styles.enterpriseHeader}>
        <span className={styles.enterpriseIcon}>✨</span>
        <span className={styles.enterpriseTitle}>Enterprise Feature</span>
      </div>
      <p className={styles.enterpriseText}>This is an enterprise feature.</p>
    </div>
  );
}
