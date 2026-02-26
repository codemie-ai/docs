import React from 'react';

export default function EnterpriseFeature(): React.ReactElement {
  return (
    <div className="bg-magical rounded-lg py-4 px-6 my-6 text-white">
      <div className="flex items-center gap-2 mb-2">
        <span className="text-xl leading-none">✨</span>
        <span className="font-semibold text-base tracking-wide">Enterprise Feature</span>
      </div>
      <p className="m-0 opacity-95 text-[0.95rem]">This is an enterprise feature.</p>
    </div>
  );
}
