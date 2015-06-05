#!/bin/sh

set -ex

bundle install --deployment

bundle exec rake
