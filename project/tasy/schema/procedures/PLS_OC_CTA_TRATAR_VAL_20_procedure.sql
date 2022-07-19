-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_20 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Validar as caracterísiticas do CBO informado para o médico executor da conta.
validação baseada na glosa 1213
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: verificar as validações de importação, aonde são realizadas duas validações
para o CBO

Alterações:
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
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_filtro_w			pls_tipos_ocor_pck.dados_filtro;
nr_seq_cbo_saude_w 		pls_conta.nr_seq_cbo_saude%type;
ie_gerar_ocorrencia_w		varchar(1);
dados_tb_selecao_w		pls_tipos_ocor_pck.dados_table_selecao_ocor;
nr_seq_selecao_w		dbms_sql.number_table;
ds_observacao_w			dbms_sql.varchar2_table;
ie_valido_w			dbms_sql.varchar2_table;
ie_registro_valido_w		varchar(1);
nr_seq_especialidade_w		especialidade_medica.cd_especialidade%type;
cd_cbo_executante_w		cbo_saude.cd_cbo%type;
nr_versao_ptu_w			varchar(20);
nr_idx_w			integer;
C01 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.ie_validar_cbo_invalido,
		a.ie_valida_cbo_solic,
		a.ie_valida_cbo_desc,
		a.ie_valida_cbo_interc
	from	pls_oc_cta_val_cbo a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

C02 CURSOR(	nr_id_transacao_pc		pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
		ie_evento			pls_oc_cta_combinada.ie_evento%type,
		ie_registro_valido_pc		pls_oc_cta_selecao_ocor_v.ie_valido%type,
		ie_validar_cbo_invalido_pc	pls_oc_cta_val_cbo.ie_validar_cbo_invalido%type,
		ie_valida_cbo_solic_pc		pls_oc_cta_val_cbo.ie_valida_cbo_solic%type,
		ie_valida_cbo_desc_pc		pls_oc_cta_val_cbo.ie_valida_cbo_desc%type) FOR
	SELECT 	nr_sequencia nr_seq_selecao,
		ie_registro_valido_pc ie_valido,
		null ds_observacao
	from
	(SELECT	x.nr_sequencia,
		--Se for importação, então verifica se um dos campos cbo esta nulo e em caso afirmativo retorna 1 .
		(case
			when ((	ie_evento = 'IMP')
			and (ie_validar_cbo_invalido_pc = 'S')
			and (coalesce(a.cd_cbo_saude_exec_imp::text, '') = '' or coalesce(a.nr_seq_cbo_saude_imp::text, '') = '')) then 1
			else	0
		end) condicao_1,

		--Quando não for importação , médico executor estiver informado porém o CBO não esta, então retorna 1
		(case
			when(	ie_evento <> 'IMP'
			and (ie_validar_cbo_invalido_pc = 'S')
			and	(a.cd_medico_executor IS NOT NULL AND a.cd_medico_executor::text <> '')
			and	coalesce(a.nr_seq_cbo_saude::text, '') = ''
			) then 1
			else  0
		end) condicao_2,
		--Se for importação, campo CBO estiver informado, ainda é preciso verificar a situação deste CBO,
		--se não estiver ativo, então retorna 1
		(case	when(	ie_evento = 'IMP'
			and (ie_validar_cbo_invalido_pc = 'S')
			and	(a.nr_seq_cbo_saude_imp IS NOT NULL AND a.nr_seq_cbo_saude_imp::text <> '')
			and (select	CASE WHEN count(1)=0 THEN  'S'  ELSE 'N' END
				from	cbo_saude
				where	nr_sequencia = a.nr_seq_cbo_saude_imp
				and	ie_situacao  = 'A') = 'S') then 1
			else 0
		end) condicao_3,
		--Se não for importação, campo CBO estiver informado, ainda é preciso verificar a situação deste CBO,
		--se não estiver ativo, então retorna 1
		(case	when(	ie_evento <> 'IMP'
			and (ie_validar_cbo_invalido_pc = 'S')
			and	(a.nr_seq_cbo_saude IS NOT NULL AND a.nr_seq_cbo_saude::text <> '')
			and (select	CASE WHEN count(1)=0 THEN  'S'  ELSE 'N' END 
				from	cbo_saude
				where	nr_sequencia = a.nr_seq_cbo_saude
				and	ie_situacao  = 'A') = 'S') then 1
			else 0
		end) condicao_4,
		--Validação solicitante, se for importação, então verifica se um dos campos cbo esta nulo e em caso afirmativo retorna 1 .
		(case
			when ((	ie_evento = 'IMP')
			and (ie_valida_cbo_solic_pc = 'S')
			and (coalesce(a.cd_cbo_saude_solic_imp::text, '') = '' or coalesce(a.nr_seq_cbo_saude_solic_imp::text, '') = '')) then 1
			else	0
		end) condicao_5,

		--Validação solicitante, quando não for importação , médico executor estiver informado porém o CBO não esta, então retorna 1
		(case
			when(	ie_evento <> 'IMP'
			and (ie_valida_cbo_solic_pc = 'S')
			and	(a.cd_medico_solicitante IS NOT NULL AND a.cd_medico_solicitante::text <> '')
			and	coalesce(a.nr_seq_cbo_saude_solic::text, '') = ''
			) then 1
			else  0
		end) condicao_6,
		--Validação solicitante
		--Se for importação, campo CBO estiver informado, ainda é preciso verificar a situação deste CBO,
		--se não estiver ativo, então retorna 1
		(case	when(	ie_evento = 'IMP'
			and (ie_valida_cbo_solic_pc = 'S')
			and	(a.nr_seq_cbo_saude_solic_imp IS NOT NULL AND a.nr_seq_cbo_saude_solic_imp::text <> '')
			and (select	CASE WHEN count(1)=0 THEN  'S'  ELSE 'N' END 
				from	cbo_saude
				where	nr_sequencia = a.nr_seq_cbo_saude_solic_imp
				and	ie_situacao  = 'A') = 'S') then 1
			else 0
		end) condicao_7,
		--Validação solicitante
		--Se não for importação, campo CBO estiver informado, ainda é preciso verificar a situação deste CBO,
		--se não estiver ativo, então retorna 1
		(case	when(	ie_evento <> 'IMP'
			and (ie_valida_cbo_solic_pc = 'S')
			and	(a.nr_seq_cbo_saude_solic IS NOT NULL AND a.nr_seq_cbo_saude_solic::text <> '')
			and (select	CASE WHEN count(1)=0 THEN  'S'  ELSE 'N' END 
				from	cbo_saude
				where	nr_sequencia = a.nr_seq_cbo_saude_solic
				and	ie_situacao  = 'A') = 'S') then 1
			else 0
		end) condicao_8,
		----------validar se o cbo da conta esta em uma versão diferente da do protocolo
		(case	when(	ie_evento <> 'IMP'
			and	(	select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END 
					from 	pls_oc_cta_selecao_ocor_v  b,
						pls_conta_ocor_v a
					where 	b.nr_sequencia	   = nr_id_transacao_pc
					and 	a.nr_sequencia	   = b.nr_seq_conta
					and	a.cd_versao_tiss   <> (	select	c.ie_versao
									from	cbo_saude_tiss c
									where	c.nr_sequencia = a.nr_seq_cbo_saude)) = 'S') then 1
			else 0
		end) condicao_9,
		-----valida pelo campo imp
		(case	when( 	ie_evento = 'IMP'
			and	(	select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END 
					from 	pls_oc_cta_selecao_ocor_v  b,
						pls_conta_ocor_v a
					where 	b.nr_sequencia	   = nr_id_transacao_pc
					and 	a.nr_sequencia	   = b.nr_seq_conta
					and	a.cd_versao_tiss   <> (	select	c.ie_versao
									from	cbo_saude_tiss c
									where	c.nr_sequencia = a.nr_seq_cbo_saude_imp)) = 'S') then 1
			else 0
		end) condicao_10,
		-- validação campo desconhecido IMP
		(case	when(	ie_evento = 'IMP'
			and	ie_valida_cbo_desc_pc = 'S'
			and	pls_obter_dados_cbo_saude(a.nr_seq_cbo_saude_imp, 'C') = '999999') then 1
			else 0
		end) condicao_11,
		-- validação campo desconhecido
		(case	when(	ie_evento <> 'IMP'
			and	ie_valida_cbo_desc_pc = 'S'
			and	pls_obter_dados_cbo_saude(a.nr_seq_cbo_saude, 'C') = '999999') then 1
			else 0
		end) condicao_12
	from	pls_oc_cta_selecao_ocor_v	x,
		pls_conta_ocor_v		a
	where	x.ie_valido		= 'S'
	And	x.nr_id_transacao	= nr_id_transacao_pc
	And	a.nr_sequencia		= x.nr_seq_conta) alias65
	where 	condicao_1  > 0
	or	condicao_2  > 0
	or	condicao_3  > 0
	or	condicao_4  > 0
	or	condicao_5  > 0
	or	condicao_6  > 0
	or	condicao_7  > 0
	or	condicao_8  > 0
	or	condicao_9  > 0
	or	condicao_10 > 0
	or	condicao_11 > 0
	or	condicao_12 > 0;

	--Se não for zero, significa que uma das condições para que seja gerada ocorrência foi atendida.
C03 CURSOR(nr_id_transacao_pc		pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
	SELECT	x.nr_sequencia,
		(SELECT nr_cbo_req
		from	ptu_nota_cobranca c
		where 	c.nr_sequencia	= a.nr_seq_nota_cobranca) nr_cbo_req,
		(select	max(cd_especialidade)
		from	ptu_nota_servico
		where	nr_seq_nota_cobr	= a.nr_seq_nota_cobranca) cd_especialidade,
		(select	nr_seq_cbo_saude
		from	pls_prestador_intercambio
		where	nr_sequencia = a.nr_seq_prest_inter) nr_seq_cbo_saude_int,
		a.cd_versao_tiss,
		a.nr_seq_prest_inter,
		a.nr_seq_nota_cobranca,
		a.cd_estabelecimento
	from	pls_oc_cta_selecao_ocor_v	x,
		pls_conta_ocor_v		a
	where	x.ie_valido		= 'S'
	And	x.nr_id_transacao	= nr_id_transacao_pc
	And	a.nr_sequencia		= x.nr_seq_conta;
BEGIN

if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '')  then
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
	pls_tipos_ocor_pck.limpar_nested_tables(dados_tb_selecao_w);
	nr_idx_w:=	0;
	for r_C01_w in C01(dados_regra_p.nr_sequencia) loop

		ie_registro_valido_w := 'S';

		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		if (r_C01_w.ie_validar_cbo_invalido = 'S' or r_C01_w.ie_valida_cbo_solic = 'S' or r_C01_w.ie_valida_cbo_desc = 'S')	then
			begin
				open C02(nr_id_transacao_p, dados_regra_p.ie_evento, ie_registro_valido_w,
					r_C01_w.ie_validar_cbo_invalido, r_C01_w.ie_valida_cbo_solic, r_C01_w.ie_valida_cbo_desc);
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
				close C02;
			end;
		elsif (r_c01_w.ie_valida_cbo_interc	= 'S') then
			begin

			for r_c03_w in C03(nr_id_transacao_p) loop
				begin
				if (coalesce(nr_versao_ptu_w::text, '') = '') then
					nr_versao_ptu_w := ptu_obter_versao_dominio('A500', pls_obter_interf_ptu(r_c03_w.cd_estabelecimento, null, clock_timestamp(), 'A500'));
				end if;
				if (r_c03_w.nr_cbo_req IS NOT NULL AND r_c03_w.nr_cbo_req::text <> '') then
					if (nr_versao_ptu_w IS NOT NULL AND nr_versao_ptu_w::text <> '') then
						select	max(b.cd_cbo)
						into STRICT	cd_cbo_executante_w
						from	cbo_saude_ptu	a,
							cbo_saude	b
						where	a.nr_seq_cbo_saude	= b.nr_sequencia
						and	a.cd_cbo_ptu		= to_char(r_c03_w.nr_cbo_req)
						and	a.nr_versao_ptu		= nr_versao_ptu_w;
					end if;

					if (coalesce(cd_cbo_executante_w::text, '') = '') then
						select	max(cd_cbo)
						into STRICT	cd_cbo_executante_w
						from	cbo_saude
						where	cd_cbo_ptu	= to_char(r_c03_w.nr_cbo_req);
					end if;
				end if;

				if (coalesce(cd_cbo_executante_w::text, '') = '') and (r_c03_w.cd_especialidade IS NOT NULL AND r_c03_w.cd_especialidade::text <> '')then

					select	max(cd_especialidade)
					into STRICT	nr_seq_especialidade_w
					from	especialidade_medica
					where	cd_ptu	= r_c03_w.cd_especialidade;

					if (nr_seq_especialidade_w IS NOT NULL AND nr_seq_especialidade_w::text <> '') then
						select 	max(nr_seq_cbo_saude)
						into STRICT	nr_seq_cbo_saude_w
						from	tiss_cbo_saude
						where	cd_especialidade	= nr_seq_especialidade_w
						and	ie_versao		= r_c03_w.cd_versao_tiss;

						if (nr_seq_cbo_saude_w IS NOT NULL AND nr_seq_cbo_saude_w::text <> '') then
							select	max(cd_cbo)
							into STRICT	cd_cbo_executante_w
							from	cbo_saude
							where	nr_sequencia	= nr_seq_cbo_saude_w;
						end if;
					end if;
				end if;

				if (coalesce(nr_seq_cbo_saude_w::text, '') = '') or (cd_cbo_executante_w = '999999') then
					select	max(nr_seq_cbo_saude)
					into STRICT	nr_seq_cbo_saude_w
					from	pls_prestador_intercambio
					where	nr_sequencia = r_c03_w.nr_seq_prest_inter;

					if (nr_seq_cbo_saude_w IS NOT NULL AND nr_seq_cbo_saude_w::text <> '') then
						select	max(a.cd_cbo)
						into STRICT	cd_cbo_executante_w
						from	cbo_saude a,
							cbo_saude_tiss b
						where	a.nr_sequencia = b.nr_seq_cbo_saude
						and	a.nr_sequencia = nr_seq_cbo_saude_w
						and	b.ie_versao = r_c03_w.cd_versao_tiss;

						if (coalesce(cd_cbo_executante_w::text, '') = '') then
							select	max(a.cd_cbo)
							into STRICT	cd_cbo_executante_w
							from	cbo_saude a
							where	a.nr_sequencia = nr_seq_cbo_saude_w;
						end if;
					end if;
				end if;

				if (coalesce(nr_seq_cbo_saude_w::text, '') = '') or (cd_cbo_executante_w = '999999') then
					--Passa nr_seq_conta ao invéz do nr_seq_selecao, pois será feito validação a nível de conta
					dados_tb_selecao_w.nr_seq_selecao(nr_idx_w) := r_C03_w.nr_sequencia;
					dados_tb_selecao_w.ds_observacao(nr_idx_w) := 'CBO enviado no intercâmbio inválido ou igual a 999999. ';
					dados_tb_selecao_w.ie_valido(nr_idx_w) := 'S';

					if (nr_idx_w >= pls_util_cta_pck.qt_registro_transacao_w) then
						CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao, pls_util_cta_pck.clob_table_vazia_w,
												'SEQ', dados_tb_selecao_w.ds_observacao, dados_tb_selecao_w.ie_valido,
												nm_usuario_p, nr_id_transacao_p);

						pls_tipos_ocor_pck.limpar_nested_tables(dados_tb_selecao_w);
						nr_idx_w := 0;
					else
						nr_idx_w := nr_idx_w + 1;
					end if;
				end if;
				end;
			end loop;

			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao, pls_util_cta_pck.clob_table_vazia_w,
									'SEQ', dados_tb_selecao_w.ds_observacao, dados_tb_selecao_w.ie_valido,
									nm_usuario_p, nr_id_transacao_p);
			end;
		end if;

		-- seta os registros que serão válidos ou inválidos após o processamento
	end loop;
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_20 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

