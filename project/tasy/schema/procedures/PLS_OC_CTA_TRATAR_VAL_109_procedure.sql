-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_109 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Irá validar se o código ANS informado no arquivo XML é condizente com o código da operadora.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/tb_seq_selecao_w	dbms_sql.number_table;
tb_observacao_w		dbms_sql.varchar2_table;
tb_valido_w		dbms_sql.varchar2_table;

-- Informações sobre a Regra
c01 CURSOR(	nr_seq_oc_cta_comb_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	ie_valida_operadora
	from	pls_oc_cta_val_oper_inv
	where	nr_seq_oc_cta_comb = nr_seq_oc_cta_comb_pc;

c02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
	SELECT	a.nr_sequencia 	nr_seq_selecao,
		'S' 		ie_valido,
		'Operadora inválida' ds_observacao
	from	pls_oc_cta_selecao_ocor_v 	a,
		pls_conta			b
	where	a.nr_id_transacao 	= nr_id_transacao_pc
	and	a.ie_valido 		= 'S'
	and	a.nr_seq_conta		= b.nr_sequencia
	and not exists (SELECT 	1
			from	pls_outorgante d
			where	d.cd_ans = b.cd_ans
			and	d.cd_estabelecimento = b.cd_estabelecimento);

BEGIN

if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar(	'V',
							nr_id_transacao_p,
							null,
							dados_regra_p);

	-- Carrega as regras
	for r_c01_w in c01(dados_regra_p.nr_sequencia) loop

		-- Só executa a regra se ela não for de tipos de prestadores iguais
		if (r_c01_w.ie_valida_operadora = 'S') then

			open c02(nr_id_transacao_p);
			loop

				tb_seq_selecao_w.delete;
				tb_observacao_w.delete;
				tb_valido_w.delete;

				fetch 	c02 bulk collect
				into	tb_seq_selecao_w, tb_valido_w, tb_observacao_w
				limit pls_util_cta_pck.qt_registro_transacao_w;
				exit when tb_seq_selecao_w.count = 0;

				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
										'SEQ', tb_observacao_w, tb_valido_w, nm_usuario_p);

			end loop;
			close c02;

		end if;
	end loop;

	tb_seq_selecao_w.delete;
	tb_observacao_w.delete;
	tb_valido_w.delete;

	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_tipos_ocor_pck.atualiza_campo_valido(	'V',
							nr_id_transacao_p,
							null,
							dados_regra_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_109 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

