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

%post
systemctl daemon-reload
systemctl enable cache-api.service >/dev/null 2>&1 || :
systemctl start cache-api.service >/dev/null 2>&1 || :

%preun
if [ $1 -eq 0 ]; then
    systemctl stop cache-api.service >/dev/null 2>&1 || :
    systemctl disable cache-api.service >/dev/null 2>&1 || :
fi

%postun
if [ $1 -eq 0 ]; then
    systemctl daemon-reload
fi
