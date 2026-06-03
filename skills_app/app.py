
from flask import Flask, render_template_string, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///skills.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Skill(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, unique=True)
    progress = db.Column(db.Integer, default=0)

def init_db():
    db.create_all()
    if Skill.query.count() == 0:
        default_skills = [
            "Kubernetes",
            "Terraform",
            "CI/CD",
            "Monitoring & Logging",
            "Cloud Platforms (Azure/AWS/GCP)",
        ]
        for skill in default_skills:
            db.session.add(Skill(name=skill, progress=0))
        db.session.commit()

TEMPLATE = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DevOps/SRE Skills Tracker</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            /* Colorful gradient background */
            background: linear-gradient(135deg, #f7971e 0%, #ffd200 50%, #21d4fd 100%);
            min-height: 100vh;
        }
        .skill {
            margin-bottom: 20px;
            background: rgba(255,255,255,0.8);
            border-radius: 10px;
            padding: 15px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .progress-bar { width: 300px; background: #eee; border-radius: 5px; overflow: hidden; display: inline-block; margin-right: 10px; }
        .progress { background: #4caf50; height: 20px; }
        .add-skill { margin-top: 30px; }
        button, .delete-btn {
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .delete-btn {
            background: #ff5252;
            color: white;
            margin-left: 15px;
        }
        .delete-btn:hover {
            background: #d32f2f;
        }
    </style>
</head>
<body>
    <h1>DevOps/SRE Skills Tracker</h1>
    <form method="post" action="/update">
        {% for skill in skills %}
        <div class="skill">
            <div style="flex:1;">
                <label><b>{{ skill.name }}</b></label><br>
                <div class="progress-bar">
                    <div class="progress" style="width: {{ skill.progress }}%"></div>
                </div>
                <span>{{ skill.progress }}%</span>
                <input type="range" name="progress_{{ loop.index0 }}" min="0" max="100" value="{{ skill.progress }}">
            </div>
            <!-- Delete button form moved outside main form below -->
        </div>
        {% endfor %}
        <button type="submit">Update Progress</button>
    </form>
    {% for skill in skills %}
    <form method="post" action="/delete" style="display:inline;">
        <input type="hidden" name="skill_id" value="{{ skill.id }}">
        <button type="submit" class="delete-btn" onclick="return confirm('Delete this skill?');">Delete {{ skill.name }}</button>
    </form>
    {% endfor %}
    <div class="add-skill">
        <form method="post" action="/add">
            <input type="text" name="skill_name" placeholder="New skill name" required>
            <button type="submit">Add Skill</button>
        </form>
    </div>
</body>
</html>
'''
@app.route("/delete", methods=["POST"])
def delete_skill():
    skill_id = request.form.get("skill_id")
    if skill_id:
        skill = Skill.query.get(skill_id)
        if skill:
            db.session.delete(skill)
            db.session.commit()
    return redirect(url_for("index"))


@app.route("/", methods=["GET"])
def index():
    skills = Skill.query.all()
    return render_template_string(TEMPLATE, skills=skills)


@app.route("/update", methods=["POST"])
def update():
    skills = Skill.query.all()
    for i, skill in enumerate(skills):
        progress = request.form.get(f"progress_{i}")
        if progress is not None:
            skill.progress = int(progress)
    db.session.commit()
    return redirect(url_for("index"))


@app.route("/add", methods=["POST"])
def add_skill():
    name = request.form.get("skill_name")
    if name and not Skill.query.filter_by(name=name).first():
        db.session.add(Skill(name=name, progress=0))
        db.session.commit()
    return redirect(url_for("index"))


if __name__ == "__main__":
    if not os.path.exists("skills.db"):
        with app.app_context():
            init_db()
    app.run(debug=True, host="0.0.0.0", port=5000)
