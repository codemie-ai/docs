import React, { type MouseEvent, type ReactElement, type ReactNode } from 'react';
import Details from '@theme-original/Details';
import type { Props } from '@theme/Details';
import toaster from '@site/src/components/toaster';

function copyReleaseLink(event: MouseEvent<HTMLAnchorElement>, id: string): void {
  // Keep the click from reaching the Details toggle handler
  event.preventDefault();
  event.stopPropagation();

  window.history.replaceState(null, '', `#${id}`);
  const url = window.location.href;

  const copied = (): void => toaster.success('Link copied to clipboard');
  const copyFailed = (): void =>
    toaster.error('This browser does not support clipboard copy functionality or it is blocked');

  if (copyWithCommand(url)) {
    copied();
  } else if (navigator.clipboard) {
    navigator.clipboard.writeText(url).then(copied, copyFailed);
  } else {
    copyFailed();
  }
}

// The Clipboard API can wait on a permission prompt; the native copy command runs within the click
function copyWithCommand(text: string): boolean {
  const onCopy = (event: ClipboardEvent): void => {
    event.preventDefault();
    event.clipboardData?.setData('text/plain', text);
  };

  document.addEventListener('copy', onCopy);
  try {
    return document.execCommand('copy');
  } catch {
    return false;
  } finally {
    document.removeEventListener('copy', onCopy);
  }
}

export default function DetailsWrapper(props: Props): ReactNode {
  const { id, className, summary } = props;
  const isRelease = className?.split(' ').includes('release');

  if (!id || !isRelease || !React.isValidElement(summary)) {
    return <Details {...props} />;
  }

  const summaryElement = summary as ReactElement<{ children?: ReactNode }>;
  const summaryWithLink = React.cloneElement(
    summaryElement,
    {},
    summaryElement.props.children,
    <a
      key="release-link"
      className="release__link"
      href={`#${id}`}
      title="Copy link to this release"
      aria-label="Copy link to this release"
      onClick={event => copyReleaseLink(event, id)}
    >
      #
    </a>
  );

  return <Details {...props} summary={summaryWithLink} />;
}
