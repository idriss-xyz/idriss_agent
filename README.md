# IDRISS AI Token Finder for Farcaster

## Getting Started

- Make sure you have Python 3.11.10
- Make sure you have Poetry installed

### Installation and Setup for Development

```shell
git clone https://github.com/victorpolisetty/idriss_project.git
cd visualisation_station
poetry env use 3.11.10
poetry install && poetry shell
make install
```

## How to run agent

```shell
./scripts/run_single_agent.sh victorpolisetty/idriss_frontend --force
```
Warning: Docker must be running

## How to run frontend (tested using Brave Browser)

```shell
http://localhost:5555/
```

## How to generate DB file

```shell
cd packages/victorpolisetty/customs/idriss_token_finder/database
python db_setup.db
```

## How to deploy

Setup Droplet on Digital Ocean:

1. Go to Digital Ocean

2. Click "Create Droplets"

3. Choose Region -> Default (San Francisco for me)

4. Choose Datacenter -> Default (San Francisco - Datacenter 3 - SF03)

5. VPC Network - Default

6. Choose an image -> Marketplace -> Search "Docker"

7. Choose Size -> Basic

8. CPU options -> Regular Disk type: SSD + $6/mo

9. Choose Authentication Method => Password (ShadowDog88@a)

10. Hostname -> Idriss Olas Token Finder

11. Create Droplet

Go Inside the console for the droplet:

Clone the project:
```shell
git clone https://github.com/victorpolisetty/idriss_project.git
cd idriss_project
```

Update Ubuntu system:
```shell
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential zlib1g-dev libssl-dev libffi-dev \
    libsqlite3-dev libbz2-dev libreadline-dev libncursesw5-dev libgdbm-dev \
    liblzma-dev libffi-dev uuid-dev wget
```

Install Python 3.11.10
```shell
cd /usr/src
sudo wget https://www.python.org/ftp/python/3.11.10/Python-3.11.10.tgz
sudo tar xvf Python-3.11.10.tgz
cd Python-3.11.10
sudo ./configure --enable-optimizations
sudo make -j$(nproc)
sudo make altinstall
```

Verify Python 3.11.10 is installed:
```shell
python3.11 --version  # Should output Python 3.11.10
```

Set Python 3.11.10 as default:
```shell
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.11 1
sudo update-alternatives --config python3  # Select Python 3.11.10
python3 --version  # Should now be 3.11.10
```

Install Poetry
```shell
curl -sSL https://install.python-poetry.org | python3.11 -
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Check poetry is installed correctly:
```shell
poetry --version
```

Setup project virtual env:
```shell
cd ~/idriss_project
poetry env use 3.11.10
poetry install --no-root
```

Run project:
```shell
poetry run ./scripts/run_single_agent.sh victorpolisetty/idriss_frontend --force
```

## Commands

Here are common commands you might need while working with the project:

### Resetting Docker

```shell
curl localhost:8080/hard_reset
```

## When to use API's

Use the /api/analyze (POST) endpoint when a user is using natural language to search for a new coin.

Use the /api/wallet/{walletAddress} (GET) endpoint when we want to retain the users original query and just rescan for any updates.

## API Endpoints

- /api/analyze (POST)
  
  Request Body:
  JSON object as shown query and wallet_address required.
  
  ![Screenshot 2025-01-21 at 8 34 01 PM](https://github.com/user-attachments/assets/f6688ee8-7abf-4ed2-b0cb-cc44108206b5)

  Responses:
  
  200: Returns a string representing the results of the analysis with keys message, parameters, suggestion, first_ticker, results.

  message -> success message
  parameters -> parameters fed into the searchcaster API
  
  suggestion -> suggestion generated by GPT if it thinks more info could yield better results
  
  first_ticker -> ticker of the coin that best matches the prompt
  
  results -> the casts from farcaster analyzed
  
  400: Returns an error message when the request is malformed or missing required fields (e.g., missing query).

  ![Screenshot 2025-01-21 at 8 43 43 PM](https://github.com/user-attachments/assets/d2159bd8-3217-4185-b696-45a3e11151ab)

  ![Screenshot 2025-01-23 at 10 59 12 AM](https://github.com/user-attachments/assets/d2dc9b19-c598-43ad-a85e-51f15a97d53a)

  ![Screenshot 2025-01-23 at 1 59 01 PM](https://github.com/user-attachments/assets/9a211614-b97e-4709-ae0f-14d9cafcaf3b)

- /api/user/{walletAddress} (GET)
  
  Path Parameter:
  
  walletAddress (string, required) – The unique identifier for the user.
  
  Responses:
  
  200: Returns user information, including wallet address, engagement, text, and count.
  
  404: Returns an error message if the wallet address does not exist in the database.
  
  400: Returns an error message when the request is malformed.

  ![Screenshot 2025-01-21 at 8 38 25 PM](https://github.com/user-attachments/assets/f134974f-1bc7-4571-9499-19c1356672d4)

- /api/wallet/{walletAddress} (GET)

  Path Parameter:

  walletAddress (string, required) – The wallet address to check in the database.

  Responses:

  200: Returns SearchCaster API results along with associated parameters and the first ticker (e.g., $SOCIAL).
  
  404: Returns an error message if the wallet address is not found in the database.
  
  500: Returns an error message for any internal server errors.

  ![Screenshot 2025-01-21 at 8 41 54 PM](https://github.com/user-attachments/assets/874cc8ce-b937-4676-80b8-63afa4e62e16)

### Database Structure

Table Name: AnalyzeRequest

Table Columns:

wallet_address -> A unique wallet address which identifies the user STRING

count -> How many casts you want the SearchCaster API to search through INT

text -> What keywords you want the SearchCaster API to look for STRING

engagement -> What filters you want the SearchCaster API to sort by (one of: ["reactions","recasts","replies","watches"]) STRING

prompt -> Prompt that the user inputted STRING

![Screenshot 2025-01-23 at 1 33 49 PM](https://github.com/user-attachments/assets/a2c65f52-5dc7-4574-9b21-eb9bb02bc30f)

## License

This project is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)

