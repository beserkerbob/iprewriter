#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <IP>"
    exit 1
fi

ip=$1

if ! [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid IP address format"
    exit 1
fi

IFS='.' read -r -a octets <<< "$ip"

# Decimal Notation
dec_ip=$(( (octets[0] << 24) + (octets[1] << 16) + (octets[2] << 8) + octets[3] ))
dec_ip_formatted=$(printf "%u" $dec_ip)

# Octal Notation
oct1=$(printf '0%03o' ${octets[0]})
oct2=$(printf '0%03o' ${octets[1]})
oct3=$(printf '0%03o' ${octets[2]})
oct4=$(printf '0%03o' ${octets[3]})
oct_ip="$oct1.$oct2.$oct3.$oct4"

# Hexadecimal Dot Notation
hex1=$(printf '0x%X' ${octets[0]})
hex2=$(printf '0x%X' ${octets[1]})
hex3=$(printf '0x%X' ${octets[2]})
hex4=$(printf '0x%X' ${octets[3]})
hex_ip="$hex1.$hex2.$hex3.$hex4"
# Output
echo $ip
if [ "${octets[2]}" -eq 0 ] && [ "${octets[1]}" -eq 0 ]; then
    echo "${octets[0]}.${octets[3]}"
fi
if [ "${octets[2]}" -eq 0 ]; then
    echo "${octets[0]}.${octets[1]}.${octets[3]}"
fi
echo $dec_ip_formatted
echo $oct_ip
echo $hex_ip
if [ "${octets[2]}" -ne 0 ] && [ "${octets[1]}" -ne 0 ]; then
    echo "$hex1.${octets[1]}.${hex3}.$hex4"
elif [ "${octets[2]}" -eq 0 ] && [ "${octets[1]}" -eq 0 ]; then
    echo "$hex1.0.0.$hex4"
elif [ "${octets[2]}" -eq 0 ]; then
    echo "$hex1.$hex2.0.$hex4"
else
    echo "$hex1.${octets[1]}.${hex3}.$hex4"
fi


#overflow the ips
overflow_ip() {
	if ! [ "${octets[2]}" -eq 0 ]; then
	    local firstoctet=${octets[0]}
	    local firstoverflow=$(((octets[2] + 255 + octets[3] )))
	    echo "${octets[0]}.${octets[1]}.${firstoverflow}"
	fi
	if ! [ "${octets[1]}" -eq 0 ]; then	
	    local a=${octets[0]}
	    local seconfoverflow=$(((octets[1] * 256 * 256) + (octets[2] * 256) + octets[3] ))
	    echo "${a}.${seconfoverflow}"
	fi
}

# Helper function to echo IPs with all variations
echo_ip_variations() {
    local a=$1 b=$2 c=$3 d=$4
    echo "$a.$b.$c.$d"
}

# Examples with combining different notations
echo_ip_variations ${octets[0]} ${octets[1]} ${octets[2]} ${octets[3]}
echo_ip_variations ${hex1} ${octets[1]} ${octets[2]} ${octets[3]}
echo_ip_variations ${oct1} ${octets[1]} ${octets[2]} ${octets[3]}

echo_ip_variations ${octets[0]} ${hex2} ${octets[2]} ${octets[3]}
echo_ip_variations ${octets[0]} ${oct2} ${octets[2]} ${octets[3]}

echo_ip_variations ${octets[0]} ${octets[1]} ${hex3} ${octets[3]}
echo_ip_variations ${octets[0]} ${octets[1]} ${oct3} ${octets[3]}

echo_ip_variations ${octets[0]} ${octets[1]} ${octets[2]} ${hex4}
echo_ip_variations ${octets[0]} ${octets[1]} ${octets[2]} ${oct4}

echo_ip_variations ${hex1} ${hex2} ${octets[2]} ${octets[3]}
echo_ip_variations ${hex1} ${oct2} ${octets[2]} ${octets[3]}
echo_ip_variations ${oct1} ${hex2} ${octets[2]} ${octets[3]}
echo_ip_variations ${oct1} ${oct2} ${octets[2]} ${octets[3]}

echo_ip_variations ${hex1} ${octets[1]} ${hex3} ${octets[3]}
echo_ip_variations ${hex1} ${octets[1]} ${oct3} ${octets[3]}
echo_ip_variations ${oct1} ${octets[1]} ${hex3} ${octets[3]}
echo_ip_variations ${oct1} ${octets[1]} ${oct3} ${octets[3]}

echo_ip_variations ${hex1} ${octets[1]} ${octets[2]} ${hex4}
echo_ip_variations ${hex1} ${octets[1]} ${octets[2]} ${oct4}
echo_ip_variations ${oct1} ${octets[1]} ${octets[2]} ${hex4}
echo_ip_variations ${oct1} ${octets[1]} ${octets[2]} ${oct4}

echo_ip_variations ${octets[0]} ${hex2} ${hex3} ${octets[3]}
echo_ip_variations ${octets[0]} ${hex2} ${oct3} ${octets[3]}
echo_ip_variations ${octets[0]} ${oct2} ${hex3} ${octets[3]}
echo_ip_variations ${octets[0]} ${oct2} ${oct3} ${octets[3]}

echo_ip_variations ${octets[0]} ${hex2} ${octets[2]} ${hex4}
echo_ip_variations ${octets[0]} ${hex2} ${octets[2]} ${oct4}
echo_ip_variations ${octets[0]} ${oct2} ${octets[2]} ${hex4}
echo_ip_variations ${octets[0]} ${oct2} ${octets[2]} ${oct4}

echo_ip_variations ${octets[0]} ${octets[1]} ${hex3} ${hex4}
echo_ip_variations ${octets[0]} ${octets[1]} ${hex3} ${oct4}
echo_ip_variations ${octets[0]} ${octets[1]} ${oct3} ${hex4}
echo_ip_variations ${octets[0]} ${octets[1]} ${oct3} ${oct4}

echo_ip_variations ${hex1} ${hex2} ${hex3} ${octets[3]}
echo_ip_variations ${hex1} ${hex2} ${oct3} ${octets[3]}
echo_ip_variations ${hex1} ${oct2} ${hex3} ${octets[3]}
echo_ip_variations ${hex1} ${oct2} ${oct3} ${octets[3]}

echo_ip_variations ${hex1} ${hex2} ${octets[2]} ${hex4}
echo_ip_variations ${hex1} ${hex2} ${octets[2]} ${oct4}
echo_ip_variations ${hex1} ${oct2} ${octets[2]} ${hex4}
echo_ip_variations ${hex1} ${oct2} ${octets[2]} ${oct4}

echo_ip_variations ${hex1} ${octets[1]} ${hex3} ${hex4}
echo_ip_variations ${hex1} ${octets[1]} ${hex3} ${oct4}
echo_ip_variations ${hex1} ${octets[1]} ${oct3} ${hex4}
echo_ip_variations ${hex1} ${octets[1]} ${oct3} ${oct4}

echo_ip_variations ${oct1} ${hex2} ${hex3} ${octets[3]}
echo_ip_variations ${oct1} ${hex2} ${oct3} ${octets[3]}
echo_ip_variations ${oct1} ${oct2} ${hex3} ${octets[3]}
echo_ip_variations ${oct1} ${oct2} ${oct3} ${octets[3]}

echo_ip_variations ${oct1} ${hex2} ${octets[2]} ${hex4}
echo_ip_variations ${oct1} ${hex2} ${octets[2]} ${oct4}
echo_ip_variations ${oct1} ${oct2} ${octets[2]} ${hex4}
echo_ip_variations ${oct1} ${oct2} ${octets[2]} ${oct4}

echo_ip_variations ${oct1} ${octets[1]} ${hex3} ${hex4}
echo_ip_variations ${oct1} ${octets[1]} ${hex3} ${oct4}
echo_ip_variations ${oct1} ${octets[1]} ${oct3} ${hex4}
echo_ip_variations ${oct1} ${octets[1]} ${oct3} ${oct4}

echo_ip_variations ${hex1} ${hex2} ${hex3} ${hex4}
echo_ip_variations ${hex1} ${hex2} ${hex3} ${oct4}
echo_ip_variations ${hex1} ${hex2} ${oct3} ${hex4}
echo_ip_variations ${hex1} ${hex2} ${oct3} ${oct4}

echo_ip_variations ${hex1} ${oct2} ${hex3} ${hex4}
echo_ip_variations ${hex1} ${oct2} ${hex3} ${oct4}
echo_ip_variations ${hex1} ${oct2} ${oct3} ${hex4}
echo_ip_variations ${hex1} ${oct2} ${oct3} ${oct4}

echo_ip_variations ${oct1} ${hex2} ${hex3} ${hex4}
echo_ip_variations ${oct1} ${hex2} ${hex3} ${oct4}
echo_ip_variations ${oct1} ${hex2} ${oct3} ${hex4}
echo_ip_variations ${oct1} ${hex2} ${oct3} ${oct4}

echo_ip_variations ${oct1} ${oct2} ${hex3} ${hex4}
echo_ip_variations ${oct1} ${oct2} ${hex3} ${oct4}
echo_ip_variations ${oct1} ${oct2} ${oct3} ${hex4}
echo_ip_variations ${oct1} ${oct2} ${oct3} ${oct4}

overflow_ip