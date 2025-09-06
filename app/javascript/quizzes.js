// Quiz form visibility toggle functionality
function initializeQuizVisibility() {
  const privateSwitch = document.getElementById('quiz_private_switch');
  const userGroupsSection = document.getElementById('user-groups-section');
  const publicWarning = document.getElementById('public-warning');
  const publicDescription = document.getElementById('public-description');
  const privateDescription = document.getElementById('private-description');
  const lockIcon = document.querySelector('label[for="quiz_private_switch"] i');

  function updateVisibility() {
    if (privateSwitch && privateSwitch.checked) {
      // Private mode
      userGroupsSection.style.display = 'block';
      publicWarning.style.display = 'none';
      if (publicDescription) publicDescription.style.display = 'none';
      if (privateDescription) privateDescription.style.display = 'inline';
      if (lockIcon) {
        lockIcon.className = 'bi bi-lock-fill text-warning me-2';
      }
    } else {
      // Public mode
      userGroupsSection.style.display = 'none';
      publicWarning.style.display = 'block';
      if (publicDescription) publicDescription.style.display = 'inline';
      if (privateDescription) privateDescription.style.display = 'none';
      if (lockIcon) {
        lockIcon.className = 'bi bi-globe text-success me-2';
      }
    }
  }

  if (privateSwitch) {
    privateSwitch.addEventListener('change', updateVisibility);
    // Initialize on page load
    updateVisibility();
  }
}

// Initialize on DOM ready (for direct page loads)
document.addEventListener('DOMContentLoaded', initializeQuizVisibility);

// Initialize on Turbo navigation (for AJAX page loads)
document.addEventListener('turbo:load', initializeQuizVisibility);
