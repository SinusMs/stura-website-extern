#!/bin/bash

docker exec -it stura-website-web-1 rake db:migrate RAILS_ENV=development