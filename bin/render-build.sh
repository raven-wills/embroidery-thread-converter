#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Starting Render build process..."

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

echo "Build process completed successfully"
