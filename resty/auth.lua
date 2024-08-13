local opts = {
    ssl_verify = "no",  -- Consider setting this to "yes" in production
    redirect_uri = "${CALLBACK_URL}"
    discovery = "https://${KC_URL}/realms/rhelai/.well-known/openid-configuration",
    client_id = "nginx",
    client_secret = "${KC_REALM_CLIENT_SECRET}",
    scope = "openid"
}

ngx.log(ngx.INFO, "Authenticating...")

local res, err = require("resty.openidc").authenticate(opts)
if err then
    ngx.status = 500
    ngx.log(ngx.ERR, "OpenID Connect authentication failed: ", err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

ngx.log(ngx.INFO, "Got Authentication token", res.id_token.sub)
-- Set the X-USER header for authenticated requests
ngx.req.set_header("X-USER", res.id_token.sub)

-- Set the access token in the request header for backend

ngx.log(ngx.INFO, "Got access token", res.access_token)
ngx.req.set_header("Authorization", "Bearer " .. res.access_token)

