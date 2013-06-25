requires 'HTML::TokeParser';
requires 'WWW::Mechanize';

on build => sub {
    requires 'Test::More';
    requires 'Time::HiRes';
    requires 'URI';
};
