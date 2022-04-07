#put fdfsImage.tar.gz under same folder then run this script

#!/bin/bash
cd shells
docker ps |grep tracker > trackerrun
trackerrun=`cat trackerrun`
docker ps |grep storage > storagerun
storagerun=`cat storagerun`
if [ -z "$trackerrun" ] || [ -z "$storagerun" ];then
  if [ $# = 2 ];then
    ip=$1
    port=$2
    process="1"
    if [ ! -e /home/dockerfdfs/conf/tracker.conf ] && [ ! -e /home/dockerfdfs/conf/storage.conf ] && [ ! -e /home/dockerfdfs/conf/client.conf ] && [ $process = "1" ];then
      mkdir -p /home/dockerfdfs/tracker
      mkdir -p /home/dockerfdfs/conf
      mkdir -p /home/dockerfdfs/storage
      mkdir -p /home/dockerfdfs/store_path

      cat > /home/dockerfdfs/conf/tracker.conf << EOF
disabled=false
bind_addr=
port=22122
connect_timeout=30
network_timeout=60
base_path=/fastdfs/tracker
max_connections=5000
accept_threads=1
work_threads=4
store_lookup=2
store_group=group1
store_server=0
store_path=0
download_server=0
reserved_storage_space = 10%
log_level=info
run_by_group=
run_by_user=
allow_hosts=*
sync_log_buff_interval = 10
check_active_interval = 120
thread_stack_size = 64KB
storage_ip_changed_auto_adjust = true
storage_sync_file_max_delay = 86400
storage_sync_file_max_time = 300
use_trunk_file = false
slot_min_size = 256
slot_max_size = 16MB
trunk_file_size = 64MB
trunk_create_file_advance = false
trunk_create_file_time_base = 02:00
trunk_create_file_interval = 86400
trunk_create_file_space_threshold = 20G
trunk_init_check_occupying = false
trunk_init_reload_from_binlog = false
use_storage_id = false
storage_ids_filename = storage_ids.conf
id_type_in_filename = ip
store_slave_file_use_link = false
rotate_error_log = false
error_log_rotate_time=00:00
rotate_error_log_size = 0
use_connection_pool = false
connection_pool_max_idle_time = 3600
http.server_port=8080
http.check_alive_interval=30
http.check_alive_type=tcp
http.check_alive_uri=/status.html
EOF

      cat > /home/dockerfdfs/conf/storage.conf << EOF
disabled=false
group_name=group1
bind_addr=
client_bind=true
port=23000
connect_timeout=30
network_timeout=60
heart_beat_interval=30
stat_report_interval=60
base_path=/fastdfs/storage
max_connections=5000
buff_size = 256KB
accept_threads=1
work_threads=4
disk_rw_separated = true
disk_reader_threads = 1
disk_writer_threads = 1
sync_wait_msec=50
sync_interval=0
sync_start_time=00:00
sync_end_time=23:59
write_mark_file_freq=500
store_path_count=1
store_path0=/fastdfs/store_path
subdir_count_per_path=256
tracker_server=$ip:$port
log_level=info
run_by_group=
run_by_user=
allow_hosts=*
file_distribute_path_mode=0
file_distribute_rotate_count=100
fsync_after_written_bytes=0
sync_log_buff_interval=10
sync_binlog_buff_interval=10
sync_stat_file_interval=300
thread_stack_size=512KB
upload_priority=10
if_alias_prefix=
check_file_duplicate=0
file_signature_method=hash
key_namespace=FastDFS
keep_alive=0
use_access_log = false
rotate_access_log = false
access_log_rotate_time=00:00
rotate_error_log = false
error_log_rotate_time=00:00
rotate_access_log_size = 0
rotate_error_log_size = 0
file_sync_skip_invalid_record=false
use_connection_pool = false
connection_pool_max_idle_time = 3600
http.domain_name=
http.server_port=8899
EOF

      cat > /home/dockerfdfs/conf/client.conf << EOF
connect_timeout=30
network_timeout=60
base_path=/home
tracker_server=$ip:$port
log_level=info
use_connection_pool = false
connection_pool_max_idle_time = 3600
load_fdfs_parameters_from_tracker=false
use_storage_id = false
storage_ids_filename = storage_ids.conf
http.tracker_server_port=80
EOF
      process="2"
    else
      echo "Config file existed"
      exit 1
    fi
    if [ -n $ip ] && [ -n $port ] && [ $process = "2" ];then
      docker run -d --name tracker -v /home/dockerfdfs/tracker:/fastdfs/tracker/data -v /home/dockerfdfs/conf/tracker.conf:/fdfs_conf/tracker.conf  --network=host season/fastdfs tracker
      sleep 3
      docker run -d --name storage -v /home/dockerfdfs/conf/storage.conf:/fdfs_conf/storage.conf  -v /home/dockerfdfs/storage:/fastdfs/storage/data -v /home/dockerfdfs/store_path:/fastdfs/store_path --network=host season/fastdfs storage
      sleep 3
      docker ps|grep tracker
      docker ps|grep storage
      exit 0
    else
      echo "run fdfs failed"
      exit 1
    fi
  else
    echo "Please run as: sh fdfs.sh ip port"
    exit 1
  fi
else
  echo "There is a running fdfs container, please remove it"
  exit 1
fi
