module Algorithm::Elo {
    my $k = 32;

    my sub do-it(Int $delta) {
        return 1 / (1 + (10 ** ($delta / 400)));
    }

    our sub calculate-elo(Int $left, Int $right, Bool :left($left-wins), Bool :right($right-wins), Bool :$draw) is export {
        unless $left-wins^$right-wins^$draw {
            die ':left, :right, and :draw are mutually exclusive';
        }

        unless $left-wins|$right-wins|$draw {
            die 'exactly least one of :left, :right, or :draw must be specified';
        }

        my $expected-left  = do-it($right - $left);
        my $expected-right = do-it($left - $right);

        my $left-multiplier  = $left-wins ?? 1 !! ($right-wins ?? 0 !! 0.5);
        my $right-multiplier = 1 - $left-multiplier;

        return (
            round($left  + $k * ($left-multiplier  - $expected-left)),
            round($right + $k * ($right-multiplier - $expected-right)),
        );
    }
}
