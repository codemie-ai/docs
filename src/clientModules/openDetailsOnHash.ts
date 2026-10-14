let openedByHash = new WeakSet<HTMLDetailsElement>();
let lastHash = '';

function openDetailsChain(target: HTMLElement): void {
  const chain: HTMLDetailsElement[] = [];
  let details = target.closest('details');
  while (details) {
    chain.unshift(details);
    details = details.parentElement?.closest('details') ?? null;
  }

  // Load and route-update handlers can both fire before React commits the open state,
  // so a second click would toggle the element closed again. The native `open` attribute is
  // ignored because browsers set it on ancestors during fragment navigation without updating React
  for (const item of chain) {
    if (openedByHash.has(item)) continue;
    openedByHash.add(item);
    if (item.dataset.collapsed !== 'false') {
      item.querySelector<HTMLElement>(':scope > summary')?.click();
    }
  }

  // Wait for the expand animation so the scroll position accounts for opened content
  setTimeout(() => target.scrollIntoView({ behavior: 'smooth', block: 'start' }), 300);
}

function openDetailsForHash(hash: string): void {
  if (!hash) return;
  if (hash !== lastHash) {
    lastHash = hash;
    openedByHash = new WeakSet();
  }

  const id = hash.startsWith('#') ? hash.slice(1) : hash;
  let attempts = 0;
  const maxAttempts = 30;

  const tryOpen = (): void => {
    const target = document.getElementById(id);
    if (!target) {
      if (attempts++ < maxAttempts) requestAnimationFrame(tryOpen);
      return;
    }

    if (target.closest('details')) {
      openDetailsChain(target);
      return;
    }

    const heading = target.closest('h1, h2, h3, h4, h5, h6') ?? target;
    let sibling = heading.nextElementSibling;

    while (sibling) {
      const details =
        sibling.tagName === 'DETAILS'
          ? (sibling as HTMLDetailsElement)
          : sibling.querySelector('details');

      if (details && !details.open) {
        const summary = details.querySelector('summary');
        summary?.click();
      }

      if (details) {
        heading.scrollIntoView({ behavior: 'smooth', block: 'start' });
        return;
      }

      sibling = sibling.nextElementSibling;
    }
  };

  requestAnimationFrame(tryOpen);
}

export function onRouteDidUpdate({ location }: { location: Location }): void {
  openDetailsForHash(location.hash);
}

if (typeof window !== 'undefined') {
  if (document.readyState === 'complete') {
    openDetailsForHash(window.location.hash);
  } else {
    window.addEventListener('load', () => openDetailsForHash(window.location.hash));
  }
}
