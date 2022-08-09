-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_11_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
DECLARE


_ora2pg_r RECORD;
tb_seq_selecao_w			pls_util_cta_pck.t_number_table;
tb_valido_w				pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w				pls_util_cta_pck.t_varchar2_table_4000;

-- Informações da validação de exigência de hora
C01 CURSOR(	nr_seq_oc_cta_comb_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.ie_exigencia_hora
	from	pls_oc_cta_val_exig_hora a
	where	a.nr_seq_oc_cta_comb	 = nr_seq_oc_cta_comb_pc;

--Exige hora inicial
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia,
		sel.ie_valido,
		null ds_observacao
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_proc_imp	proc
	where	sel.nr_id_transacao 	= nr_id_transacao_p
	and	sel.ie_valido 		= 'S'
	and 	proc.nr_sequencia	= sel.nr_seq_conta_proc
	and	coalesce(proc.dt_inicio::text, '') = ''
	
union all

	SELECT	sel.nr_sequencia,
		sel.ie_valido,
		null ds_observacao
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_mat_imp	mat
	where	sel.nr_id_transacao 	= nr_id_transacao_p
	and	sel.ie_valido 		= 'S'
	and	mat.nr_sequencia 	= sel.nr_seq_conta_mat
	and	coalesce(mat.dt_inicio::text, '') = '';

--Exige hora final
C03 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia,
		sel.ie_valido,
		null ds_observacao
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_proc_imp	proc
	where	sel.nr_id_transacao 	= nr_id_transacao_p
	and	sel.ie_valido 		= 'S'
	and 	proc.nr_sequencia	= sel.nr_seq_conta_proc
	and	coalesce(proc.dt_fim::text, '') = ''
	
union all

	SELECT	sel.nr_sequencia,
		sel.ie_valido,
		null ds_observacao
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_mat_imp	mat
	where	sel.nr_id_transacao 	= nr_id_transacao_p
	and	sel.ie_valido 		= 'S'
	and	mat.nr_sequencia 	= sel.nr_seq_conta_mat
	and	coalesce(mat.dt_fim::text, '') = '';

--Ambos
C04 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia,
		sel.ie_valido,
		null ds_observacao
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_proc_imp	proc
	where	sel.nr_id_transacao 	= nr_id_transacao_p
	and	sel.ie_valido 		= 'S'
	and 	proc.nr_sequencia	= sel.nr_seq_conta_proc
	and	coalesce(proc.dt_inicio::text, '') = ''
	and	coalesce(proc.dt_fim::text, '') = ''
	
union all

	SELECT	sel.nr_sequencia,
		sel.ie_valido,
		null ds_observacao
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_mat_imp	mat
	where	sel.nr_id_transacao 	= nr_id_transacao_p
	and	sel.ie_valido 		= 'S'
	and	mat.nr_sequencia 	= sel.nr_seq_conta_mat
	and	coalesce(mat.dt_inicio::text, '') = ''
	and	coalesce(mat.dt_fim::text, '') = '';

BEGIN
-- Deve existir a informação da regra e transação para aplicar a validação
if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') and (nr_id_transacao_p IS NOT NULL AND nr_id_transacao_p::text <> '')  then

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', 'N', nr_id_transacao_p, null);

	--limpa as variáveis
	SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

	for r_C01_w in C01(nr_seq_combinada_p) loop
		-- Deve ser verificado a parametrização da validação conforme definido pelo usuário.
		-- Cada tipo de verificação será visto individualmente.
		if (r_C01_w.ie_exigencia_hora = 'I') then
			begin
				--Abre cursor da regra 'Exige hora inicial' e gera ocorrência para os registros que vierem no cursor
				open C02(nr_id_transacao_p);
				loop
					fetch C02 bulk collect into	tb_seq_selecao_w, tb_valido_w, tb_observacao_w
					limit pls_util_pck.qt_registro_transacao_w;
					exit when tb_seq_selecao_w.count = 0;

					--Grava as informações na tabela de seleção
					CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
											tb_observacao_w, nr_id_transacao_p,
											'SEQ');
					--limpa as variáveis
					SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
				end loop;
				close C02;
			exception
			when others then
				--Fecha cursor
				if (C02%isopen) then

					close C02;
				end if;
			end;
		elsif (r_C01_w.ie_exigencia_hora = 'F') then
			begin
				--Abre cursor da regra 'Exige hora final' e gera ocorrência para os registros que vierem no cursor
				open C03(nr_id_transacao_p);
				loop
					fetch C03 bulk collect into	tb_seq_selecao_w, tb_valido_w, tb_observacao_w
					limit pls_util_pck.qt_registro_transacao_w;
					exit when tb_seq_selecao_w.count = 0;

					--Grava as informações na tabela de seleção
					CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
											tb_observacao_w, nr_id_transacao_p,
											'SEQ');
					--limpa as variáveis
					SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
				end loop;
				close C03;
			exception
			when others then
				--Fecha cursor
				if (C03%isopen) then

					close C03;
				end if;
			end;
		elsif (r_C01_w.ie_exigencia_hora = 'A') then
			begin
				--Abre cursor da regra 'Ambos' e gera ocorrência para os registros que vierem no cursor
				open C04(nr_id_transacao_p);
				loop
					fetch C04 bulk collect into	tb_seq_selecao_w, tb_valido_w, tb_observacao_w
					limit pls_util_pck.qt_registro_transacao_w;
					exit when tb_seq_selecao_w.count = 0;

					--Grava as informações na tabela de seleção
					CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
											tb_observacao_w, nr_id_transacao_p,
											'SEQ');
					--limpa as variáveis
					SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
				end loop;
				close C04;
			exception
			when others then
				--Fecha cursor
				if (C04%isopen) then

					close C04;
				end if;
			end;
		end if;
	end loop; -- C01
	--Grava o que restar nas variáveis na tabela
	CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
							tb_observacao_w, nr_id_transacao_p,
							'SEQ');

	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_ocor_imp_pck.atualiza_campo_valido(	'V', 'N',
							ie_regra_excecao_p, null,
							nr_id_transacao_p, null);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_11_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;
