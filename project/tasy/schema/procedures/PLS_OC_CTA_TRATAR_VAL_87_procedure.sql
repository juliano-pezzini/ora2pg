-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_87 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Validar liberação usuário prestador web
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
*/
dados_tb_sel_w		pls_tipos_ocor_pck.dados_table_selecao_ocor;
dados_tb_selecao_w	pls_tipos_ocor_pck.dados_table_selecao_ocor;
nr_idx_w			integer := 0;
nr_seq_usuario_web_w	pls_lote_protocolo_conta.nr_seq_prestador_web%type;
is_usuario_valido_w		boolean := true;
nm_usuario_w		pls_lote_protocolo_conta.nm_usuario%type;
ie_c02_w		varchar(1);

C01 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.ie_valida_usuario,
		a.ie_considera_webservice
	from	pls_oc_cta_val_usuario a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
	SELECT	a.nr_sequencia nr_seq_selecao,
		a.nr_seq_lote_conta,
		a.nr_seq_prestador
	from	pls_oc_cta_selecao_ocor_v	x,
		pls_proc_participante_ocor_v	a
	where	x.ie_valido		= 'S'
	and	x.nr_id_transacao	= nr_id_transacao_pc
	and	a.nr_seq_conta_proc	= x.nr_seq_conta_proc
	and	(a.nr_seq_prestador IS NOT NULL AND a.nr_seq_prestador::text <> '');

C03 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		conta.nr_seq_lote_conta,
		conta.nr_seq_prestador_exec_imp,
		conta.nr_seq_prestador_imp_prot
	from	pls_oc_cta_selecao_ocor_v	sel,
		pls_conta_v			conta
	where	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido		= 'S'
	and	conta.nr_sequencia	= sel.nr_seq_conta;
BEGIN

-- Deve existir informação da regra para aplicar a validação e se a regra é de Importação
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') and (dados_regra_p.ie_evento = 'IMP') then

	for	r_C01_w in C01(dados_regra_p.nr_sequencia) loop

		/*Verifica se é para validar a ocorrência*/

		if (r_C01_w.ie_valida_usuario = 'S')	then
			ie_c02_w	:= 'N';
			CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
			pls_tipos_ocor_pck.limpar_nested_tables(dados_tb_sel_w);

			for r_C02_w in C02(nr_id_transacao_p) loop
				is_usuario_valido_w	:= false;
				ie_c02_w	:= 'S';
				if (r_C02_w.nr_seq_lote_conta IS NOT NULL AND r_C02_w.nr_seq_lote_conta::text <> '')  then
					/*Obter dados do lote*/

					select	nr_seq_prestador_web,
						nm_usuario
					into STRICT	nr_seq_usuario_web_w,
						nm_usuario_w
					from	pls_lote_protocolo_conta
					where	nr_sequencia = r_C02_w.nr_seq_lote_conta;

					--Valida se é Webservice
					if (nm_usuario_w = 'WebService') and (coalesce(r_C01_w.ie_considera_webservice, 'S') = 'N') then
						is_usuario_valido_w	:= true;
					/*Caso o prestador participante da conta não esteja liberado para o usuário web*/

					elsif (pls_obter_prestador_login(nr_seq_usuario_web_w, r_C02_w.nr_seq_prestador) = 'S') then
						is_usuario_valido_w	:= true;
						close C02;
						exit;
					end if;
				end if;
			end loop;

			if (C02%ISOPEN) then
				close C02;
			end if;

			if (not is_usuario_valido_w) or (ie_c02_w	= 'N')then
				for r_C03_w in C03(nr_id_transacao_p) loop
					if (r_C03_w.nr_seq_lote_conta IS NOT NULL AND r_C03_w.nr_seq_lote_conta::text <> '')  then
						/*Obter dados do lote*/

						select	nr_seq_prestador_web,
							nm_usuario
						into STRICT	nr_seq_usuario_web_w,
							nm_usuario_w
						from	pls_lote_protocolo_conta
						where	nr_sequencia = r_C03_w.nr_seq_lote_conta;

						/*Caso o prestador executor da conta não esteja liberado para o usuário web*/

						if (nm_usuario_w = 'WebService') and (coalesce(r_C01_w.ie_considera_webservice, 'S') = 'N') then
							is_usuario_valido_w	:= true;
						/*Caso o prestador participante da conta não esteja liberado para o usuário web*/

						elsif (pls_obter_prestador_login(nr_seq_usuario_web_w, r_C03_w.nr_seq_prestador_exec_imp) = 'N') then
							/*Caso o prestador atendimento da conta não esteja liberado para o usuário web*/

							if (pls_obter_prestador_login(nr_seq_usuario_web_w, r_C03_w.nr_seq_prestador_imp_prot) = 'N') then
								dados_tb_selecao_w.ie_valido(nr_idx_w)		:= 'S';
								dados_tb_selecao_w.nr_seq_selecao(nr_idx_w)	:= r_C03_w.nr_seq_selecao;
								dados_tb_selecao_w.ds_observacao(nr_idx_w)	:= 'Prestador do arquivo não está liberado para importar com o usuário '
															|| substr(pls_obter_nm_usuario_web(nr_seq_usuario_web_w),1,20);
								if (nr_idx_w = pls_util_cta_pck.qt_registro_transacao_w) then
									CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao, pls_util_cta_pck.clob_table_vazia_w,
															'SEQ', dados_tb_selecao_w.ds_observacao, dados_tb_selecao_w.ie_valido, nm_usuario_p);
									nr_idx_w := 0;
									pls_tipos_ocor_pck.limpar_nested_tables(dados_tb_selecao_w);
								else
									nr_idx_w := nr_idx_w + 1;
								end if;
							end if;
						end if;
					end if;
				end loop;
			end if;

			/*Lança as glosas caso existir registros que não foram gerados*/

			if (nr_idx_w > 0)	then
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao, pls_util_cta_pck.clob_table_vazia_w,
										'SEQ', dados_tb_selecao_w.ds_observacao, dados_tb_selecao_w.ie_valido, nm_usuario_p);
			end if;

			CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
		end if;

	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_87 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
