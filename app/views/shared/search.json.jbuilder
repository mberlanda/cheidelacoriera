# frozen_string_literal: true

json.draw params['draw'].to_i
json.recordsTotal @data.count
json.recordsFiltered @data.count
json.data @data
