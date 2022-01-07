module TmuxM
  module_function

  def commit_long
    return "28b6237c623f507188a782a016563c78dd0ffb85"
  end

  def appimage_revision
    return 29
  end

  def stable_version_list
    return %w(2.6 2.7 2.8 2.9 2.9a 3.0 3.0a 3.1 3.1a 3.1b 3.1c 3.2 3.2a)
  end

  def devel_version
    return "3.3-rc"
  end

  def stable_version
    return stable_version_list[-1]
  end

  def appimage_version
    return "v#{stable_version}-eaw-appimage-0.1.7"
  end

  def commit
    return commit_long[0..7]
  end
end

if __FILE__ == $0 then
  case ARGV[0]
    when "commit_long";         puts TmuxM::commit_long
    when "appimage_revision";   puts TmuxM::appimage_revision
    when "appimage_version";    puts TmuxM::appimage_version
    when "commit";              puts TmuxM::commit
    when "stable_version_list"; puts TmuxM::stable_version_list.join(" ")
    when "stable_version";      puts TmuxM::stable_version
    when "devel_version";       puts TmuxM::devel_version
  end

  exit 0
end

class TmuxAT34Next < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  revision 6

  stable do
    tmux_version = "HEAD-#{TmuxM::commit}"
    url "https://github.com/tmux/tmux/archive/#{TmuxM::commit_long}.zip"
    version tmux_version

    def pick_diff(formula_path)
      lines = formula_path.each_line.to_a.inject([]) do |result, line|
        result.push(line) if ((/^__END__/ === line) || result.first)
        result
      end
      lines.shift
      return lines.join("")
    end

    patch :p1, pick_diff(Formula["z80oolong/tmux/tmux"].path)

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
