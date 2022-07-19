-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_19 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Validar as caracterisiticas do profissinal executor, a primeira validacao criada dentro 
desta rotina tem como objetivo validar se o medico executor informado na conta esta nulo ou nao.

Validacao realizada em base na glosa 9916
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
------------------------------------------------------------------------------------------------------------------

dlehmkuhl OS 688483 - 14/04/2014 -

Alteracao:	Modificada a forma de trabalho em relacao a atualizacao dos campos de controle
	que basicamente decidem se a ocorrencia sera ou nao gerada. Foi feita tambem a 
	substituio da rotina obterX_seX_geraX.

Motivo:	Necessario realizar essas alteracoes para corrigir bugs principalmente no que se
	refere a questao de aplicacao de filtros (passo anterior ao da validacao). Tambem
	tivemos um foco especial em performance, visto que a mesma precisou ser melhorada
	para nao inviabilizar a nova solicitacao que diz que a excecao deve verificar todo
	o atendimento.
------------------------------------------------------------------------------------------------------------------

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_filtro_w		pls_tipos_ocor_pck.dados_filtro;

nr_seq_selecao_w	dbms_sql.number_table;
ds_observacao_w		dbms_sql.varchar2_table;
ie_valido_w		dbms_sql.varchar2_table;
ie_registro_valido_w	varchar(1);

C01 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.ie_val_profs_exec_comp,
			coalesce(a.ie_tipo_profissional, 'PE' ) ie_tipo_profissional,
			coalesce(a.ie_valida_cpf, 'N') ie_valida_cpf,
			coalesce(a.ie_profissional_inativo, 'N') ie_profissional_inativo
	from	pls_oc_cta_val_profis a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

	
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
		ie_evento		pls_oc_cta_combinada.ie_evento%type,
		ie_registro_valido_pc	pls_oc_cta_selecao_ocor_v.ie_valido%type) FOR
	SELECT	
		x.nr_sequencia	nr_seq_selecao,
		ie_registro_valido_pc ie_valido,
		null ds_observacao
	from	pls_oc_cta_selecao_ocor_v	x,
		pls_conta_ocor_v		a
	where	x.ie_valido		= 'S'
	and	x.nr_id_transacao	= nr_id_transacao_pc
	and	a.nr_sequencia 		= x.nr_seq_conta
	and	coalesce(a.cd_medico_executor_imp::text, '') = ''
	and	ie_evento = 'IMP'
	
union all

	SELECT	
		x.nr_sequencia	nr_seq_selecao,
		ie_registro_valido_pc ie_valido,
		null ds_observacao
	from	pls_oc_cta_selecao_ocor_v	x,
		pls_conta_ocor_v		a
	where	x.ie_valido		= 'S'
	and	x.nr_id_transacao	= nr_id_transacao_pc
	and	a.nr_sequencia 		= x.nr_seq_conta
	and	coalesce(a.cd_medico_executor::text, '') = ''
	and	ie_evento <> 'IMP';
	
C03 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
			ie_evento				pls_oc_cta_combinada.ie_evento%type,
			ie_registro_valido_pc	pls_oc_cta_selecao_ocor_v.ie_valido%type,
			ie_tipo_profissional_pc	pls_oc_cta_val_profis.ie_tipo_profissional%type
			) FOR

	SELECT	nr_seq_selecao,
			ie_valido,
			ds_observacao
	from (
		SELECT	
			x.nr_sequencia	nr_seq_selecao,
			ie_registro_valido_pc ie_valido,
			null ds_observacao,
			CASE WHEN ie_tipo_profissional_pc ='PE' THEN  pls_obter_dados_medico(cd_medico_executor_imp, 'CPF')   ELSE pls_obter_dados_medico(cd_medico_solicitante_imp, 'CPF') END  nr_cpf,
			CASE WHEN  ie_tipo_profissional_pc ='PE' THEN  cd_medico_executor_imp  ELSE cd_medico_solicitante_imp END  cd_medico
		from	pls_oc_cta_selecao_ocor_v	x,
			pls_conta_ocor_v		a
		where	x.ie_valido		= 'S'
		and	x.nr_id_transacao	= nr_id_transacao_pc
		and	a.nr_sequencia 		= x.nr_seq_conta
		and	ie_evento = 'IMP'
		
union all

		select	
			x.nr_sequencia	nr_seq_selecao,
			ie_registro_valido_pc ie_valido,
			null ds_observacao,
			CASE WHEN ie_tipo_profissional_pc ='PE' THEN  pls_obter_dados_medico(cd_medico_executor, 'CPF')   ELSE pls_obter_dados_medico(cd_medico_solicitante,'CPF') END  nr_cpf,
			CASE WHEN  ie_tipo_profissional_pc ='PE' THEN  cd_medico_executor  ELSE cd_medico_solicitante END  cd_medico
		from	pls_oc_cta_selecao_ocor_v	x,
			pls_conta_ocor_v		a
		where	x.ie_valido		= 'S'
		and	x.nr_id_transacao	= nr_id_transacao_pc
		and	a.nr_sequencia 		= x.nr_seq_conta
		and	ie_evento <> 'IMP'	
	) v
	where	coalesce(v.nr_cpf::text, '') = ''
	and 	(v.cd_medico IS NOT NULL AND v.cd_medico::text <> ''); --Apenas aplica validao do CPF, caso o profissional do tipo adequado estiver presente.
	
--Cursor de participantes com CPF nulo no cadastro do medico ou sem a informacao do medico apontada no registro do participante	
C04 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
			ie_evento				pls_oc_cta_combinada.ie_evento%type,
			ie_registro_valido_pc	pls_oc_cta_selecao_ocor_v.ie_valido%type,
			ie_tipo_profissional_pc	pls_oc_cta_val_profis.ie_tipo_profissional%type
			) FOR

	SELECT	
			x.nr_sequencia	nr_seq_selecao,
			ie_registro_valido_pc ie_valido,
			null ds_observacao
	from	pls_oc_cta_selecao_ocor_v	x,
			pls_conta_ocor_v		a
	where	x.ie_valido		= 'S'
	and		x.nr_id_transacao	= nr_id_transacao_pc
	and		a.nr_sequencia 		= x.nr_seq_conta
	and   exists (SELECT   1
				  from  pls_conta_proc p,
						pls_proc_participante x,
						pessoa_fisica y
				  where   p.nr_seq_conta = a.nr_sequencia
				  and   p.nr_sequencia = x.nr_seq_conta_proc 
				  and   x.cd_medico_imp = y.cd_pessoa_fisica    
				  and   coalesce(y.nr_cpf::text, '') = '')
	and	ie_evento = 'IMP'
	
union all

	select	
			x.nr_sequencia	nr_seq_selecao,
			ie_registro_valido_pc ie_valido,
			null ds_observacao
	from	pls_oc_cta_selecao_ocor_v	x,
		pls_conta_ocor_v		a
	where	x.ie_valido		= 'S'
	and	x.nr_id_transacao	= nr_id_transacao_pc
	and   exists (select   1
				  from   pls_conta_proc p,
					  pls_proc_participante x,
					  pessoa_fisica y
				  where   p.nr_seq_conta = a.nr_sequencia
				  and   p.nr_sequencia = x.nr_seq_conta_proc 
				  and   x.cd_medico = y.cd_pessoa_fisica    
				  and   coalesce(y.nr_cpf::text, '') = '')
	and	a.nr_sequencia 		= x.nr_seq_conta
	and	ie_evento <> 'IMP';	

-- Cursor para verificar se ha algum profissional inativo ligado diretamente a conta	
C05 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
			ie_evento				pls_oc_cta_combinada.ie_evento%type,
			ie_registro_valido_pc	pls_oc_cta_selecao_ocor_v.ie_valido%type,
			ie_tipo_profissional_pc	pls_oc_cta_val_profis.ie_tipo_profissional%type
			) FOR

	SELECT	nr_seq_selecao,
			ie_valido,
			ds_observacao
	from (
		SELECT	
			x.nr_sequencia	nr_seq_selecao,
			ie_registro_valido_pc ie_valido,
			null ds_observacao,
			CASE WHEN ie_tipo_profissional_pc ='PE' THEN  pls_obter_dados_medico(cd_medico_executor_imp, 'IN')   ELSE pls_obter_dados_medico(cd_medico_solicitante_imp, 'IN') END  ie_profissional_ativo,
			CASE WHEN  ie_tipo_profissional_pc ='PE' THEN  cd_medico_executor_imp  ELSE cd_medico_solicitante_imp END  cd_medico
		from	pls_oc_cta_selecao_ocor_v	x,
			pls_conta_ocor_v		a
		where	x.ie_valido		= 'S'
		and	x.nr_id_transacao	= nr_id_transacao_pc
		and	a.nr_sequencia 		= x.nr_seq_conta
		and	ie_evento = 'IMP'
		
union all

		select	
			x.nr_sequencia	nr_seq_selecao,
			ie_registro_valido_pc ie_valido,
			null ds_observacao,
			CASE WHEN ie_tipo_profissional_pc ='PE' THEN  pls_obter_dados_medico(cd_medico_executor, 'IN')   ELSE pls_obter_dados_medico(cd_medico_solicitante,'IN') END  ie_profissional_ativo,
			CASE WHEN  ie_tipo_profissional_pc ='PE' THEN  cd_medico_executor  ELSE cd_medico_solicitante END  cd_medico
		from	pls_oc_cta_selecao_ocor_v	x,
			pls_conta_ocor_v		a
		where	x.ie_valido		= 'S'
		and	x.nr_id_transacao	= nr_id_transacao_pc
		and	a.nr_sequencia 		= x.nr_seq_conta
		and	ie_evento <> 'IMP'	
	) v
	where	v.ie_profissional_ativo = 'I'
	and 	(v.cd_medico IS NOT NULL AND v.cd_medico::text <> ''); --Apenas aplica validacao de inatividade, caso o profissional do tipo adequado estiver presente.
	
--Cursor de participantes inativos
C06 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
			ie_evento				pls_oc_cta_combinada.ie_evento%type,
			ie_registro_valido_pc	pls_oc_cta_selecao_ocor_v.ie_valido%type,
			ie_tipo_profissional_pc	pls_oc_cta_val_profis.ie_tipo_profissional%type
			) FOR

	SELECT	
			x.nr_sequencia	nr_seq_selecao,
			ie_registro_valido_pc ie_valido,
			null ds_observacao
	from	pls_oc_cta_selecao_ocor_v	x,
			pls_conta_ocor_v		a
	where	x.ie_valido		= 'S'
	and		x.nr_id_transacao	= nr_id_transacao_pc
	and		a.nr_sequencia 		= x.nr_seq_conta
	and   exists (SELECT   1
				  from  pls_conta_proc p,
						pls_proc_participante x,
						medico y
				  where   p.nr_seq_conta = a.nr_sequencia
				  and   p.nr_sequencia = x.nr_seq_conta_proc 
				  and   x.cd_medico_imp = y.cd_pessoa_fisica    
				  and   y.ie_situacao = 'I')
	and	ie_evento = 'IMP'
	
union all

	select	
			x.nr_sequencia	nr_seq_selecao,
			ie_registro_valido_pc ie_valido,
			null ds_observacao
	from	pls_oc_cta_selecao_ocor_v	x,
		pls_conta_ocor_v		a
	where	x.ie_valido		= 'S'
	and	x.nr_id_transacao	= nr_id_transacao_pc
	and   exists (select   1
				  from   pls_conta_proc p,
					  pls_proc_participante x,
					  medico y
				  where   p.nr_seq_conta = a.nr_sequencia
				  and   p.nr_sequencia = x.nr_seq_conta_proc 
				  and   x.cd_medico = y.cd_pessoa_fisica    
				  and   y.ie_situacao = 'I')
	and	a.nr_sequencia 		= x.nr_seq_conta
	and	ie_evento <> 'IMP';	
	
BEGIN

if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '')  then
	ie_registro_valido_w := 'S';
	
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
	
	for r_C01_w in C01(dados_regra_p.nr_sequencia) loop
		
		if (r_C01_w.ie_val_profs_exec_comp = 'S')	then
			begin			
				open C02(nr_id_transacao_p, dados_regra_p.ie_evento, ie_registro_valido_w);
				nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
				ie_valido_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				loop
				fetch C02 bulk collect into nr_seq_selecao_w, ie_valido_w, ds_observacao_w limit pls_util_cta_pck.qt_registro_transacao_w;
				exit when nr_seq_selecao_w.count = 0;
					begin
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
													'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
					end;
				end loop;
				close C02;
			exception
			when others then
				close C02;	
			end;
		end if;
		
		if (r_C01_w.ie_valida_cpf = 'S' ) then
		
			--Verificacao por tipo de profissional executor ou solicitante.
			if (r_C01_w.ie_tipo_profissional in ('PE', 'PS')) then
			
				open C03(nr_id_transacao_p, dados_regra_p.ie_evento, ie_registro_valido_w, r_C01_w.ie_tipo_profissional);
				nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
				ie_valido_w			:= pls_util_cta_pck.vchr2_table_vazia_w;
				ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				loop
				fetch C03 bulk collect into nr_seq_selecao_w, ie_valido_w, ds_observacao_w limit pls_util_cta_pck.qt_registro_transacao_w;
				exit when nr_seq_selecao_w.count = 0;
					begin
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
													'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
					end;
				end loop;
				close C03;
			
			--Verificacao por tipo de profissional participante(PP). Verifica se algum medico participante nao tem seu CPF informado.
			else
			
				open C04(nr_id_transacao_p, dados_regra_p.ie_evento, ie_registro_valido_w, r_C01_w.ie_tipo_profissional);
				nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
				ie_valido_w			:= pls_util_cta_pck.vchr2_table_vazia_w;
				ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				loop
				fetch C04 bulk collect into nr_seq_selecao_w, ie_valido_w, ds_observacao_w limit pls_util_cta_pck.qt_registro_transacao_w;
				exit when nr_seq_selecao_w.count = 0;
					begin
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
													'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
					end;
				end loop;
				close C04;
			
			end if;
		
		end if;
		
		if (r_C01_w.ie_profissional_inativo = 'S' ) then
		
			--Verificacao por tipo de profissional executor ou solicitante.
			if (r_C01_w.ie_tipo_profissional in ('PE', 'PS')) then
			
				open C05(nr_id_transacao_p, dados_regra_p.ie_evento, ie_registro_valido_w, r_C01_w.ie_tipo_profissional);
				nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
				ie_valido_w			:= pls_util_cta_pck.vchr2_table_vazia_w;
				ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				loop
				fetch C05 bulk collect into nr_seq_selecao_w, ie_valido_w, ds_observacao_w limit pls_util_cta_pck.qt_registro_transacao_w;
				exit when nr_seq_selecao_w.count = 0;
					begin
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
													'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
					end;
				end loop;
				close C05;
			
			--Verificacao por tipo de profissional participante(PP). Verifica se algum medico participante esta inativo.
			else
			
				open C06(nr_id_transacao_p, dados_regra_p.ie_evento, ie_registro_valido_w, r_C01_w.ie_tipo_profissional);
				nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
				ie_valido_w			:= pls_util_cta_pck.vchr2_table_vazia_w;
				ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				loop
				fetch C06 bulk collect into nr_seq_selecao_w, ie_valido_w, ds_observacao_w limit pls_util_cta_pck.qt_registro_transacao_w;
				exit when nr_seq_selecao_w.count = 0;
					begin
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w,
													'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
					end;
				end loop;
				close C06;
			
			end if;
		
		end if;		
			
	end loop;
	-- seta os registros que serao validos ou invalidos apos o processamento 
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_19 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

