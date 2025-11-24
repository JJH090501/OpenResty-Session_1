types {
    text/html                html htm shtml;
    text/css                 css;
    text/xml                 xml;
    image/gif                gif;
    image/jpeg               jpeg jpg;
    application/javascript   js;
    application/json         json;
    image/png                png;
    image/svg+xml            svg;
    application/font-woff    woff;
    application/octet-stream bin exe;
} 

# 이게 바로 mime.types 에 들어있는 확장자 명들임. 위는 예시

http {
    include mime.types;

    types {
        text/markdown md;       # md 파일은 text/markdown으로 처리
        application/xml xhtml;  # xhtml 확장자 처리 추가
    }
}

# 위 처럼 mime.types에 없는 거 있음, 저렇게 추가

server {
    listen 8080;             # 서버 포트
    server_name localhost;
}

# 서버 설정 편집 시 위 처럼 server_name을 로컬로 하면 로컬포트로 돌아감. 
# 실제 운영 시 api.example.com 처럼 도메인 주소로 지정 또는 서버 IP 주소를 넣음. ( 0.0.0.0 과 같음 )
