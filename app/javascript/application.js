// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

function toggleRowVisibility() {
    var hiddenRow = document.getElementById("hidden-row");

    if (hiddenRow.style.display === "none") {
      hiddenRow.style.display = "";
    } else {
      hiddenRow.style.display = "none";
    }
  }