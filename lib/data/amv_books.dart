const Map<String, dynamic> amvBooksNameToNum = {
  "ኦሪት ዘፍጥረት": 1,
  "ኦሪት ዘጸአት": 2,
  "ኦሪት ዘሌዋውያን": 3,
  "ኦሪት ዘኍልቍ": 4,
  "ኦሪት ዘዳግም": 5,
  "መጽሐፈ ኢያሱ ወልደ ነዌ": 6,
  "መጽሐፈ መሣፍንት": 7,
  "መጽሐፈ ሩት": 8,
  "መጽሐፈ ሳሙኤል ቀዳማዊ": 9,
  "መጽሐፈ ሳሙኤል ካል": 10,
  "መጽሐፈ ነገሥት ቀዳማዊ።": 11,
  "መጽሐፈ ነገሥት ካልዕ።": 12,
  "መጽሐፈ ዜና መዋዕል ቀዳማዊ።": 13,
  "መጽሐፈ ዜና መዋዕል ካልዕ።": 14,
  "መጽሐፈ ዕዝራ።": 15,
  "መጽሐፈ ነህምያ።": 16,
  "መጽሐፈ አስቴር።": 17,
  "መጽሐፈ ኢዮብ።": 18,
  "መዝሙረ ዳዊት": 19,
  "መጽሐፈ ምሳሌ": 20,
  "መጽሐፈ መክብብ": 21,
  "መኃልየ መኃልይ ዘሰሎሞን": 22,
  "ትንቢተ ኢሳይያስ": 23,
  "ትንቢተ ኤርምያስ": 24,
  "ሰቆቃው ኤርምያስ": 25,
  "ትንቢተ ሕዝቅኤል": 26,
  "ትንቢተ ዳንኤል": 27,
  "ትንቢተ ሆሴዕ": 28,
  "ትንቢተ ኢዮኤል": 29,
  "ትንቢተ አሞጽ": 30,
  "ትንቢተ አብድዩ": 31,
  "ትንቢተ ዮናስ": 32,
  "ትንቢተ ሚክያስ": 33,
  "ትንቢተ ናሆም": 34,
  "ትንቢተ ዕንባቆም": 35,
  "ትንቢተ ሶፎንያስ": 36,
  "ትንቢተ ሐጌ": 37,
  "ትንቢተ ዘካርያስ": 38,
  "ትንቢተ ሚልክያ": 39,
  "የማቴዎስ ወንጌል": 40,
  "የማርቆስ ወንጌል": 41,
  "የሉቃስ ወንጌል": 42,
  "የዮሐንስ ወንጌል": 43,
  "የሐዋርያት ሥራ": 44,
  "ወደ ሮሜ ሰዎች": 45,
  "1ኛ ወደ ቆሮንቶስ ሰዎች": 46,
  "2ኛ ወደ ቆሮንቶስ ሰዎች": 47,
  "ወደ ገላትያ ሰዎች": 48,
  "ወደ ኤፌሶን ሰዎች": 49,
  "ወደ ፊልጵስዩስ ሰዎች": 50,
  "ወደ ቆላስይስ ሰዎች": 51,
  "1ኛ ወደ ተሰሎንቄ ሰዎች": 52,
  "2ኛ ወደ ተሰሎንቄ ሰዎች": 53,
  "1ኛ ወደ ጢሞቴዎስ": 54,
  "2ኛ ወደ ጢሞቴዎስ": 55,
  "ወደ ቲቶ": 56,
  "ወደ ፊልሞና": 57,
  "ወደ ዕብራውያን": 58,
  "የያዕቆብ መልእክት": 59,
  "1ኛ የጴጥሮስ መልእክት": 60,
  "2ኛ የጴጥሮስ መልእክት": 61,
  "1ኛ የዮሐንስ መልእክት": 62,
  "2ኛ የዮሐንስ መልእክት": 63,
  "3ኛ የዮሐንስ መልእክት": 64,
  "የይሁዳ መልእክት": 65,
  "የዮሐንስ ራእይ": 66
};

const Map<int, dynamic> amvBooksNumToName = {
  1: "ኦሪት ዘፍጥረት",
  2: "ኦሪት ዘጸአት",
  3: "ኦሪት ዘሌዋውያን",
  4: "ኦሪት ዘኍልቍ",
  5: "ኦሪት ዘዳግም",
  6: "መጽሐፈ ኢያሱ ወልደ ነዌ",
  7: "መጽሐፈ መሣፍንት",
  8: "መጽሐፈ ሩት",
  9: "መጽሐፈ ሳሙኤል ቀዳማዊ",
  10: "መጽሐፈ ሳሙኤል ካል",
  11: "መጽሐፈ ነገሥት ቀዳማዊ።",
  12: "መጽሐፈ ነገሥት ካልዕ።",
  13: "መጽሐፈ ዜና መዋዕል ቀዳማዊ።",
  14: "መጽሐፈ ዜና መዋዕል ካልዕ።",
  15: "መጽሐፈ ዕዝራ።",
  16: "መጽሐፈ ነህምያ።",
  17: "መጽሐፈ አስቴር።",
  18: "መጽሐፈ ኢዮብ።",
  19: "መዝሙረ ዳዊት",
  20: "መጽሐፈ ምሳሌ",
  21: "መጽሐፈ መክብብ",
  22: "መኃልየ መኃልይ ዘሰሎሞን",
  23: "ትንቢተ ኢሳይያስ",
  24: "ትንቢተ ኤርምያስ",
  25: "ሰቆቃው ኤርምያስ",
  26: "ትንቢተ ሕዝቅኤል",
  27: "ትንቢተ ዳንኤል",
  28: "ትንቢተ ሆሴዕ",
  29: "ትንቢተ ኢዮኤል",
  30: "ትንቢተ አሞጽ",
  31: "ትንቢተ አብድዩ",
  32: "ትንቢተ ዮናስ",
  33: "ትንቢተ ሚክያስ",
  34: "ትንቢተ ናሆም",
  35: "ትንቢተ ዕንባቆም",
  36: "ትንቢተ ሶፎንያስ",
  37: "ትንቢተ ሐጌ",
  38: "ትንቢተ ዘካርያስ",
  39: "ትንቢተ ሚልክያ",
  40: "የማቴዎስ ወንጌል",
  41: "የማርቆስ ወንጌል",
  42: "የሉቃስ ወንጌል",
  43: "የዮሐንስ ወንጌል",
  44: "የሐዋርያት ሥራ",
  45: "ወደ ሮሜ ሰዎች",
  46: "1ኛ ወደ ቆሮንቶስ ሰዎች",
  47: "2ኛ ወደ ቆሮንቶስ ሰዎች",
  48: "ወደ ገላትያ ሰዎች",
  49: "ወደ ኤፌሶን ሰዎች",
  50: "ወደ ፊልጵስዩስ ሰዎች",
  51: "ወደ ቆላስይስ ሰዎች",
  52: "1ኛ ወደ ተሰሎንቄ ሰዎች",
  53: "2ኛ ወደ ተሰሎንቄ ሰዎች",
  54: "1ኛ ወደ ጢሞቴዎስ",
  55: "2ኛ ወደ ጢሞቴዎስ",
  56: "ወደ ቲቶ",
  57: "ወደ ፊልሞና",
  58: "ወደ ዕብራውያን",
  59: "የያዕቆብ መልእክት",
  60: "1ኛ የጴጥሮስ መልእክት",
  61: "2ኛ የጴጥሮስ መልእክት",
  62: "1ኛ የዮሐንስ መልእክት",
  63: "2ኛ የዮሐንስ መልእክት",
  64: "3ኛ የዮሐንስ መልእክት",
  65: "የይሁዳ መልእክት",
  66: "የዮሐንስ ራእይ"
};
