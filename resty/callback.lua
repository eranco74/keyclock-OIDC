local opts = {
    ssl_verify = "no",  -- Consider setting this to "yes" in production
    redirect_uri = "${CALLBACK_URL}"
    discovery = "https://${KC_URL}/realms/rhelai/.well-known/openid-configuration",
    client_id = "nginx",
    client_secret = "${KC_REALM_CLIENT_SECRET}"
}


ngx.log(ngx.ERR, "OpenID Connect callback authnticating: ")
local res, err = require("resty.openidc").authenticate(opts)
if err then
    ngx.log(ngx.ERR, "OpenID Connect callback failed: ", err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- Set the access token in the request header for backend
ngx.req.set_header("Authorization", "Bearer " .. res.access_token)

-- Redirect user to the original request URL or a default location
-- return ngx.redirect("/login")
