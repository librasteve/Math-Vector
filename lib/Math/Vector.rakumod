use v6.d;

use Test;

class Math::Vector does Positional
{
    has @.components handles <AT-POS>;
    
    multi method new (*@x) 
    {
        self.bless(components => @x);
    }
    
    multi method new (@x) 
    {
        self.bless(components => @x);
    }
    
    multi method Str() 
    {
        "^(" ~ @.components.join(', ') ~ ")";
    }
    
    multi method raku()
    {
        "Math::Vector.new(" ~ @.components.map({.perl}).join(', ') ~ ")";
    }
    
    multi method Num()
    {
        die "Cannot call Num on Vector!";
    }

    method dim() {
        @.components.elems;
    }

    multi sub infix:<⋅>(Math::Vector $a, Math::Vector $b where { $a.dim == $b.dim }) is export # is tighter(&infix:<+>) (NYI)
    {
        [+]($a.components »*« $b.components);
    }

    multi sub infix:<dot>(Math::Vector $a, Math::Vector $b) is export
    {
        $a ⋅ $b;
    }

    method length() {
        sqrt(self ⋅ self.conj);
    }
    
    multi method abs()
    {
        self.length;
    }

    multi method conj()
    {
        Math::Vector.new(@.components>>.conj);
    }

    method unitize() {
        my $length = self.length;
        if $length > 1e-10
        {
            return Math::Vector.new(@.components >>/>> $length);
        }
        else
        {
            return Math::Vector.new(@.components);
        }
    }

    method round($r) {
        Math::Vector.new(@.components>>.round($r));
    }
    
    multi sub infix:<+> (Math::Vector $a, Math::Vector $b where { $a.dim == $b.dim }) is export
    {
        Math::Vector.new($a.components »+« $b.components);
    }
    
    multi sub infix:<->(Math::Vector $a, Math::Vector $b where { $a.dim == $b.dim }) is export
    {
        Math::Vector.new($a.components »-« $b.components);
    }

    multi sub prefix:<->(Math::Vector $a) is export
    {
        Math::Vector.new(0 <<-<< $a.components);
    }

    multi sub infix:<*>(Math::Vector $a, $b) is export
    {
        Math::Vector.new($a.components >>*>> $b);
    }

    multi sub infix:<*>($a, Math::Vector $b) is export
    {
        Math::Vector.new($a <<*<< $b.components);
    }

    multi sub infix:</>(Math::Vector $a, $b) is export
    {
        Math::Vector.new($a.components >>/>> $b);
    }

    multi sub infix:<×>(Math::Vector $a where { $a.dim == 3 }, Math::Vector $b where { $b.dim == 3 }) is export
    {
        Math::Vector.new($a[1] * $b[2] - $a[2] * $b[1],
            $a[2] * $b[0] - $a[0] * $b[2],
            $a[0] * $b[1] - $a[1] * $b[0]);
    }

    multi sub infix:<cross>(Math::Vector $a, Math::Vector $b) is export
    {
        $a × $b;
    }

    multi sub circumfix:<⎡ ⎤>(Math::Vector $a) is export
    {
        $a.length;
    }

    sub is-approx-vector(Math::Vector $a, Math::Vector $b, $desc) is export
    {
        ok(($a - $b).length < 0.00001, $desc);
    }
}

subset Math::UnitVector of Math::Vector where { (1 - 1e-10) < $^v.length < (1 + 1e-10) };
