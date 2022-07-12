-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW secao_graf_v (section_id, linked_data, section_title, nr_seq_apresentacao, nm_usuario, nr_seq_pepo, nr_cirurgia, nr_seq_modelo, ie_modo_visualizacao, ds_caminho_imagem, ie_chart_view, ie_grid_view) AS SELECT
             c.nr_sequencia section_id, 
             c.nr_seq_linked_data linked_data, 
             c.ds_nome section_title, 
             c.nr_seq_apresentacao ,
             b.nm_usuario,
             b.nr_seq_pepo,
             b.nr_cirurgia,
             b.nr_seq_modelo,
			 c.ie_modo_visualizacao,
			 c.ds_caminho_imagem,
             c.ie_chart_view,
             c.ie_grid_view
             FROM    pepo_modelo a, 
             w_flowsheet_cirurgia_pac b, 
             w_flowsheet_cirurgia_grupo c 
             WHERE a.nr_sequencia    = b.nr_seq_modelo 
             AND b.nr_sequencia      = c.nr_seq_flowsheet
			 AND coalesce(c.ie_modo_visualizacao, 'VI') in ('VI', 'IN')
             ORDER BY c.nr_seq_apresentacao, c.ds_nome;

