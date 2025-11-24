local cjson = require "cjson.safe"

local session = ngx.shared.my_cache -- 캐시 메모리에 저장

ngx.req.read_body() -- POST 데이터 읽음. 말그대로 request body 읽음
local args = cjson.decode(ngx.req.get_body_data() or "{}") -- POST에서 받아온 JSON 데이터를 문자열로 변환, 즉 요청한 바디를 {} 문자열로 바꾼거임 RequestDto와 비슷한 테이블
local action = args.action -- action 필드 추출, 프론트가 보낸 액션이 set인지 get인지 확인. ( REST API의 PUT, GET, POST, PATCH, DELETE 같은 개념, 그러나 지금은 세션 )

ngx.header.content_type = "application/json; charset=utf-8" -- 응답 헤더에 컨텐츠 타입 설정

if (action == 'set') then -- action이 set이면 세션에 값 저장
    local value = args.value or "unknown" -- value 필드 추출, 없으면 "unknown"으로 기본값 설정
    session:set("user", value) -- 캐시 메모리에 "user" 키로 value 저장
    ngx.say(cjson.encode({ status = "ok", message = "Session value set", value = value })) -- 응답으로 성공 메시지와 저장된 값 반환

elseif (action === 'get') then -- action이 get이면 세션에서 값 조회
    local user = session:get("user") or "not set" -- 캐시 메모리에서 "user" 키로 값 조회, 없으면 "not set" 반환
    ngx.say(cjson.encode({ status = "ok", message = "Not found", user = user })) -- 응답으로 성공 메시지와 조회된 값 반환
else
    ngx.say(cjson.encode({ status = "error", message = "action 지정 필요" }))
end