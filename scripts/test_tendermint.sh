while true; do
    curl -s http://localhost:26657/status && break
    echo "Waiting for Tendermint..."
    sleep 1
done
echo "Tendermint is up!"