Capybara Cheatsheet
===================

Actions
-------
Actions can be run bare (as shown here), from `page`, or from a session. The click interactions and form interactions can also be run from a node.

``` ruby
visit '/path'
visit post_comments_path(post)

click_link 'Link'                                 # Finds a link by id or text and clicks it. Also looks at image alt text inside the link.
click_button 'Button'                             # Finds a button by id, text or value and clicks it.
click_on 'Link or Button'                         # Finds a button or link, as above, and clicks on it.

fill_in 'Input Field', :with => 'content'         # The field can be found via its name, id or label text. Field can be a text or password INPUT field, or a TEXTAREA.
choose 'Radio Button'                             # The radio button can be found via name, id or label text.
choose 'radio_group', option: Radio Button'       # The radio button group can be found by name or id.
check 'Checkbox'                                  # The check box can be found via name, id or label text.
uncheck 'Checkbox'                                # The check box can be found via name, id or label text.
attach_file 'File Field', '/path/to/file.ext'     # The file field can be found via its name, id or label text.
select 'Option', :from => 'Select Box'            # The select box can be found via its name, id or label text. Specifying :from is optional -- default searches all select boxes.
unselect 'Option', :from => 'Select Box'          # The select box can be found via its name, id or label text. Specifying :from is optional -- default searches all select boxes.

save_screenshot 'filename.jpg'                    # Save JPEG of current page.
save_and_open_page                                # Save JPEG of current page and open in default browser.
```

Scoping
-------
``` ruby
within('css expression') { do stuff, with selectors limited to within the specified element }
within(:xpath, '//ul/li') { ... }
within_fieldset('fieldset-id') { do stuff, with selectors limited to within the specified element }
within_fieldset('Fieldset Legend Text') { do stuff, with selectors limited to within the specified element }
within_table('table-id') { do stuff, with selectors limited to within the specified element }
within_table('Table Caption Text') { do stuff, with selectors limited to within the specified element }
within_frame('frame-id') { ... }   # Only works on some drivers (e.g. Selenium).
within_window('window handle') { ... } # Execute the given block within the given window. Only works on some drivers (e.g. Selenium).
```

Nodes
-----
``` ruby
node[attribute_name]  # Get attribute from the element.
node.click
node.drag_to(other_element)
node.selected?
node.checked?
node.visible?
node.select_option
node.unselect_option
node.set(value)       # Set value of an INPUT or TEXTAREA node.
node.text
node.value            # Get value of an INPUT, TEXTAREA, or (non-multi-select) SELECT node.
node.find(locator)    # Find nodes within this node, by XPath.
```

Matchers
--------
* Note that most of the matchers ultimately call have_selector, so they take the same options.
* Note that the matchers are actually of the form has_xxx? but RSpec uses the should have_xxx form.
* WARNING: Do not use should_not with these -- use should have_no_xxx instead. Or perhaps use :count => 0.

``` ruby
node.should have_button(locator)
node.should have_checked_field(locator)       # Checks if the page or current node has a radio button or checkbox with the given label, value or id, that is currently checked.
node.should have_unchecked_field(locator)     # Checks if the page or current node has a radio button or checkbox with the given label, value or id, that is currently unchecked.
node.should have_content(content)
node.should have_css(selector) # Converts the CSS to an XPath, so accepts anything that have_xpath() does.
node.should have_field(locator)   # Checks if the page or current node has a form field with the given label, name or id.
node.should have_field(locator, :with => 'content')  # For textual fields, can specify a :with option to specify the text the field should contain.
node.should have_link(locator)    # Checks if the page or current node has a link with the given text or id.
node.should have_link(locator, :href => "/url/path")
node.should have_table(locator)   # Checks if the page or current node has a table with the given id or caption.
node.should have_table(locator, :rows => [['Jonas', '24'], ['Peter', '32']])   # Check that the table contains the rows and columns given. Note that this option is quite strict -- the order needs to be correct and the text needs to match exactly.
node.should have_select(locator)  # Checks if the page or current node has a select field with the given label, name or id.
node.should have_select(locator, :options => ['Option 1', 'Option 2'])      # Can specify that given options exist in the select box.
node.should have_select(locator, :selected => 'Option Text')                # Can specify which option should currently be selected.
node.should have_select(locator, :selected => ['Option 1', 'Option 2'])     # Can specify mutliple selected options for multi-select.
node.should have_xpath(path)
node.should have_xpath(XPath.generate { |x| x.descendant(:p) })  # Accepts XPath expressions generate by the XPath gem.
node.should have_selector(:xpath, xpath_expression)
node.should have_selector(:css, css_selector)
node.should have_selector(css_selector)
node.should have_selector(:css_id)
node.should have_selector(:xpath, path, :count => 4) # This will check if the expression occurs exactly 4 times. 
node.should have_selector(:xpath, path, :minimum => 4) # This will check if the expression occurs at least 4 times. 
node.should have_selector(:xpath, path, :maximum => 4) # This will check if the expression occurs at most 4 times. 
node.should have_selector(:xpath, path, :between => (1..4) # This will check if the expression occurs between 1 and 4 times. 
node.should have_selector(:xpath, path, :text => 'Horse', :visible => true) # Accepts all options that Finders#all accepts.
```

Finders
-------
Finders work on the page/session, or a node. They return objects that are essentially nodes.

``` ruby
node.all(locator)   # Find all elements within the node matching the given selector and options. May return an empty array.
node.all(locator, :text => 'content')  # Find only elements that have the specified content.
node.all(locator, :visible => true)    # Find only elements that have the specified visibility.
node.find(locator)  # Find the first element that matches the locator. Takes any option that all() does. Raises an error if the element is not found.
node.find(locator, :message => 'Message to raise when locator cannot be found')
node.find_button(locator)     # Find a button on the page. The link can be found by its id, name or value.
node.find_by_id(id)           # Find a element on the page, given its id.
node.find_field(locator)      # Find a form field on the page. The field can be found by its name, id or label text.
node.find_link(locator)       # Find a link on the page. The link can be found by its id or text.
node.first(locator)           # Find the first element on the page matching the given selector and options, or nil if no element matches. Takes any option that all() does.
```

