$:.unshift((Pathname.new(__FILE__).dirname/"..").realpath.to_s)

require "lib/version"

class TmuxAT34Next < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  license "ISC"
  revision 6

  stable do
    tmux_version = "HEAD-#{Config::commit}"
    url "https://github.com/tmux/tmux/archive/#{Config::commit_long}.tar.gz"
    sha256 Config::commit_sha256
    version tmux_version

    patch :p1, Formula["z80oolong/tmux/tmux"].diff_data

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "bison" => :build
  end

  depends_on "z80oolong/tmux/tmux-libevent@2.2"
  depends_on "utf8proc" => :optional
  depends_on "z80oolong/tmux/tmux-ncurses@6.2"

  keg_only :versioned_formula
 
  option "with-version-master", "In head build, set the version of tmux as `master`."
  option "without-utf8-cjk", "Build without using East asian Ambiguous Width Character in tmux."
  option "without-utf8-emoji", "Build without using Emoji Character in tmux."
  option "without-pane-border-acs-ascii", "Build without using ACS ASCII as pane border in tmux."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    ENV.append "CFLAGS",   "-I#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_lib}"
    ENV.append "CFLAGS",   "-I#{Formula["z80oolong/tmux/tmux-ncurses@6.2"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["z80oolong/tmux/tmux-ncurses@6.2"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["z80oolong/tmux/tmux-ncurses@6.2"].opt_lib}"

    if build.with?("version-master") then
      inreplace "configure.ac" do |s|
        s.gsub!(/AC_INIT\(\[tmux\],[^)]*\)/, "AC_INIT([tmux], master)")
      end
    end

    ENV.append "CPPFLAGS", "-DNO_USE_UTF8CJK" if build.without?("utf8-cjk")
    ENV.append "CPPFLAGS", "-DNO_USE_UTF8CJK_EMOJI" if build.without?("utf8-emoji")
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

  def fix_rpath(binname, append_list, delete_list)
    return unless OS.linux?

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
