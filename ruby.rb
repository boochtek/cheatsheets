# Ruby Cheatsheet


## Date formatting

# NOTE: These are actually from ActiveSupport, not base Ruby.

# Show current named date formats.
pp Date::DATE_FORMATS

# Set custom date formats.
DateTime::DATE_FORMATS[:mine]="%Y-%m-%d %H:%M:%S"
Date::DATE_FORMATS[:month_and_year] = "%B %Y"
Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }

# Use a date format.
date.to_fs(:short)
datetime.to_formatted_s(:mine)

# From https://github.com/caxlsx/caxlsx/blob/master/lib/axlsx/util/constants.rb
ISO_8601_REGEX = /\A(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[0-1]|0[1-9]|[1-2][0-9])T(2[0-3]|[0-1][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[0-1][0-9]):[0-5][0-9])?\Z/.freeze


## Files

file = File.open('path/to/file')
extension = File.extname(file).delete_prefix('.')
content_type ||= Mime::Type.lookup_by_extension(extension)

# Open Source TODO: Some File class methods should also be instance methods:
#   - File.basename(file)
#   - File.extname(file)
