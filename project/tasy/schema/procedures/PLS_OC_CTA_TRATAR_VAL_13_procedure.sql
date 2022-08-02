-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_13 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de informações de nascimento na conta médica
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_sql_w			varchar(4000);
ds_sql_mortos_w			varchar(2000);
ds_sql_nasc_w			varchar(2000);
ds_sql_restricao_w		varchar(2000);
nr_seq_selecao_w		dbms_sql.number_table;
ds_observacao_w			dbms_sql.varchar2_table;
ie_valido_w			dbms_sql.varchar2_table;
ie_registro_valido_w		varchar(1);
v_cur				pls_util_pck.t_cursor;

-- Informações da validação de informações de nascimento
C02 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
SELECT	a.nr_sequencia	nr_seq_validacao,
	a.ie_tipo_validacao,
	a.ds_carac_valido
from	pls_oc_cta_val_inf_nasc a
where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

BEGIN

-- Deve existir informação da regra para executar a validação
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	ie_registro_valido_w := 'S';
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

	-- Buscar os dados da regra cadastrada para a vaidação
	for	r_C02_w in C02(dados_regra_p.nr_sequencia) loop
		ds_sql_w	:= '';
		ds_sql_mortos_w	:= '';
		ds_sql_nasc_w	:= '';
		ds_sql_restricao_w :=	 '	where 1 = 1' ||pls_tipos_ocor_pck.enter_w||'';
		-- Atualizar o campo ie_valido_temp para N  na tabela PLS_SELECAO_OCOR_CTA  para todos os registros.
		CALL pls_tipos_ocor_pck.atualiza_sel_ie_valido_temp(nr_id_transacao_p, null, 'V');

		-- Caso seja para verificar os dados do nascimento, deve ser verificado se a quantidade de nascimentos informada na conta é diferente da quantidade de declarações
		-- de nascimento que a conta possui.
		if (r_C02_w.ie_tipo_validacao = 1) then
			ds_sql_nasc_w := 	'	(select	count(1) ' || pls_tipos_ocor_pck.enter_w ||
						'	from	pls_diagnostico_nasc_vivo decl ' || pls_tipos_ocor_pck.enter_w ||
						'	where	decl.nr_seq_conta = conta.nr_sequencia ) qt_declar_nasc'|| pls_tipos_ocor_pck.enter_w ||'';

			if (dados_regra_p.ie_evento = 'IMP') then
				ds_sql_restricao_w :=	ds_sql_restricao_w ||' 	and (qt_nasc_vivos_total_imp <> qt_declar_nasc) '||pls_tipos_ocor_pck.enter_w||'';
			else
				ds_sql_restricao_w :=	ds_sql_restricao_w ||' 	and (qt_nasc_vivos_total <> qt_declar_nasc)'||pls_tipos_ocor_pck.enter_w||'';
			end if;

		-- Caso seja para verificar os dados de óbito, deve ser verificado a quantidade de óbitos informados na conta é diferente da quantidade de declarações
		-- de óbito que a conta possui
		elsif (r_C02_w.ie_tipo_validacao = 2) then
			ds_sql_mortos_w	:=	'	(select	count(1) ' || pls_tipos_ocor_pck.enter_w ||
						'	from	pls_diagnost_conta_obito decl ' || pls_tipos_ocor_pck.enter_w ||
						'	where	decl.nr_seq_conta = conta.nr_sequencia) qt_declar_mortos ' || pls_tipos_ocor_pck.enter_w ||'';

			if (dados_regra_p.ie_evento = 'IMP') then
				ds_sql_restricao_w :=	ds_sql_restricao_w ||' 	and (qt_obito_total_imp <> qt_declar_mortos) '||pls_tipos_ocor_pck.enter_w||'';
			else
				ds_sql_restricao_w :=	ds_sql_restricao_w ||' 	and (qt_obito_total <> qt_declar_mortos)'||pls_tipos_ocor_pck.enter_w||'';
			end if;

		-- Caso seja para verificar os dois irá verificar um de cada vez, pois as validações ocorrem no formado ou.
		elsif (r_C02_w.ie_tipo_validacao = 3) then
			ds_sql_nasc_w	:=	'	(select	count(1) ' || pls_tipos_ocor_pck.enter_w ||
						'	from	pls_diagnostico_nasc_vivo decl ' || pls_tipos_ocor_pck.enter_w ||
						'	where	decl.nr_seq_conta = conta.nr_sequencia ) qt_declar_nasc,'|| pls_tipos_ocor_pck.enter_w ||'';


			ds_sql_mortos_w :=  	'	(select	count(1) ' || pls_tipos_ocor_pck.enter_w ||
						'	from	pls_diagnost_conta_obito decl ' || pls_tipos_ocor_pck.enter_w ||
						'	where	decl.nr_seq_conta = conta.nr_sequencia) qt_declar_mortos ' || pls_tipos_ocor_pck.enter_w ||'';

			if (dados_regra_p.ie_evento = 'IMP') then
				ds_sql_restricao_w :=	ds_sql_restricao_w ||' 	and ((qt_nasc_vivos_total_imp <> qt_declar_nasc) '||pls_tipos_ocor_pck.enter_w||
							' 		or (qt_obito_total_imp <> qt_declar_mortos)) '||pls_tipos_ocor_pck.enter_w||'';
			else
				ds_sql_restricao_w :=	ds_sql_restricao_w ||' 	and ((qt_nasc_vivos_total <> qt_declar_nasc) '||pls_tipos_ocor_pck.enter_w||
							' 		or (qt_obito_total <> qt_declar_mortos)) '||pls_tipos_ocor_pck.enter_w||'';
			end if;
		elsif (r_C02_w.ds_carac_valido IS NOT NULL AND r_C02_w.ds_carac_valido::text <> '') then
			ds_sql_nasc_w := 'null';
			ds_sql_restricao_w := ds_sql_restricao_w 	|| '	and pls_valida_caract_decl(nr_seq_conta, ''' || r_C02_w.ds_carac_valido
									|| ''', ''' || dados_regra_p.ie_evento || ''') = ''N''';
		end if;

		ds_sql_w :=	'select nr_sequencia nr_seq_selecao,' || pls_tipos_ocor_pck.enter_w ||
				''''||ie_registro_valido_w||''' ie_registro_valido, ' ||pls_tipos_ocor_pck.enter_w||
				' 	null ds_obervacao ' ||pls_tipos_ocor_pck.enter_w||
				'from	(select	distinct sel.nr_sequencia, ' || pls_tipos_ocor_pck.enter_w ||
				'		conta.qt_obito_total_imp, ' || pls_tipos_ocor_pck.enter_w ||
				'		conta.qt_obito_total, ' || pls_tipos_ocor_pck.enter_w ||
				'		conta.qt_nasc_vivos_total_imp, ' || pls_tipos_ocor_pck.enter_w ||
				'		conta.qt_nasc_vivos_total, ' || pls_tipos_ocor_pck.enter_w ||
				'		conta.nr_sequencia nr_seq_conta, ' || pls_tipos_ocor_pck.enter_w ||

				'		'||ds_sql_nasc_w || pls_tipos_ocor_pck.enter_w ||
				'		'||ds_sql_mortos_w || pls_tipos_ocor_pck.enter_w ||

				'	from	pls_oc_cta_selecao_ocor_v sel, ' || pls_tipos_ocor_pck.enter_w ||
				'	pls_conta_ocor_v conta ' || pls_tipos_ocor_pck.enter_w ||
				'	where	sel.nr_id_transacao = :nr_id_transacao ' || pls_tipos_ocor_pck.enter_w ||
				'	and	sel.ie_valido = ''S'' ' || pls_tipos_ocor_pck.enter_w ||
				'	and	conta.nr_sequencia = sel.nr_seq_conta) ' || pls_tipos_ocor_pck.enter_w ||
				'	'||ds_sql_restricao_w||'';
		begin

			open v_cur for EXECUTE ds_sql_w using 	nr_id_transacao_p;
			loop
				nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
				ie_valido_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				fetch v_cur bulk collect
				into  nr_seq_selecao_w, ie_valido_w, ds_observacao_w
				limit pls_util_cta_pck.qt_registro_transacao_w;
					exit when nr_seq_selecao_w.count = 0;

					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao( nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w, 'SEQ', ds_observacao_w,
										ie_valido_w, nm_usuario_p);

			end loop;
			close v_cur;
		exception
		when others then
			--Fecha cursor
			close v_cur;
			-- Insere o log na tabela e aborta a operação
			CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p,ds_sql_w,nr_id_transacao_p,nm_usuario_p);
		end;
		-- seta os registros que serão válidos ou inválidos após o processamento
		CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
	end loop; -- C02
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_13 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

