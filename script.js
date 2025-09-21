// Dummy articles
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

function loadNews() {
  console.log("✅ Script loaded. Rendering news...");
  const container = document.getElementById("news-container");
  if (!container) {
    console.error("❌ Container not found!");
    return;
  }

  container.innerHTML = articles.map(article => `
    <div class="news-card">
      <h2>${article.title}</h2>
      <p>${article.description}</p>
    </div>
  `).join("");
}

document.addEventListener("DOMContentLoaded", loadNews);
