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
6. First start: execute `docker compose up --build` from project directory
    - Alternative: In VS Code `Ctrl` + `Shift` + `B` -> "Init"
    - This will create the docker containers, install required dependencies and start the containers
7. If containers have already been created: execute `docker compose up` from project directory
    - Alternative: In VS Code `Ctrl` + `Shift` + `B` -> "Run"
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
TODO...
