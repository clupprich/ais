defmodule ChecksumTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  test_with_params "handle invalid checksums",
                   fn checksum, ex1, ex2 ->
                     {:ok, ais} = AIS.new()
                     assert AIS.get(ais) == []

                     case AIS.parse(ais, checksum) do
                       {a, {b, _}} ->
                        assert a == ex1
                        assert b == ex2
                       {a, _} ->
                        assert a == ex1
                     end

                   end do
    [
      {"!AIVDM,1,1,,A,H3HOIFTl00000006Gqjhm01p?650,0*4F", :ok, nil},
      {"!AIVDM,1,1,,B,B3HOIj000P08MfW52kD?kwoUkP06,0*68", :ok, nil},
      {"!AIVDM,1,1,,A,18K;l002qP0EqBLDG3K?Hq:0L<P,0*3C", :error, :invalid_checksum},
      {"!AIVDM,1,1,,A,13HPIH001P0jw:LCpNqc7gV0D1C,0*58", :error, :invalid_checksum},
      {"!AIVDM,1,1,,A,13Hcoc0P?00BL>LDIGCLOwV06QH,0*25", :error, :invalid_checksum},
      {"!AIVDM,1,1,,B,H3HOIj0LhuE@tp0000000000000,2*28", :ok, nil},
      {"!AIVDM,1,1,,B,H3HOIj4nC=D6GTn6<qopl01h1230,0*30", :ok, nil},
      {"!AIVDM,1,1,,B,19NSQd026P059vLD`PSn3<H0D<P,0*41", :error, :invalid_checksum},
      {"!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C", :ok, nil},
      {"!AIVDM,1,1,,A,13IVvu0P0000n1>LCkW2D?v@0<1D,0*0C", :ok, nil},
      {"!AIVDM,1,1,,A,33iVm6500000kCrLCu7ccQ:>0000,0*05", :ok, nil},
      {"!AIVDM,1,1,,A,33ku8dU00000a:>LCD:K18m00000,0*0A", :ok, nil},
      {"!AIVDM,1,1,,A,13IMm1301fP02m@LC56bf`P:0PSm,0*0B", :ok, nil},
      {"!AIVDM,1,1,,A,E>jCfrv2`0c2h0W:0a2ah@@@@@@004WD>;2<H50hppN000,4*09", :ok, nil},
      {"!AIVDM,1,1,,A,19NSG;@00swwGrPLFBq3ek8H00S;,0*05", :ok, nil},
      {"!AIVDM,1,1,,A,13Ht`rPP0000Q9VLD:P@0?vR00Sc,0*0D", :ok, nil},
      {"!AIVDM,1,1,,B,33IQ?i;00500k5:LCocRiH<f02vQ,0*0E", :ok, nil},
      {"!AIVDM,1,1,,A,13aFf6PP00P0lEDLDKL>4?vjR0RC,0*0B", :ok, nil},
      {"!AIVDM,1,1,,B,13HOI:?P00P0TQBLD;Uh0?vj2@?J,0*01", :ok, nil},
      {"!AIVDM,1,1,,B,13Hbq1?P00P14H0LB20;IOvp26qL,0*01", :ok, nil},
      {"!AIVDM,2,1,7,B,53HPIH82<K2`IOW;3H1H:0L5<<tLpD000000000l1PI644000031H20ETQ@0,0*0C",
       :error, :incomplete},
      {"!AIVDM,1,1,,A,13IMm1301eP02H<LC5C:gpPl0Uih,0*01", :ok, nil},
      {"!AIVDM,1,1,,B,13IbQQ000100lqLLD7DoSA<p80RN,0*02", :ok, nil},
      {"!AIVDM,1,1,,A,13n@oD0PB@0IRqvQj@W;EppH088t19uvPT,0*3E", :ok, nil},
      {"!AIVDM,1,1,,A,59N`1sT2<iHtCEAc@00m<>0Hh4lT,0*5E", :error, :invalid}
    ]
  end
end
