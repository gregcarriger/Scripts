# variables
$name=server.company.com
$domain=domain.company.com

# script
openssl pkcs12 -in $name.pfx -nocerts -out $name.key
openssl pkcs12 -in $name.pfx -clcerts -nokeys -out $name.pem
echo -n | openssl s_client -connect $domain:636 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $domain.crt
