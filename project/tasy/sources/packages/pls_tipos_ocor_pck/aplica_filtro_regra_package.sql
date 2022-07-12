-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_tipos_ocor_pck.aplica_filtro_regra ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_selecao_w		dbms_sql.number_table;

-- retorna somente os itens que nao estao dentro da vigencia da regra

C01 CURSOR(	nr_id_transacao_pc	pls_selecao_ocor_cta.nr_id_transacao%type,
		dt_vig_inicio_pc	pls_oc_cta_combinada.dt_inicio_vigencia_ref%type,
		dt_vig_fim_pc		pls_oc_cta_combinada.dt_fim_vigencia_ref%type) FOR
	SELECT	x.nr_sequencia nr_seq_selecao
	from	pls_selecao_ocor_cta	x
	where	x.nr_id_transacao	= nr_id_transacao_pc
	and	x.ie_valido		= 'S'
	and	x.dt_item not between dt_vig_inicio_pc and dt_vig_fim_pc;

-- retorna somente os itens que foram desconsiderados em regras passadas e agora estao dentro da vigencia da regra

C02 CURSOR(	nr_id_transacao_pc	pls_selecao_ocor_cta.nr_id_transacao%type,
		dt_vig_inicio_pc	pls_oc_cta_combinada.dt_inicio_vigencia_ref%type,
		dt_vig_fim_pc		pls_oc_cta_combinada.dt_fim_vigencia_ref%type) FOR
	SELECT	x.nr_sequencia nr_seq_selecao
	from	pls_selecao_ocor_cta	x
	where	x.nr_id_transacao	= nr_id_transacao_pc
	and	x.ie_valido		= 'D'
	and	x.dt_item between dt_vig_inicio_pc and dt_vig_fim_pc;


BEGIN
-- Se nao tiver informacao da regra nem procura pelos parametros da validacao

if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	-- coloca tudo com o ie_valido = D se a regra nao esta vigente para os itens

	-- isso e feito para desconsiderar no processamento tudo o que nao esta vigente

	-- lembrando que o que nao esta vigente gera ocorrencia normalmente, a regra de excecao nao e considerada

	open C01(nr_id_transacao_p, dados_regra_p.dt_inicio_vigencia, dados_regra_p.dt_fim_vigencia);
	loop

	fetch C01 bulk collect into nr_seq_selecao_w limit pls_util_cta_pck.qt_registro_transacao_w;
	exit when nr_seq_selecao_w.count = 0;

		forall i in nr_seq_selecao_w.first..nr_seq_selecao_w.last
			update	pls_selecao_ocor_cta
			set	ie_valido 	= 'D'
			where	nr_sequencia = nr_seq_selecao_w(i);
		

	end loop;
	close C01;

	-- coloca tudo com o ie_valido = S se a regra esta vigente para os itens

	-- isso e feito para considerar no processamento tudo o que nao foi considerado em uma possivel regra anterior

	open C02(nr_id_transacao_p, dados_regra_p.dt_inicio_vigencia, dados_regra_p.dt_fim_vigencia);
	loop

	fetch C02 bulk collect into nr_seq_selecao_w limit pls_util_cta_pck.qt_registro_transacao_w;
	exit when nr_seq_selecao_w.count = 0;

		forall i in nr_seq_selecao_w.first..nr_seq_selecao_w.last
			update	pls_selecao_ocor_cta
			set	ie_valido 	= 'S'
			where	nr_sequencia = nr_seq_selecao_w(i);
		

	end loop;
	close C02;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tipos_ocor_pck.aplica_filtro_regra ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
