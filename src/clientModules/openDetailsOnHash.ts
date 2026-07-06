function openDetailsForHash(hash: string): void {
  if (!hash) return;

  const id = hash.startsWith('#') ? hash.slice(1) : hash;
  let attempts = 0;
  const maxAttempts = 30;

  const tryOpen = (): void => {
    const target = document.getElementById(id);
    if (!target) {
      if (attempts++ < maxAttempts) requestAnimationFrame(tryOpen);
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
