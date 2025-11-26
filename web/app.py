from flask import Flask, request, jsonify
import smtplib
from email.mime.text import MIMEText
import os

app = Flask(__name__)

def load_env_file():
    env_vars = {}
    try:
        with open('.env.txt', 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#'):
                    key, value = line.split('=', 1)
                    env_vars[key.strip()] = value.strip()
    except FileNotFoundError:
        print(".env file not found!")
        return {}
    return env_vars

def send_welcome_email(to_email):
    env = load_env_file()
    
    smtp_host = env.get('SMTP_HOST', 'smtp.gmail.com')
    smtp_port = int(env.get('SMTP_PORT', 587))
    smtp_user = env.get('SMTP_USER', '')
    smtp_pass = env.get('SMTP_PASS', '')
    from_email = env.get('FROM_EMAIL', smtp_user)

    if not all([smtp_user, smtp_pass]):
        print("SMTP credentials not found in .env")
        return False

    try:
        msg = MIMEText("Welcome to our service! Thanks for signing up.")
        msg['Subject'] = 'Welcome!'
        msg['From'] = from_email
        msg['To'] = to_email
        server = smtplib.SMTP(smtp_host, smtp_port)
        server.starttls()
        server.login(smtp_user, smtp_pass)
        server.sendmail(smtp_user, to_email, msg.as_string())
        server.quit()
        print(f"Welcome email sent to: {to_email}")
        return True
    except Exception as e:
        print(f"Failed to send email: {e}")
        return False

@app.route('/send-welcome', methods=['POST'])
def send_welcome():
    print(f"Received POST request with content-type: {request.content_type}")
    raw_data = request.get_data()
    print(f"Raw request data: {raw_data}")
    data = request.get_json()
    print(f"Parsed JSON: {data}")
    user_email = data.get('user_id') if data and 'user_id' in data else None
    if not user_email:
        user_email = data.get('email') if data and 'email' in data else None
    if not user_email:
        user_email = data.get('Email') if data and 'Email' in data else None
    
    if not user_email:
        print("No email found in request data")
        return jsonify({"error": "No email provided"}), 400
    
    print(f"Sending welcome email to: {user_email}")
    if send_welcome_email(user_email):
        return jsonify({"status": "success", "sent_to": user_email}), 200
    else:
        return jsonify({"status": "failed", "sent_to": user_email}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)