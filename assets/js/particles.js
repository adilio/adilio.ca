/**
 * Particle Animation System for adilio.ca
 * Creates floating particles with QRCheck-inspired colors
 */
(function() {
  'use strict';

  const particleContainer = document.querySelector('.particle-container');
  if (!particleContainer) return;

  const isMobile = window.matchMedia('(max-width: 768px)').matches;
  const particleCount = isMobile ? 22 : 36;
  const colors = ['pink', 'magenta', 'purple', 'blue', 'cyan', 'deep-purple'];

  function createParticle() {
    const particle = document.createElement('div');
    particle.className = `particle ${colors[Math.floor(Math.random() * colors.length)]}`;

    const size = Math.random() * 6 + 3;
    particle.style.width = `${size}px`;
    particle.style.height = `${size}px`;

    particle.style.left = `${Math.random() * 100}%`;

    const duration = Math.random() * 12 + 18;
    particle.style.animationDuration = `${duration}s`;

    const drift = (Math.random() - 0.5) * 220;
    particle.style.setProperty('--drift', `${drift}px`);

    const delay = Math.random() * 6;
    particle.style.animationDelay = `${delay}s`;

    particleContainer.appendChild(particle);

    setTimeout(() => {
      particle.remove();
      createParticle();
    }, (duration + delay) * 1000);
  }

  for (let i = 0; i < particleCount; i += 1) {
    createParticle();
  }
})();
