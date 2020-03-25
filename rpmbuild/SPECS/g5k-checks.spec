# Generated from g5k-checks-0.5.1.gem by gem2rpm -*- rpm-spec -*-
%global gem_name g5k-checks

Name: rubygem-%{gem_name}
Version: 0.7.5
Release: 1%{?dist}
Summary: Hardware verification tool for Grid'5000
Group: Development/Languages
License: CECILL-B
URL: https://github.com/grid5000/g5k-checks
Source0: %{gem_name}-%{version}.gem
Requires: dmidecode
Requires: ethtool
Requires: fio
Requires: hdparm
Requires: hwloc
Requires: lshw
Requires: ruby(release)
Requires: ruby(rubygems)
Requires: rubygem(json)
Requires: util-linux
BuildRequires: ruby(release)
BuildRequires: rubygems-devel
BuildRequires: ruby
BuildArch: noarch
Provides: rubygem(%{gem_name}) = %{version}

%description
g5k-checks verifies that a node is matching its Grid'5000 Reference API
description.



%prep
gem unpack %{SOURCE0}

%setup -q -D -T -n  %{gem_name}-%{version}

gem spec %{SOURCE0} -l --ruby > %{gem_name}.gemspec

%build
# Create the gem as gem install only works on a gem file
gem build %{gem_name}.gemspec

# %%gem_install compiles any C extensions and installs the gem into ./%%gem_dir
# by default, so that we can move it into the buildroot in %%install
%gem_install

%install
mkdir -p %{buildroot}%{gem_dir}
cp -a .%{gem_dir}/* \
        %{buildroot}%{gem_dir}/


mkdir -p %{buildroot}%{_bindir}
cp -a .%{_bindir}/* \
        %{buildroot}%{_bindir}/

find %{buildroot}%{gem_instdir}/bin -type f | xargs chmod a+x
mkdir -p $RPM_BUILD_ROOT/etc/
install -p -D -m 644 conf/g5k-checks.conf $RPM_BUILD_ROOT/etc/

# Run the test suite
%check
pushd .%{gem_instdir}

popd

%files
%dir %{gem_instdir}
%{_bindir}/g5k-checks
%{gem_instdir}/bin
%{gem_instdir}/conf
%{gem_instdir}/scripts
%{gem_libdir}
%config /etc/g5k-checks.conf
%doc %{gem_docdir}
%doc %{gem_instdir}/LICENSE
%doc %{gem_instdir}/VERSION
%exclude %{gem_cache}
%{gem_spec}

%changelog
* Fri Dec 23 2016 Pierre Riteau <priteau@uchicago.edu> - 0.7.5-1
- Synchronize with upstream release 0.7.5
* Wed Mar 16 2016 Pierre Riteau <priteau@uchicago.edu> - 0.5.1-1
- Initial package
