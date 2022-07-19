-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_18 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Irá realizar a chamada para a rotina de validação conforme a validação selecionada na regra.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Tomar cuidado ao criar uma nova rotina para que sejam verificados todos os registros da tabela
PLS_SELECAO_OCOR_CTA.
Tomar cuidado com a manutenção dos registros na tabela PLS_SELECAO_OCOR_CTA, utilizar sempre a
rotina PLS_TIPOS_OCOR_PCK.GERENCIA_REGISTRO_SELECAO;

Alterações:
 ------------------------------------------------------------------------------------------------------------------
jjung 29/06/2013

Alteração:	Adicionado parametro nos métodos de atualização dos campos IE_VALIDO e IE_VALIDO_TEMP
	da PLS_TIPOS_OCOR_PCK

Motivo:	Se tornou necessário diferenciar os filtros das validações na hora de realizar esta operação
	para que os filtros de exceção funcionem corretamente.
------------------------------------------------------------------------------------------------------------------
dlehmkuhl OS 688483 - 14/04/2014 -

Alteração:	Modificada a forma de trabalho em relação a atualização dos campos de controle
	que basicamente decidem se a ocorrência será ou não gerada. Foi feita também a
	substituição da rotina obterX_seX_geraX.

Motivo:	Necessário realizar essas alterações para corrigir bugs principalmente no que se
	refere a questão de aplicação de filtros (passo anterior ao da validação). Também
	tivemos um foco especial em performance, visto que a mesma precisou ser melhorada
	para não inviabilizar a nova solicitação que diz que a exceção deve verificar todo
	o atendimento.
------------------------------------------------------------------------------------------------------------------
jjung OS 744694 - 10/09/2014 -

Alteração:	Incluído chamada para a rotina PLS_TIPOS_OCOR_PCK.TRATAR_ERRO_SQL_DINAMICO
	quando ocorre alguma exceção na rotina.

Motivo:	Caso não tenha essa chamada ficará difícil identificar por que esta ocorrência não está
	funcionando como deveria.
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_filtro_w		pls_tipos_ocor_pck.dados_filtro;
vl_apresentado_w	pls_conta_proc.vl_procedimento_imp%type;
vl_calculado_w		pls_conta_proc.vl_procedimento%type;

nr_seq_selecao_w	dbms_sql.number_table;
ds_observacao_w		dbms_sql.varchar2_table;
ie_valido_w		dbms_sql.varchar2_table;
ie_registro_valido_w	varchar(1);

-- Procedimentos que foram aplicadas nos filtros da regra
C01 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
		vl_tolerancia		pls_oc_cta_val_va500.vl_tolerancia%type,
		ie_registro_valido_pc	pls_oc_cta_selecao_ocor_v.ie_valido%type ) FOR

	SELECT
		 nr_sequencia nr_seq_selecao,
		 ie_registro_valido_pc ie_valido,
		 null ds_observacao
	from
		(SELECT
			x.nr_sequencia,
			--Obtém o valor apresentado
			(a.vl_procedimento_ptu_imp 	+
			 a.vl_material_ptu_imp 		+
			 a.vl_co_ptu_imp) vl_apresentado,
			--Obtém o valor calculado sem considerar o valor de tolerância
			(a.vl_calc_co_util	+
			a.vl_calc_hi_util	+
			a.vl_calc_mat_util) vl_calc,
			-- Obtém o valor calculado acrescido do valor de tolerância
			(a.vl_calc_co_util	+
			a.vl_calc_hi_util	+
			a.vl_calc_mat_util	+
			vl_tolerancia)	  vl_calc_final
		from	pls_oc_cta_selecao_ocor_v	x,
			pls_conta_proc_ocor_v		a
		where	x.ie_valido		= 'S'
		and	x.nr_id_transacao	= nr_id_transacao_pc
		and	x.nr_seq_conta_proc	= a.nr_sequencia
		and	a.vl_procedimento	> 0
		and	a.ie_origem_conta	= 'A'
		) alias4
	where	vl_calc > 0
	and	vl_calc_final < vl_apresentado;

--Busca os materiais que foram aplicadas nos filtros da regra
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
		vl_tolerancia		pls_oc_cta_val_va500.vl_tolerancia%type,
		ie_registro_valido_pc	pls_oc_cta_selecao_ocor_v.ie_valido%type) FOR
	SELECT
		 nr_sequencia nr_seq_selecao,
		 ie_registro_valido_pc ie_valido,
		 null ds_observacao
	from
		(SELECT
			x.nr_sequencia,
			--Obtém o valor apresentado
			(a.vl_material_imp	-
			a.vl_taxa_material_imp)	vl_apresentado,
			--Obtém o valor calculado sem considerar o valor de tolerância
			(a.vl_material		-
			a.vl_taxa_material)	vl_calc,
			-- Obtém o valor calculado acrescido do valor de tolerância
			(a.vl_material		-
			 a.vl_taxa_material	+
			 vl_tolerancia)	vl_calc_final
		from	pls_oc_cta_selecao_ocor_v	x,
			pls_conta_mat_ocor_v	a
		where	x.nr_id_transacao	= nr_id_transacao_pc
		and	x.ie_valido		= 'S'
		and	x.nr_seq_conta_mat	= a.nr_sequencia
		and	a.vl_material		> 0
		and	a.ie_origem_conta	= 'A'
		) alias4
	where	vl_calc > 0
	and	vl_calc_final < vl_apresentado;

-- Informações da regra de validação ddos valores do A500
C03 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.ie_val_valor_apres_maior,
		coalesce(a.vl_tolerancia, 0) vl_tolerancia
	from	pls_oc_cta_val_va500 a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p
	and	a.ie_val_valor_apres_maior = 'S';

BEGIN

if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '')  then

	for r_c03_w in C03(dados_regra_p.nr_sequencia) loop

		ie_registro_valido_w := 'S';
		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

		begin
			--Processamento dos procedimentos
			open C01(nr_id_transacao_p, r_c03_w.vl_tolerancia, ie_registro_valido_w);
			nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
			ie_valido_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
			ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
			loop
			fetch C01 bulk collect into nr_seq_selecao_w, ie_valido_w, ds_observacao_w limit pls_util_cta_pck.qt_registro_transacao_w;
			exit when nr_seq_selecao_w.count = 0;
				begin
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
											'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
				end;
			end loop;
			close C01;

			--Processamento dos materiais
			open C02(nr_id_transacao_p, r_c03_w.vl_tolerancia, ie_registro_valido_w);
			nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
			ie_valido_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
			ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
			loop
			fetch C02 bulk collect into nr_seq_selecao_w, ie_valido_w, ds_observacao_w limit pls_util_cta_pck.qt_registro_transacao_w;
			exit when nr_seq_selecao_w.count = 0;
				begin
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
												'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
				commit;
				end;
			end loop;
			close C02;

		exception
		when others then
			if (C01%ISOPEN) then
				close C01;
			end if;
			if (C02%ISOPEN) then
				close C02;
			end if;

			CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p,'',nr_id_transacao_p, nm_usuario_p);
		end;

		-- seta os registros que serão válidos ou inválidos após o processamento
		CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);

	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_18 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

