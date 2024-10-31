# README

<!-- This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ... -->

## Prerequisites
- Ubuntu Linux or Windows
  - Note: If you encounter problems on Windows, you could also use [WSL2](https://docs.docker.com/desktop/wsl/) to run a Linux instance on top of Windows.
- [Latest version of Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/)

## Development Environment Setup
1. Clone the repository
2. Open project folder in VS Code
3. Windows only: Set Git Bash as the default terminal in VS Code
   1. `Ctrl` + `Shift` + `P`
   2. "Terminal: Select default Profile"
   3. "Git Bash"
4. Ensure Docker is running
5. First start: execute `docker compose up --build` from project directory
    - Alternative: In VS Code `Ctrl` + `Shift` + `B` -> "Init"
    - This will create the docker containers, install required dependencies and start the containers
6. If containers have already been created: execute `docker compose up` from project directory
    - Alternative: In VS Code `Ctrl` + `Shift` + `B` -> "Run"
   - This will start the docker containers
7. Web application available under http://localhost:3000
8. With the Terminal from which the Containers where started in focus: `Ctrl` + `C` to stop server

**Note:** With the current setup, the webserver will be completely rebuilt whenever changes are detected by docker. This process takes a few seconds.

## Database Migration
- run `docker exec -it stura-website-web-1 rake db:migrate RAILS_ENV=development` from project directory
- Alternative: In VS Code `Ctrl` + `Shift` + `B` -> "Migrate Database"