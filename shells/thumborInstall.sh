#put thumborImage.tar.gz  under same folder then run this script

#!/bin/bash
cd shells
docker ps |grep thumbor> thumborrun
thumborrun=`cat thumborrun`
if [ -z "$thumborrun" ];then
  if [ $# = 1 ];then
    port=$1
    process="1"
    if [ ! -e /home/dockerthumbor/thumbor.conf ] && [ ! -e /home/dockerthumbor/thumbor.conf.tpl ] && [ $process = "1" ];then
      mkdir -p /home/dockerthumbor
      cat > /home/dockerthumbor/thumbor.conf << EOF
THUMBOR_LOG_CONFIG = None
THUMBOR_LOG_FORMAT = '%(asctime)s %(name)s:%(levelname)s %(message)s'
THUMBOR_LOG_DATE_FORMAT = '%Y-%m-%d %H:%M:%S'
MAX_WIDTH = 0
MAX_HEIGHT = 0
MAX_PIXELS = 75000000
MIN_WIDTH = 1
MIN_HEIGHT = 1
ALLOWED_SOURCES =  []
QUALITY = 80
PROGRESSIVE_JPEG = True
PILLOW_JPEG_SUBSAMPLING = None
PILLOW_JPEG_QTABLES = None
PILLOW_RESAMPLING_FILTER = 'LANCZOS'
WEBP_QUALITY = None
PNG_COMPRESSION_LEVEL = 6
AUTO_WEBP = False
SVG_DPI = 150
MAX_AGE = 86400
MAX_AGE_TEMP_IMAGE = 0
ALLOW_ANIMATED_GIFS = True
USE_GIFSICLE_ENGINE = True
RESPECT_ORIENTATION = True
IGNORE_SMART_ERRORS = False
SEND_IF_MODIFIED_LAST_MODIFIED_HEADERS = False
RESULT_STORAGE_BUCKET = ''
AWS_SECRET_KEY = ''
ENABLE_ETAGS = True
MAX_ID_LENGTH = 32
FILE_LOADER_ROOT_PATH = '/usr/src/app/loader'
HTTP_LOADER_CONNECT_TIMEOUT = 5
HTTP_LOADER_REQUEST_TIMEOUT = 20
HTTP_LOADER_FOLLOW_REDIRECTS = True
HTTP_LOADER_MAX_REDIRECTS = 5
HTTP_LOADER_PROXY_HOST = None
HTTP_LOADER_PROXY_PORT = None
HTTP_LOADER_PROXY_USERNAME = None
HTTP_LOADER_PROXY_PASSWORD = None
HTTP_LOADER_CA_CERTS = None
HTTP_LOADER_VALIDATE_CERTS = True
HTTP_LOADER_CLIENT_KEY = None
HTTP_LOADER_CLIENT_CERT = None
HTTP_LOADER_CURL_ASYNC_HTTP_CLIENT = False
STORAGE_EXPIRATION_SECONDS = 2592000
STORES_CRYPTO_KEY_FOR_EACH_IMAGE = False
FILE_STORAGE_ROOT_PATH = '/usr/src/app/storage'
UPLOAD_MAX_SIZE = 0
UPLOAD_ENABLED = False
UPLOAD_PHOTO_STORAGE = 'thumbor.storages.file_storage'
UPLOAD_DELETE_ALLOWED = False
UPLOAD_PUT_ALLOWED = False
UPLOAD_DEFAULT_FILENAME = 'image'
MEMCACHE_STORAGE_SERVERS = ['localhost:11211']
MIXED_STORAGE_FILE_STORAGE = 'thumbor.storages.no_storage'
MIXED_STORAGE_CRYPTO_STORAGE = 'thumbor.storages.no_storage'
MIXED_STORAGE_DETECTOR_STORAGE = 'thumbor.storages.no_storage'
META_CALLBACK_NAME = None
DETECTORS = []
FACE_DETECTOR_CASCADE_FILE = 'haarcascade_frontalface_alt.xml'
GLASSES_DETECTOR_CASCADE_FILE = 'haarcascade_eye_tree_eyeglasses.xml'
PROFILE_DETECTOR_CASCADE_FILE = 'haarcascade_profileface.xml'
OPTIMIZERS = []
JPEGTRAN_PATH = '/usr/bin/jpegtran'
PROGRESSIVE_JPEG = True
FFMPEG_PATH = '/usr/bin/ffmpeg' # Default path for the docker installation in debian
FILTERS = ['thumbor.filters.brightness', 'thumbor.filters.contrast', 'thumbor.filters.rgb', 'thumbor.filters.round_corner', 'thumbor.filters.quality', 'thumbor.filters.noise', 'thumbor.filters.watermark', 'thumbor.filters.equalize', 'thumbor.filters.fill', 'thumbor.filters.sharpen', 'thumbor.filters.strip_icc', 'thumbor.filters.frame', 'thumbor.filters.grayscale', 'thumbor.filters.rotate', 'thumbor.filters.format', 'thumbor.filters.max_bytes', 'thumbor.filters.convolution', 'thumbor.filters.blur', 'thumbor.filters.extract_focal', 'thumbor.filters.no_upscale']
RESULT_STORAGE_EXPIRATION_SECONDS = 0
RESULT_STORAGE_FILE_STORAGE_ROOT_PATH = '/data/result_storage'
RESULT_STORAGE_STORES_UNSAFE = False
SQS_QUEUE_KEY_ID = None
SQS_QUEUE_KEY_SECRET = None
SQS_QUEUE_REGION = 'us-east-1'
USE_CUSTOM_ERROR_HANDLING = False
ERROR_HANDLER_MODULE = 'thumbor.error_handlers.sentry'
ERROR_FILE_LOGGER = None
ERROR_FILE_NAME_USE_CONTEXT = False
SENTRY_DSN_URL = ''
APP_CLASS = 'thumbor.app.ThumborServiceApp'
EOF

      cat > /home/dockerthumbor/thumbor.conf.tpl << EOF
THUMBOR_LOG_CONFIG = {{ THUMBOR_LOG_CONFIG | default(None) }}
THUMBOR_LOG_FORMAT = '{{ THUMBOR_LOG_FORMAT | default('%(asctime)s %(name)s:%(levelname)s %(message)s') }}'
THUMBOR_LOG_DATE_FORMAT = '{{ THUMBOR_LOG_DATE_FORMAT | default('%Y-%m-%d %H:%M:%S') }}'
MAX_WIDTH = {{ MAX_WIDTH | default(0) }}
MAX_HEIGHT = {{ MAX_HEIGHT | default(0) }}
MAX_PIXELS = {{ MAX_PIXELS | default(75000000) }}
MIN_WIDTH = {{ MIN_WIDTH | default(1) }}
MIN_HEIGHT = {{ MIN_HEIGHT | default(1) }}
ALLOWED_SOURCES =  {{ ALLOWED_SOURCES | default([]) }}
QUALITY = {{ QUALITY | default(80) }}
PROGRESSIVE_JPEG = {{ PROGRESSIVE_JPEG | default(True) }}
PILLOW_JPEG_SUBSAMPLING = {{ PILLOW_JPEG_SUBSAMPLING | default(None) }}
PILLOW_JPEG_QTABLES = {{ PILLOW_JPEG_QTABLES | default(None) }}
PILLOW_RESAMPLING_FILTER = '{{ PILLOW_RESAMPLING_FILTER | default('LANCZOS') }}'
WEBP_QUALITY = {{ WEBP_QUALITY | default(None) }}
PNG_COMPRESSION_LEVEL = {{ PNG_COMPRESSION_LEVEL | default(6) }}
AUTO_WEBP = {{ AUTO_WEBP | default(False) }}
SVG_DPI = {{ SVG_DPI | default(150) }}
MAX_AGE = {{ MAX_AGE | default(86400) }}
MAX_AGE_TEMP_IMAGE = {{ MAX_AGE_TEMP_IMAGE | default(0) }}
RESPECT_ORIENTATION = {{ RESPECT_ORIENTATION | default(False) }}
IGNORE_SMART_ERRORS = {{ IGNORE_SMART_ERRORS | default(False) }}
SEND_IF_MODIFIED_LAST_MODIFIED_HEADERS = {{ SEND_IF_MODIFIED_LAST_MODIFIED_HEADERS | default(False) }}
ALLOW_ANIMATED_GIFS = {{ ALLOW_ANIMATED_GIFS | default(True) }}
USE_GIFSICLE_ENGINE = {{ USE_GIFSICLE_ENGINE | default(False) }}
USE_BLACKLIST = {{ USE_BLACKLIST | default(False) }}
ENGINE_THREADPOOL_SIZE = {{ ENGINE_THREADPOOL_SIZE | default(0) }}
METRICS = '{{ METRICS | default('thumbor.metrics.logger_metrics') }}'
LOADER = '{{ LOADER | default('thumbor.loaders.http_loader') }}'
STORAGE = '{{ STORAGE | default('thumbor.storages.file_storage') }}'
STORAGE_BUCKET = '{{ STORAGE_BUCKET | default('') }}'
RESULT_STORAGE_BUCKET = '{{ RESULT_STORAGE_BUCKET | default('') }}'
RESULT_STORAGE = '{{ RESULT_STORAGE | default('thumbor.result_storages.file_storage') }}'
ENGINE = '{{ ENGINE | default('thumbor.engines.pil') }}'
GIF_ENGINE = '{{ GIF_ENGINE | default('thumbor.engines.gif') }}'
SECURITY_KEY = '{{ SECURITY_KEY | default('MY_SECURE_KEY') }}'
ALLOW_UNSAFE_URL = {{ ALLOW_UNSAFE_URL | default(True) }}
ALLOW_OLD_URLS = {{ ALLOW_OLD_URLS | default(True) }}
AWS_ACCESS_KEY = '{{ AWS_ACCESS_KEY_ID | default('') }}'
ENABLE_ETAGS = {{ ENABLE_ETAGS | default(True) }}
MAX_ID_LENGTH = {{ MAX_ID_LENGTH | default(32) }}
STATSD_HOST = {{ STATSD_HOST | default(None) }}
STATSD_PORT = {{ STATSD_PORT | default(8125) }}
STATSD_PREFIX = {{ STATSD_PREFIX | default(None) }}
FILE_LOADER_ROOT_PATH = '{{ FILE_LOADER_ROOT_PATH | default('/data/loader') }}'
HTTP_LOADER_CONNECT_TIMEOUT = {{ HTTP_LOADER_CONNECT_TIMEOUT | default(5) }}
HTTP_LOADER_REQUEST_TIMEOUT = {{ HTTP_LOADER_REQUEST_TIMEOUT | default(20) }}
HTTP_LOADER_FOLLOW_REDIRECTS = {{ HTTP_LOADER_FOLLOW_REDIRECTS | default(True) }}
HTTP_LOADER_MAX_REDIRECTS = {{ HTTP_LOADER_MAX_REDIRECTS | default(5) }}
HTTP_LOADER_MAX_CLIENTS = {{ HTTP_LOADER_MAX_CLIENTS | default(10) }}
HTTP_LOADER_FORWARD_USER_AGENT = {{ HTTP_LOADER_FORWARD_USER_AGENT | default(False) }}
HTTP_LOADER_DEFAULT_USER_AGENT = '{{ HTTP_LOADER_DEFAULT_USER_AGENT | default('Thumbor/6.3.0') }}'
HTTP_LOADER_PROXY_HOST = {{ HTTP_LOADER_PROXY_HOST | default(None) }}
HTTP_LOADER_PROXY_PORT = {{ HTTP_LOADER_PROXY_PORT | default(None) }}
HTTP_LOADER_PROXY_USERNAME = {{ HTTP_LOADER_PROXY_USERNAME | default(None) }}
HTTP_LOADER_PROXY_PASSWORD = {{ HTTP_LOADER_PROXY_PASSWORD | default(None) }}
HTTP_LOADER_CLIENT_CERT = {{ HTTP_LOADER_CLIENT_CERT | default(None) }}
HTTP_LOADER_CURL_ASYNC_HTTP_CLIENT = {{ HTTP_LOADER_CURL_ASYNC_HTTP_CLIENT | default(False) }}
STORAGE_EXPIRATION_SECONDS = {{ STORAGE_EXPIRATION_SECONDS | default(2592000) }}
STORES_CRYPTO_KEY_FOR_EACH_IMAGE = {{ STORES_CRYPTO_KEY_FOR_EACH_IMAGE | default(False) }}
FILE_STORAGE_ROOT_PATH = '{{ FILE_STORAGE_ROOT_PATH | default('/data/storage') }}'
UPLOAD_MAX_SIZE = {{ UPLOAD_MAX_SIZE | default(0) }}
UPLOAD_ENABLED = {{ UPLOAD_ENABLED | default(False) }}
UPLOAD_PHOTO_STORAGE = '{{ UPLOAD_PHOTO_STORAGE | default('thumbor.storages.file_storage') }}'
UPLOAD_DELETE_ALLOWED = {{ UPLOAD_DELETE_ALLOWED | default(False) }}
UPLOAD_PUT_ALLOWED = {{ UPLOAD_PUT_ALLOWED | default(False) }}
UPLOAD_DEFAULT_FILENAME = '{{ UPLOAD_DEFAULT_FILENAME | default('image') }}'
MONGO_STORAGE_SERVER_HOST = '{{ MONGO_STORAGE_SERVER_HOST | default('mongo') }}'
MONGO_STORAGE_SERVER_PORT = {{ MONGO_STORAGE_SERVER_PORT | default(27017) }}
MONGO_STORAGE_SERVER_DB = '{{ MONGO_STORAGE_SERVER_DB | default('thumbor') }}'
MONGO_STORAGE_SERVER_COLLECTION = '{{ MONGO_STORAGE_SERVER_COLLECTION | default('images') }}'
REDIS_STORAGE_SERVER_HOST = '{{ REDIS_STORAGE_SERVER_HOST | default('redis') }}'
REDIS_STORAGE_SERVER_PORT = {{ REDIS_STORAGE_SERVER_PORT | default(6379) }}
REDIS_STORAGE_SERVER_DB = {{ REDIS_STORAGE_SERVER_DB | default(0) }}
REDIS_STORAGE_SERVER_PASSWORD = {{ REDIS_STORAGE_SERVER_PASSWORD | default(None) }}
REDIS_RESULT_STORAGE_SERVER_HOST = '{{ REDIS_RESULT_STORAGE_SERVER_HOST | default('redis') }}'
REDIS_RESULT_STORAGE_SERVER_PORT = {{ REDIS_RESULT_STORAGE_SERVER_PORT | default(6379) }}
REDIS_RESULT_STORAGE_SERVER_DB = {{ REDIS_RESULT_STORAGE_SERVER_DB | default(0) }}
REDIS_RESULT_STORAGE_SERVER_PASSWORD = {{ REDIS_STORAGE_SERVER_PASSWORD | default(None) }}
MEMCACHE_STORAGE_SERVERS = {{ MEMCACHE_STORAGE_SERVERS | default(['localhost:11211',]) }}
MIXED_STORAGE_FILE_STORAGE = '{{ MIXED_STORAGE_FILE_STORAGE | default('thumbor.storages.no_storage') }}'
MIXED_STORAGE_CRYPTO_STORAGE = '{{ MIXED_STORAGE_CRYPTO_STORAGE | default('thumbor.storages.no_storage') }}'
MIXED_STORAGE_DETECTOR_STORAGE = '{{ MIXED_STORAGE_DETECTOR_STORAGE | default('thumbor.storages.no_storage') }}'
META_CALLBACK_NAME = {{ META_CALLBACK_NAME | default(None) }}
DETECTORS = {{ DETECTORS | default([]) }}
FACE_DETECTOR_CASCADE_FILE = '{{ FACE_DETECTOR_CASCADE_FILE | default('haarcascade_frontalface_alt.xml') }}'
GLASSES_DETECTOR_CASCADE_FILE = '{{ GLASSES_DETECTOR_CASCADE_FILE | default('haarcascade_eye_tree_eyeglasses.xml') }}'
PROFILE_DETECTOR_CASCADE_FILE = '{{ PROFILE_DETECTOR_CASCADE_FILE | default('haarcascade_profileface.xml') }}'
OPTIMIZERS = {{ OPTIMIZERS | default([]) }}
JPEGTRAN_PATH = '{{ JPEGTRAN_PATH | default('/usr/bin/jpegtran') }}'
PROGRESSIVE_JPEG = {{ PROGRESSIVE_JPEG | default(True) }}
FFMPEG_PATH = '{{ FFMPEG_PATH  | default('/usr/bin/ffmpeg') }}' # Default path for the docker installation in debian
FILTERS = {{ FILTERS | default(['thumbor.filters.brightness', 'thumbor.filters.contrast', 'thumbor.filters.rgb', 'thumbor.filters.round_corner', 'thumbor.filters.quality', 'thumbor.filters.noise', 'thumbor.filters.watermark', 'thumbor.filters.equalize', 'thumbor.filters.fill', 'thumbor.filters.sharpen', 'thumbor.filters.strip_icc', 'thumbor.filters.frame', 'thumbor.filters.grayscale', 'thumbor.filters.rotate', 'thumbor.filters.format', 'thumbor.filters.max_bytes', 'thumbor.filters.convolution', 'thumbor.filters.blur', 'thumbor.filters.extract_focal', 'thumbor.filters.no_upscale']) }}
RESULT_STORAGE_EXPIRATION_SECONDS = {{ RESULT_STORAGE_EXPIRATION_SECONDS | default(0) }}
RESULT_STORAGE_FILE_STORAGE_ROOT_PATH = '{{ RESULT_STORAGE_FILE_STORAGE_ROOT_PATH | default('/data/result_storage') }}'
RESULT_STORAGE_STORES_UNSAFE = {{ RESULT_STORAGE_STORES_UNSAFE | default(False) }}
REDIS_QUEUE_SERVER_HOST = '{{ REDIS_QUEUE_SERVER_HOST | default('redis') }}'
REDIS_QUEUE_SERVER_PORT = {{ REDIS_QUEUE_SERVER_PORT | default(6379) }}
REDIS_QUEUE_SERVER_DB = {{ REDIS_QUEUE_SERVER_DB | default(0) }}
REDIS_QUEUE_SERVER_PASSWORD = {{ REDIS_QUEUE_SERVER_PASSWORD | default(None) }}
SQS_QUEUE_KEY_ID = {{ SQS_QUEUE_KEY_ID | default(None) }}
SQS_QUEUE_KEY_SECRET = {{ SQS_QUEUE_KEY_SECRET | default(None) }}
SQS_QUEUE_REGION = '{{ SQS_QUEUE_REGION | default('us-east-1') }}'
USE_CUSTOM_ERROR_HANDLING = {{ USE_CUSTOM_ERROR_HANDLING | default(False) }}
ERROR_HANDLER_MODULE = '{{ ERROR_HANDLER_MODULE | default('thumbor.error_handlers.sentry') }}'
ERROR_FILE_LOGGER = {{ ERROR_FILE_LOGGER | default(None) }}
ERROR_FILE_NAME_USE_CONTEXT = {{ ERROR_FILE_NAME_USE_CONTEXT | default('False') }}
SENTRY_DSN_URL = '{{ SENTRY_DSN_URL | default('') }}'
APP_CLASS = '{{ APP_CLASS | default('thumbor.app.ThumborServiceApp') }}'
TC_AWS_REGION = '{{ TC_AWS_REGION | default('eu-west-1') }}' # AWS Region
TC_AWS_ENDPOINT = {{ TC_AWS_ENDPOINT | default(None) }} # Custom S3 endpoint URL (for GCP, Minio, etc.)
TC_AWS_STORAGE_BUCKET = '{{ TC_AWS_STORAGE_BUCKET | default('') }}' # S3 bucket for Storage
TC_AWS_STORAGE_ROOT_PATH = '{{ TC_AWS_STORAGE_ROOT_PATH | default('') }}' # S3 path prefix for Storage bucket
TC_AWS_LOADER_BUCKET = '{{ TC_AWS_LOADER_BUCKET | default('') }}' #S3 bucket for loader
TC_AWS_LOADER_ROOT_PATH = '{{ TC_AWS_LOADER_ROOT_PATH | default('') }}' # S3 path prefix for Loader bucket
TC_AWS_RESULT_STORAGE_BUCKET = '{{ TC_AWS_RESULT_STORAGE_BUCKET | default('') }}' # S3 bucket for result Storage
TC_AWS_RESULT_STORAGE_ROOT_PATH = '{{ TC_AWS_RESULT_STORAGE_ROOT_PATH | default('') }}' # S3 path prefix for Result storage bucket
TC_AWS_STORAGE_SSE = {{ TC_AWS_STORAGE_SSE | default(False) }}
TC_AWS_STORAGE_RRS = {{ TC_AWS_STORAGE_RRS | default(False) }}
TC_AWS_ENABLE_HTTP_LOADER = {{ TC_AWS_ENABLE_HTTP_LOADER | default(False) }}
TC_AWS_ALLOWED_BUCKETS = {{ TC_AWS_ALLOWED_BUCKETS | default(False) }} # List of allowed bucket to be requested
TC_AWS_STORE_METADATA = {{ TC_AWS_STORE_METADATA | default(False) }} # Store result with metadata (for instance content-type)
EOF
      echo "Done config"
      process="2"
    else
      echo "Config file existed"
      exit 1
    fi
    if [ -n $port ] && [ $process = "2" ];then
      docker run -d --name thumbor --network=host -v /home/dockerthumbor/:/usr/src/app/  -e THUMBOR_PORT=$port apsl/thumbor
      sleep 3
      docker ps|grep thumbor
      exit 0
    else
      echo "Run thumbor failed"
      exit 1
    fi
  else
    echo "Please run as: sh thumbor.sh port"
    echo "Please supply port for thumbor"
    exit 1
  fi
else
  echo "There is a running thumbor container, please remove it"
  exit 1
fi
