require 'settings/settings.rb'

Given /^az ablakban (.*) egyenlet van$/ do |a|
    @eqn = a.to_expr
end

When /^kijelölöm az? (.*)[öea]?-t$/ do |a|
  pending # express the regexp above with the code you wish you had
end

When /^a kijelölt részt oda húzom, ahol most az? (.*) van$/ do |a|
  pending # express the regexp above with the code you wish you had
end

Then /^(.*) lesz az egyenlet\.$/ do |a|
  pending # express the regexp above with the code you wish you had
end

When /^a kijelölt részt ([a-záéíóöőúüű]+) ([a-záéíóöőúüű]+) húzom attól, ahol most az? (.*) van$/ do |len,dir,a|
  pending # express the regexp above with the code you wish you had
end


