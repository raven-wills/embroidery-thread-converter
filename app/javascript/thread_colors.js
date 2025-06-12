document.addEventListener('DOMContentLoaded', function() {
  const fromSelect = document.getElementById('from_brand');
  const toSelect = document.getElementById('to_brand');

  function updateToBrandOptions() {
    const selectedFrom = fromSelect.value;

    Array.from(toSelect.options).forEach(option => {
      if (option.value === selectedFrom) {
        option.style.display = 'none';
      } else {
        option.style.display = 'block';
      }
    });

    if (toSelect.value === selectedFrom) {
      toSelect.selectedIndex = 0;
    }
  }

  if (fromSelect && toSelect) {
    fromSelect.addEventListener('change', updateToBrandOptions);
    updateToBrandOptions(); // Initialize on page load
  }
});
