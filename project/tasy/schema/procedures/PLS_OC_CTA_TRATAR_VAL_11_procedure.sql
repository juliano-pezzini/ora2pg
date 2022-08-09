-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_11 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de exigência de hora inicia/final do procedimento ou material
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:

------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_selecao_w	dbms_sql.number_table;
ds_observacao_w		dbms_sql.varchar2_table;
ie_valido_w		dbms_sql.varchar2_table;
ie_gera_ocor_w		varchar(1);
nr_indice_w		integer;

-- Informações da validação de exigência de hora
C01 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia	nr_seq_validacao,
		a.ie_exigencia_hora
	from	pls_oc_cta_val_exig_hora a
	where	a.nr_seq_oc_cta_comb = nr_seq_oc_cta_comb_p;

C02 CURSOR(	nr_id_transacao_p	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia	nr_seq_selecao,
		a.dt_inicio_proc_imp 	hr_inicio_imp,
		a.dt_inicio_proc 	hr_inicio,
		a.dt_fim_proc_imp 	hr_fim_imp,
		a.dt_fim_proc		hr_fim
	from	pls_selecao_ocor_cta sel,
		pls_conta_proc a
	where	sel.nr_id_transacao 	= nr_id_transacao_p
	and	sel.ie_valido 		= 'S'
	and 	a.nr_sequencia 		= sel.nr_seq_conta_proc
	
union all

	SELECT	sel.nr_sequencia	nr_seq_selecao,
		a.dt_inicio_atend_imp 	hr_inicio_imp,
		a.dt_inicio_atend 	hr_inicio,
		a.dt_fim_atend_imp 	hr_fim_imp,
		a.dt_fim_atend 		hr_fim
	from	pls_selecao_ocor_cta sel,
		pls_conta_mat a
	where	sel.nr_id_transacao 	= nr_id_transacao_p
	and	sel.ie_valido 		= 'S'
	and	a.nr_sequencia 		= sel.nr_seq_conta_mat;
BEGIN
-- Deve existir a informação da regra para aplicar a validação
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

	nr_seq_selecao_w.delete;
	ie_valido_w.delete;
	ds_observacao_w.delete;
	nr_indice_w := 0;

	for r_C01_w in C01(dados_regra_p.nr_sequencia) loop

		for r_C02_w in C02(nr_id_transacao_p) loop

			ie_gera_ocor_w := 'N';

			-- Deve ser verificado a parametrização da validação conforme definido pelo usuário.
			-- Cada tipo de verificação será visto individualmente.
			if (r_C01_w.ie_exigencia_hora = 'I') then

				-- Deve ser verificado o evento a que a regra se aplica, ser for importação então deve verificar os campos imp
				if (dados_regra_p.ie_evento = 'IMP') then

					if (coalesce(r_C02_w.hr_inicio_imp::text, '') = '') then
						ie_gera_ocor_w := 'S';
					end if;
				else
					if (coalesce(r_C02_w.hr_inicio::text, '') = '') then
						ie_gera_ocor_w := 'S';
					end if;
				end if;
			elsif (r_C01_w.ie_exigencia_hora = 'F') then

				-- Deve ser verificado o evento a que a regra se aplica, ser for importação então deve verificar os campos imp
				if (dados_regra_p.ie_evento = 'IMP') then

					if (coalesce(r_C02_w.hr_fim_imp::text, '') = '') then
						ie_gera_ocor_w := 'S';
					end if;
				else
					if (coalesce(r_C02_w.hr_fim::text, '') = '') then
						ie_gera_ocor_w := 'S';
					end if;
				end if;
			elsif (r_C01_w.ie_exigencia_hora = 'A') then

				-- Deve ser verificado o evento a que a regra se aplica, ser for importação então deve verificar os campos imp
				if (dados_regra_p.ie_evento = 'IMP') then

					if (coalesce(r_C02_w.hr_inicio_imp::text, '') = '') or (coalesce(r_C02_w.hr_fim_imp::text, '') = '') then
						ie_gera_ocor_w := 'S';
					end if;
				else

					if (coalesce(r_C02_w.hr_inicio::text, '') = '') or (coalesce(r_C02_w.hr_fim::text, '') = '') then
						ie_gera_ocor_w := 'S';
					end if;
				end if;
			end if;

			if (ie_gera_ocor_w = 'S') then

				nr_seq_selecao_w(nr_indice_w) := r_C02_w.nr_seq_selecao;
				ie_valido_w(nr_indice_w) := 'S';
				ds_observacao_w(nr_indice_w) := null;

				if (nr_indice_w >= pls_util_pck.qt_registro_transacao_w) then

					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao( nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
											'SEQ', ds_observacao_w,
											ie_valido_w, nm_usuario_p);
					nr_indice_w := 0;
					nr_seq_selecao_w.delete;
					ie_valido_w.delete;
					ds_observacao_w.delete;
				else
					nr_indice_w := nr_indice_w + 1;
				end if;
			end if;
		end loop; --C02
	end loop; -- C01
	CALL pls_tipos_ocor_pck.gerencia_selecao_validacao( nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
							'SEQ', ds_observacao_w,
							ie_valido_w, nm_usuario_p);
	nr_seq_selecao_w.delete;
	ie_valido_w.delete;
	ds_observacao_w.delete;

	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_11 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
