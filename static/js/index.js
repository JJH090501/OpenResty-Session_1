const resultEl = document.getElementById("result");

// 세션 설정 요청
document.getElementById("setSessionBtn").addEventListener("click", () => {
    fetch("/api/session_test", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "set", value: "Harry_9805" })    
    })
        .then(res => res.json())
        .then(data => resultEl.innerText = JSON.stringify(data))
        .catch(err => console.error(err));
    });

    // 세션 조회 요청
    document.getElementById("getSessionBtn").addEventListener("click", () => {
        fetch("/api/session_test", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "get" })
    })
        .then(res => res.json())
        .then(data => resultEl.innerText = JSON.stringify(data))
        .catch(err => console.error(err));
    });