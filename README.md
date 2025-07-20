# README

## Prerequisites
- Linux or Windows  
  - **Note:** If you're using Windows and want proper syntax highlighting/autocompletion for Ruby scripts, it's recommended to install and use [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) to run a Linux instance on top of Windows. Setting up a language server for Ruby on Windows natively is an absolute pain in the ass.
  - WSL2 setup instructions:
    - [Install a Linux distro using WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
    - Install VS Code and Docker Desktop on your **Windows** system
    - Clone the repository inside your **WSL2 Linux** installation
    - [Set up VS Code for working with WSL2](https://code.visualstudio.com/docs/remote/wsl)
    - [Set up Docker for working with WSL2](https://docs.docker.com/desktop/wsl/)
    - To open the project, type `code <path/to/project>` inside the Linux command line
    - Follow the [Development Environment Setup](#development-environment-setup) as if you were using Linux 🙂
- [Latest version of Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/)

## Development Environment Setup
1. Clone the repository
2. Open the project folder in VS Code
3. **Windows only:** Set Git Bash as the default terminal in VS Code
   1. Press `Ctrl` + `Shift` + `P`
   2. Select "Terminal: Select Default Profile"
   3. Choose "Git Bash"
4. Ensure Docker is running
5. First start: execute `init.dev.sh` from the project directory
   - Alternatively, in VS Code press `Ctrl` + `Shift` + `B` -> select "Init (development)"
   - This will create the Docker containers and start them
6. If containers have already been created: execute `run.dev.sh` from the project directory
   - Alternatively, in VS Code press `Ctrl` + `Shift` + `B` -> select "Run (development)"
   - This will start the Docker containers
7. Web application available at http://localhost:3000
8. With the terminal from which the containers were started in focus: press `Ctrl` + `C` to stop the server
9. *(Optional)* Set up Ruby syntax highlighting and autocomplete:
   1. Install Ruby 3.3.0  
      - **Note for WSL2 users:** Ruby must be installed in your **Linux** installation, **not** Windows
      - [Windows download](https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.3.0-1/rubyinstaller-devkit-3.3.0-1-x64.exe)
      - **Linux recommended method:** use [Ruby Version Manager](https://rvm.io/)
      - Alternative methods: https://www.ruby-lang.org/en/downloads/
   2. Run `bundle install`
      - This installs all dependencies required by the Ruby Language Server
      - You’ll need to re-run this if new dependencies are added to the `Gemfile`
   3. Install the [Ruby LSP](https://marketplace.visualstudio.com/items?itemName=Shopify.ruby-lsp) extension in VS Code

## Rails CLI
- **Note:** Since Ruby runs in a Docker container, all CLI commands must be executed from a [shell within the container](#webserver-shell-webserver-shellsh).
- Common commands:
  - `bin/rails generate`: Generate controllers, views, test files, etc.  
    Example: `bin/rails generate controller <ControllerName> <ActionName>`
  - `bin/rails db:migrate`: Run database migrations
- More details: [Rails Command Line Guide](https://guides.rubyonrails.org/command_line.html)

## Additional Utility Shell Scripts / VS Code Tasks
**Note:** All shell scripts are also available as VS Code tasks (`Ctrl` + `Shift` + `B` -> select task)

### Webserver Shell (`webserver-shell.sh`)
- Opens a shell inside the `stura-website-web-1` container
- Usage: `./webserver-shell.sh`

### Docker Shell (`docker-shell.sh`)
- Opens a shell in the container specified by name
- Usage: `./docker-shell.sh <container-name>`

### Database Migration (`migrate.sh`)
- Runs any pending database migrations
- Usage: `./migrate.sh`

## Useful Links
- [Ruby Documentation](https://www.ruby-lang.org/en/documentation/)
- [Rails Guides](https://guides.rubyonrails.org/index.html)
- [Rails API Documentation](https://api.rubyonrails.org/)
- [Rails CLI Guide](https://guides.rubyonrails.org/command_line.html)
- [Docker Docs](https://docs.docker.com/get-started/)

## Deployment Instructions
**Prerequisites:** Docker Compose

1. Rename `.example.env` to `.env` and set appropriate values for all variables
2. Initialize services by running the `init.prod.sh` helper script (this may take some time)
3. Initialize the database:
   1. Open a shell in the `web-1` container (e.g., via the `webserver-shell.sh` script)
   2. In the shell, run:
      ```sh
      bin/rails db:create db:migrate db:seed
      ```
4. Set up a reverse proxy with HTTPS (e.g., using [Nginx](https://nginx.org/) + [Certbot](https://certbot.eff.org/))
   - **Important:** The app is configured to use HTTP for internal communication but **assumes** the original client used HTTPS. The proxy must explicitly forward this info using a custom header (e.g., in Nginx: `proxy_set_header X-Forwarded-Proto https;`)
   - Example Nginx config:
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
      # Redirect all HTTP requests to HTTPS
      return 301 https://$host$request_uri; 
   }
   ```
5. If there are problems with email delivery:
   - check connectivity from within the docker container: `telnet <smtp-server-address> <port>`
   - take a look at [this](https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration)