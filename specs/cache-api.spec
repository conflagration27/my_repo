Name:           cache-api
Version:        1.0
Release:        1%{?dist}
Summary:        Simple Caching Proxy API
License:        MIT
BuildArch:      noarch

Source0:        cache-api.py
Source1:        cache-api.service

%description
My flask app for caching 

%install
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/lib/systemd/system

install -m 755 %{SOURCE0} %{buildroot}/usr/bin/cache-api.py

install -m 644 %{SOURCE1} %{buildroot}/usr/lib/systemd/system/cache-api.service

%files
/usr/bin/cache-api.py
/usr/lib/systemd/system/cache-api.service