class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/ui/native/dist-release-local/groovy-zips/apache-groovy-binary-3.0.7.zip"
  sha256 "4ffd1325229da00455ae95a68de976d053e46315628ffcd57a433238e74e7eab"
  license "Apache-2.0"

  livecheck do
    url "https://dl.bintray.com/groovy/maven/"
    regex(/href=.*?groovy-binary[._-]v?([\d.]+)\.zip/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  conflicts_with "groovysdk", because: "both install the same binaries"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    libexec.install "bin", "conf", "lib"
    bin.install Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/groovy.ico"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You should set GROOVY_HOME:
        export GROOVY_HOME=#{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end