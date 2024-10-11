class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.248.0.tar.gz"
  sha256 "160f0d6f7e4d17a9d67507c287d4a424ec2d1e5c8db2a80877b758d6ec51537b"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4dff5c4683ad71104cfe37f33d4f6992a79904ff9fe78f166f9accad667b406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cde190878a5a77f356c06d80599046d5333f0c1544011d6c29afce2f50cac7da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26c1b8e6101a52f8e91d83323f73efd0f715c2c04a0a218c8038558218ccbbe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c49771640596d956640347aff6d90efebcf274f04406920b0dda4e1d26f490"
    sha256 cellar: :any_skip_relocation, ventura:       "73629924cd981a09af9524a25e423fa0702b6dc700ca128ab43dd717c503d65e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75bb4229c88a3c2592094da86b044bd24b02039931422c703e2b8d2ff951d706"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
