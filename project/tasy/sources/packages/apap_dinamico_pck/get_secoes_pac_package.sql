-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION apap_dinamico_pck.get_secoes_pac (nr_atendimento_p bigint,nm_usuario_p text,nr_seq_documento_p bigint) RETURNS SETOF SECOES_PAC_T AS $body$
DECLARE

secoes_pac_r_w secoes_pac_r;

c_secoes CURSOR FOR
   SELECT   c.nr_sequencia nr_seq_grupo,
			c.nr_seq_linked_data,
			c.ds_grupo_informacao,
			c.nr_seq_apresentacao,
			b.nr_sequencia nr_seq_modelo,
			c.ie_tipo,
			d.ie_chart_view,
			d.ie_timeline_view,
			d.ie_grid_view,
			coalesce(d.ie_fixed,'N') ie_fixed,
			coalesce(d.ie_fixed_chart,'N') ie_fixed_chart,
			coalesce(d.ie_fixed_timeline,'N') ie_fixed_timeline,
			coalesce(d.ie_fixed_grid,'N') ie_fixed_grid,
			c.cd_funcao_add_new,
			c.nr_seq_item_pront,
			c.ie_tipo_acesso
   from     documento a,
			w_apap_pac b,
			w_apap_pac_grupo c,
			documento_secao d
   where    a.nr_sequencia          = b.nr_seq_documento
   and      b.nr_sequencia          = c.nr_seq_mod_apap
   and      c.ie_padrao_visivel     = 'S'
   and      b.nr_atendimento        = nr_atendimento_p
   and      b.nm_usuario            = nm_usuario_p
   and      a.nr_sequencia          = nr_seq_documento_p
   and     c.nr_seq_documento_secao = d.nr_sequencia;

BEGIN
														
<<read_secoes>>
for r_secoes in c_secoes
   loop
   secoes_pac_r_w.nr_seq_modelo        	:= r_secoes.nr_seq_modelo;
   secoes_pac_r_w.nr_seq_grupo         	:= r_secoes.nr_seq_grupo;
   secoes_pac_r_w.nr_seq_linked_data   	:= r_secoes.nr_seq_linked_data;
   secoes_pac_r_w.ds_grupo_informacao  	:= r_secoes.ds_grupo_informacao;
   secoes_pac_r_w.nr_seq_apresentacao  	:= r_secoes.nr_seq_apresentacao;
   secoes_pac_r_w.ie_tipo  				:= r_secoes.ie_tipo;
   secoes_pac_r_w.ie_chart_view  		:= r_secoes.ie_chart_view;
   secoes_pac_r_w.ie_timeline_view  	:= r_secoes.ie_timeline_view;
   secoes_pac_r_w.ie_grid_view  		:= r_secoes.ie_grid_view;
   secoes_pac_r_w.ie_fixed              := r_secoes.ie_fixed;
   secoes_pac_r_w.ie_fixed_chart        := r_secoes.ie_fixed_chart;
   secoes_pac_r_w.ie_fixed_timeline     := r_secoes.ie_fixed_timeline;
   secoes_pac_r_w.ie_fixed_grid         := r_secoes.ie_fixed_grid;
   secoes_pac_r_w.cd_funcao_add_new		:= r_secoes.cd_funcao_add_new;
   secoes_pac_r_w.nr_seq_item_pront		:= r_secoes.nr_seq_item_pront;
   secoes_pac_r_w.ie_tipo_acesso		:= r_secoes.ie_tipo_acesso;
   RETURN NEXT secoes_pac_r_w;
   end loop read_secoes;
return;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION apap_dinamico_pck.get_secoes_pac (nr_atendimento_p bigint,nm_usuario_p text,nr_seq_documento_p bigint) FROM PUBLIC;