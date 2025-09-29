<!DOCTYPE html>
<html>
<head>
  <title>Competition View</title>
  <link rel="stylesheet" href="competition.css">
  <style>
    /* Top Buttons */
    .top-buttons {
      display: flex;
      justify-content: flex-start;
      gap: 15px;
      margin: 20px;
    }
    .btn {
      padding: 10px 20px;
      background: #007bff;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      text-decoration: none;
      font-weight: bold;
      transition: 0.3s;
    }
    .btn:hover {
      background: #0056b3;
    }

    /* Image thumbnails */
    .file-img {
      max-width: 300px;
      cursor: pointer;
      border-radius: 8px;
      transition: 0.3s;
    }
    .file-img:hover {
      opacity: 0.8;
    }

    /* Video */
    .file-video {
      max-width: 500px;
      width: 100%;
      border-radius: 8px;
    }

    /* PDF */
    .file-pdf {
      width: 100%;
      height: 500px;
      border: none;
      margin-top: 10px;
      border-radius: 8px;
    }

    /* Wrapper */
    .file-box {
      margin: 20px;
      padding: 15px;
      border: 1px solid #ddd;
      border-radius: 8px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      background: #fafafa;
    }

    /* Modal (fullscreen) */
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0,0,0,0.9);
    }
    .modal-content {
      margin: auto;
      display: block;
      max-width: 90%;
      max-height: 90%;
    }
    .close {
      position: absolute;
      top: 20px;
      right: 40px;
      color: white;
      font-size: 40px;
      font-weight: bold;
      cursor: pointer;
    }
    .download-btn {
      position: absolute;
      bottom: 30px;
      right: 40px;
      background: white;
      padding: 10px 20px;
      border-radius: 5px;
      text-decoration: none;
      font-weight: bold;
      color: black;
    }
  </style>
</head>
<body>
  <!-- Back Buttons -->
  <div class="top-buttons">
    <button class="btn" onclick="goBack()">Back</button>
    <a href="Staff.html" class="btn">Back to Dashboard</a>
  </div>

  <div class="competition-view">
    <h2 id="compTitle"></h2>
    <div id="filesContainer"></div>
  </div>

  <!-- Modal -->
  <div id="imgModal" class="modal">
    <span class="close">&times;</span>
    <img class="modal-content" id="modalImg">
    <a id="downloadLink" class="download-btn" target="_blank">Download</a>
  </div>

  <script>
    // Back button function
    function goBack() {
      window.history.back();
    }

    const urlParams = new URLSearchParams(window.location.search);
    const comp = urlParams.get("comp");
    document.getElementById("compTitle").innerText = comp.toUpperCase() + "Competition";

    fetch("ListFilesServlet?comp=" + comp)
      .then(res => res.json())
      .then(files => {
        const container = document.getElementById("filesContainer");
        container.innerHTML = "";

        files.forEach(path => {
          let ext = path.split('.').pop().toLowerCase();
          const wrapper = document.createElement("div");
          wrapper.classList.add("file-box");

          const heading = document.createElement("h3");
          heading.style.textAlign = "center";
          heading.style.marginBottom = "10px";

          if (["jpg", "jpeg", "png"].includes(ext)) {
            heading.innerText = "Image Preview";
            const img = document.createElement("img");
            img.src = path;
            img.classList.add("file-img");

            // Fullscreen open on click
            img.addEventListener("click", () => {
              const modal = document.getElementById("imgModal");
              const modalImg = document.getElementById("modalImg");
              const downloadLink = document.getElementById("downloadLink");

              modal.style.display = "block";
              modalImg.src = path;
              downloadLink.href = path;
              downloadLink.download = path.split("/").pop();
            });

            wrapper.appendChild(heading);
            wrapper.appendChild(img);

          } else if (ext === "mp4") {
            heading.innerText = "Video Clip";
            const video = document.createElement("video");
            video.src = path;
            video.controls = true;
            video.classList.add("file-video");
            wrapper.appendChild(heading);
            wrapper.appendChild(video);

          } else if (ext === "pdf") {
            heading.innerText = "PDF Document";
            const iframe = document.createElement("iframe");
            iframe.src = path;
            iframe.classList.add("file-pdf");
            wrapper.appendChild(heading);
            wrapper.appendChild(iframe);
          }

          container.appendChild(wrapper);
        });

        // Only for semaphore competition: add Practice Resources section
        if (comp === "semaphore") {
          const resDiv = document.createElement("div");
          resDiv.classList.add("practice-resources");
          resDiv.innerHTML = `
            <h3>Practice Resources</h3>
            <div class="badges">
              <a href="https://play.google.com/store/apps/details?id=com.saysua.semaphoretraining.next" target="_blank">
                <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get it on Google Play" class="gp-badge">
              </a>
              <a href="https://play.google.com/store/apps/details?id=dieuk.semoplay" target="_blank">
                <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get it on Google Play" class="gp-badge">
              </a>
            </div>`;
          container.appendChild(resDiv);
        }
      })
      .catch(err => console.error("Error loading files:", err));

    // Close modal
    const modal = document.getElementById("imgModal");
    const closeBtn = document.querySelector(".close");
    closeBtn.onclick = function() {
      modal.style.display = "none";
    };
    window.onclick = function(event) {
      if (event.target == modal) {
        modal.style.display = "none";
      }
    };
  </script>
</body>
</html>
