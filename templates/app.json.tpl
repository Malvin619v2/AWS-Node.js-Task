  
[
  {
    "essential": true,
    "memory": 256,
    "name": "helloworldjs-app",
    "cpu": 256,
    "image": "203261016281.dkr.ecr.us-east-2.amazonaws.com/helloworldjs-app:latest",
    "workingDirectory": "/app",
    "command": ["npm", "start"],
    "portMappings": [
        {
            "containerPort": 3000,
            "hostPort": 3000
        }
    ]
  }
]

