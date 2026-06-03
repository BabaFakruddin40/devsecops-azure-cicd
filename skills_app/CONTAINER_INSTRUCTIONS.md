# Build and run the DevOps/SRE Skills Tracker app in a container

# Build the Docker image
# (Run this command from the skills_app directory)
docker build -t skills-tracker .

# Run the container, mapping port 5000
# (The SQLite DB will persist only inside the container unless you mount a volume)
docker run -d -p 5000:5000 --name skills-tracker skills-tracker

# To persist the database, mount a local volume:
# docker run -d -p 5000:5000 -v $(pwd)/skills.db:/app/skills.db --name skills-tracker skills-tracker
