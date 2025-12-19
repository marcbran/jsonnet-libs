local h = import './gen/main.libsonnet';
local ul = h.ul;
local li = h.li;
local span = h.span;
local table = h.table;
local tr = h.tr;
local td = h.td;
local html = h.html;
local body = h.body;
local h1 = h.h1;
local div = h.div;
local form = h.form;
local input = h.input;
local textarea = h.textarea;

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
    {
      name: 'page',
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
      output(input): h.manifestPage(input),
      expected: '<!doctype html><ul><li style="color:red">First Item</li><li style="color:green" title="Some hover text.">Second Item</li><li><span class="code-example-third">Third</span> Item</li></ul>',
    },
    {
      name: 'article',
      input::
        html([
          body([
            h1('title'),
            div('content'),
          ]),
        ]),
      expected: '<html><body><h1>title</h1><div>content</div></body></html>',
    },
    {
      name: 'form',
      input::
        form([
          input({ type: 'text', name: 'title', value: 'title' }),
          textarea({ name: 'content' }, 'content'),
        ]),
      expected: '<form><input name="title" type="text" value="title"></input><textarea name="content">content</textarea></form>',
    },
  ],
};

{
  output(input): h.manifestElement(input),
  tests: [
    jsonmlTests,
  ],
}
