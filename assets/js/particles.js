/**
 * Particle Animation System for adilio.ca
 * Creates floating particles with QRCheck-inspired colors
 */
(function() {
  'use strict';

  const particleContainer = document.querySelector('.particle-container');
  if (!particleContainer) return;

  // Device detection for performance optimization
  const isMobile = window.matchMedia('(max-width: 768px)').matches;
  const particleCount = isMobile ? 15 : 25;

  const colors = ['pink', 'magenta', 'purple', 'blue', 'cyan', 'deep-purple'];

  function createParticle() {
    const particle = document.createElement('div');
    particle.className = `particle ${colors[Math.floor(Math.random() * colors.length)]}`;

    // Random size between 2-8px
    const size = Math.random() * 6 + 2;
    particle.style.width = `${size}px`;
    particle.style.height = `${size}px`;

    // Random horizontal position
    particle.style.left = `${Math.random() * 100}%`;

    // Random animation duration (15-25 seconds)
    const duration = Math.random() * 10 + 15;
    particle.style.animationDuration = `${duration}s`;

    // Random horizontal drift (-100px to +100px)
    const drift = (Math.random() - 0.5) * 200;
    particle.style.setProperty('--drift', `${drift}px`);

    // Random delay to stagger animations
    const delay = Math.random() * 5;
    particle.style.animationDelay = `${delay}s`;

    particleContainer.appendChild(particle);

    // Remove and recreate particle after animation completes
    setTimeout(() => {
      particle.remove();
      createParticle();
    }, (duration + delay) * 1000);
  }

  // Initialize particles
  for (let i = 0; i < particleCount; i++) {
    createParticle();
  }
})();
