hex: 
  let
    # Helper function to convert a 2-character hex string to a decimal integer manually
    hexToDecimal = hexStr:
      let
        hexMap = { "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4; "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
                  "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15; };
        # Convert each character of the hex string to decimal and compute its contribution
        hexStr1 = builtins.substring 0 1 hexStr;
        hexStr2 = builtins.substring 1 1 hexStr;
      in
        (hexMap.${hexStr1} * 16) + hexMap.${hexStr2};
    red = hexToDecimal (builtins.substring 1 2 hex);
    green = hexToDecimal (builtins.substring 3 2 hex);
    blue = hexToDecimal (builtins.substring 5 2 hex);
  in { "r" = red; "g" = green; "b" = blue; }

