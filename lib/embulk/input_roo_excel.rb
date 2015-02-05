require 'pp'
require 'roo'

module Embulk
  module Plugin

    class InputRooExcel < InputPlugin
      # input plugin file name must be: embulk/input_<name>.rb
      Plugin.register_input('roo_excel', self)

      def self.transaction(config, &control)

#        threads = config.param('threads', :integer, default: 1)

        task = {
          'columns'  => config.param('columns', :array, default: []),
          'done'     => config.param('done', :array, default: []),
          'sheet'    => config.param('sheet', :string, default: nil),
          'data_pos' => config.param('data_pos', :integer, default: 1),
        }
        task['files'] = config.param('paths', :array, default: []).map{ |path|
          next [] unless Dir.exists?(path)
          Dir.entries(path).sort.select { |entry| entry.match(/\.xlsx\Z/) }.map{ |entry| 
              File.join(path,entry)
          }
         }.flatten

        files = task['files'] - task['done']

        columns = []
        task['columns'].each_with_index do |c,i|
          columns << Column.new(i, c['name'], c['type'].to_sym)
        end

#      puts threads 
        resume(task, columns, files.length, &control)
        #resume(task, columns, threads, &control)
      end

      def self.resume(task, columns, count, &control)
        puts "Excel input started."
        commit_reports = yield(task, columns, count)
        puts "Excel input finished. Commit reports = #{commit_reports.to_json}"

        next_config_diff = {}
        return next_config_diff
      end

      def initialize(task, schema, index, page_builder)
        super
        @file     = task['files'][index]
      end

      def run
        puts "Excel input thread #{@index}..."

        columns = @task['columns']
        ncol = columns.size
        data_pos = @task['data_pos'] 

        sheet = @task['sheet']
        xlsx = Roo::Excelx.new(@file)
        if( sheet )
          xlsx.default_sheet = sheet 
        else
          xlsx.default_sheet = xlsx.sheets.first
        end
                
        data_pos.upto(xlsx.last_row) do |row|
          data = []
          1.upto(ncol) do |col|
            data << xlsx.cell(row,col).to_s || ""
          end
          @page_builder.add(data)
        end         

        @page_builder.finish  # don't forget to call finish :-)

        commit_report = {}
        return commit_report
      end
    end

  end
end
