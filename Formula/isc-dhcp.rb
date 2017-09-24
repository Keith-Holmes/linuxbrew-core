class IscDhcp < Formula
  desc "Production-grade DHCP solution"
  homepage "https://www.isc.org/software/dhcp"
  url "https://ftp.isc.org/isc/dhcp/4.3.6/dhcp-4.3.6.tar.gz"
  sha256 "a41eaf6364f1377fe065d35671d9cf82bbbc8f21207819b2b9f33f652aec6f1b"

  bottle do
    sha256 "fbec5ac1f973a13a7ccc488737e257c5d3107791ffda3b45d0e231c0986e3cac" => :high_sierra
    sha256 "2ad8df9f26b3c7728a791fe5f83de04cb525d6ba9634a2b894da865a22ba109e" => :sierra
    sha256 "0084e6e135ad2bdd55d6c6c9b937895ca622598632118bb5e22a1aac09e6d9e6" => :el_capitan
    sha256 "942afade1da7421427d3c5306a2ace342017967607447eb5ffa920436b46c42b" => :yosemite
    sha256 "8591199b8e4729c27106a7c595e71a59185f82b919e016b2400e9c786fb7d62f" => :x86_64_linux
  end

  def install
    # use one dir under var for all runtime state.
    dhcpd_dir = var+"dhcpd"

    # Change the locations of various files to match Homebrew
    # we pass these in through CFLAGS since some cannot be changed
    # via configure args.
    path_opts = {
      "_PATH_DHCPD_CONF"    => etc+"dhcpd.conf",
      "_PATH_DHCLIENT_CONF" => etc+"dhclient.conf",
      "_PATH_DHCPD_DB"      => dhcpd_dir+"dhcpd.leases",
      "_PATH_DHCPD6_DB"     => dhcpd_dir+"dhcpd6.leases",
      "_PATH_DHCLIENT_DB"   => dhcpd_dir+"dhclient.leases",
      "_PATH_DHCLIENT6_DB"  => dhcpd_dir+"dhclient6.leases",
      "_PATH_DHCPD_PID"     => dhcpd_dir+"dhcpd.pid",
      "_PATH_DHCPD6_PID"    => dhcpd_dir+"dhcpd6.pid",
      "_PATH_DHCLIENT_PID"  => dhcpd_dir+"dhclient.pid",
      "_PATH_DHCLIENT6_PID" => dhcpd_dir+"dhclient6.pid",
      "_PATH_DHCRELAY_PID"  => dhcpd_dir+"dhcrelay.pid",
      "_PATH_DHCRELAY6_PID" => dhcpd_dir+"dhcrelay6.pid",
    }

    path_opts.each do |symbol, path|
      ENV.append "CFLAGS", "-D#{symbol}='\"#{path}\"'"
    end

    # See discussion at: https://gist.github.com/1157223
    ENV.append "CFLAGS", "-D__APPLE_USE_RFC_3542" if MacOS.version >= :lion

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{dhcpd_dir}"

    ENV.deparallelize { system "make", "-C", "bind" }

    # build everything else
    inreplace "Makefile", "SUBDIRS = ${top_srcdir}/bind", "SUBDIRS = "
    system "make"
    system "make", "install"

    # rename all the installed sample etc/* files so they don't clobber
    # any existing config files at symlink time.
    Dir.open("#{prefix}/etc") do |dir|
      dir.each do |f|
        file = "#{dir.path}/#{f}"
        File.rename(file, "#{file}.sample") if File.file?(file)
      end
    end

    # create the state dir and lease files else dhcpd will not start up.
    dhcpd_dir.mkpath
    %w[dhcpd dhcpd6 dhclient dhclient6].each do |f|
      file = "#{dhcpd_dir}/#{f}.leases"
      File.new(file, File::CREAT|File::RDONLY).close
    end

    # dhcpv6 plists
    (prefix+"homebrew.mxcl.dhcpd6.plist").write plist_dhcpd6
    (prefix+"homebrew.mxcl.dhcpd6.plist").chmod 0644
  end

  def caveats; <<-EOS.undent
    This install of dhcpd expects config files to be in #{etc}.
    All state files (leases and pids) are stored in #{var}/dhcpd.

    Dhcpd needs to run as root since it listens on privileged ports.

    There are two plists because a single dhcpd process may do either
    DHCPv4 or DHCPv6 but not both. Use one or both as needed.

    Note that you must create the appropriate config files before starting
    the services or dhcpd will refuse to run.
      DHCPv4: #{etc}/dhcpd.conf
      DHCPv6: #{etc}/dhcpd6.conf

    Sample config files may be found in #{etc}.
    EOS
  end

  plist_options :startup => true

  def plist
    <<-EOS.undent
    <?xml version='1.0' encoding='UTF-8'?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
                    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version='1.0'>
    <dict>
    <key>Label</key><string>#{plist_name}</string>
    <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/dhcpd</string>
        <string>-f</string>
      </array>
    <key>Disabled</key><false/>
    <key>KeepAlive</key><true/>
    <key>RunAtLoad</key><true/>
    <key>LowPriorityIO</key><true/>
    </dict>
    </plist>
    EOS
  end

  def plist_dhcpd6
    <<-EOS.undent
    <?xml version='1.0' encoding='UTF-8'?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
                    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version='1.0'>
    <dict>
    <key>Label</key><string>#{plist_name}</string>
    <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/dhcpd</string>
        <string>-f</string>
        <string>-6</string>
        <string>-cf</string>
        <string>#{etc}/dhcpd6.conf</string>
      </array>
    <key>Disabled</key><false/>
    <key>KeepAlive</key><true/>
    <key>RunAtLoad</key><true/>
    <key>LowPriorityIO</key><true/>
    </dict>
    </plist>
    EOS
  end
end
