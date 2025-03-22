local h = import './gen/main.libsonnet';
local ul = h.ul;
local li = h.li;
local span = h.span;
local table = h.table;
local tr = h.tr;
local td = h.td;

local jsonmlTests = {
  name: 'jsonml',
  tests: [
    {
      name: 'bulleted-list',
      input::
        ul({}, [
          li(
            { style: 'color:red' },
            'First Item',
          ),
          li(
            {
              title: 'Some hover text.',
              style: 'color:green',
            },
            'Second Item',
          ),
          li([
            span({ class: 'code-example-third' }, 'Third'),
            ' Item',
          ]),
        ]),
      expected: '<ul><li style="color:red">First Item</li><li style="color:green" title="Some hover text.">Second Item</li><li><span class="code-example-third">Third</span> Item</li></ul>',
    },
    {
      name: 'colorful-table',
      input::
        table(
          {
            class: 'MyTable',
            style: 'background-color:yellow',
          },
          [
            tr([
              td(
                {
                  class: 'MyTD',
                  style: 'border:1px solid black',
                },
                '#550758',
              ),
              td(
                {
                  class: 'MyTD',
                  style: 'background-color:red',
                },
                'Example text here',
              ),
            ]),
            tr([
              td(
                {
                  class: 'MyTD',
                  style: 'border:1px solid black',
                },
                '#993101',
              ),
              td(
                {
                  class: 'MyTD',
                  style: 'background-color:green',
                },
                '127624015',
              ),
            ]),
            tr([
              td(
                {
                  class: 'MyTD',
                  style: 'border:1px solid black',
                },
                '#E33D87',
              ),
              td(
                {
                  class: 'MyTD',
                  style: 'background-color:blue',
                },
                [
                  ' ',
                  span(
                    { style: 'background-color:maroon' },
                    '©',
                  ),
                  ' ',
                ]
              ),
            ]),
          ]
        ),
      expected: '<table class="MyTable" style="background-color:yellow"><tr><td class="MyTD" style="border:1px solid black">#550758</td><td class="MyTD" style="background-color:red">Example text here</td></tr><tr><td class="MyTD" style="border:1px solid black">#993101</td><td class="MyTD" style="background-color:green">127624015</td></tr><tr><td class="MyTD" style="border:1px solid black">#E33D87</td><td class="MyTD" style="background-color:blue"> <span style="background-color:maroon">©</span> </td></tr></table>',
    },
  ],
};

{
  output(input): std.manifestXmlJsonml(input),
  tests: [
    jsonmlTests,
  ],
}
