from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/login', methods=['GET'])
def login():
    auth_token = request.headers.get('Authorization')
    if auth_token:
        token_status = "Auth Token is set."
        if auth_token.startswith('Bearer '):
            auth_token = auth_token[len('Bearer '):]
    else:
        token_status = "Auth Token is not set."

    return render_template('login.html', token_status=token_status, auth_token=auth_token)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
