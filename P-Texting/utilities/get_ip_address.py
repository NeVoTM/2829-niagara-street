#!/usr/bin/env python3
"""
IP Address Detection Utility

Gets the current public IP address being used to send messages.
This is important for tracking VPN/proxy rotation to avoid detection.

Multiple services are tried for reliability.
"""

import urllib.request
import urllib.error
import json
import socket

def get_public_ip():
    """
    Get current public IP address.
    
    Tries multiple services for reliability:
    1. ipify.org (simple, fast)
    2. ipinfo.io (JSON response with location info)
    3. ip-api.com (JSON with detailed info)
    4. Fallback to local IP if all fail
    
    Returns:
        str: IP address (e.g., "123.45.67.89")
    """
    
    # Service 1: ipify (simple text response)
    try:
        response = urllib.request.urlopen('https://api.ipify.org?format=text', timeout=5)
        ip = response.read().decode('utf-8').strip()
        if ip:
            return ip
    except Exception:
        pass
    
    # Service 2: ipinfo.io (JSON with extra info)
    try:
        response = urllib.request.urlopen('https://ipinfo.io/json', timeout=5)
        data = json.loads(response.read().decode('utf-8'))
        ip = data.get('ip')
        if ip:
            return ip
    except Exception:
        pass
    
    # Service 3: ip-api.com (JSON with location)
    try:
        response = urllib.request.urlopen('http://ip-api.com/json/', timeout=5)
        data = json.loads(response.read().decode('utf-8'))
        ip = data.get('query')
        if ip:
            return ip
    except Exception:
        pass
    
    # Fallback: Get local IP (not public, but better than nothing)
    try:
        # This trick gets the local IP by connecting to a public DNS server
        # It doesn't actually send data, just determines which interface would be used
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        return f"{local_ip} (local)"
    except Exception:
        pass
    
    return "UNKNOWN"

def get_public_ip_with_info():
    """
    Get public IP with additional location information.
    
    Returns:
        dict: {
            'ip': '123.45.67.89',
            'city': 'New York',
            'region': 'NY',
            'country': 'US',
            'org': 'ISP Name'
        }
    """
    try:
        response = urllib.request.urlopen('https://ipinfo.io/json', timeout=5)
        data = json.loads(response.read().decode('utf-8'))
        return {
            'ip': data.get('ip', 'UNKNOWN'),
            'city': data.get('city', 'UNKNOWN'),
            'region': data.get('region', 'UNKNOWN'),
            'country': data.get('country', 'UNKNOWN'),
            'org': data.get('org', 'UNKNOWN')
        }
    except Exception as e:
        return {
            'ip': get_public_ip(),
            'error': str(e)
        }

if __name__ == "__main__":
    print("=" * 60)
    print("IP Address Detection")
    print("=" * 60)
    
    # Simple IP
    print("\nSimple IP:")
    ip = get_public_ip()
    print(f"  {ip}")
    
    # Detailed info
    print("\nDetailed Information:")
    info = get_public_ip_with_info()
    for key, value in info.items():
        print(f"  {key:10s}: {value}")
    
    print("\n" + "=" * 60)
    print("Use this IP for tracking message sends")
    print("Change VPN/proxy to rotate IPs and avoid detection")
    print("=" * 60)
