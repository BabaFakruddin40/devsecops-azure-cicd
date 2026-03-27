from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy", "service": "user-service"}), 200

@app.route('/users', methods=['GET'])
def get_users():
    return jsonify([
        {"id": 1, "name": "John Doe"},
        {"id": 2, "name": "Jane Smith"}
    ]), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)