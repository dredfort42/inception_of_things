# Create go.mod file
go mod init github.com/dredfort42/InceptionOfThings/DemoContainer

# Build Docker container
docker image build -t demo-container .

# Prepare and send to DockerHub
docker image tag demo-container dredfort/demo-container
docker image push dredfort/demo-container

# Run Docker container
docker run -p 9999:8888 dredfort/demo-container 