import React from 'react';

// Docusaurus Root wrapper component
// This wraps the entire application and allows us to add global elements
export default function Root({ children }: { children: React.ReactNode }) {
  return (
    <>
      {children}
      {/* Toast container for toastify notifications */}
      <div id="toast-container" />
    </>
  );
}
