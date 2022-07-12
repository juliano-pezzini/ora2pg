-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW datasource_secao_graf_v (row_id, nr_cirurgia, nr_seq_pepo, nm_usuario, nr_seq_linked_data) AS SELECT
              d.nr_sequencia ROW_ID ,
              b.nr_cirurgia,
              b.nr_seq_pepo,
              b.nm_usuario,
              c.nr_seq_linked_data
            FROM pepo_modelo a, 
                 w_flowsheet_cirurgia_pac b, 
                 w_flowsheet_cirurgia_grupo c, 
                 w_flowsheet_cirurgia_info d 
            WHERE 
               a.NR_SEQUENCIA           = b.nr_seq_modelo  
               AND b.nr_sequencia       = c.nr_seq_flowsheet 
               AND c.nr_sequencia       = d.nr_seq_grupo;
