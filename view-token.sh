
_decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 2 ]; then result="$1"'=='
  elif [ $len -eq 3 ]; then result="$1"'=' 
  fi
  echo "$result" | tr '_-' '/+' | base64 -d
}

# $1 => JWT to decode
# $2 => either 1 for header or 2 for body (default is 2)
decode_jwt() { _decode_base64_url $(echo -n $1 | cut -d "." -f ${2:-2}) | jq .; }

# decodes body (default behaviour)
decode_jwt $MY_JWT
# decodes header
decode_jwt $MY_JWT 1 


res=$(curl -X POST http://localhost:4011/connect/token -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=client_credentials&client_id=client-credentials-flow-client-id&client_secret=client-credentials-flow-client-secret&scope=kafka-viewer" | jq --raw-output '.access_token')

decode_jwt $res