-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE apap_pck.carregar_informacoes ( grupo_p INOUT dadosGrupo_tp) AS $body$
DECLARE

C02 CURSOR FOR
	SELECT  distinct a.nr_seq_informacao,
		a.ds_informacao,
		a.nr_seq_apap_grupo,
		a.ie_maxima,
		a.ie_media,
		a.ie_minima,
		a.ie_total,
		a.ie_grupo_inf,
		a.nr_seq_inf,
		coalesce(obter_valor_dominio(2274,a.ds_unid_med),a.ds_unid_med) ds_unid_med,
		a.ie_grafico
	FROM  w_apap_pac_v a
	where 	a.nr_atendimento = nr_atendimento_w
	and 	a.nm_usuario = nm_usuario_w
	and	a.nr_seq_apap_grupo = grupo_p.nr_seq_apap_grupo
	order by nr_seq_informacao;
nr_indice_w	integer;
BEGIN

for r_c02 in c02 loop
	begin
	
	nr_indice_w := grupo_p.informacoes.count+1;
	grupo_p.informacoes[nr_indice_w].ds_informacao		:= '  '||r_c02.ds_informacao;
	grupo_p.informacoes[nr_indice_w].nr_seq_apap_grupo	:= r_c02.nr_seq_apap_grupo;
	grupo_p.informacoes[nr_indice_w].nr_seq_informacao	:= r_c02.nr_seq_informacao;
	grupo_p.informacoes[nr_indice_w].ie_maxima		:= r_c02.ie_maxima;
	grupo_p.informacoes[nr_indice_w].ie_media		:= r_c02.ie_media;
	grupo_p.informacoes[nr_indice_w].ie_minima		:= r_c02.ie_minima;
	grupo_p.informacoes[nr_indice_w].ie_total		:= r_c02.ie_total;
	grupo_p.informacoes[nr_indice_w].ie_grupo_informacao	:= 'I';
	grupo_p.informacoes[nr_indice_w].ie_grupo_inf		:= r_c02.ie_grupo_inf;
	grupo_p.informacoes[nr_indice_w].nr_seq_inf		:= r_c02.nr_seq_inf;
	grupo_p.informacoes[nr_indice_w].ds_unidade_medida	:= r_c02.ds_unid_med;
	grupo_p.informacoes[nr_indice_w].ie_grafico		:= r_c02.ie_grafico;
	
	grupo_p.informacoes(nr_indice_w) := apap_pck.carregar_horarios(grupo_p.informacoes(nr_indice_w));
	end;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apap_pck.carregar_informacoes ( grupo_p INOUT dadosGrupo_tp) FROM PUBLIC;
