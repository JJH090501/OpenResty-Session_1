package.path = "/usr/local/openresty/lualib/?.lua;" .. package.path
package.cpath = "/usr/local/openresty/lualib/?.so;" .. package.cpath

local mysql = require "resty.mysql"
local cjson = require "cjson.safe"
local session_lib =require "resty.session"
local session = session_lib.start()

-- 요청 POST 데이터 읽기
ngx.req.read_body()
local args = ngx.req.get_post_args() -- POST에서 받아온 데이터를 테이블로 변환
local id = args.id -- 아이디 추출
local pw = args.password -- 비번 추출

if ngx.req.get_method() ~= "POST" then
    ngx.status = 405  -- Method Not Allowed
    ngx.say("POST 요청만 허용됩니다.")
    return ngx.redirect("/login.html")
end

ngx.say("요청 읽음 ㅗ")

-- 데이터 베이스 연결
local db, err = mysql:new()
if not db then -- db 객체 생성 실패시
    ngx.status = 500 -- 500 에러 반환
    ngx.say("db 연결 실패: ", err) -- 에러 메시지 출력
    return
end

db:set_timeout(1000) -- 1초 타임아웃 설정

local ok, err, errno, sqlstate = db:connect{
    host = '127.0.0.1',
    port = 3306,
    database = 'lua_db',
    user = 'root',
    password = 'wkdwnsgur09',
    charset = 'utf8',
    max_packet_size = 1024 * 1024,
}

if not ok then
    ngx.status = 500
    ngx.say("db 연결 실패: ", err, ": ", errno, " ", sqlstate)
    return
else
    ngx.say("디비 연결 성공 ㅗ")
end

-- 사용자 인증 쿼리
local sql = "SELECT * FROM users WHERE id = '" .. id .. "' AND pw = '" .. pw .. "' LIMIT 1"
local res, err, errno, sqlstate = db:query(sql)
if not res then
    ngx.status = 500
    ngx.say("쿼리 실패: ", err, ": ", errno, " ", sqlstate)
    return
end

ngx.say("id:", id, " pw:", pw)
ngx.say("SQL:", "SELECT * FROM users WHERE id = '" .. id .. "' AND pw = '" .. pw .. "' LIMIT 1")


if #res == 1 then
    session.data.user = id
    session:save()
    ngx.say("done")
else
    ngx.say("fail")
end

-- 데이터베이스 연결 종료
db:set_keepalive(10000, 10)