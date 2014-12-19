Name:           bde
Version:        0.1
Release:        9%{?dist}
Summary:        Blaskovic Desktop Environment

Group:          User Interface/Desktops
License:        GPLv3+
URL:            https://github.com/blaskovic/dwm

Source0:        https://github.com/blaskovic/dwm/archive/master/dwm-master.tar.gz
Source1:        https://github.com/blaskovic/utilities/archive/master/utilities-master.tar.gz

Requires:       bde-dwm
Requires:       bde-utils

%description
Blaskovic super truper Desktop Environment based on DWM.

%package dwm
Summary:        DWM for BDE

Requires:       sed
Requires:       gawk
Requires:       dmenu
Requires:       slock
Requires:       alsa-utils
Requires:       wmname
Requires:       xorg-x11-xkb-utils
Requires:       lxpolkit
Requires:       acpi

BuildRequires:  libX11-devel
BuildRequires:  libXinerama-devel
BuildRequires:  libxcb-devel

%package utils
Summary:        Utilities for BDE

Requires:       sed
Requires:       gawk
Requires:       xsel
Requires:       sdcv
Requires:       aspell

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
install -m755 bdict/bdict %{buildroot}%{_bindir}/bdict

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
%{_bindir}/bdict

%files


%changelog
* Tue Nov 11 2014 Branislav Blaskovic <branislav@blaskovic.sk> - 0.1-9
- bump version for newer utilities (screenshot upload path)

* Fri Oct  3 2014 Branislav Blaskovic <branislav@blaskovic.sk> - 0.1-8
- bump version for newer utilities (screenshot patch)

* Thu Sep 18 2014 Branislav Blaskovic <branislav@blaskovic.sk> - 0.1-7
- requires for bdict added

* Thu Sep 18 2014 Branislav Blaskovic <branislav@blaskovic.sk> - 0.1-6
- bdict added

* Fri Jul  4 2014 Branislav Blaskovic <branislav@blaskovic.sk> - 0.1-4
- Meta package 'bde'

* Fri Jul  4 2014 Branislav Blaskovic <branislav@blaskovic.sk> - 0.1-3
- More requires

* Wed Jul  2 2014 Branislav Blaskovic <branislav@blaskovic.sk> - 0.1-1
- Initial spec file

