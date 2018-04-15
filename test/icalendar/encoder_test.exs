defmodule ICalendar.EncoderTest do
  use ExUnit.Case
  alias ICalendar.Encoder
  alias ICalendar.Event
  doctest ICalendar.Encoder

  test "encode_params" do
    params = %{
      cn: "Bernard Desruisseaux",
      cutype: "INDIVIDUAL",
      partstat: "NEEDS-ACTION",
      role: "REQ-PARTICIPANT",
      rsvp: "TRUE"
    }

    res = Encoder.encode_params(params)

    correct = ~s(CN=Bernard Desruisseaux;CUTYPE=INDIVIDUAL;PARTSTAT=NEEDS-ACTION;ROLE=REQ-PARTICIPANT;RSVP=TRUE)
    assert res == correct
  end

  test "serialize" do
    stream = File.read!("test/fixtures/event.ics")
    {:ok, res} = ICalendar.Decoder.decode(stream)

    IO.inspect res
    res = Encoder.encode(res)
    IO.puts res

    stream = File.read!("test/fixtures/blank_description.ics")
    {:ok, res} = ICalendar.Decoder.decode(stream)


    IO.inspect res
    res = Encoder.encode_to_iodata(res)
    #res = Encoder.encode(res)
    IO.inspect res
    IO.puts res
  end

  test "properly encode text" do
    assert Encoder.encode_val("test;me,putting\\quotes\nnow", :text) == ~S(test\;me\,putting\\quotes\nnow)
  end

  test "properly encode time" do
    {:ok, time} = Timex.parse("173015ZAmerica/Los_Angeles", "{h24}{m}{s}Z{Zname}")
    assert Encoder.encode_val(time, :time) == {"173015", %{tzid: "America/Los_Angeles"}}
  end
end
