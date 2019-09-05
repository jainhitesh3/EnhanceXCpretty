#! /usr/bin/env ruby

require "rexml/document"

@total_count = 0
@pass_count = 0
@fail_count = 0

def calculateTestCaseCount(filename)
  file = File.new(filename)
  repair_malformed_html(filename)
  begin
    doc = REXML::Document.new(file)
  rescue REXML::ParseException => e
    puts "ERROR OCCURED!!!!!!!!!!!!!!!!!!!!!"
  end
  testCaseNames = []
  titleArray = REXML::XPath.match(doc , '//h3[@class=\'title\']')
  for title in titleArray do
    value = title.text
      if !(value.include? "BlibliMobile")
        if !(testCaseNames.include? value)
          testCaseNames.push(value)
          @total_count = @total_count + 1
        end
      end
  end
  passArray = REXML::XPath.match(doc , '//h3[@class=\'time\']')
  @pass_count = passArray.count
  @fail_count = @total_count - @pass_count
  showUpdatedTestCount(filename)
  addPieChart(filename)
end

def repair_malformed_html(filename)
  html_file_contents = File.read(filename)
  File.open(filename, 'w') do |file|
    html_file_contents.each_line do |line|
      if %r{</head>}.match(line)
        if !(line.include? "meta")
          line = "</meta></meta>" + line
        end
      end
      file.puts line
    end
  end
end

def updateContentToFile(filename , searchString , newString)
  html_file_contents = File.read(filename)
  File.open(filename, 'w') do |file|
    html_file_contents.each_line do |line|
      if line.include? searchString
        line = newString
      end
      file.puts line
    end
  end
end

def showUpdatedTestCount(filename)
  updateContentToFile(filename , "</span> tests</h2>" , "<span class=\"number\">"+@total_count.to_s+"</span> tests</h2>")
  updateContentToFile(filename , "</span> failures</h2>" , "<span class=\"number\">"+@fail_count.to_s+"</span> failures</h2>")
end

def addPieChart(filename)
  pieChart = "<section class=\"piechart\">
        <div id=\"piechart\" align=\"middle\" style=\"vertical-align: top;\"></div>
        <script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>

        <script type=\"text/javascript\">
        // Load google charts
        google.charts.load('current', {'packages':['corechart']});
        google.charts.setOnLoadCallback(drawChart);

        // Draw the chart and set the chart values
        function drawChart() {
          var data = google.visualization.arrayToDataTable([
          ['Result', 'Count'],
          ['Pass', $PASS_COUNT],
          ['Fail', $FAIL_COUNT]
        ]);

          // Optional; add a title and set the width and height of the chart
          var options = {'title':'Test Results', 'width':450, 'height':300 };

          // Display the chart inside the div element with id=\"piechart\"
          var chart = new google.visualization.PieChart(document.getElementById('piechart'));
          chart.draw(data, options);
        }
        </script>
        </section>"

  pieChart["$PASS_COUNT"] = @pass_count.to_s
  pieChart["$FAIL_COUNT"] = @fail_count.to_s

  updateContentToFile(filename , "</style>" , ".piechart {float: left; margin-left: 500px; margin-top: 68px; margin-right: 120px;}" + "rect {fill-opacity: 0.0 ;} \n </style> ")
  updateContentToFile(filename , "<section id=\"test-suites\">" , pieChart + "\n<section id=\"test-suites\">\n")
end

if __FILE__ == $0
  filename = ARGV[0]
  calculateTestCaseCount(filename)
end
