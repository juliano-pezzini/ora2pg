-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ocor_imp_pck.obter_select_filtro ( ie_considera_selecao_p boolean, ie_incidencia_selecao_regra_p text, ie_incidencia_selecao_filtro_p text, ie_processo_excecao_p text, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nr_seq_filtro_p pls_oc_cta_filtro.nr_sequencia%type, nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, dt_inicio_vigencia_p pls_oc_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_oc_cta_combinada.dt_fim_vigencia%type, ds_campo_extra_p text, ds_tabela_extra_p text, ds_restricao_extra_p text, ds_campo_proc_extra_p text, ds_tabela_proc_extra_p text, ds_restricao_proc_extra_p text, ds_campo_mat_extra_p text, ds_tabela_mat_extra_p text, ds_restricao_mat_extra_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


_ora2pg_r RECORD;
ds_select_w		varchar(12000);
ds_alias_protocolo_w	varchar(10);
ds_alias_conta_w	varchar(10);
ds_alias_proc_w		varchar(10);
ds_alias_mat_w		varchar(10);

ds_campo_padrao_w		varchar(1000);
ds_tabela_padrao_w		varchar(1000);
ds_restricao_padrao_w		varchar(4000);

ds_campo_proc_padrao_w		varchar(1000);
ds_tabela_proc_padrao_w		varchar(1000);
ds_restricao_proc_padrao_w	varchar(4000);

ds_campo_mat_padrao_w		varchar(1000);
ds_tabela_mat_padrao_w		varchar(1000);
ds_restricao_mat_padrao_w	varchar(4000);


BEGIN
-- Cria os selects padraes de acordo com a aplicacao da regra sendo verificada e de acordo

-- com as demais variaveis do processo de geraaao das ocorrancias combinadas.


ds_alias_protocolo_w := pls_ocor_imp_pck.obter_alias_tabela('pls_protocolo_conta_imp');
ds_alias_conta_w := pls_ocor_imp_pck.obter_alias_tabela('pls_conta_imp');
ds_alias_proc_w := pls_ocor_imp_pck.obter_alias_tabela('pls_conta_proc_imp');
ds_alias_mat_w := pls_ocor_imp_pck.obter_alias_tabela('pls_conta_mat_imp');

-- sa respeita a incidancia do filtro quando for um processo de exceaao (filtro ou regra de exceaao ou ambos)

-- procedimento


if	((ie_incidencia_selecao_filtro_p = 'P' and ie_processo_excecao_p = 'S') or (ie_incidencia_selecao_regra_p = 'P')) then
	
	-- obtam as restriaaes padrao para a parte dos procedimentos	

	SELECT * FROM pls_ocor_imp_pck.obter_restricao_padrao_filtro(	ie_considera_selecao_p, ie_incidencia_selecao_regra_p, 'PROC', ie_processo_excecao_p, nr_seq_ocorrencia_p, nr_id_transacao_p, nr_seq_filtro_p, ie_incidencia_selecao_filtro_p, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, valor_bind_p, ds_campo_proc_padrao_w, ds_tabela_proc_padrao_w) INTO STRICT _ora2pg_r;
 valor_bind_p := _ora2pg_r.valor_bind_p; ds_campo_proc_padrao_w := _ora2pg_r.ds_campo_p; ds_tabela_proc_padrao_w := _ora2pg_r.ds_tabela_p;

	ds_select_w :=	'select	' || ds_alias_conta_w || '.nr_sequencia nr_seq_conta,'|| pls_util_pck.enter_w ||
			'	' || ds_alias_proc_w || '.nr_sequencia nr_seq_conta_proc,' || pls_util_pck.enter_w ||
			'	null nr_seq_conta_mat,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.cd_guia_ok_conv,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.nr_seq_segurado_conv,' || pls_util_pck.enter_w ||
			'	trunc(' || ds_alias_proc_w || '.dt_execucao_conv) dt_execucao_conv,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_proc_w || '.dt_execucao_conv, ''INICIO_DIA'') dt_proc_hora_ini,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_proc_w || '.dt_execucao_conv, ''FIM_DIA'') dt_proc_hora_fim,' || pls_util_pck.enter_w ||
			'	' || ds_alias_proc_w || '.ie_origem_proced_conv,' || pls_util_pck.enter_w ||
			'	' || ds_alias_proc_w || '.cd_procedimento_conv,' || pls_util_pck.enter_w ||
			'	null nr_seq_material_conv' || pls_util_pck.enter_w ||
			ds_campo_proc_padrao_w || pls_util_pck.enter_w ||
			ds_campo_extra_p || pls_util_pck.enter_w ||
			'from	pls_protocolo_conta_imp ' || ds_alias_protocolo_w || ',' || pls_util_pck.enter_w ||
			'	pls_conta_imp ' || ds_alias_conta_w || ',' || pls_util_pck.enter_w ||
			'	pls_conta_proc_imp ' || ds_alias_proc_w || pls_util_pck.enter_w ||
			ds_tabela_proc_padrao_w || pls_util_pck.enter_w ||
			ds_tabela_extra_p || pls_util_pck.enter_w ||
			'where ' || ds_alias_conta_w || '.nr_seq_protocolo = ' || ds_alias_protocolo_w || '.nr_sequencia' || pls_util_pck.enter_w ||
			'and   ' || ds_alias_proc_w || '.nr_seq_conta = ' || ds_alias_conta_w || '.nr_sequencia ' || pls_util_pck.enter_w ||
			ds_restricao_proc_padrao_w ||
			ds_restricao_extra_p;
			
-- sa respeita a incidancia do filtro quando for um processo de exceaao (filtro ou regra de exceaao ou ambos)

-- Por material

elsif	((ie_incidencia_selecao_filtro_p = 'M' and ie_processo_excecao_p = 'S') or (ie_incidencia_selecao_regra_p = 'M')) then
	
	-- obtam as restriaaes padrao para a parte de materiais

	SELECT * FROM pls_ocor_imp_pck.obter_restricao_padrao_filtro(	ie_considera_selecao_p, ie_incidencia_selecao_regra_p, 'MAT', ie_processo_excecao_p, nr_seq_ocorrencia_p, nr_id_transacao_p, nr_seq_filtro_p, ie_incidencia_selecao_filtro_p, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, valor_bind_p, ds_campo_mat_padrao_w, ds_tabela_mat_padrao_w) INTO STRICT _ora2pg_r;
 valor_bind_p := _ora2pg_r.valor_bind_p; ds_campo_mat_padrao_w := _ora2pg_r.ds_campo_p; ds_tabela_mat_padrao_w := _ora2pg_r.ds_tabela_p;
	
	ds_select_w := 	'select	' || ds_alias_conta_w || '.nr_sequencia	nr_seq_conta,' || pls_util_pck.enter_w ||
			'	null nr_seq_conta_proc,'|| pls_util_pck.enter_w ||
			'	' || ds_alias_mat_w || '.nr_sequencia nr_seq_conta_mat,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.cd_guia_ok_conv,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.nr_seq_segurado_conv,' || pls_util_pck.enter_w ||
			'	trunc(' || ds_alias_mat_w || '.dt_execucao_conv) dt_execucao_conv,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_mat_w || '.dt_execucao_conv, ''INICIO_DIA'') dt_atend_hora_ini,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_mat_w || '.dt_execucao_conv, ''FIM_DIA'') dt_atend_hora_fim,' || pls_util_pck.enter_w ||
			'	null ie_origem_proced_conv,' || pls_util_pck.enter_w ||
			'	null cd_procedimento_conv,' || pls_util_pck.enter_w ||
			'	' || ds_alias_mat_w || '.nr_seq_material_conv' || pls_util_pck.enter_w ||
			ds_campo_mat_padrao_w || pls_util_pck.enter_w ||
			ds_campo_extra_p || pls_util_pck.enter_w ||
			'from	pls_protocolo_conta_imp ' || ds_alias_protocolo_w || ',' || pls_util_pck.enter_w ||
			'	pls_conta_imp ' || ds_alias_conta_w || ',' || pls_util_pck.enter_w ||
			'	pls_conta_mat_imp ' || ds_alias_mat_w || pls_util_pck.enter_w ||
			ds_tabela_mat_padrao_w || pls_util_pck.enter_w ||
			ds_tabela_extra_p || pls_util_pck.enter_w ||
			'where ' || ds_alias_conta_w || '.nr_seq_protocolo = ' || ds_alias_protocolo_w || '.nr_sequencia' || pls_util_pck.enter_w ||
			'and   ' || ds_alias_mat_w || '.nr_seq_conta = ' || ds_alias_conta_w || '.nr_sequencia ' || pls_util_pck.enter_w ||
			ds_restricao_mat_padrao_w ||
			ds_restricao_extra_p;

-- Por procedimento / material  e Conforme a regra externa.

-- sa pode ser aplicado em situaaaes que nao sejam exceaaes, pois regras de exceaao sao aplicadas de acordo com a sua incidancia

elsif (ie_incidencia_selecao_regra_p = 'PM' and ie_processo_excecao_p = 'N') then
	-- obtam as restriaaes padrao para a parte dos procedimentos	

	SELECT * FROM pls_ocor_imp_pck.obter_restricao_padrao_filtro(	ie_considera_selecao_p, ie_incidencia_selecao_regra_p, 'PROC', ie_processo_excecao_p, nr_seq_ocorrencia_p, nr_id_transacao_p, nr_seq_filtro_p, ie_incidencia_selecao_filtro_p, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, valor_bind_p, ds_campo_proc_padrao_w, ds_tabela_proc_padrao_w) INTO STRICT _ora2pg_r;
 valor_bind_p := _ora2pg_r.valor_bind_p; ds_campo_proc_padrao_w := _ora2pg_r.ds_campo_p; ds_tabela_proc_padrao_w := _ora2pg_r.ds_tabela_p;

	ds_select_w :=	'select	' || ds_alias_conta_w || '.nr_sequencia nr_seq_conta,'|| pls_util_pck.enter_w ||
			'	' || ds_alias_proc_w || '.nr_sequencia nr_seq_conta_proc,' || pls_util_pck.enter_w ||
			'	null nr_seq_conta_mat,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.cd_guia_ok_conv,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.nr_seq_segurado_conv,' || pls_util_pck.enter_w ||
			'	trunc(' || ds_alias_proc_w || '.dt_execucao_conv) dt_execucao_conv,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_proc_w || '.dt_execucao_conv, ''INICIO_DIA'') dt_proc_hora_ini,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_proc_w || '.dt_execucao_conv, ''FIM_DIA'') dt_proc_hora_fim,' || pls_util_pck.enter_w ||
			'	' || ds_alias_proc_w || '.ie_origem_proced_conv,' || pls_util_pck.enter_w ||
			'	' || ds_alias_proc_w || '.cd_procedimento_conv,' || pls_util_pck.enter_w ||
			'	null nr_seq_material_conv' || pls_util_pck.enter_w ||
			ds_campo_proc_padrao_w || pls_util_pck.enter_w ||
			ds_campo_proc_extra_p || pls_util_pck.enter_w ||
			'from	pls_protocolo_conta_imp ' || ds_alias_protocolo_w || ',' || pls_util_pck.enter_w ||
			'	pls_conta_imp ' || ds_alias_conta_w || ',' || pls_util_pck.enter_w ||
			'	pls_conta_proc_imp ' || ds_alias_proc_w || pls_util_pck.enter_w ||
			ds_tabela_proc_padrao_w || pls_util_pck.enter_w ||
			ds_tabela_proc_extra_p || pls_util_pck.enter_w ||
			'where ' || ds_alias_conta_w || '.nr_seq_protocolo = ' || ds_alias_protocolo_w || '.nr_sequencia' || pls_util_pck.enter_w ||
			'and   ' || ds_alias_proc_w || '.nr_seq_conta = ' || ds_alias_conta_w || '.nr_sequencia ' || pls_util_pck.enter_w ||
			ds_restricao_proc_padrao_w ||
			ds_restricao_proc_extra_p;
			
	-- obtam as restriaaes padrao para a parte de materiais

	SELECT * FROM pls_ocor_imp_pck.obter_restricao_padrao_filtro(	ie_considera_selecao_p, ie_incidencia_selecao_regra_p, 'MAT', ie_processo_excecao_p, nr_seq_ocorrencia_p, nr_id_transacao_p, nr_seq_filtro_p, ie_incidencia_selecao_filtro_p, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, valor_bind_p, ds_campo_mat_padrao_w, ds_tabela_mat_padrao_w) INTO STRICT _ora2pg_r;
 valor_bind_p := _ora2pg_r.valor_bind_p; ds_campo_mat_padrao_w := _ora2pg_r.ds_campo_p; ds_tabela_mat_padrao_w := _ora2pg_r.ds_tabela_p;
	
	ds_select_w := ds_select_w || pls_util_pck.enter_w || 'union all' || pls_util_pck.enter_w ||
			'select	' || ds_alias_conta_w || '.nr_sequencia	nr_seq_conta,' || pls_util_pck.enter_w ||
			'	null nr_seq_conta_proc,'|| pls_util_pck.enter_w ||
			'	' || ds_alias_mat_w || '.nr_sequencia nr_seq_conta_mat,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.cd_guia_ok_conv,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.nr_seq_segurado_conv,' || pls_util_pck.enter_w ||
			'	trunc(' || ds_alias_mat_w || '.dt_execucao_conv) dt_execucao_conv,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_mat_w || '.dt_execucao_conv, ''INICIO_DIA'') dt_atend_hora_ini,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_mat_w || '.dt_execucao_conv, ''FIM_DIA'') dt_atend_hora_fim,' || pls_util_pck.enter_w ||
			'	null ie_origem_proced_conv,' || pls_util_pck.enter_w ||
			'	null cd_procedimento_conv,' || pls_util_pck.enter_w ||
			'	' || ds_alias_mat_w || '.nr_seq_material_conv' || pls_util_pck.enter_w ||
			ds_campo_mat_padrao_w || pls_util_pck.enter_w ||
			ds_campo_mat_extra_p || pls_util_pck.enter_w ||
			'from	pls_protocolo_conta_imp ' || ds_alias_protocolo_w || ',' || pls_util_pck.enter_w ||
			'	pls_conta_imp ' || ds_alias_conta_w || ',' || pls_util_pck.enter_w ||
			'	pls_conta_mat_imp ' || ds_alias_mat_w || pls_util_pck.enter_w ||
			ds_tabela_mat_padrao_w || pls_util_pck.enter_w ||
			ds_tabela_mat_extra_p || pls_util_pck.enter_w ||
			'where ' || ds_alias_conta_w || '.nr_seq_protocolo = ' || ds_alias_protocolo_w || '.nr_sequencia' || pls_util_pck.enter_w ||
			'and   ' || ds_alias_mat_w || '.nr_seq_conta = ' || ds_alias_conta_w || '.nr_sequencia ' || pls_util_pck.enter_w ||
			ds_restricao_mat_padrao_w ||
			ds_restricao_mat_extra_p;

else
	-- obtam as restriaaes padrao para a parte de contas

	SELECT * FROM pls_ocor_imp_pck.obter_restricao_padrao_filtro(	ie_considera_selecao_p, ie_incidencia_selecao_regra_p, 'CONTA', ie_processo_excecao_p, nr_seq_ocorrencia_p, nr_id_transacao_p, nr_seq_filtro_p, ie_incidencia_selecao_filtro_p, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, cd_estabelecimento_p, valor_bind_p, ds_campo_padrao_w, ds_tabela_padrao_w) INTO STRICT _ora2pg_r;
 valor_bind_p := _ora2pg_r.valor_bind_p; ds_campo_padrao_w := _ora2pg_r.ds_campo_p; ds_tabela_padrao_w := _ora2pg_r.ds_tabela_p;
	
	-- se nao for nada acima, fica a navel de conta

	ds_select_w :=	'select	' || ds_alias_conta_w || '.nr_sequencia	nr_seq_conta,' || pls_util_pck.enter_w ||
			'	null nr_seq_conta_proc,' || pls_util_pck.enter_w ||
			'	null nr_seq_conta_mat,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.cd_guia_ok_conv,' || pls_util_pck.enter_w ||
			'	' || ds_alias_conta_w || '.nr_seq_segurado_conv,' || pls_util_pck.enter_w ||
			'	trunc(' || ds_alias_conta_w || '.dt_atendimento_conv) dt_atendimento,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_conta_w || '.dt_atendimento_conv, ''INICIO_DIA'') dt_atend_hora_ini,' || pls_util_pck.enter_w ||
			'	pls_util_pck.obter_data_com_hora(' || ds_alias_conta_w || '.dt_atendimento_conv, ''FIM_DIA'') dt_atend_hora_fim,' || pls_util_pck.enter_w ||
			'	null ie_origem_proced, ' || pls_util_pck.enter_w ||
			'	null cd_procedimento, ' || pls_util_pck.enter_w ||
			'	null nr_seq_material ' || pls_util_pck.enter_w ||
			ds_campo_padrao_w || pls_util_pck.enter_w ||
			ds_campo_extra_p || pls_util_pck.enter_w ||
			'from	pls_protocolo_conta_imp ' || ds_alias_protocolo_w || ',' || pls_util_pck.enter_w ||
			'	pls_conta_imp ' || ds_alias_conta_w || pls_util_pck.enter_w ||
			ds_tabela_padrao_w || pls_util_pck.enter_w ||
			ds_tabela_extra_p || pls_util_pck.enter_w ||
			'where ' || ds_alias_conta_w || '.nr_seq_protocolo = ' || ds_alias_protocolo_w || '.nr_sequencia' || pls_util_pck.enter_w ||
			ds_restricao_padrao_w ||
			ds_restricao_extra_p;
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_ocor_imp_pck.obter_select_filtro ( ie_considera_selecao_p boolean, ie_incidencia_selecao_regra_p text, ie_incidencia_selecao_filtro_p text, ie_processo_excecao_p text, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nr_seq_filtro_p pls_oc_cta_filtro.nr_sequencia%type, nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, dt_inicio_vigencia_p pls_oc_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_oc_cta_combinada.dt_fim_vigencia%type, ds_campo_extra_p text, ds_tabela_extra_p text, ds_restricao_extra_p text, ds_campo_proc_extra_p text, ds_tabela_proc_extra_p text, ds_restricao_proc_extra_p text, ds_campo_mat_extra_p text, ds_tabela_mat_extra_p text, ds_restricao_mat_extra_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;