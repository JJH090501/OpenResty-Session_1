document.addEventListener('DOMContentLoaded', () => {
    // 1. "회원가입" 버튼 클릭 시 이동
    const signupBtn = document.getElementById('signupSub');
    if (signupBtn) {
        signupBtn.addEventListener('click', () => {
            // 회원가입 페이지 경로
            window.location.href = '/html/signup.html'; // 필요에 따라 경로 수정
        });
    }

    // 2. 로그인 폼 처리
    const loginForm = document.querySelector('.login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault(); // 기본 form 제출 방지

            const id = document.getElementById('userId').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!id || !password) {
                alert('아이디와 비밀번호를 모두 입력해주세요.');
                return;
            }

            const data = new URLSearchParams();
            data.append('id', id);
            data.append('password', password);

            fetch('/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: data,
                credentials: 'same-origin' // 쿠키/세션 전송
            })
            .then(res => res.text())
            .then(msg => {
                if (msg.includes('done')) {
                    alert('로그인 성공!');
                    window.location.href = '/home'; // 로그인 성공 후 이동 경로
                } else {
                    alert('로그인 실패'); // "fail" 또는 Lua에서 보내는 메시지
                }
            })
            .catch(err => {
                alert('로그인 요청 중 에러 발생: ' + err);
            });
        });
    }
});