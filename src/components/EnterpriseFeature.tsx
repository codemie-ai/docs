import React from 'react';
import Link from '@docusaurus/Link';

export default function EnterpriseFeature(): React.ReactElement {
  return (
    <div className="bg-magical rounded-lg py-4 px-6 my-6 text-white">
      <div className="flex items-center gap-2 mb-2">
        <span className="text-xl leading-none">✨</span>
        <span className="font-semibold text-base tracking-wide">Enterprise Feature</span>
      </div>
      <p className="m-0 opacity-95 text-[0.95rem]">
        Part of the CodeMie Enterprise package, and may not be enabled on every deployment. If this
        capability is missing from the UI described below, contact the CodeMie platform
        administrator.{' '}
        <Link
          to="/user-guide/getting-started/enterprise-features"
          className="text-white underline underline-offset-2 hover:text-white hover:opacity-80"
        >
          See all Enterprise features
        </Link>
        .
      </p>
    </div>
  );
}
