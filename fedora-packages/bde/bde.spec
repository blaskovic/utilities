%global commit 2fd265f7987da757b28db9d9dc11e7db9119d14e
%global shortcommit %(c=%{commit}; echo ${c:0:7})

Name:           bde
Version:        0.1
Release:        2%{?dist}
Summary:        Blaskovic Desktop Environment

Group:          Development/Tools
License:        GPLv3+
URL:            https://github.com/blaskovic/dwm

Source0:        https://github.com/blaskovic/dwm/archive/master/dwm-master.tar.gz
Source1:        https://github.com/blaskovic/utilities/archive/master/utilities-master.tar.gz

Requires:       dmenu, slock
BuildRequires:  libX11-devel, libXinerama-devel, libxcb-devel

%description
Blaskovic super truper Desktop Environment based on DWM.

%package dwm
Summary: DWM for BDE

%package utils
Summary: Utilities for BDE

%description dwm
DWM part of BDE

%description utils
Utilities for BDE

%prep
# http://www.rpm.org/max-rpm/s1-rpm-inside-macros.html
%setup -q -c -T -b 0 -n dwm-master
%setup -q -c -T -b 1 -n utilities-master

%build
pushd ..

pushd dwm-master
make
popd

popd

%install
pwd
make install DESTDIR=%{buildroot} BINDIR=%{_bindir} DATADIR=%{_datadir}
#install -m755 ../utilities-master/bmount/bmount %{buildroot}%{_bindir}/bmount

%files dwm
%{_mandir}/man1/dwm.1.gz
%{_datadir}/xsessions/dwm.desktop
%{_bindir}/dwm
%{_bindir}/dwm-menu.sh
%{_bindir}/dwm-panel
%{_bindir}/dwm-panel-cycle
%{_bindir}/dwm-personalized
%{_bindir}/open-browser.sh
%{_bindir}/switch-keyboard.sh

%files utils
%{_bindir}/bmount


%changelog
* Wed Jul 2 2014 Branislav Blaskovic <branislav@blaskovic.sk> - 0.1-1
- Initial spec file

