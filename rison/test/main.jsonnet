local rison = import '../main.libsonnet';

local objectTests = {
  name: 'object',
  tests: [
    {
      name: 'empty object',
      input:: {},
      expected: '()',
    },
    {
      name: 'simple object',
      input:: {
        a: 0,
      },
      expected: '(a:0)',
    },
    {
      name: 'multiple member object',
      input:: {
        a: 0,
        b: 'a',
      },
      expected: '(a:0,b:a)',
    },
    {
      name: 'nested object',
      input:: {
        a: {
          b: 0,
        },
      },
      expected: '(a:(b:0))',
    },
  ],
};

local arrayTests = {
  name: 'array',
  tests: [
    {
      name: 'empty array',
      input:: [],
      expected: '!()',
    },
    {
      name: 'simple array',
      input:: [
        0,
      ],
      expected: '!(0)',
    },
    {
      name: 'multiple member array',
      input:: [
        0,
        'a',
      ],
      expected: '!(0,a)',
    },
    {
      name: 'nested array',
      input:: [
        [
          0,
        ],
        [
          0,
          1,
          2,
        ],
      ],
      expected: '!(!(0),!(0,1,2))',
    },
  ],
};

local primitiveTests = {
  name: 'primitive',
  tests: [
    {
      name: 'null',
      input:: null,
      expected: '!n',
    },
    {
      name: 'true',
      input:: true,
      expected: '!t',
    },
    {
      name: 'true',
      input:: false,
      expected: '!f',
    },
    {
      name: 'number',
      input:: 0,
      expected: '0',
    },
    {
      name: 'string',
      input:: 'foobar',
      expected: 'foobar',
    },
  ],
};

local exampleTests = {
  name: 'example',
  tests: [
    {
      name: 'glossary',
      input:: {
        glossary: {
          title: 'example glossary',
          GlossDiv: {
            title: 'S',
            GlossList: {
              GlossEntry: {
                ID: 'SGML',
                SortAs: 'SGML',
                GlossTerm: 'Standard Generalized Markup Language',
                Acronym: 'SGML',
                Abbrev: 'ISO 8879:1986',
                GlossDef: {
                  para: 'A meta-markup language, used to create markup languages such as DocBook.',
                  GlossSeeAlso: ['GML', 'XML'],
                },
                GlossSee: 'markup',
              },
            },
          },
        },
      },
      expected: "(glossary:(GlossDiv:(GlossList:(GlossEntry:(Abbrev:'ISO 8879:1986',Acronym:SGML,GlossDef:(GlossSeeAlso:!(GML,XML),para:'A meta-markup language, used to create markup languages such as DocBook.'),GlossSee:markup,GlossTerm:'Standard Generalized Markup Language',ID:SGML,SortAs:SGML)),title:S),title:'example glossary'))",
    },
    {
      name: 'menu',
      input:: {
        menu: {
          id: 'file',
          value: 'File',
          popup: {
            menuitem: [
              { value: 'New', onclick: 'CreateNewDoc()' },
              { value: 'Open', onclick: 'OpenDoc()' },
              { value: 'Close', onclick: 'CloseDoc()' },
            ],
          },
        },
      },
      expected: "(menu:(id:file,popup:(menuitem:!((onclick:'CreateNewDoc()',value:New),(onclick:'OpenDoc()',value:Open),(onclick:'CloseDoc()',value:Close))),value:File))",
    },
    {
      name: 'widget',
      input:: {
        widget: {
          debug: 'on',
          window: {
            title: 'Sample Konfabulator Widget',
            name: 'main_window',
            width: 500,
            height: 500,
          },
          image: {
            src: 'Images/Sun.png',
            name: 'sun1',
            hOffset: 250,
            vOffset: 250,
            alignment: 'center',
          },
          text: {
            data: 'Click Here',
            size: 36,
            style: 'bold',
            name: 'text1',
            hOffset: 250,
            vOffset: 100,
            alignment: 'center',
            onMouseUp: 'sun1.opacity = (sun1.opacity / 100) * 90;',
          },
        },
      },
      expected: "(widget:(debug:on,image:(alignment:center,hOffset:250,name:sun1,src:Images/Sun.png,vOffset:250),text:(alignment:center,data:'Click Here',hOffset:250,name:text1,onMouseUp:'sun1.opacity = (sun1.opacity / 100) * 90;',size:36,style:bold,vOffset:100),window:(height:500,name:main_window,title:'Sample Konfabulator Widget',width:500)))",
    },
    {
      name: 'web-app',
      input:: {
        'web-app': {
          servlet: [
            {
              'servlet-name': 'cofaxCDS',
              'servlet-class': 'org.cofax.cds.CDSServlet',
              'init-param': {
                'configGlossary:installationAt': 'Philadelphia, PA',
                'configGlossary:adminEmail': 'ksm@pobox.com',
                'configGlossary:poweredBy': 'Cofax',
                'configGlossary:poweredByIcon': '/images/cofax.gif',
                'configGlossary:staticPath': '/content/static',
                templateProcessorClass: 'org.cofax.WysiwygTemplate',
                templateLoaderClass: 'org.cofax.FilesTemplateLoader',
                templatePath: 'templates',
                templateOverridePath: '',
                defaultListTemplate: 'listTemplate.htm',
                defaultFileTemplate: 'articleTemplate.htm',
                useJSP: false,
                jspListTemplate: 'listTemplate.jsp',
                jspFileTemplate: 'articleTemplate.jsp',
                cachePackageTagsTrack: 200,
                cachePackageTagsStore: 200,
                cachePackageTagsRefresh: 60,
                cacheTemplatesTrack: 100,
                cacheTemplatesStore: 50,
                cacheTemplatesRefresh: 15,
                cachePagesTrack: 200,
                cachePagesStore: 100,
                cachePagesRefresh: 10,
                cachePagesDirtyRead: 10,
                searchEngineListTemplate: 'forSearchEnginesList.htm',
                searchEngineFileTemplate: 'forSearchEngines.htm',
                searchEngineRobotsDb: 'WEB-INF/robots.db',
                useDataStore: true,
                dataStoreClass: 'org.cofax.SqlDataStore',
                redirectionClass: 'org.cofax.SqlRedirection',
                dataStoreName: 'cofax',
                dataStoreDriver: 'com.microsoft.jdbc.sqlserver.SQLServerDriver',
                dataStoreUrl: 'jdbc:microsoft:sqlserver://LOCALHOST:1433;DatabaseName=goon',
                dataStoreUser: 'sa',
                dataStorePassword: 'dataStoreTestQuery',
                dataStoreTestQuery: "SET NOCOUNT ON;select test='test';",
                dataStoreLogFile: '/usr/local/tomcat/logs/datastore.log',
                dataStoreInitConns: 10,
                dataStoreMaxConns: 100,
                dataStoreConnUsageLimit: 100,
                dataStoreLogLevel: 'debug',
                maxUrlLength: 500,
              },
            },
            {
              'servlet-name': 'cofaxEmail',
              'servlet-class': 'org.cofax.cds.EmailServlet',
              'init-param': {
                mailHost: 'mail1',
                mailHostOverride: 'mail2',
              },
            },
            {
              'servlet-name': 'cofaxAdmin',
              'servlet-class': 'org.cofax.cds.AdminServlet',
            },
            {
              'servlet-name': 'fileServlet',
              'servlet-class': 'org.cofax.cds.FileServlet',
            },
            {
              'servlet-name': 'cofaxTools',
              'servlet-class': 'org.cofax.cms.CofaxToolsServlet',
              'init-param': {
                templatePath: 'toolstemplates/',
                log: 1,
                logLocation: '/usr/local/tomcat/logs/CofaxTools.log',
                logMaxSize: '',
                dataLog: 1,
                dataLogLocation: '/usr/local/tomcat/logs/dataLog.log',
                dataLogMaxSize: '',
                removePageCache: '/content/admin/remove?cache=pages&id=',
                removeTemplateCache: '/content/admin/remove?cache=templates&id=',
                fileTransferFolder: '/usr/local/tomcat/webapps/content/fileTransferFolder',
                lookInContext: 1,
                adminGroupID: 4,
                betaServer: true,
              },
            },
          ],
          'servlet-mapping': {
            cofaxCDS: '/',
            cofaxEmail: '/cofaxutil/aemail/*',
            cofaxAdmin: '/admin/*',
            fileServlet: '/static/*',
            cofaxTools: '/tools/*',
          },
          taglib: {
            'taglib-uri': 'cofax.tld',
            'taglib-location': '/WEB-INF/tlds/cofax.tld',
          },
        },
      },
      expected: "(web-app:(servlet:!((init-param:(cachePackageTagsRefresh:60,cachePackageTagsStore:200,cachePackageTagsTrack:200,cachePagesDirtyRead:10,cachePagesRefresh:10,cachePagesStore:100,cachePagesTrack:200,cacheTemplatesRefresh:15,cacheTemplatesStore:50,cacheTemplatesTrack:100,'configGlossary:adminEmail':'ksm@pobox.com','configGlossary:installationAt':'Philadelphia, PA','configGlossary:poweredBy':Cofax,'configGlossary:poweredByIcon':/images/cofax.gif,'configGlossary:staticPath':/content/static,dataStoreClass:org.cofax.SqlDataStore,dataStoreConnUsageLimit:100,dataStoreDriver:com.microsoft.jdbc.sqlserver.SQLServerDriver,dataStoreInitConns:10,dataStoreLogFile:/usr/local/tomcat/logs/datastore.log,dataStoreLogLevel:debug,dataStoreMaxConns:100,dataStoreName:cofax,dataStorePassword:dataStoreTestQuery,dataStoreTestQuery:'SET NOCOUNT ON;select test=!'test!';',dataStoreUrl:'jdbc:microsoft:sqlserver://LOCALHOST:1433;DatabaseName=goon',dataStoreUser:sa,defaultFileTemplate:articleTemplate.htm,defaultListTemplate:listTemplate.htm,jspFileTemplate:articleTemplate.jsp,jspListTemplate:listTemplate.jsp,maxUrlLength:500,redirectionClass:org.cofax.SqlRedirection,searchEngineFileTemplate:forSearchEngines.htm,searchEngineListTemplate:forSearchEnginesList.htm,searchEngineRobotsDb:WEB-INF/robots.db,templateLoaderClass:org.cofax.FilesTemplateLoader,templateOverridePath:'',templatePath:templates,templateProcessorClass:org.cofax.WysiwygTemplate,useDataStore:!t,useJSP:!f),servlet-class:org.cofax.cds.CDSServlet,servlet-name:cofaxCDS),(init-param:(mailHost:mail1,mailHostOverride:mail2),servlet-class:org.cofax.cds.EmailServlet,servlet-name:cofaxEmail),(servlet-class:org.cofax.cds.AdminServlet,servlet-name:cofaxAdmin),(servlet-class:org.cofax.cds.FileServlet,servlet-name:fileServlet),(init-param:(adminGroupID:4,betaServer:!t,dataLog:1,dataLogLocation:/usr/local/tomcat/logs/dataLog.log,dataLogMaxSize:'',fileTransferFolder:/usr/local/tomcat/webapps/content/fileTransferFolder,log:1,logLocation:/usr/local/tomcat/logs/CofaxTools.log,logMaxSize:'',lookInContext:1,removePageCache:/content/admin/remove?cache=pages&id=,removeTemplateCache:/content/admin/remove?cache=templates&id=,templatePath:toolstemplates/),servlet-class:org.cofax.cms.CofaxToolsServlet,servlet-name:cofaxTools)),servlet-mapping:(cofaxAdmin:'/admin/*',cofaxCDS:/,cofaxEmail:'/cofaxutil/aemail/*',cofaxTools:'/tools/*',fileServlet:'/static/*'),taglib:(taglib-location:/WEB-INF/tlds/cofax.tld,taglib-uri:cofax.tld)))",
    },
    {
      name: 'menu-2',
      input:: {
        menu: {
          header: 'SVG Viewer',
          items: [
            { id: 'Open' },
            { id: 'OpenNew', label: 'Open New' },
            null,
            { id: 'ZoomIn', label: 'Zoom In' },
            { id: 'ZoomOut', label: 'Zoom Out' },
            { id: 'OriginalView', label: 'Original View' },
            null,
            { id: 'Quality' },
            { id: 'Pause' },
            { id: 'Mute' },
            null,
            { id: 'Find', label: 'Find...' },
            { id: 'FindAgain', label: 'Find Again' },
            { id: 'Copy' },
            { id: 'CopyAgain', label: 'Copy Again' },
            { id: 'CopySVG', label: 'Copy SVG' },
            { id: 'ViewSVG', label: 'View SVG' },
            { id: 'ViewSource', label: 'View Source' },
            { id: 'SaveAs', label: 'Save As' },
            null,
            { id: 'Help' },
            { id: 'About', label: 'About Adobe CVG Viewer...' },
          ],
        },
      },
      expected: "(menu:(header:'SVG Viewer',items:!((id:Open),(id:OpenNew,label:'Open New'),!n,(id:ZoomIn,label:'Zoom In'),(id:ZoomOut,label:'Zoom Out'),(id:OriginalView,label:'Original View'),!n,(id:Quality),(id:Pause),(id:Mute),!n,(id:Find,label:Find...),(id:FindAgain,label:'Find Again'),(id:Copy),(id:CopyAgain,label:'Copy Again'),(id:CopySVG,label:'Copy SVG'),(id:ViewSVG,label:'View SVG'),(id:ViewSource,label:'View Source'),(id:SaveAs,label:'Save As'),!n,(id:Help),(id:About,label:'About Adobe CVG Viewer...'))))",
    },
  ],
};

local testGroups = [
  objectTests,
  arrayTests,
  primitiveTests,
  exampleTests,
];

std.flattenArrays([
  [
    {
      name: '%s/%s' % [group.name, test.name],
      actual: rison(test.input),
      expected: test.expected,
    }
    for test in group.tests
  ]
  for group in testGroups
])
