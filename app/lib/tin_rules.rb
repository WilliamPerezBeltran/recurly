# frozen_string_literal: true

module TinRules
  TIN_FORMAT_RULES = {
    AU: {
      au_abn: {
        format: 'NN NNN NNN NNN',
        regex: /^\d{2}\s\d{3}\s\d{3}\s\d{3}$|^\d{11}$/,
        length: 11
      },
      au_acn: {
        format: 'NNN NNN NNN',
        regex: /^\d{3} \d{3} \d{3}$/,
        length: 9
      }
    },

    CA: {
      ca_gst: {
        format: 'NNNNNNNNNRT0001',
        regex: /^\d{9}RT0001$/,
        length: 9
      }
    },

    IN: {
      in_gst: {
        format: 'NNXXXXXXXXXXNAN',
        regex: /^(\d{2})([A-Za-z0-9]{10})(\d)([A-Za-z]{1})(\d{1})$/,
        length: 15
      }
    }

  }.freeze
end
