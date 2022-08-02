-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_consistir_conta ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_w		pls_conta_mat.nr_sequencia%type;
nr_seq_protocolo_w		bigint;
qt_registros_w			integer;
nr_seq_analise_w		bigint;
qt_analises_realizadas_w	bigint;
nr_seq_regra_via_acesso_w	bigint;
ie_status_prov_pagto_w		pls_parametro_contabil.ie_status_prov_pagto%type;
nr_lote_contabilizado_w		lote_contabil.nr_lote_contabil%type;
ie_situacao_prot_w		pls_protocolo_conta.ie_situacao%type;
ie_origem_conta_w		pls_conta.ie_origem_conta%type;
tx_item_w			pls_conta_proc.tx_item%type;
ie_tx_item_w			varchar(1);
ie_via_acesso_regra_w		pls_parametros.ie_via_acesso_regra%type;
ie_novo_pos_w			pls_visible_false.ie_novo_pos_estab%type;
ie_concil_contab_w		pls_visible_false.ie_concil_contab%type;
ie_status_origem_lote_w		lote_contabil.ie_status_origem%type;
ie_atual_vl_apres_e_mantem_w	pls_parametros.ie_atualiza_vl_apres_e_mantem%type;
dt_fim_consistencia_w		pls_conta.dt_fim_consistencia%type;
ie_manter_vl_apres_w		varchar(1) := 'N';

C01 CURSOR FOR
	SELECT	nr_sequencia,
		coalesce(nr_seq_regra_via_acesso, 0),
		tx_item,
		coalesce(ie_tx_manual,'N')
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_status <> 'D';

/* ADICIONADO A RESTRICAO PARA NAO  EXCLUIR AS GLOSAS E ALTERAR OS ITENS CANCELADOS, ESTE STATUS SO ACONTECE NO COMPLEMENTO DE CONTAS MEDICAS PELO PORTAL */

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_conta_mat
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_status <> 'D';


BEGIN
select	coalesce(ie_status_prov_pagto,'NC')
into STRICT	ie_status_prov_pagto_w
from	pls_parametro_contabil
where	cd_estabelecimento	= cd_estabelecimento_p;

select 	coalesce(max(ie_novo_pos_estab), 'N')
into STRICT	ie_novo_pos_w
from	pls_visible_false;

if (ie_status_prov_pagto_w = 'F') then	
	select	max(coalesce(nr_lote_contabil_prov,0)) nr_lote_contabil
	into STRICT	nr_lote_contabilizado_w
	from	pls_conta_medica_resumo
	where	nr_seq_conta = nr_seq_conta_p
	and	coalesce(nr_lote_contabil_prov,0) <> 0;
	
	if ( coalesce( nr_lote_contabilizado_w, 0 ) = 0 ) then	
		select	max( coalesce( nr_lote_contabil_prov,0 ) ) nr_lote_contabil
		into STRICT	nr_lote_contabilizado_w
		from	pls_conta_coparticipacao
		where	nr_seq_conta = nr_seq_conta_p
		and	coalesce( nr_lote_contabil_prov,0 ) <> 0;		
	end if;
	
	if (coalesce(nr_lote_contabilizado_w, 0) > 0) then
		select 	coalesce(max(ie_status_origem), 'M')
		into STRICT	ie_status_origem_lote_w
		from	lote_contabil
		where	nr_lote_contabil = nr_lote_contabilizado_w;

		if (ie_status_origem_lote_w <> 'SO') then
			/* A conta ja foi contabilizada no lote #@NR_LOTE_CONTABILIZADO#@. */

			CALL wheb_mensagem_pck.exibir_mensagem_abort(324839, 'NR_LOTE_CONTABILIZADO=' || nr_lote_contabilizado_w);	
		end if;
	end if;
end if;

select	max(nr_seq_analise),
	max(nr_seq_protocolo),
	max(ie_origem_conta),
	max(dt_fim_consistencia)
into STRICT	nr_seq_analise_w,
	nr_seq_protocolo_w,
	ie_origem_conta_w,
	dt_fim_consistencia_w
from	pls_conta
where	nr_sequencia 		= nr_seq_conta_p   
and	cd_estabelecimento	= cd_estabelecimento_p;

select 	max(ie_situacao)
into STRICT	ie_situacao_prot_w
from	pls_protocolo_conta
where	nr_sequencia = nr_seq_protocolo_w;

select	count(nr_sequencia)
into STRICT	qt_analises_realizadas_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p
and	ie_status	= 'A'
and	ie_tipo_conta	<> 'I';

/*No caso de haver alguma liberacao o processo e cancelado.*/

if (qt_analises_realizadas_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(175535);
	/*Esta conta esta em processo de auditoria. Processo abortado*/

end if;	

select	count(1)
into STRICT	qt_registros_w
from	pls_conta_proc
where	nr_seq_conta	= nr_seq_conta_p
and	ie_status	= 'L';

if (qt_registros_w > 0) and
	not(ie_origem_conta_w = 'C' AND ie_situacao_prot_w = 'I')   then
	/*Existem itens liberados pelo usuario na conta nr. ' || to_char(nr_seq_conta_p) || '. A consistencia nao pode ser desfeita!'*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(175544,'NR_SEQ_CONTA=' ||nr_seq_conta_p);
end if;

select	count(1)
into STRICT	qt_registros_w
from	pls_conta_mat
where	nr_seq_conta	= nr_seq_conta_p
and	ie_status	= 'L';

if (qt_registros_w > 0) and
	not(ie_origem_conta_w = 'C' AND ie_situacao_prot_w = 'I')   then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(175546,'NR_SEQ_CONTA=' ||nr_seq_conta_p);
	/*Existem itens liberados pelo usuario na conta nr. ' || to_char(nr_seq_conta_p) || '. A consistencia n?o pode ser desfeita!*/

end if;

-- Limpar os vinculos dos itens desta conta com as regras de liberacao por Caracteristicas da conta X Caracteristicas do item.
CALL pls_cta_consist_carac_item_pck.limpar_itens_liberados(nr_seq_conta_p);

CALL pls_delete_conta_medica_resumo(nr_seq_conta_p,null,null,nm_usuario_P);

if (coalesce(nr_seq_analise_w,0) <> 0) then
	delete	FROM pls_analise_conta_item
	where	nr_seq_conta	= nr_seq_conta_p;
end if;

CALL pls_desfazer_ocorrencia(null,null,nr_seq_conta_p);

delete	from pls_analise_glo_ocor_grupo	a
where	a.nr_seq_conta_glosa in (SELECT	x.nr_sequencia
				from	pls_conta_glosa	x
				where	1 = 1
				and	x.nr_seq_conta	= nr_seq_conta_p);
delete  FROM pls_analise_glo_ocor_grupo	a
where	a.nr_seq_conta_glosa in (SELECT	x.nr_sequencia
				from	pls_conta_glosa	x
				where	1 = 1
				and	exists (select 1
						from	pls_conta_proc proc
						where	proc.nr_seq_conta	= nr_seq_conta_p
						and	x.nr_seq_conta_proc	= proc.nr_sequencia));

delete  FROM pls_analise_glo_ocor_grupo	a
where	a.nr_seq_conta_glosa in (SELECT	x.nr_sequencia
				from	pls_conta_glosa	x
				where	1 = 1
				and	exists (select 1
						from	pls_conta_mat mat
						where	mat.nr_seq_conta	= nr_seq_conta_p
						and	x.nr_seq_conta_mat	= mat.nr_sequencia));
delete	FROM PLS_ANALISE_FLUXO_OCOR a
where	a.nr_seq_conta_glosa in (SELECT	x.nr_sequencia
				from	pls_conta_glosa	x
				where	1 = 1
				and	x.nr_seq_conta	= nr_seq_conta_p);

delete	FROM PLS_ANALISE_FLUXO_OCOR a
where	a.nr_seq_conta_glosa in (SELECT	x.nr_sequencia
				from	pls_conta_glosa	x
				where	1 = 1
				and	exists (select 1
						from	pls_conta_proc proc
						where	proc.nr_seq_conta	= nr_seq_conta_p
						and	x.nr_seq_conta_proc	= proc.nr_sequencia));
						
delete	FROM PLS_ANALISE_FLUXO_OCOR a
where	a.nr_seq_conta_glosa in (SELECT	x.nr_sequencia
				from	pls_conta_glosa	x
				where	1 = 1
				and	exists (select 1
						from	pls_conta_mat mat
						where	mat.nr_seq_conta	= nr_seq_conta_p
						and	x.nr_seq_conta_mat	= mat.nr_sequencia));

-- Se parametro da gestao de operadoras "Utilizar somente a via de acesso informada na regra" for nao, entao mantem a taxa do item ao

--desfazer a consistencia OS1341510
select	ie_via_acesso_regra,
	ie_atualiza_vl_apres_e_mantem
into STRICT	ie_via_acesso_regra_w,
	ie_atual_vl_apres_e_mantem_w
from	table(pls_parametros_pck.f_retorna_param(cd_estabelecimento_p));
	
if ( ie_atual_vl_apres_e_mantem_w = 'S' and (dt_fim_consistencia_w IS NOT NULL AND dt_fim_consistencia_w::text <> '')) then

	ie_manter_vl_apres_w := 'S';

end if;
	
select	coalesce(max(ie_concil_contab), 'N')
into STRICT	ie_concil_contab_w
from 	pls_visible_false;

if (ie_concil_contab_w = 'S') then
	CALL pls_ctb_onl_gravar_movto_pck.gravar_movto_desf_consis_conta(nr_seq_conta_p, cd_estabelecimento_p, nm_usuario_p);
end if;
open C01;
loop
fetch C01 into	
	nr_seq_conta_proc_w,
	nr_seq_regra_via_acesso_w,
	tx_item_w,
	ie_tx_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	delete	from pls_conta_glosa
	where	nr_seq_conta_proc	= nr_seq_conta_proc_w;
	
	delete	FROM pls_conta_proc_aprop
	where	nr_seq_conta_proc	= nr_seq_conta_proc_w;
	
	if 	((ie_origem_conta_w = 'C') and (ie_situacao_prot_w = 'I') and (coalesce(tx_item_w,100) <> 100)) then
		ie_tx_item_w := 'S';
	elsif (ie_origem_conta_w != 'C') then
		ie_tx_item_w := 'N';
	end if;
	
	/*
		tx_item = Se parametro da gestao de operadoras estiver como 'N' entao nao limpa a taxa ao desfazer a consist?ncia. 
		Se estiver como sim, entao 
	*/
	if (coalesce(nr_seq_regra_via_acesso_w,0) > 0) then
		update	pls_conta_proc
		set	vl_procedimento			= 0,
			vl_saldo			= 0,
			vl_glosa			= 0,
			vl_liberado			= 0,
			vl_unitario			= 0,
			vl_liberado_regra		= 0,
			vl_exame_coleta			= 0,
			vl_total_procedimento		= 0,
			qt_procedimento			= 0,
			vl_medico			= 0,
			vl_anestesista			= 0,
			vl_auxiliares			= 0,
			tx_medico			 = NULL,
			tx_custo_operacional		 = NULL,
			tx_material			 = NULL,
			vl_custo_operacional		= 0,
			ie_via_acesso			 = NULL,
			tx_item				= 100,
			vl_materiais			= 0,
			vl_beneficiario			= 0,
			vl_pag_medico_conta		= 0,
			vl_medico_original = 0,
			nr_seq_honorario_crit		 = NULL,
			vl_unitario_imp			= CASE WHEN ie_vl_apresentado_sistema='S' THEN   CASE WHEN  ie_manter_vl_apres_w='S' THEN vl_unitario_imp   ELSE 0 END   ELSE vl_unitario_imp END ,
			vl_procedimento_imp		= CASE WHEN ie_vl_apresentado_sistema='S' THEN  CASE WHEN ie_manter_vl_apres_w='S' THEN  vl_procedimento_imp   ELSE 0 END   ELSE vl_procedimento_imp END ,
			nr_seq_regra			 = NULL,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao			= clock_timestamp(),
			ie_status			= 'U',
			ds_log				= 'pls_desfazer_consistir_conta',
			ie_sca				 = NULL,
			nr_seq_tabela_sca		 = NULL,
			nr_seq_regra_valor		 = NULL,
			ie_valor_base			 = NULL,
			nr_seq_exame_coleta		 = NULL,
			nr_seq_regra_via_acesso		 = NULL,
			nr_seq_prest_pgto_coleta	 = NULL,
			nr_seq_regra_qtde_exec		 = NULL,
			nr_seq_regra_tipo_exec		 = NULL,
			ie_regra_qtde_execucao		 = NULL,
			ie_glosa			= 'N',
			nr_seq_regra_vinculo		 = NULL,
			nr_seq_regra_int		 = NULL,
			ie_via_obrigatoria		= 'N',
			ie_autogerado			= 'N',
			nr_seq_regra_tx_proc		 = NULL,
			ie_vl_apresentado_sistema	= 'N',
			nr_seq_regra_horario		 = NULL,
			tx_intercambio			= 0,
			nr_seq_regra_lib		 = NULL,
			nr_seq_grupo_ans		 = NULL,
			nr_seq_rp_combinada		 = NULL,
			vl_provisao			= 0,
			nr_seq_regra_copartic		 = NULL,
			dt_liberacao		 = NULL
		where	nr_sequencia			= nr_seq_conta_proc_w;
	else
		update	pls_conta_proc
		set	vl_procedimento			= 0,
			vl_saldo			= 0,
			vl_glosa			= 0,
			vl_liberado			= 0,
			vl_unitario			= 0,
			vl_liberado_regra		= 0,
			vl_exame_coleta			= 0,
			vl_total_procedimento		= 0,
			qt_procedimento			= 0,
			vl_medico			= 0,
			vl_anestesista			= 0,
			vl_auxiliares			= 0,
			tx_medico			 = NULL,
			tx_custo_operacional		 = NULL,
			tx_material			 = NULL,
			vl_custo_operacional		= 0,
			ie_via_acesso			= ie_via_acesso,
			tx_item				= CASE WHEN ie_via_acesso_regra_w='N' THEN  tx_item  ELSE CASE WHEN coalesce(ie_tx_item_w,'N')='S' THEN  tx_item  ELSE CASE WHEN coalesce(ie_via_acesso,'X')='X' THEN 100  ELSE CASE WHEN coalesce(nr_seq_regra_qtde_exec,0)=0 THEN tx_item  ELSE 100 END  END  END  END ,
			vl_materiais			= 0,
			vl_beneficiario			= 0,
			vl_pag_medico_conta		= 0,
			vl_medico_original = 0,
			nr_seq_honorario_crit		 = NULL,
			vl_unitario_imp			= CASE WHEN ie_vl_apresentado_sistema='S' THEN  CASE WHEN  ie_manter_vl_apres_w='S' THEN vl_unitario_imp   ELSE 0 END   ELSE vl_unitario_imp END ,
			vl_procedimento_imp		= CASE WHEN ie_vl_apresentado_sistema='S' THEN  CASE WHEN  ie_manter_vl_apres_w='S' THEN  vl_procedimento_imp   ELSE 0 END   ELSE vl_procedimento_imp END ,
			nr_seq_regra			 = NULL,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao			= clock_timestamp(),
			ie_status			= 'U',
			ds_log				= 'pls_desfazer_consistir_conta',
			ie_sca				 = NULL,
			nr_seq_tabela_sca		 = NULL,
			nr_seq_regra_valor		 = NULL,
			ie_valor_base			 = NULL,
			nr_seq_exame_coleta		 = NULL,
			nr_seq_prest_pgto_coleta	 = NULL,
			nr_seq_regra_qtde_exec		 = NULL,
			nr_seq_regra_tipo_exec		 = NULL,
			ie_regra_qtde_execucao		 = NULL,
			ie_glosa			= 'N',
			ie_via_obrigatoria		= 'N',
			nr_seq_regra_vinculo		 = NULL,
			nr_seq_regra_int		 = NULL,
			ie_autogerado			= 'N',
			nr_seq_regra_tx_proc		 = NULL,
			ie_vl_apresentado_sistema	= 'N',
			nr_seq_regra_horario		 = NULL,
			tx_intercambio			= 0,
			vl_glosa_taxa_co 		= 0,       
			vl_glosa_taxa_material		= 0,
			vl_glosa_taxa_servico   	= 0,
			nr_seq_regra_lib		 = NULL,
			nr_seq_grupo_ans		 = NULL,
			nr_seq_rp_combinada		 = NULL,
			ie_tx_manual			= ie_tx_item_w,
			vl_provisao			= 0,
			nr_seq_regra_copartic		 = NULL,
			dt_liberacao		 = NULL
		where	nr_sequencia			= nr_seq_conta_proc_w;
	end if;
	
	update 	pls_proc_participante
	set	vl_calculado = 0,
		vl_participante = 0,
		vl_glosa = 0,
		ie_status = 'U'
	where	nr_seq_conta_proc	= nr_seq_conta_proc_w
	and 	ie_status <> 'C';

	delete	FROM ptu_intercambio_consist
	where	nr_seq_procedimento	= nr_seq_conta_proc_w;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into	
	nr_seq_conta_mat_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	delete	from pls_conta_glosa
	where	nr_seq_conta_mat	= nr_seq_conta_mat_w;
	
	delete	FROM pls_conta_mat_aprop
	where	nr_seq_conta_mat	= nr_seq_conta_mat_w;

	update	pls_conta_mat
	set	vl_material		= 0,
		vl_saldo		= 0,
		vl_glosa		= 0,
		vl_liberado		= 0,
		vl_unitario		= 0,
		qt_material		= 0,
		nr_seq_regra		 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		ie_status		= 'U',
		nr_seq_regra_valor	 = NULL,
		ie_valor_base		 = NULL,
		nr_seq_regra_qtde_exec	 = NULL,
		ie_glosa		= 'N',
		ie_autorizado		= 'N',
		nr_seq_regra_int	 = NULL,
		vl_unitario_imp		= CASE WHEN ie_vl_apresentado_sistema='S' THEN  CASE WHEN  ie_manter_vl_apres_w='S' THEN  vl_unitario_imp  ELSE 0 END   ELSE vl_unitario_imp END ,
		vl_material_imp		= CASE WHEN ie_vl_apresentado_sistema='S' THEN  CASE WHEN  ie_manter_vl_apres_w='S' THEN  vl_material_imp  ELSE 0 END   ELSE vl_material_imp END ,
		nr_seq_regra_lib	 = NULL,
		vl_provisao		= 0
	where	nr_sequencia		= nr_seq_conta_mat_w;

	delete	FROM ptu_intercambio_consist
	where	nr_seq_material		= nr_seq_conta_mat_w;
	end;
end loop;
close C02;

delete	FROM pls_ocorrencia_benef	a
where	nr_seq_glosa	in (	SELECT	c.nr_sequencia
				from	pls_conta_glosa c
				where	c.nr_seq_conta	= nr_seq_conta_p);
				
delete	FROM pls_ocorrencia_benef	e
where	nr_seq_glosa	in (	SELECT	a.nr_sequencia
				from	pls_conta_glosa	a
				where	nr_seq_glosa_conta in (	select	c.nr_sequencia
								from	pls_conta_glosa c
								where	c.nr_seq_conta	= nr_seq_conta_p));
delete	FROM pls_conta_glosa	a
where	nr_seq_glosa_conta in (	SELECT	c.nr_sequencia
				from	pls_conta_glosa c
				where	c.nr_seq_conta	= nr_seq_conta_p);

delete	FROM pls_conta_glosa
where	nr_seq_conta	= nr_seq_conta_p;

update	pls_conta
set	ie_status		= 'U',
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	nr_seq_honorario_crit	 = NULL,
	ie_tipo_partic_prof	 = NULL,
	vl_pagamento_medico	= 0,
	vl_coparticipacao	= 0,
	ie_glosa		= 'N',
	ie_exige_autorizacao	= 'N'
where	nr_sequencia		= nr_seq_conta_p
and	ie_status 	!= 'C';

select	count(1)
into STRICT	qt_registros_w
from	pls_conta
where	nr_seq_protocolo	= nr_seq_protocolo_w
and	ie_status		not in ('U','C');

if (qt_registros_w = 0) then
	update	pls_protocolo_conta
	set	dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		ie_status	= '1'
	where	nr_sequencia	= nr_seq_protocolo_w;
end if;

delete	FROM pls_resumo_conta
where	nr_seq_conta	= nr_seq_conta_p;

delete	FROM pls_conta_copartic_aprop
where	NR_SEQ_CONTA_COPARTICIPACAO in (SELECT	nr_sequencia
					from	pls_conta_coparticipacao
					where	nr_seq_conta	= nr_seq_conta_p);

CALL pls_deletar_coparticipacao(nr_seq_conta_p,null,'S', 'N', null, null, nm_usuario_p,cd_estabelecimento_p);

if (ie_novo_pos_w = 'S') then
	CALL pls_pos_estabelecido_pck.deletar_pos_estabelecido(nr_seq_conta_p, null, null);
else
	CALL pls_delete_pls_conta_pos_estab(	null, null, nr_seq_conta_p,
					null);
end if;
				
				
--Deleta os registros de regra de lancamento de pos-estabelecido
delete	FROM pls_conta_proc	a
where	a.nr_seq_conta	= nr_seq_conta_p
and	(a.nr_seq_regra_conv IS NOT NULL AND a.nr_seq_regra_conv::text <> '')
and	(a.nr_seq_proc_princ IS NOT NULL AND a.nr_seq_proc_princ::text <> '')
and	a.ie_status	= 'M'
and	not exists (	SELECT	1
			from	pls_conta_pos_estabelecido	x
			where	x.nr_seq_conta_proc		= a.nr_sequencia
			and	x.ie_status_faturamento		= 'A')
and not exists ( select 1
				from	pls_conta_pos_estab_prev x
				where	x.nr_seq_conta_proc		= a.nr_sequencia
				and 	(nr_lote_contabil_prov IS NOT NULL AND nr_lote_contabil_prov::text <> ''));

update	pls_conta_mat
set	nr_seq_regra_conv	 = NULL
where	nr_seq_conta = nr_seq_conta_p;

update	pls_conta_proc	a
set	a.nr_seq_regra_conv	 = NULL
where	a.nr_seq_conta 		= nr_seq_conta_p
and	not exists (	SELECT	1
			from	pls_conta_pos_estabelecido	x
			where	x.nr_seq_conta_proc		= a.nr_sequencia
			and	x.ie_status_faturamento		= 'A');


if (ie_novo_pos_w = 'N') then
	delete 	FROM pls_diagnostico_conta_pos
	where	nr_seq_conta	= nr_seq_conta_p;
	
	delete 	FROM pls_diag_conta_obito_pos
	where	nr_seq_conta	= nr_seq_conta_p;
	
	delete 	FROM pls_diagnos_nasc_viv_pos
	where	nr_seq_conta	= nr_seq_conta_p;
	
	delete 	FROM pls_conta_pos_cabecalho
	where	nr_seq_conta	= nr_seq_conta_p;
end if;

/*Apagar as inconsistencias no caso de ser um intercambio*/

delete	FROM ptu_intercambio_consist
where	nr_seq_conta	= nr_seq_conta_p;

CALL pls_fechar_conta(nr_seq_conta_p, 'N', 'N', 'S', cd_estabelecimento_p, nm_usuario_p, null, null);
CALL pls_gerar_valores_protocolo(nr_seq_protocolo_w, nm_usuario_p);
CALL pls_atualizar_utilizacao_guia(nr_seq_conta_p, cd_estabelecimento_p, nm_usuario_p);

update	pls_conta
set	ie_status_fat	 = NULL
where	nr_sequencia	= nr_seq_conta_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_consistir_conta ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

