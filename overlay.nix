_final: prev: {
  autobrr = prev.callPackage ./packages/autobrr { };
  ezbookkeeping = prev.callPackage ./packages/ezbookkeeping { };
  expenseowl = prev.callPackage ./packages/expenseowl { };
}
