# keyclock-OIDC
POC that configures nginx to use keyclock for authntication with identity provider (Google)

Set the following vars in .env file
```bash
# .env
BACKEND_SERVICE=
API_KEY_SERVICE=
KC_URL=
KC_REALM_CLIENT_SECRET=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
CALLBACK_URL=
```

 execute `make deploy`
