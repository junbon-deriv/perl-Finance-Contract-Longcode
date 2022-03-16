use strict;
use warnings;

use Test::More ;
use Test::Warnings;
use Test::Exception;
use Date::Utility;

use Finance::Contract::Longcode qw(shortcode_to_longcode);
use BOM::Platform::Context qw(localize);

my $now = Date::Utility->new();

subtest 'shortcode to longcode' => sub {
    subtest 'call contracts' => sub {
        my $shortcode = 'CALL_1HZ100V_10.00_' . $now->epoch . '_' . $now->plus_time_interval('5m')->epoch . '_' . 'S0P_0';
        my $expected_longcode = 'Win payout if Volatility 100 (1s) Index is strictly higher than entry spot at 5 minutes after contract start time.';
        is localize(shortcode_to_longcode($shortcode)), $expected_longcode, 'intraday call contract longcode';

        $shortcode = 'CALL_1HZ100V_10.00_' . $now->epoch . '_' . '5T' . '_' . 'S0P_0';
        $expected_longcode = 'Win payout if Volatility 100 (1s) Index after 5 ticks is strictly higher than entry spot.';
        is localize(shortcode_to_longcode($shortcode)), $expected_longcode, 'tick call contract longcode';

        $shortcode = 'CALL_1HZ100V_10.00_' . $now->epoch . '_' . $now->plus_time_interval('5d')->epoch . '_' . 'S0P_0';
        $expected_longcode = 'Win payout if Volatility 100 (1s) Index is strictly higher than entry spot at close on ' . $now->plus_time_interval('5d')->date . '.';
        is localize(shortcode_to_longcode($shortcode)), $expected_longcode, 'daily call contract longcode';
    }
};

done_testing();
