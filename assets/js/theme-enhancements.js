(function () {
  'use strict';

  const docEl = document.documentElement;
  const bodyEl = document.body;

  function syncThemeAttribute() {
    const theme = docEl.getAttribute('data-theme');
    if (theme) {
      bodyEl.setAttribute('data-theme', theme);
    } else {
      bodyEl.removeAttribute('data-theme');
    }
  }

  syncThemeAttribute();

  const themeObserver = new MutationObserver(syncThemeAttribute);
  themeObserver.observe(docEl, { attributes: true, attributeFilter: ['data-theme'] });

  const scrollTargets = document.querySelectorAll('[data-scroll-target]');
  scrollTargets.forEach((trigger) => {
    trigger.addEventListener('click', (event) => {
      event.preventDefault();
      const selector = trigger.getAttribute('data-scroll-target');
      if (!selector) return;
      const target = document.querySelector(selector);
      if (target) {
        target.scrollIntoView({ behavior: 'smooth' });
      }
    });
  });

  const revealables = document.querySelectorAll('[data-animate]');
  if ('IntersectionObserver' in window) {
    const revealObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            revealObserver.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.2 }
    );

    revealables.forEach((element) => revealObserver.observe(element));
  } else {
    revealables.forEach((element) => element.classList.add('is-visible'));
  }
})();
