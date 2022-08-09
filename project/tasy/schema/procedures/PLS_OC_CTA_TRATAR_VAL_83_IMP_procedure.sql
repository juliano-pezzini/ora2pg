-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_83_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
DECLARE


_ora2pg_r RECORD;
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_valido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;
nr_idx_w		integer := 0;
qt_guia_w		integer := 0;
ds_observacao_w		varchar(1500);
cd_guia_principal_w	pls_guia_plano.cd_guia%type;

-- Informações da validação guia principal autorização
C01 CURSOR(	nr_seq_oc_cta_comb_p	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.ie_valida_guia_autoriza,
		coalesce(a.ie_guia_nulo,'N') ie_guia_nulo,
		ie_tipo_guia,
		coalesce(a.ie_valida_guia_referencia,'N') ie_valida_guia_referencia,
		( 	SELECT 	max(ds_expressao)
			from 	valor_dominio_v
			where 	cd_dominio = 1746
			and 	vl_dominio = ie_tipo_guia) ds_tipo_guia
	from	pls_oc_cta_val_guia_aut a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

C02 CURSOR(	nr_id_transacao_pc		pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia 		nr_seq_selecao,
		conta.nr_seq_guia_conv		nr_seq_guia,
		conta.cd_guia_ok_conv		cd_guia_referencia,
		conta.cd_guia_principal_conv	cd_guia_ref, --utilizado esse campo pois é assim que é tratado na glosa 1306
		conta.cd_guia_operadora_conv	cd_guia,
	       (SELECT	max(x.ie_tipo_guia)
		from	pls_protocolo_conta_imp x
		where	x.nr_sequencia = conta.nr_seq_protocolo) ie_tipo_guia,
	       (select 	max(cd_guia_principal)
  	        from	pls_guia_plano guia
		where 	guia.nr_sequencia = conta.nr_seq_guia_conv) cd_guia_principal,
		conta.nr_seq_segurado_conv	nr_seq_segurado
	from	pls_oc_cta_selecao_imp		sel,
		pls_conta_imp			conta
	where	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido		= 'S'
	and	conta.nr_sequencia	= sel.nr_seq_conta;
BEGIN

if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') then

	for	r_C01_w in C01(nr_seq_combinada_p) loop

		/*Verifica se é para validar a ocorrência, caso a regra não estiver marcada para validar, então gera ocorrência
		para tudo que chegar na selecão para essa transação*/
		if (r_C01_w.ie_valida_guia_autoriza = 'S') or (r_C01_w.ie_guia_nulo = 'S' ) or (r_C01_w.ie_tipo_guia IS NOT NULL AND r_C01_w.ie_tipo_guia::text <> '') or (r_C01_w.ie_valida_guia_referencia = 'S') then

			-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
			CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', ie_regra_excecao_p, nr_id_transacao_p, null);

			-- Incializar as listas para cada regra.
			SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables( tb_seq_selecao_w, tb_valido_w, tb_observacao_w ) INTO STRICT _ora2pg_r;
  tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w  := _ora2pg_r.tb_ds_observacao_p;

			for r_C02_w in C02(nr_id_transacao_p) loop

				ds_observacao_w := null;
				qt_guia_w := 0;

				if (r_C01_w.ie_valida_guia_referencia = 'S') and (r_C02_w.cd_guia_ref IS NOT NULL AND r_C02_w.cd_guia_ref::text <> '') and (r_C02_w.ie_tipo_guia in ('4','5')) and (r_C02_w.cd_guia_ref <> r_C02_w.cd_guia) then
					select	count(1)
					into STRICT	qt_guia_w
					from	pls_guia_plano
					where	cd_guia = r_C02_w.cd_guia_ref
					and	nr_seq_segurado	= r_C02_w.nr_seq_segurado;

					if (qt_guia_w = 0) then
						select	count(1)
						into STRICT	qt_guia_w
						from	pls_conta
						where	cd_guia	= r_C02_w.cd_guia_ref
						and	nr_seq_segurado = r_C02_w.nr_seq_segurado;

						if (qt_guia_w = 0) then
							select	count(1)
							into STRICT	qt_guia_w
							from	pls_conta_imp
							where	cd_guia_operadora_conv	= r_C02_w.cd_guia_ref
							and	nr_seq_segurado_conv = r_C02_w.nr_seq_segurado;

							if (qt_guia_w = 0) then
								ds_observacao_w := 	'Não foi encontrado nenhuma autorização nem conta médica com o código de guia = ' || r_C02_w.cd_guia_ref ||
											' e segurado = ' || r_C02_w.nr_seq_segurado || '.';
							end if;
						end if;
					end if;
				end if;

				if (r_C02_w.nr_seq_guia IS NOT NULL AND r_C02_w.nr_seq_guia::text <> '') and (r_C02_w.cd_guia_referencia IS NOT NULL AND r_C02_w.cd_guia_referencia::text <> '') and (coalesce(ds_observacao_w::text, '') = '') then

					/*Caso a guia principal que está na guia seja diferente da conta*/

					if ( r_c02_w.cd_guia_principal <> r_C02_w.cd_guia_referencia) and ( r_C01_w.ie_valida_guia_autoriza = 'S') then
						ds_observacao_w := 	' Guia referência da conta ' || r_C02_w.cd_guia_referencia ||
									' é diferente que está na guia da autorização (' || r_c02_w.cd_guia_principal || ')';

					elsif ( coalesce(r_c02_w.cd_guia_principal::text, '') = '') and (r_C01_w.ie_guia_nulo = 'S') then

						ds_observacao_w := 	' Há uma guia referência informada na conta (' || r_C02_w.cd_guia_referencia ||
									'), porém, não está informada na guia da autorização';
					end if;

					--Caso ainda não gerou ocorrência, Nesse caso, busca pela guia referência e nr_seq_segurado uma guia autorizada do tipo da guia selecionada na validação
					if ((r_C01_w.ie_tipo_guia IS NOT NULL AND r_C01_w.ie_tipo_guia::text <> '') and coalesce(ds_observacao_w::text, '') = '') then

						select	max(cd_guia)
						into STRICT	cd_guia_principal_w
						from	pls_guia_plano
						where	cd_guia		= r_C02_w.cd_guia_referencia
						and	nr_seq_segurado = r_C02_w.nr_seq_segurado
						and	ie_tipo_guia	= r_c01_w.ie_tipo_guia
						and 	ie_status	= '1';

						if (coalesce(cd_guia_principal_w::text, '') = '') then

							ds_observacao_w := 	'Não localizada uma autorização com cd_guia = ' || r_C02_w.cd_guia_referencia ||
									' e segurado '||r_C02_w.nr_seq_segurado||' cujo o tipo de guia = '|| r_C01_w.ds_tipo_guia||
									' ou a guia não está autorizada. ';

						end if;

					end if;
				end if;

				if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then

					tb_valido_w(nr_idx_w)		:= 'S';
					tb_seq_selecao_w(nr_idx_w)	:= r_C02_w.nr_seq_selecao;
					tb_observacao_w(nr_idx_w)	:= ds_observacao_w;

					--Se atingir a quantidade máxima de registros nas listas em memória, manda para o banco
					if (nr_idx_w = pls_util_cta_pck.qt_registro_transacao_w) then
						--Persiste as informações presentes nas listas para o banco.
						CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w,
												nr_id_transacao_p,'SEQ');

						--Como mandou as informações das listas para o banco, então reinicia o índice e as próprias listas
						nr_idx_w := 0;
						SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
					else
						--Como ainda não chegou a hora de persistir as informações das listas no BD, então incrementa o índice e prossegue.
						nr_idx_w := nr_idx_w + 1;
					end if;
				end if;
			end loop;

			--Caso sobrarem informações nas listas, manda para o banco
			if (nr_idx_w > 0)	then
				CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w,
										nr_id_transacao_p,'SEQ');
			end if;

			-- seta os registros que serão válidos ou inválidos após o processamento
			CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N', ie_regra_excecao_p, null, nr_id_transacao_p, null);
		end if;

	end loop;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_83_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;
