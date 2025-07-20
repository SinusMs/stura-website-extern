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
- Linux or Windows
  - **Note:** If you use Windows and want proper syntax highlighting/autocompletion for Ruby scripts, you should install and use [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) to run a Linux instance on top of Windows. Setting up a language server for Ruby on Windows natively is an absolute pain in the ass.
  - WSL2 setup instructions:
    - [Install a Linux distro using WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
    - Install VS Code and Docker Desktop to your WINDOWS system
    - Clone the repostitory inside your WSL2 LINUX INSTALLATION
    - [Set up VS Code for working with WSL](https://code.visualstudio.com/docs/remote/wsl)
    - [Set up Docker for working whith WSL2](https://docs.docker.com/desktop/wsl/)
    - To open the project, type `code <path/to/project>` inside Linux Command Line
    - Follow the [Development Environment Setup Instructions](#development-environment-setup) as if you were using Linux :)
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
6. First start: execute `init.dev.sh` from project directory
    - Alternative: In VS Code `Ctrl` + `Shift` + `B` -> "Init (development)"
    - This will create the docker containers, install required dependencies and start the containers
7. If containers have already been created: execute `run.dev.sh` from project directory
    - Alternative: In VS Code `Ctrl` + `Shift` + `B` -> "Run (development)"
    - This will start the docker containers
8. Web application available under http://localhost:3000
9. With the Terminal from which the Containers where started in focus: `Ctrl` + `C` to stop server
10. (Optional) Set up Ruby syntax highlighting and autocomplete
     1. Install Ruby 3.3.0
        - **Note for WSL2 Users:** Ruby needs to be installed to your LINUX installation, NOT Windows
        - [Windows Dowload](https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.3.0-1/rubyinstaller-devkit-3.3.0-1-x64.exe)
        - Linux recommended installation method: via [Ruby Version Manager](https://www.ruby-lang.org/en/downloads/)
          - Alternative Ways: https://www.ruby-lang.org/en/downloads/
     3. Navigate to Folder `Ruby-LSP` in your local project and execute `bundle install`
        - This will install all dependencies required by the Ruby Language Server for this project
        - You will need to redo this step whenever a new dependency is added to the file "Gemfile" in the root folder
     4. Add extension [Ruby LSP](https://marketplace.visualstudio.com/items?itemName=Shopify.ruby-lsp) to VS Code

## Rails CLI
- **Note:** Because ruby runs in a docker container, all cli commands must be executed from a [shell within the container](#webserver-shell-webserver-shellsh).
- Most important commands:
  - `bin/rails generate`: Generate e.g. controllers along with their view and test files using `bin/rails generate controller <Controller Name> <Action/View Name>`
  - `bin/rails db:migrate`: Execute database migrations
- A more detailed overview can be found [here](https://guides.rubyonrails.org/command_line.html).

## Additional utility Shell Scripts/VS Code Tasks
**Note:** All Shell scripts are also available as VS Code Tasks (`Ctrl` + `Shift` + `B` -> Select Task)
### Webserver Shell (webserver-shell.sh)
- Starts a shell within the container "stura-website-web-1"
- `./webserver-shell.sh`
### Docker Shell (docker-shell.sh)
- Starts a shell within the container specified by its name
- `./docker-shell.sh <name>`
### Database Migration (migrate.sh)
- executes all pending database migrations
- `./migrate.sh`

## Useful Links
- [Ruby Doc](https://www.ruby-lang.org/en/documentation/)
- [Rails Guides](https://guides.rubyonrails.org/index.html)
- [Rails API Doc](https://guides.rubyonrails.org/index.html)
- [Rails CLI](https://guides.rubyonrails.org/command_line.html)
- [Docker Guides + Documentation](https://docs.docker.com/get-started/)

## Deployment Instructions
- Prerequisites: docker compose
1. Rename `.example.env` to `.env` and enter appropiate values for the variables in the file.
2. Initialize services by running `init.prod.sh` helper script. This might take a while.
3. Initialize Database:
   1. Open a shell in the web-1 Container. (i.e. by running the `webserver-shell.sh` helper script)
   2. In the shell, run `bin/rails db:create db:migrate db:seed`
4. Set up a reverse proxy with https, e.g. using nginx/certbot
   - **Important:** The application is configured to use http requests for communication with the reverse proxy but assume they were https requests originally. However, the proxy needs to set a custom header for the application to recognize a request as https. (In nginx using `proxy_set_header X-Forwarded-Proto https;`)
   - The final nginx configuration should look similar to this:
```nginx
server {
  listen 443 ssl;
  server_name yourdomain.com;

  ssl_certificate     /etc/ssl/certs/your-cert.pem;
  ssl_certificate_key /etc/ssl/private/your-key.pem;

  location / {
    proxy_pass http://rails_app:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Proto https;  # 👈 REQUIRED
    proxy_set_header X-Forwarded-Ssl on;       # optional but common
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}

server {
  listen 80;
  server_name yourdomain.com;
  # Use HTTPS only by redirecting all HTTP requests
  return 301 https://$host$request_uri; 
}
```