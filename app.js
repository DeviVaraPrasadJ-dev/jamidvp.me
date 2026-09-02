// -----------------------------------------------------------------------------
// JavaScript: Interactive Logic for DevOps & Cloud Portfolio
// Terminal Tab Switcher, Command Copy, ScrollSpy, Back-to-Top, and FormSubmit Emailer
// -----------------------------------------------------------------------------

document.addEventListener('DOMContentLoaded', () => {
  // 1. Mobile Navigation Toggle
  const mobileToggle = document.getElementById('mobileNavToggle');
  const navLinks = document.querySelector('.nav-links');

  if (mobileToggle && navLinks) {
    mobileToggle.addEventListener('click', () => {
      if (navLinks.style.display === 'flex') {
        navLinks.style.display = '';
      } else {
        navLinks.style.display = 'flex';
        navLinks.style.position = 'absolute';
        navLinks.style.top = '54px';
        navLinks.style.left = '0';
        navLinks.style.width = '100%';
        navLinks.style.background = '#ffffff';
        navLinks.style.flexDirection = 'column';
        navLinks.style.padding = '20px';
        navLinks.style.gap = '14px';
        navLinks.style.boxShadow = '0 10px 25px rgba(0,0,0,0.1)';
        navLinks.style.borderBottom = '1px solid #e2e8f0';
      }
    });

    navLinks.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        if (window.innerWidth <= 768) {
          navLinks.style.display = '';
        }
      });
    });
  }

  // 2. Terminal Tabs Switching
  const tabButtons = document.querySelectorAll('.terminal-tabs .terminal-tab-btn');
  const termPanes = document.querySelectorAll('.terminal-body .term-pane');

  tabButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const tabId = btn.getAttribute('data-tab');

      // Update button active state
      tabButtons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      // Update pane active state
      termPanes.forEach(pane => pane.classList.remove('active'));
      const activePane = document.getElementById(`pane-${tabId}`);
      if (activePane) {
        activePane.classList.add('active');
      }
    });
  });

  // 3. Copy Terminal Command Utility
  const copyCmdBtn = document.getElementById('copyCmdBtn');
  const copyBtnText = document.getElementById('copyBtnText');

  if (copyCmdBtn && copyBtnText) {
    copyCmdBtn.addEventListener('click', () => {
      const activePane = document.querySelector('.terminal-body .term-pane.active');
      if (activePane) {
        const cmdToCopy = activePane.getAttribute('data-command') || '';
        navigator.clipboard.writeText(cmdToCopy).then(() => {
          copyBtnText.textContent = 'Copied!';
          copyCmdBtn.style.color = '#15803d';
          setTimeout(() => {
            copyBtnText.textContent = 'Copy Command';
            copyCmdBtn.style.color = '';
          }, 2000);
        }).catch(() => {
          copyBtnText.textContent = 'Copied!';
          copyCmdBtn.style.color = '#15803d';
          setTimeout(() => {
            copyBtnText.textContent = 'Copy Command';
            copyCmdBtn.style.color = '';
          }, 2000);
        });
      }
    });
  }

  // 4. Smooth Scrolling with Sticky Navbar Offset
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      const targetId = this.getAttribute('href');
      if (targetId === '#' || !targetId) return;

      const targetEl = document.querySelector(targetId);
      if (targetEl) {
        e.preventDefault();
        const headerOffset = 104; // 54px main nav + 48px subnav + 2px border
        const elementPosition = targetEl.getBoundingClientRect().top;
        const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

        window.scrollTo({
          top: offsetPosition,
          behavior: 'smooth'
        });
      }
    });
  });

  // 5. Active ScrollSpy (Highlights Nav Links as User Scrolls)
  const sections = document.querySelectorAll('section[id]');
  const navItems = document.querySelectorAll('.sub-nav-menu a, .nav-links a');

  function updateScrollSpy() {
    const scrollY = window.pageYOffset;

    sections.forEach(current => {
      const sectionHeight = current.offsetHeight;
      const sectionTop = current.offsetTop - 120;
      const sectionId = current.getAttribute('id');

      if (scrollY >= sectionTop && scrollY < sectionTop + sectionHeight) {
        navItems.forEach(link => {
          link.classList.remove('active');
          if (link.getAttribute('href') === `#${sectionId}`) {
            link.classList.add('active');
          }
        });
      }
    });
  }

  window.addEventListener('scroll', updateScrollSpy);

  // 6. Floating Back to Top Button
  const backToTopBtn = document.getElementById('backToTopBtn');
  if (backToTopBtn) {
    window.addEventListener('scroll', () => {
      if (window.pageYOffset > 350) {
        backToTopBtn.classList.add('visible');
      } else {
        backToTopBtn.classList.remove('visible');
      }
    });

    backToTopBtn.addEventListener('click', () => {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    });
  }

  // 7. Contact Form Email Delivery (FormSubmit Direct Delivery to Inbox)
  const contactForm = document.getElementById('contactForm');
  const formSuccess = document.getElementById('formSuccess');

  if (contactForm && formSuccess) {
    contactForm.addEventListener('submit', function(e) {
      e.preventDefault();
      const submitBtn = contactForm.querySelector('button[type="submit"]');
      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = `<span>Sending Message...</span> <i class="fa-solid fa-spinner fa-spin"></i>`;
      }

      const formData = new FormData(contactForm);

      fetch('https://formsubmit.co/ajax/jamidevivaraprasad611@gmail.com', {
        method: 'POST',
        headers: { 
          'Accept': 'application/json'
        },
        body: formData
      })
      .then(response => {
        formSuccess.style.display = 'block';
        contactForm.reset();
        if (submitBtn) {
          submitBtn.disabled = false;
          submitBtn.innerHTML = `<span>Send Message</span> <i class="fa-solid fa-paper-plane"></i>`;
        }
        setTimeout(() => {
          formSuccess.style.display = 'none';
        }, 8000);
      })
      .catch(error => {
        // Fallback: still show confirmation and allow standard direct email
        formSuccess.style.display = 'block';
        contactForm.reset();
        if (submitBtn) {
          submitBtn.disabled = false;
          submitBtn.innerHTML = `<span>Send Message</span> <i class="fa-solid fa-paper-plane"></i>`;
        }
        setTimeout(() => {
          formSuccess.style.display = 'none';
        }, 8000);
      });
    });
  }
});
