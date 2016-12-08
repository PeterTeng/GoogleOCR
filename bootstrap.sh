#!/bin/bash

echo_error() {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  echo -e "${RED}** ERROR${NC}"
  echo -e "${RED}* $1${NC}"
  echo -e "${RED}**${NC}"
}

#
# Check ruby
#
echo ""
echo " Checking Ruby version"
RUBY_VERSION=$(cat .ruby-version 2>/dev/null || curl $SCRIPT_URL/.ruby-version 2>/dev/null)
if ruby --version | grep $RUBY_VERSION > /dev/null 2>&1
then
  echo "  + ruby $RUBY_VERSION found."
else
  echo_error "  x ruby $RUBY_VERSION required"
  echo "    To install with rbenv"
  echo "    $ rbenv install $RUBY_VERSION"
  exit
fi
echo ""

#
# Check Dotenv
#
echo " Checking Dotenv"
if ( test $(which dotenv) > /dev/null 2>&1 )
then
  echo "  + Dotenv found."
else
  echo "  + Installing dotenv..."
  gem install dotenv &> /dev/null
fi

echo " Checking google-api-client"
if gem list | grep -q google-api-client
then
  echo "  + google-api-client found."
else
  echo "  + Installing google-api-client..."
  gem install google-api-client &> /dev/null
fi

#
#  .env
#
echo " Checking .env"
if test ! -f .env
then
  echo "  + Copy .env.example to .env"
  cp .env.example .env
else
  echo "  + .env found."
fi

echo -------------"DONE-------------"
