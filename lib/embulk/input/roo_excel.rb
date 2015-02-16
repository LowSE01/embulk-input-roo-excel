require 'roo'
require 'time'

module Embulk
  module Input

    class RooExcelInputPlugin < InputPlugin
      # input plugin file name must be: embulk/input_<name>.rb
      Plugin.register_input('roo_excel', self)

      def self.transaction(config, &control)

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
        if files.empty?
          raise "no valid xlsx file found"
        end

        columns = []
        task['columns'].each_with_index do |c,i|
          columns << Column.new(i, c['name'], c['type'].to_sym)
        end

        resume(task, columns, files.length, &control)
      end

      def self.resume(task, columns, count, &control)
        puts "InputRooExcel input started."
        commit_reports = yield(task, columns, count)
        puts "InputRooExcel input finished. Commit reports = #{commit_reports.to_json}"

        next_config_diff = {}
        return next_config_diff
      end

      def initialize(task, schema, index, page_builder)
        super
        @file = task['files'][index]
      end

      def run
        puts "InputRooExcel input thread #{@index}..."

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
            column = columns[col-1]
            data << convert_cell(column,xlsx,row,col)
          end
          @page_builder.add(data)
        end

        @page_builder.finish  # don't forget to call finish :-)

        commit_report = {}
        return commit_report
      end

      # MEMO roo celltype
      # returns the type of a cell: * :float * :string, * :date * :percentage * :formula * :time * :datetime.
      #
      def convert_cell(column,xlsx,nrow,ncol)
        d = xlsx.cell(nrow,ncol)
        type = column['type'] || 'string'

        case type
        when 'long'
          d.to_i
        when 'double'
          d.to_f
        when 'string'
          d.to_s
        when 'timestamp'
          convert_time(d)
        else # TODO
          d.to_s
        end
      end
      def convert_time(t)
        if( t.kind_of?(Date) or t.kind_of?(DateTime) )
          t.to_time
        elsif( t.kind_of?(Time) )
          t
        elsif( t.kind_of?(String) )
          Time.parse(t)
        else
          raise ArgumentError,"Can't convert time:#{t}"
        end
      end
    end # InputRooExcel
  end # Plugin
end # Embulk
