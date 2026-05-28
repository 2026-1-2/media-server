#!/bin/sh

CONF_DIR="/app/cam_conf"
YML_ORIG_FILE="/app/mediamtx-orig.yml"
YML_FILE="/app/mediamtx.yml"

cat $YML_ORIG_FILE >> $YML_FILE

if [ -d "$CONF_DIR" ] && ls "$CONF_DIR"/*.conf 1> /dev/null 2>&1; then
    for conf_file in "$CONF_DIR"/*.conf; do
        in_camera_block=0
        while IFS= read -r line; do
            line=$(echo "$line" | awk '{$1=$1};1')
            if [ -z "$line" ] || echo "$line" | grep -q "^#"; then
                continue
            fi
            
            if [ "$line" = "camera {" ]; then
                in_camera_block=1
                cam_name=""
                cam_ip=""
                cam_port=""
                cam_rtsp_path=""
                username=""
                password=""
                continue
            fi
            
            if [ "$in_camera_block" -eq 1 ]; then
                if [ "$line" = "}" ]; then
                    in_camera_block=0
                    url="rtsp://"

                    if [ -n "$username" ] && [ -n "$password" ]; then
                        url="${url}${username}:${password}@"
                    fi
                    
                    clean_path=$(echo "$cam_rtsp_path" | sed 's|^/||')
                    
                    url="${url}${cam_ip}:${cam_port}/${clean_path}"

                    cat <<EOF >> "$YML_FILE"
  $cam_name:
    source: $url
    rtspTransport: tcp
    sourceOnDemand: no
EOF
                    continue
                fi
                
                key=$(echo "$line" | awk '{print $1}')
                val=$(echo "$line" | sed "s/^$key[ \t]*//" | sed 's/;$//')
                case "$key" in
                    cam_name)      cam_name="$val" ;;
                    cam_ip)        cam_ip="$val" ;;
                    cam_port)      cam_port="$val" ;;
                    cam_rtsp_path) cam_rtsp_path="$val" ;;
                    username)      username="$val" ;;
                    password)      password="$val" ;;
                esac
            fi
        done < "$conf_file"
    done
fi

exec /app/mediamtx "$YML_FILE"