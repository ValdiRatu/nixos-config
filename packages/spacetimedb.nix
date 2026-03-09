{ lib, stdenv, fetchurl, autoPatchelfHook, gcc-unwrapped }:
  
stdenv.mkDerivation rec {
  pname = "spacetimedb";
  version = "2.0.3";
  
  src = fetchurl {
     url = "https://github.com/clockworklabs/SpacetimeDB/releases/download/v${version}/spacetime-x86_64-unknown-linux-gnu.tar.gz";
     hash = "sha256-lS718JaIdWk+R7qieh9YnwjOUKeeHucwOec3+HBA1YY=";
  };
  
  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ gcc-unwrapped.lib ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp spacetimedb-standalone $out/bin/spacetimedb-standalone
    cp spacetimedb-cli $out/bin/spacetime
  '';
  
  meta = {
    description = "SpacetimeDB";
    homepage = "https://github.com/clockworklabs/SpacetimeDB";
    license = lib.licenses.bsl11;
    mainProgram = "spacetime";
    platforms = ["x86_64-linux"];
  };
}