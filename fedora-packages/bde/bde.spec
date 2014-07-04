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
%setup -q -T -b 0 -n dwm-master
%setup -q -T -b 1 -n utilities-master

%build
cd %{_builddir}
cd dwm-master
make


%install
cd %{_builddir}
cd dwm-master
make install DESTDIR=%{buildroot} BINDIR=%{_bindir} DATADIR=%{_datadir}

cd %{_builddir}
cd utilities-master
install -m755 bmount/bmount %{buildroot}%{_bindir}/bmount
install -m755 screenshot/screenshot %{buildroot}%{_bindir}/screenshot
install -m755 view-ical/view-ical %{buildroot}%{_bindir}/view-ical

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
%{_bindir}/screenshot
%{_bindir}/view-ical


%changelog
* Wed Jul 2 2014 Branislav Blaskovic <branislav@blaskovic.sk> - 0.1-1
- Initial spec file

