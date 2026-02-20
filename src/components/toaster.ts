import Toastify from 'toastify-js';

const fixCloseButton = () => {
  const closeButton = document.querySelector('.toast-close');
  if (closeButton) {
    closeButton.setAttribute('aria-label', 'Close notification');
    closeButton.innerHTML = '<div aria-hidden="true" class="toast-close-icon">&#10006;</div>';
  }
};

interface ToastOptions {
  text?: string;
  className?: string;
  newWindow?: boolean;
  close?: boolean;
  gravity?: 'top' | 'bottom';
  position?: 'left' | 'center' | 'right';

  /** Prevents dismissing of toast on hover */
  stopOnFocus?: boolean;
  escapeMarkup?: boolean;
  selector?: string;
  duration?: number;

  /** Callback after click */
  onClick?: () => void;
}

const defaultOpts: ToastOptions = {
  text: 'This is a toast',
  className: 'codemie-toast',
  newWindow: true,
  close: true,
  gravity: 'top',
  position: 'right',
  stopOnFocus: true,
  escapeMarkup: false,
  selector: 'toast-container',
  onClick() {},
};

const infoOpts: ToastOptions = {
  className: 'codemie-toast codemie-toast-info',
  duration: 3000,
};

const successOpts: ToastOptions = {
  className: 'codemie-toast codemie-toast-success',
  duration: 3000,
};

const errOpts: ToastOptions = {
  className: 'codemie-toast codemie-toast-err',
  duration: 10000,
};

const prepareText = (text: string): string => {
  const separatorRegex = /<br\s*\/?>/; // Matches <br>, <br/>, or </br>
  let [header, content] = text.split(separatorRegex, 2);

  if (!header) header = '';
  if (!content) content = '';

  return `<h2 class="codemie-toast-header">${header}</h2><p class="codemie-toast-content">${content}</p>`;
};

interface Toaster {
  info: (text: string) => void;
  success: (text: string) => void;
  error: (text: string) => void;
}

const toaster: Toaster = {
  info: (text: string) => {
    if (!text) return;
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
    Toastify({ ...defaultOpts, ...infoOpts, text: prepareText(text) }).showToast();
    fixCloseButton();
  },
  success: (text: string) => {
    if (!text) return;
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
    Toastify({ ...defaultOpts, ...successOpts, text: prepareText(text) }).showToast();
    fixCloseButton();
  },
  error: (text: string) => {
    if (!text) return;
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
    Toastify({ ...defaultOpts, ...errOpts, text: prepareText(text) }).showToast();
    fixCloseButton();
  },
};

export default toaster;
