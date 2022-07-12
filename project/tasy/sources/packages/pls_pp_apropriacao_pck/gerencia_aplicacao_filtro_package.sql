-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_apropriacao_pck.gerencia_aplicacao_filtro ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_regra_periodo_p pls_pp_lote.nr_seq_regra_periodo%type, nr_id_transacao_p pls_pp_rp_aprop_selecao.nr_id_transacao%type, cd_condicao_pagamento_p pls_pp_lote.cd_condicao_pagamento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


-- controle para saber quando é necessário restringir apenas os registros que estão na tabela de seleção
ie_considera_tab_selecao_w 	boolean;
qt_filtro_processado_w		integer;
ie_processou_filtro_w		boolean;

-- existem duas formas de cadastrar o que deve entrar no lote.
-- Informando o período no cadastro ou informando os filtros diretamente no lote (lote complementar)
-- para apropriações só é permitido filtros para prestador e pagamento
c_conf_filtro CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type,
			nr_seq_regra_periodo_pc	pls_pp_lote.nr_seq_regra_periodo%type) FOR
	SELECT	a.nr_sequencia nr_seq_filtro,
		a.ie_filtro_prestador,
		a.ie_filtro_pagamento,
		a.ie_excecao
	from	pls_pp_rp_cta_filtro a
	where	a.nr_seq_regra_periodo = nr_seq_regra_periodo_pc
	and	a.ie_tipo_filtro = 'A'
	and	a.ie_situacao = 'A'
	
union all

	SELECT	a.nr_sequencia nr_seq_filtro,
		a.ie_filtro_prestador,
		a.ie_filtro_pagamento,
		a.ie_excecao
	from	pls_pp_rp_cta_filtro a
	where	a.nr_seq_lote = nr_seq_lote_pc
	and	a.ie_tipo_filtro = 'A'
	and	a.ie_situacao = 'A'
	order by ie_excecao,
		 nr_seq_filtro;

BEGIN

-- abre os "cabeçalhos" das configurações de filtros
for r_c_conf_filtro_w in c_conf_filtro(nr_seq_lote_p, nr_seq_regra_periodo_p) loop

	ie_processou_filtro_w := false;

	-- faz a devida alimentação dos campos de acordo com o tipo de regra para realizar o correto processamento dos filtros
	CALL CALL CALL CALL CALL pls_pp_apropriacao_pck.prepara_reg_proces_filtro(nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao);

	-- só considera a tabela de seleção quando for filtro de exceção (retira registros) para qualquer outro caso não considerar, 
	-- pois serão inseridos registros a nível de filtro
	if (r_c_conf_filtro_w.ie_excecao = 'S') then
		ie_considera_tab_selecao_w := true;
	else
		ie_considera_tab_selecao_w := false;
	end if;
	
	-- filtro de prestador
	if (r_c_conf_filtro_w.ie_filtro_prestador = 'S') then

		SELECT * FROM pls_pp_apropriacao_pck.aplica_filtro_prestador(	ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, cd_condicao_pagamento_p, nr_seq_lote_p, nm_usuario_p) INTO STRICT 	ie_considera_tab_selecao_w, qt_filtro_processado_w;

		if (qt_filtro_processado_w > 0) then

			ie_processou_filtro_w := true;
		end if;
	end if;
	
	-- filtro de pagamento
	if (r_c_conf_filtro_w.ie_filtro_pagamento = 'S') then

		SELECT * FROM pls_pp_apropriacao_pck.aplica_filtro_pagamento(	ie_considera_tab_selecao_w, qt_filtro_processado_w, nr_id_transacao_p, r_c_conf_filtro_w.ie_excecao, r_c_conf_filtro_w.nr_seq_filtro, cd_condicao_pagamento_p, nm_usuario_p) INTO STRICT 	ie_considera_tab_selecao_w, qt_filtro_processado_w;

		if (qt_filtro_processado_w > 0) then

			ie_processou_filtro_w := true;
		end if;
	end if;
	
	-- quando for exceção, busca tudo o que tiver o ie_excecao = S e coloca o ie_valido = N pois se caiu na exceção não deve casar
	CALL CALL CALL CALL CALL pls_pp_apropriacao_pck.atualiza_sel_excecao_end(nr_id_transacao_p, ie_processou_filtro_w, r_c_conf_filtro_w.ie_excecao);
end loop;

-- limpa tudo o que for inválido, porque na tabela de seleção só poderá ser utilizado o que for ie_valido = S nos passos seguintes
CALL CALL CALL CALL CALL CALL pls_pp_apropriacao_pck.limpar_invalidos(nr_id_transacao_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_apropriacao_pck.gerencia_aplicacao_filtro ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_regra_periodo_p pls_pp_lote.nr_seq_regra_periodo%type, nr_id_transacao_p pls_pp_rp_aprop_selecao.nr_id_transacao%type, cd_condicao_pagamento_p pls_pp_lote.cd_condicao_pagamento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
