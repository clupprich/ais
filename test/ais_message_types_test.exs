defmodule AisMessageTypesTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  test_with_params "test known ais messages id",
                   fn msg ->
                     {:ok, ais} = AIS.new()
                     assert AIS.get(ais) == []

                     {result, _} = AIS.parse(ais, msg)
                     assert result == :ok
                   end do
    [
      # 1
      # 2
      # 3
      # 4
      {"!AIVDM,1,1,,A,402;bFQv@kkLc00Dl4LE52100@J6,0*58"},
      # 5
      # 6
      {"!AIVDM,1,1,,A,6>jCKIkfJjOt>db;q700@20,2*16"},
      # 7
      {"!AIVDM,1,1,,A,777QkG00RW38,0*62"},
      # 8
      {"!AIVDM,1,1,,A,83HT5APj2P00000001BQJ@2E0000,0*72"},
      # 11
      # 18
      {"!AIVDM,1,1,,B,B3HOIj000H08MeW52k4F7wo5oP06,0*42"},
      # 21
      {"!AIVDM,1,1,,B,E>jCfrv2`0c2h0W:0a2ah@@@@@@004WD>;2<H50hppN000,4*0A"},
      # 24 A
      {"!AIVDM,1,1,,A,H3HOIj0LhuE@tp0000000000000,2*2B"},
      # 24 B
      {"!AIVDM,1,1,,A,H3HOIFTl00000006Gqjhm01p?650,0*4F"}
    ]
  end
end
