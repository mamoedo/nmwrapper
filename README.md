# Network Manager Wrapper

This is a wrapper that allows you to easily manage wireless connections with Network Manager

## Getting Started

### Prerequisites

You only need to have network-manager installed. In Debian, for example:

```
sudo apt-get install network-manager
```

## Usage

Usage: nmwrapper [ACTION] [OPTIONS]

Actions:

        -create (Requires all options)
        -delete (Requires connection name)
        -up     (Requires connection name)
        -down   (Requires connection name)

Options:

        -b=     Band (a: 5GHz, bg: 2.4GHz)
        -bssid= BSSID
        -c=     Connection name
        -k=     Key management (open, wpa-psk, wep)
        -p=     Password
