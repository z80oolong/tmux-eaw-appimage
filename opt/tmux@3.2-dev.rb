class TmuxAT32Dev < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  tmux_version = "HEAD-2a2ebf31"
  url "https://github.com/tmux/tmux/archive/2a2ebf315ff2ca2533b22c26d407cc5cf90ba325.tar.gz"
  sha256 "c56d2e152941954a6debd0a14958518cc37f7c2932588cdf9fc91517f4a9ab68"
  version tmux_version

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "patchelf" => :build
  depends_on "z80oolong/tmux/tmux-libevent@2.2"
  depends_on "utf8proc" => :optional
  depends_on "z80oolong/tmux/tmux-ncurses@6.2" unless OS.mac?

  option "without-utf8-cjk", "Build without using East asian Ambiguous Width Character in tmux."
  option "without-pane-border-acs-ascii", "Build without using ACS ASCII as pane border in tmux."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  diff_file = Tap.fetch("z80oolong/tmux").path/"diff/tmux-HEAD-2a2ebf31-fix.diff"
  unless diff_file.exist? then
    diff_file = Formula["z80oolong/tmux/#{name}"].opt_prefix/".brew/tmux-HEAD-2a2ebf31-fix.diff"
  end
  patch :p1, diff_file.open.gets(nil)

  def install
    ENV.append "CFLAGS",   "-I#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_lib}"
    ENV.append "CFLAGS",   "-I#{Formula["z80oolong/tmux/tmux-ncurses@6.2"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["z80oolong/tmux/tmux-ncurses@6.2"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["z80oolong/tmux/tmux-ncurses@6.2"].opt_lib}"

    ENV.append "CPPFLAGS", "-DNO_USE_UTF8CJK" if build.without?("utf8-cjk")
    ENV.append "CPPFLAGS", "-DNO_USE_PANE_BORDER_ACS_ASCII" if build.without?("pane-border-acs-ascii")

    system "sh", "autogen.sh"

    args = %W[
      --disable-Dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    args << "--enable-utf8proc" if build.with?("utf8proc")

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"
    fix_rpath "#{bin}/tmux", ["z80oolong/tmux/tmux-ncurses@6.2"], ["ncurses"]

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def post_install
    system "install", "-m", "0444", Tap.fetch("z80oolong/tmux").path/"diff/tmux-#{version}-fix.diff", "#{prefix}/.brew"
  end

  def fix_rpath(binname, append_list, delete_list)
    delete_list_hash = {}
    rpath = %x{#{Formula["patchelf"].opt_bin}/patchelf --print-rpath #{binname}}.chomp.split(":")

    (append_list + delete_list).each {|name| delete_list_hash["#{Formula[name].opt_lib}"] = true}
    rpath.delete_if {|path| delete_list_hash[path]}
    append_list.each {|name| rpath.unshift("#{Formula[name].opt_lib}")}

    system "#{Formula["patchelf"].opt_bin}/patchelf", "--set-rpath", "#{rpath.join(":")}", "#{binname}"
  end

  def caveats; <<~EOS
    Example configuration has been installed to:
      #{opt_pkgshare}
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
