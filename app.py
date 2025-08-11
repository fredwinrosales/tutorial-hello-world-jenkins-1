from flask import Flask
app = Flask(__name__)

@app.get("/")
def hello():
    return {"msg": "Hola desde Docker + Jenkins!"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
