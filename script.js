// Dummy articles for now (later will be fetched from backend API)
const articles = [
  {
    title: "World Leaders Meet for Global Summit",
    description: "Top leaders from around the globe gather to discuss climate change and economic reforms."
  },
  {
    title: "Tech Giants Release New AI Tools",
    description: "The latest AI tools promise to revolutionize the way businesses operate."
  },
  {
    title: "Markets Rally After Policy Announcement",
    description: "Stock markets see significant gains following new government policies."
  },
  {
    title: "Sports Update: Championship Highlights",
    description: "Fans witnessed an unforgettable final with stunning performances."
  }
];

// Function to display news
function loadNews() {
  const container = document.getElementById("news-container");
  container.innerHTML = articles.map(article => `
    <div class="news-card">
      <h2>${article.title}</h2>
      <p>${article.description}</p>
    </div>
  `).join("");
}

// Load news on page load
document.addEventListener("DOMContentLoaded", loadNews);
