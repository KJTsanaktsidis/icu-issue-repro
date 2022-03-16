# icu-issue-repro
Demonstrate some problems I'm having with ICU

With ICU 60.3:

```
% docker run --rm -e FFI_ICU_LIB=/opt/icu-60.3/lib icu-issue-repro bundle exec ruby /app/repro.rb
ICU::TimeFormatting.format(test_time, date: :long, time: :long, locale: 'en_US') -> February 13, 2009 at 11:31:30 PM UTC
ICU::TimeFormatting.format(test_time, date: :long, time: :long, locale: 'C') -> February 13, 2009 at 11:31:30 PM UTC
ICU::TimeFormatting.format(test_time, date: :long, time: :long) -> February 13, 2009 at 11:31:30 PM UTC
ICU::TimeFormatting.format(test_time, date: :long, time: :short, locale: 'en_US') -> February 13, 2009 at 11:31 PM
ICU::TimeFormatting.format(test_time, date: :long, time: :short, locale: 'C') -> February 13, 2009 at 11:31 PM
ICU::TimeFormatting.format(test_time, date: :long, time: :short) -> February 13, 2009 at 11:31 PM
ICU::TimeFormatting.format(test_time, skeleton: 'dMMMMyyyyhmma') -> February 13, 2009, 11:31 PM
ICU::TimeFormatting.format(test_time, skeleton: 'dMMMMyyyyHHmm') -> February 13, 2009, 23:31
```

With ICU 70.1:
```
% docker run --rm -e FFI_ICU_LIB=/opt/icu-70.1/lib icu-issue-repro bundle exec ruby /app/repro.rb
ICU version: 70.1 (from /opt/icu-70.1/lib/libicui18n.so.70)
test_time is 2009-02-13 23:31:30 +0000 (epoch 1234567890)
ICU::TimeFormatting.format(test_time, date: :long, time: :long, locale: 'en_US') -> February 13, 2009 at 11:31:30 PM UTC
ICU::TimeFormatting.format(test_time, date: :long, time: :long, locale: 'C') -> February 13, 2009 at 23:31:30 UTC
ICU::TimeFormatting.format(test_time, date: :long, time: :long) -> February 13, 2009 at 23:31:30 UTC
ICU::TimeFormatting.format(test_time, date: :long, time: :short, locale: 'en_US') -> February 13, 2009 at 11:31 PM
ICU::TimeFormatting.format(test_time, date: :long, time: :short, locale: 'C') -> February 13, 2009 at 23:31
ICU::TimeFormatting.format(test_time, date: :long, time: :short) -> February 13, 2009 at 23:31
ICU::TimeFormatting.format(test_time, skeleton: 'dMMMMyyyyhmma') -> February 13, 2009, 11:31 PM
ICU::TimeFormatting.format(test_time, skeleton: 'dMMMMyyyyHHmm') -> February 13, 2009, 23:31
```

With ICU 70.1, with patch for ICU-21353 applied

```
% docker run --rm -e FFI_ICU_LIB=/opt/icu-70.1-patched/lib icu-issue-repro bundle exec ruby /app/repro.rb
ICU version: 70.1 (from /opt/icu-70.1-patched/lib/libicui18n.so.70)
test_time is 2009-02-13 23:31:30 +0000 (epoch 1234567890)
ICU::TimeFormatting.format(test_time, date: :long, time: :long, locale: 'en_US') -> February 13, 2009 at 11:31:30 PM UTC
ICU::TimeFormatting.format(test_time, date: :long, time: :long, locale: 'C') -> February 13, 2009 at 23:31:30 UTC
ICU::TimeFormatting.format(test_time, date: :long, time: :long) -> February 13, 2009 at 23:31:30 UTC
ICU::TimeFormatting.format(test_time, date: :long, time: :short, locale: 'en_US') -> February 13, 2009 at 11:31 PM
ICU::TimeFormatting.format(test_time, date: :long, time: :short, locale: 'C') -> February 13, 2009 at 23:31
ICU::TimeFormatting.format(test_time, date: :long, time: :short) -> February 13, 2009 at 23:31
ICU::TimeFormatting.format(test_time, skeleton: 'dMMMMyyyyhmma') -> February 13, 2009 at 11:31 PM
ICU::TimeFormatting.format(test_time, skeleton: 'dMMMMyyyyHHmm') -> February 13, 2009 at 23:31
```


Two issues:
* When formatting times with the C locale, ICU 60.3 formats them in 12 hour time with AM/PM, whilst ICU 70.1 formats them as 24-hour time
* When formatting times with a skeleton pattern, ICU <= 70.1 joins the parts with ', ', whereas with the patch applied, they are joined with 'at' like when using :long date

