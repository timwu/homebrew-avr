require 'formula'

class AvrBinutils < Formula
  url 'http://ftp.gnu.org/gnu/binutils/binutils-2.22.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  md5 'ee0f10756c84979622b992a4a61ea3f5'

  def options
    [["--disable-libbfd", "Disable installation of libbfd."]]
  end

  def install

    if MacOS.lion?
      ENV['CC'] = 'clang'
    end

    ENV['CPPFLAGS'] = "-I#{include}"

    args = ["--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--disable-nls"]

    unless ARGV.include? '--disable-libbfd'
      Dir.chdir "bfd" do
        ohai "building libbfd"
        system "./configure", "--enable-install-libbfd", *args
        system "make"
        system "make install"
      end
    end

    # brew's build environment is in our way
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'LD'
    ENV.delete 'CC'
    ENV.delete 'CXX'

    if MacOS.lion?
      ENV['CC'] = 'clang'
    end

    system "./configure", "--target=avr", *args

    system "make"
    system "make install"
  end
 
  def patches
    'http://sourceware.org/cgi-bin/cvsweb.cgi/src/bfd/elf32-avr.c.diff?cvsroot=src&only_with_tag=binutils-2_22-branch&r1=1.51&r2=1.51.2.1'
  end
end
