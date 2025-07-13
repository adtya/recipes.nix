{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "expenseowl";
  version = "3.19";

  src = fetchFromGitHub {
    owner = "tanq16";
    repo = "expenseowl";
    rev = "v${version}";
    hash = "sha256-wWFnZpqrxLgy5XEAJ1OMDcEt3WMRI2PPKfTAmmHa9mc=";
  };

  vendorHash = "sha256-mGKxBRU5TPgdmiSx0DHEd0Ys8gsVD/YdBfbDdSVpC3U=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Extremely simple, self-hosted expense tracker with a beautiful UI";
    homepage = "https://github.com/tanq16/expenseowl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adtya ];
    mainProgram = "expenseowl";
  };
}
