
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

#decode_jwt eyJhbGciOiJSUzI1NiIsImtpZCI6IkRFMDUyNzU5OTE4MjhEODhBMjE0QzVGNkExRTNFOENCIiwidHlwIjoiSldUIn0.eyJuYmYiOjE2NTAwNjEwMTcsImV4cCI6MTY1MDA2NDYxNywiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo0MDExIiwiYXVkIjoiczN2aWV3ZXItYXBwIiwiY2xpZW50X2lkIjoiY2xpZW50LWNyZWRlbnRpYWxzLWZsb3ctY2xpZW50LWlkIiwic3RyaW5nX2NsYWltIjoic3RyaW5nX2NsYWltX3ZhbHVlIiwianRpIjoiMjFDRjVEM0VGRjFCOTBDNUQ3REVDMjM0NkVCMzZGRkQiLCJpYXQiOjE2NTAwNjEwMTcsInNjb3BlIjpbInMzdmlld2VyIl0sImpzb25fY2xhaW0iOlsidmFsdWUxIiwidmFsdWUyIl19.oWO30TK3IWUCmd5P9nlDV6wD5IpvuvqGS5VGSxMSCcSEgbS-mSmaBMan71KPzGQpVnIXJKgT65gZFZdqYmdZTvKtnafAdVxwyOvVI5l50k_jO0JTgtuvwnlWszsHV54k-_DRnHo8kbCrhf54P4tw0sV8i96rOMWYF8pmTo1834Btd4A95tLcpNmqUwnnQ5exkjmo12t6It-as9pPj321ex1e0yu0DjgGC8F8Hmt4BMtrhxk95ApbvImD3r5r_2CTvYFavCFeGKbN63PypVyUPucE7lI4x5LACMMsMcLaJH_EK3dsdIS9ZN5rXGs5GRGW7_iRRMSMW5uQnF7rd33ncA
res=$(curl -X POST http://localhost:4011/connect/token -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=client_credentials&client_id=client-credentials-flow-client-id&client_secret=client-credentials-flow-client-secret&scope=s3viewer" | jq --raw-output '.access_token')

decode_jwt $res