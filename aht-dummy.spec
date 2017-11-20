Name:		aht-dummy
Version:	1.0
Release:	1
Summary:	Dummy RPM for atomic-host-tests.
License:	GPLv2+
BuildArch:	noarch

%description
%{summary}

%build
echo -e "#!/bin/sh\necho Hello from %{name}!" > %{name}

%install
mkdir -p %{buildroot}/usr/bin
install %{name} %{buildroot}/usr/bin

%files
/usr/bin/%{name}
