-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_filtro_rec_glosa_pck.gerencia_aplicacao_filtro ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_regra_periodo_p pls_pp_lote.nr_seq_regra_periodo%type, nr_id_transacao_p pls_pp_cta_rec_selecao.nr_id_transacao%type, ie_tipo_data_ref_p pls_pp_lote.ie_tipo_dt_referencia%type, dt_inicio_referencia_p pls_pp_lote.dt_referencia_inicio%type, dt_fim_referencia_p pls_pp_lote.dt_referencia_fim%type, cd_condicao_pagamento_p pls_pp_lote.cd_condicao_pagamento%type, ie_recurso_proprio_p pls_pp_lote.ie_recurso_proprio%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

					
-- controle para saber quando e necessario restringir apenas os registros que estao na tabela de selecao

ie_considera_tab_selecao_w 	boolean;
qt_filtro_processado_w		integer;
ie_processou_filtro_w		boolean;
ie_incidencia_filtro_w		varchar(2);

-- existem duas formas de cadastrar o que deve entrar no lote.

-- Informando o periodo no cadastro ou informando os filtros diretamente no lote

c_conf_filtro CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type,
			nr_seq_regra_periodo_pc	pls_pp_lote.nr_seq_regra_periodo%type) FOR
	SELECT	a.nr_sequencia nr_seq_filtro,
		a.ie_filtro_protocolo,
		a.ie_filtro_conta,
		a.ie_filtro_prestador,
		a.ie_filtro_contrato,
		a.ie_filtro_produto,
		a.ie_filtro_pagamento,
		a.ie_filtro_procedimento,
		a.ie_filtro_material,
		a.ie_excecao
	from	pls_pp_rp_cta_filtro a
	where	a.nr_seq_regra_periodo = nr_seq_regra_periodo_pc
	and	a.ie_tipo_filtro = 'R'
	and	a.ie_situacao = 'A'
	
union all

	SELECT	a.nr_sequencia nr_seq_filtro,
		a.ie_filtro_protocolo,
		a.ie_filtro_conta,
		a.ie_filtro_prestador,
		a.ie_filtro_contrato,
		a.ie_filtro_produto,
		a.ie_filtro_pagamento,
		a.ie_filtro_procedimento,
		a.ie_filtro_material,
		a.ie_excecao
	from	pls_pp_rp_cta_filtro a
	where	a.nr_seq_lote = nr_seq_lote_pc
	and	a.ie_tipo_filtro = 'R'
	and	a.ie_situacao = 'A'
	order by ie_excecao,
		 nr_seq_filtro;
		
BEGIN

-- abre os "cabecalhos" das configuracoes de filtros

for r_c_conf_filtro_w in c_conf_filtro(nr_seq_lote_p, nr_seq_regra_periodo_p) loop
	
	-- alimenta a incidencia do filtro

	ie_incidencia_filtro_w := 'C';
	if (r_c_conf_filtro_w.ie_filtro_procedimento = 'S') then
		ie_incidencia_filtro_w := 'P';
	elsif (r_c_conf_filtro_w.ie_filtro_material = 'S') then
		ie_incidencia_filtro_w := 'M';
	end if;

	-- faz a devida alimentacao dos campos de acordo com o tipo de regra para realizar o correto processamento dos filtros

	CALL CALL CALL CALL CALL pls_pp_filtro_rec_glosa_pck.prepara_reg_proces_filtro(nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao);
	
	-- so considera a tabela de selecao quando for filtro de excecao (retira registros) para qualquer outro caso nao considerar, 

	-- pois serao inseridos registros a nivel de filtro

	if (r_c_conf_filtro_w.ie_excecao = 'S') then
		ie_considera_tab_selecao_w := true;
	else
		ie_considera_tab_selecao_w := false;
	end if;
	
	ie_processou_filtro_w := false;
					
	-- filtro de protocolo

	if (r_c_conf_filtro_w.ie_filtro_protocolo = 'S') then
		SELECT * FROM pls_pp_filtro_rec_glosa_pck.aplica_filtro_protocolo(	ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, ie_tipo_data_ref_p, dt_inicio_referencia_p, dt_fim_referencia_p, cd_condicao_pagamento_p, ie_recurso_proprio_p, ie_incidencia_filtro_w, cd_estabelecimento_p, nm_usuario_p) INTO STRICT 	ie_considera_tab_selecao_w, qt_filtro_processado_w;

		if (qt_filtro_processado_w > 0) then
			ie_processou_filtro_w := true;
		end if;
	end if;
	
	-- filtro de conta

	if (r_c_conf_filtro_w.ie_filtro_conta = 'S') then
		SELECT * FROM pls_pp_filtro_rec_glosa_pck.aplica_filtro_conta(	ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, ie_tipo_data_ref_p, dt_inicio_referencia_p, dt_fim_referencia_p, cd_condicao_pagamento_p, ie_recurso_proprio_p, ie_incidencia_filtro_w, cd_estabelecimento_p, nm_usuario_p) INTO STRICT 	ie_considera_tab_selecao_w, qt_filtro_processado_w;

		if (qt_filtro_processado_w > 0) then
			ie_processou_filtro_w := true;
		end if;
	end if;
	
	-- filtro de prestador

	if (r_c_conf_filtro_w.ie_filtro_prestador = 'S') then
		SELECT * FROM pls_pp_filtro_rec_glosa_pck.aplica_filtro_prestador(	ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, ie_tipo_data_ref_p, dt_inicio_referencia_p, dt_fim_referencia_p, cd_condicao_pagamento_p, ie_recurso_proprio_p, ie_incidencia_filtro_w, cd_estabelecimento_p, nm_usuario_p) INTO STRICT 	ie_considera_tab_selecao_w, qt_filtro_processado_w;
						
		if (qt_filtro_processado_w > 0) then
			ie_processou_filtro_w := true;
		end if;
	end if;
	
	-- filtro de contrato

	if (r_c_conf_filtro_w.ie_filtro_contrato = 'S') then
		SELECT * FROM pls_pp_filtro_rec_glosa_pck.aplica_filtro_contrato(		ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, ie_tipo_data_ref_p, dt_inicio_referencia_p, dt_fim_referencia_p, cd_condicao_pagamento_p, ie_recurso_proprio_p, ie_incidencia_filtro_w, cd_estabelecimento_p, nm_usuario_p) INTO STRICT 		ie_considera_tab_selecao_w, qt_filtro_processado_w;
						
		if (qt_filtro_processado_w > 0) then
			ie_processou_filtro_w := true;
		end if;
	end if;
	
	-- filtro de produto

	if (r_c_conf_filtro_w.ie_filtro_produto = 'S') then
		SELECT * FROM pls_pp_filtro_rec_glosa_pck.aplica_filtro_produto(		ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, ie_tipo_data_ref_p, dt_inicio_referencia_p, dt_fim_referencia_p, cd_condicao_pagamento_p, ie_recurso_proprio_p, ie_incidencia_filtro_w, cd_estabelecimento_p, nm_usuario_p) INTO STRICT 		ie_considera_tab_selecao_w, qt_filtro_processado_w;
						
		if (qt_filtro_processado_w > 0) then
			ie_processou_filtro_w := true;
		end if;
	end if;
	
	-- filtro de pagamento

	if (r_c_conf_filtro_w.ie_filtro_pagamento = 'S') then
		SELECT * FROM pls_pp_filtro_rec_glosa_pck.aplica_filtro_pagamento(	ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, ie_tipo_data_ref_p, dt_inicio_referencia_p, dt_fim_referencia_p, cd_condicao_pagamento_p, ie_recurso_proprio_p, ie_incidencia_filtro_w, cd_estabelecimento_p, nm_usuario_p) INTO STRICT 	ie_considera_tab_selecao_w, qt_filtro_processado_w;
						
		if (qt_filtro_processado_w > 0) then
			ie_processou_filtro_w := true;
		end if;
	end if;
	
	-- filtro de procedimento

	if (r_c_conf_filtro_w.ie_filtro_procedimento = 'S') then
		SELECT * FROM pls_pp_filtro_rec_glosa_pck.aplica_filtro_procedimento(	ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, ie_tipo_data_ref_p, dt_inicio_referencia_p, dt_fim_referencia_p, cd_condicao_pagamento_p, ie_recurso_proprio_p, ie_incidencia_filtro_w, cd_estabelecimento_p, nm_usuario_p) INTO STRICT 	ie_considera_tab_selecao_w, qt_filtro_processado_w;
						
		if (qt_filtro_processado_w > 0) then
			ie_processou_filtro_w := true;
		end if;
	end if;
	
	-- filtro de material

	if (r_c_conf_filtro_w.ie_filtro_material = 'S') then
		SELECT * FROM pls_pp_filtro_rec_glosa_pck.aplica_filtro_material(	ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, ie_tipo_data_ref_p, dt_inicio_referencia_p, dt_fim_referencia_p, cd_condicao_pagamento_p, ie_recurso_proprio_p, ie_incidencia_filtro_w, cd_estabelecimento_p, nm_usuario_p) INTO STRICT 	ie_considera_tab_selecao_w, qt_filtro_processado_w;
						
		if (qt_filtro_processado_w > 0) then
			ie_processou_filtro_w := true;
		end if;
	end if;

	-- quando for excecao, busca tudo o que tiver o ie_excecao = S e coloca o ie_valido = N pois se caiu na excecao nao deve casar

	CALL CALL CALL CALL CALL pls_pp_filtro_rec_glosa_pck.atualiza_sel_excecao_end(nr_id_transacao_p, ie_processou_filtro_w, r_c_conf_filtro_w.ie_excecao);
end loop;

-- limpa tudo o que for invalido, porque na tabela de selecao so podera ser utilizado o que for ie_valido = S nos passos seguintes

CALL CALL CALL CALL CALL CALL pls_pp_filtro_rec_glosa_pck.limpar_invalidos(nr_id_transacao_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_filtro_rec_glosa_pck.gerencia_aplicacao_filtro ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_regra_periodo_p pls_pp_lote.nr_seq_regra_periodo%type, nr_id_transacao_p pls_pp_cta_rec_selecao.nr_id_transacao%type, ie_tipo_data_ref_p pls_pp_lote.ie_tipo_dt_referencia%type, dt_inicio_referencia_p pls_pp_lote.dt_referencia_inicio%type, dt_fim_referencia_p pls_pp_lote.dt_referencia_fim%type, cd_condicao_pagamento_p pls_pp_lote.cd_condicao_pagamento%type, ie_recurso_proprio_p pls_pp_lote.ie_recurso_proprio%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
