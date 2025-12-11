import hashlib
import json

config = json.load(open('config.json'))
content = config['message_text']
if config.get('image_path'):
    content += f"|{config['image_path']}"

hash = hashlib.sha256(content.encode()).hexdigest()[:16]
print(f'Current config message hash: {hash}')

# Also check md5
md5_hash = hashlib.md5(content.encode()).hexdigest()[:16]
print(f'MD5 hash: {md5_hash}')
