defmodule ChecksumTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  test_with_params "handle invalid checksums",
    fn (checksum, expected) ->
      {:ok, ais} = AIS.new()
      assert AIS.get(ais) == []

      {result, _} = AIS.parse(ais, checksum)
      assert result == expected

      assert AIS.get(ais) == []
    end do
      [
        {"!AIVDM,1,1,,A,H3HOIFTl00000006Gqjhm01p?650,0*4F", :ok},
        {"!AIVDM,1,1,,B,B3HOIj000P08MfW52kD?kwoUkP06,0*68", :ok},
        {"!AIVDM,1,1,,A,18K;l002qP0EqBLDG3K?Hq:0L<P,0*3C", :invalid_checksum},
        {"!AIVDM,1,1,,A,13HPIH001P0jw:LCpNqc7gV0D1C,0*58", :invalid_checksum},
        {"!AIVDM,1,1,,A,13Hcoc0P?00BL>LDIGCLOwV06QH,0*25", :invalid_checksum},
        {"!AIVDM,1,1,,B,H3HOIj0LhuE@tp0000000000000,2*28", :ok},
        {"!AIVDM,1,1,,B,H3HOIj4nC=D6GTn6<qopl01h1230,0*30", :ok},
        {"!AIVDM,1,1,,B,19NSQd026P059vLD`PSn3<H0D<P,0*41", :invalid_checksum},
        {"!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C", :ok}
      ]
  end
end
