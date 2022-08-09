-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_conta_partic ( nr_seq_conta_p bigint, ie_tipo_guia_p text, cd_guia_ text, cd_guia_referencia_p text, cd_guia_conta_w text, nr_seq_tipo_acomodacao_p bigint, nr_seq_protocolo_p bigint, nr_seq_segurado_p bigint, ie_regime_internacao_p text, ie_carater_internacao_p text, nr_seq_tipo_atendimento_p bigint, nr_seq_saida_spsadt_p bigint, ie_tipo_segurado_p text, ie_origem_conta_p text, ie_tipo_conta_p text, nr_seq_fatura_p bigint, nr_seq_analise_p bigint, cd_senha_externa_p text, nm_usuario_p text, cd_estabelecimento_p bigint, dt_emissao_p timestamp, ds_conta_gerada_p INOUT text, ie_commit_p text, nr_seq_conta_proc_p text) AS $body$
DECLARE


/*Procedure responsavel por gerar as novas contas quando da existencia de nr_seq_prestador nos participantes do procedimento chamada no inicio da pls_consistir_conta
para que os valores calculados fiquem corretos*/
ie_cancelamento_w		varchar(255);
cd_guia_w			varchar(20);
cd_guia_proc_w			varchar(20);
nr_protocolo_prestador_w	varchar(20);
ds_retorno_w			varchar(20);
cd_max_guia_w			varchar(20);
ie_conselho_profissional_w	varchar(10);
cd_medico_w			varchar(10);
ie_tipo_guia_w			varchar(5);
ie_atualizado_w			varchar(1);
ie_credenciado_w		varchar(1);
ie_via_acesso_w			varchar(1);
ie_gera_conta_w			varchar(1)	:= 'N';
ie_prestador_partic_w		varchar(1)	:= 'N';
ie_origem_protocolo_w		varchar(1);
ie_cooperado_w			varchar(1);
vl_digitado_complemento_w	double precision;
nr_seq_conta_proc_criada_w	bigint;
nr_seq_conta_w			bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_partic_w		bigint;
nr_seq_prestador_w		bigint;
nr_seq_grau_partic_w		bigint;
nr_seq_protocolo_w		bigint;
nr_seq_protocolo_criado_w	bigint;
nr_seq_cbo_saude_w		bigint;
nr_seq_conselho_w		bigint;
nr_seq_prestador_prot_w		bigint;
nr_seq_lote_conta_w		bigint;
qt_procedimento_ww		bigint;
qt_procedimentos_w		bigint;
nr_seq_participante_w		bigint;
nr_seq_outorgante_w		bigint;
qt_conta_w			bigint;
ie_origem_conta_w		bigint;
nr_seq_protocolo_conta_w	bigint;
ds_retorno_pos_w		bigint;
i				bigint;
nr_seq_regra_conta_auto_w	bigint;
nr_seq_regra_conta_auto_ww	bigint;
nr_seq_prestador_exec_w		bigint;
nr_seq_regra_w			bigint;
nr_seq_conta_proc_ant_w		bigint;
qt_partic_conta_w		bigint;
qt_partic_gerado_w		bigint;
tx_item_w			double precision;
dt_competencia_w		timestamp;
dt_protocolo_w			timestamp;
dt_recebimento_w		timestamp;
dt_procedimento_w		timestamp;
dt_inicio_proc_w		timestamp;
dt_fim_proc_w			timestamp;
ie_exige_guia_w			varchar(1);
ie_exige_guia_aux_w		varchar(1);
ie_guia_fisica_w		varchar(1);
ie_tipo_importacao_w		varchar(2)	:= 'UP';
ie_status_proc_w		varchar(10);
qt_regra_abert_w		bigint;
dt_integracao_w			timestamp;

C01 CURSOR FOR
	SELECT	coalesce(a.cd_guia_referencia, a.cd_guia),
		c.cd_medico,
		c.ie_atualizado,
		c.ie_conselho_profissional,
		c.nr_seq_cbo_saude,
		c.nr_seq_conselho,
		c.nr_seq_conta_proc,
		c.nr_sequencia,
		c.nr_seq_grau_partic,
		c.nr_seq_prestador,
		c.cd_guia,
		--pls_obter_se_credenciado_prest(c.cd_medico, a.nr_seq_prestador_exec),
		b.dt_procedimento,
		b.dt_inicio_proc,
		b.dt_fim_proc,
		b.tx_item,
		b.ie_via_acesso,
		c.vl_digitado_complemento,
		a.nr_seq_prestador_exec
	from	pls_proc_participante	c,
		pls_conta_proc		b,
		pls_conta		a
	where	a.nr_sequencia	= b.nr_seq_conta
	and	b.nr_sequencia	= c.nr_seq_conta_proc
	and	a.nr_sequencia 	= nr_seq_conta_p
	and	((c.nr_seq_prestador IS NOT NULL AND c.nr_seq_prestador::text <> '') or (a.ie_tipo_guia = 5))
	and (c.ie_status <> 'C' or coalesce(c.ie_status::text, '') = '')
	and	((c.ie_gerada_cta_honorario <> 'S' and (c.ie_gerada_cta_honorario IS NOT NULL AND c.ie_gerada_cta_honorario::text <> '')) or (coalesce(c.ie_gerada_cta_honorario::text, '') = ''))
	and	not exists (SELECT	1
				from	pls_conta_proc x
				where	x.nr_seq_participante_hi	= c.nr_sequencia)
	and (b.nr_sequencia = nr_seq_conta_proc_p or coalesce(nr_seq_conta_proc_p::text, '') = '')
	order by
		c.nr_seq_conta_proc;/*Diego OS 473247 - Visto com o Diogo - Para nao criar novamente a conta para o partic.*/

	/*and	c.nr_seq_proc_cta_hon is null;*/

	
C02 CURSOR FOR
	SELECT	a.ie_prestador_partic,
		a.nr_sequencia,
		coalesce(a.ie_guia_informada,'N')
	from	pls_regra_conta_autom	a
	where	a.cd_estabelecimento 	= cd_estabelecimento_p
	and	a.ie_tipo_guia		= ie_tipo_guia_p
	and	coalesce(a.ie_origem_protocolo,coalesce(ie_origem_conta_p,'0'))	= coalesce(ie_origem_conta_p,'0')
	and	a.ie_situacao		= 'A'
	and	a.ie_gerar_conta	= 'S'
	order by
		coalesce(a.ie_tipo_guia,' '),
		coalesce(a.ie_origem_protocolo,' '),
		coalesce(a.ie_prestador_partic,'N');
C03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_conta
	where	nr_seq_conta_referencia = nr_seq_conta_p
	order by 1;
	

BEGIN

select	count(1)
into STRICT	qt_regra_abert_w
from	pls_regra_conta_autom	a
where	a.cd_estabelecimento 	= cd_estabelecimento_p
and	a.ie_tipo_guia 		= ie_tipo_guia_p  LIMIT 1;

if (ie_tipo_guia_p in ('4','5')) and (qt_regra_abert_w > 0) then
	
	if (ie_tipo_guia_p = 5) then
		ie_tipo_guia_w	:= 6;
	else
		ie_tipo_guia_w 	:= ie_tipo_guia_p;
	end if;

	qt_partic_conta_w	:= 0;
	qt_partic_gerado_w	:= 0;

	open C01;
	loop
	fetch C01 into	
		cd_guia_w,
		cd_medico_w,
		ie_atualizado_w,
		ie_conselho_profissional_w,
		nr_seq_cbo_saude_w,
		nr_seq_conselho_w,
		nr_seq_conta_proc_w,
		nr_seq_conta_partic_w,
		nr_seq_grau_partic_w,
		nr_seq_prestador_w,
		cd_guia_proc_w,
		--ie_credenciado_w,
		dt_procedimento_w,
		dt_inicio_proc_w,
		dt_fim_proc_w,
		tx_item_w,
		ie_via_acesso_w,
		vl_digitado_complemento_w,
		nr_seq_prestador_exec_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		qt_partic_conta_w		:= qt_partic_conta_w + 1;
		cd_max_guia_w			:= null;
		ds_retorno_w			:= null;
		nr_seq_regra_conta_auto_w	:= null;
		ie_credenciado_w		:= pls_obter_se_credenciado_prest(cd_medico_w, nr_seq_prestador_exec_w);
		ie_cooperado_w			:= pls_obter_se_cooperado_ativo(cd_medico_w, dt_procedimento_w, null);
		
		open C02;
		loop
		fetch C02 into	
			ie_prestador_partic_w,
			nr_seq_regra_conta_auto_ww,
			ie_exige_guia_aux_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			ie_gera_conta_w	:= 'N';
			
			if (coalesce(nr_seq_prestador_w,0) > 0) then
				if (coalesce(ie_prestador_partic_w,'N') = 'S') then
					ie_gera_conta_w	:= 'S';
				end if;
			else
				ie_gera_conta_w	:= 'S';
			end if;
			
			if (ie_gera_conta_w = 'S') then
				nr_seq_regra_conta_auto_w	:= nr_seq_regra_conta_auto_ww;
				ie_exige_guia_w := ie_exige_guia_aux_w;
			end if;
			end;
		end loop;
		close C02;

		if	(((((coalesce(ie_cooperado_w,'N') = 'S') or (coalesce(ie_credenciado_w,'N') = 'S')) and (ie_tipo_guia_p = 5)) or (coalesce(nr_seq_prestador_w,0) > 0)) and (coalesce(nr_seq_regra_conta_auto_w,0) > 0) and (coalesce(cd_guia_w,'X') <> 'X') and
			((ie_exige_guia_w = 'N') or (cd_guia_proc_w IS NOT NULL AND cd_guia_proc_w::text <> ''))) then
			begin
			/* Verifica se ja existe um protocolo de SP/SADT para os participantes do protocolo principal */
	
			begin
			select	max(nr_sequencia)
			into STRICT	nr_seq_protocolo_w
			from	pls_protocolo_conta
			where	nr_seq_prot_referencia	= nr_seq_protocolo_p
			and	ie_status in (1, 2)
			and	ie_tipo_guia = ie_tipo_guia_w;
			exception
			when others then
				nr_seq_protocolo_w	:= 0;
			end;
			
			if (coalesce(nr_seq_protocolo_w,0) = 0) then /* Se nao existir cria-se um novo protocolo de SP/SADT */
				select	nr_seq_prestador,
					dt_mes_competencia,
					nr_protocolo_prestador,
					dt_protocolo,
					nr_seq_lote_conta,
					dt_recebimento,
					ie_origem_protocolo,
					coalesce(ie_guia_fisica,'N'),
					ie_tipo_importacao,
					dt_integracao
				into STRICT	nr_seq_prestador_prot_w	,
					dt_competencia_w,
					nr_protocolo_prestador_w,
					dt_protocolo_w,
					nr_seq_lote_conta_w,
					dt_recebimento_w,
					ie_origem_protocolo_w,
					ie_guia_fisica_w,
					ie_tipo_importacao_w,
					dt_integracao_w
				from	pls_protocolo_conta
				where	nr_sequencia	= nr_seq_protocolo_p;

				select  nextval('pls_protocolo_conta_seq')
				into STRICT    nr_seq_protocolo_w
				;

				select	max(nr_sequencia)
				into STRICT	nr_seq_outorgante_w
				from    pls_outorgante
				where   cd_estabelecimento = cd_estabelecimento_p;		

				insert into pls_protocolo_conta(nr_sequencia, nm_usuario, dt_atualizacao,
					nm_usuario_nrec, dt_atualizacao_nrec, ie_situacao,
					ie_status, dt_mes_competencia, cd_estabelecimento,
					ie_tipo_guia, ie_apresentacao, dt_protocolo,
					nr_seq_prestador, nr_protocolo_prestador, qt_contas_informadas,
					dt_base_venc, ie_tipo_protocolo, nr_seq_prot_referencia,
					nr_seq_outorgante, ie_guia_fisica, nr_seq_lote_conta,
					dt_recebimento, ie_origem_protocolo, ie_tipo_importacao,
					dt_integracao)
				values (nr_seq_protocolo_w, nm_usuario_p, clock_timestamp(),
					nm_usuario_p, clock_timestamp(), 'D',
					1, dt_competencia_w, cd_estabelecimento_p,
					ie_tipo_guia_w, 'A', dt_protocolo_w,
					nr_seq_prestador_prot_w	, nr_protocolo_prestador_w, null,
					clock_timestamp(), 'C', nr_seq_protocolo_p,
					nr_seq_outorgante_w, ie_guia_fisica_w, nr_seq_lote_conta_w,
					dt_recebimento_w, ie_origem_protocolo_w, ie_tipo_importacao_w,
					dt_integracao_w);
			end if;
			
			qt_procedimento_ww	:= 0;
			
			if (coalesce(nr_seq_prestador_w,0) = 0) then
				nr_seq_prestador_w	:= pls_obter_seq_prestador_partic(cd_medico_w, nr_seq_prestador_exec_w, cd_estabelecimento_p);
			end if;
				
			select	max(coalesce(nr_sequencia,0)) /* Verifica se ja foi gerada uma conta de Hi para este medico, grau de participacao e guia nesta conta */
			into STRICT	nr_seq_conta_w
			from	pls_conta
			where	nr_seq_protocolo 	= nr_seq_protocolo_w
			and	nr_seq_segurado		= nr_seq_segurado_p
			and	cd_guia 		= cd_guia_proc_w
			and	nr_seq_prestador_exec	= nr_seq_prestador_w
			and	nr_seq_grau_partic 	= nr_seq_grau_partic_w
			and	nr_seq_conta_referencia	= nr_seq_conta_p
			and	((coalesce(cd_medico_executor::text, '') = '') or (cd_medico_executor = cd_medico_w))
			and	coalesce(nr_seq_analise::text, '') = '';
			
			if (coalesce(nr_seq_conta_w,0) = 0) then /*Se nao existe cria-se a conta */
				select	nextval('pls_conta_seq')
				into STRICT	nr_seq_conta_w
				;
				
				insert into pls_conta(nr_seq_protocolo, cd_guia, cd_guia_referencia,
					cd_guia_prestador, dt_emissao, dt_atendimento_referencia, cd_senha,                
					ie_tipo_guia, nr_seq_segurado, nr_seq_prestador_exec,   
					cd_cnes, cd_medico_executor, nr_seq_grau_partic,      
					nr_seq_cbo_saude, nr_seq_tipo_acomodacao,  
					ie_status, cd_usuario_plano_imp, dt_atualizacao, 
					nm_usuario, cd_estabelecimento, nr_seq_conta_referencia, 
					nr_sequencia, cd_cooperativa, nr_crm_exec, 
					nr_seq_conselho_exec, uf_crm_exec, ie_carater_internacao,
					nr_seq_tipo_atendimento, nr_seq_saida_spsadt, cd_medico_solicitante,
					nr_seq_prestador,ie_origem_conta, nr_seq_regra_conta_auto,
					dt_atendimento, ie_indicacao_acidente, ie_cobertura_especial,
					ie_regime_atendimento, ie_saude_ocupacional)  
				SELECT	nr_seq_protocolo_w, coalesce(cd_guia_proc_w, cd_guia_w), cd_guia_w,      
					cd_guia_prestador, dt_emissao, dt_atendimento_referencia, cd_senha,                
					ie_tipo_guia_w, nr_seq_segurado, nr_seq_prestador_w,   
					cd_cnes, cd_medico_w, nr_seq_grau_partic_w,      
					nr_seq_cbo_saude_w, nr_seq_tipo_acomodacao,  
					'U', cd_usuario_plano_imp, clock_timestamp(), 
					nm_usuario_p, cd_estabelecimento, nr_seq_conta_p, 
					nr_seq_conta_w, cd_cooperativa, obter_crm_medico(cd_medico_w), 
					pls_obter_seq_conselho_prof(cd_medico_w), obter_dados_medico(cd_medico_w, 'UFCRM'),ie_carater_internacao,
					nr_seq_tipo_atendimento, nr_seq_saida_spsadt, cd_medico_solicitante,
					nr_seq_prestador,ie_origem_conta, nr_seq_regra_conta_auto_w,
					coalesce(dt_atendimento,dt_atendimento_referencia), ie_indicacao_acidente, ie_cobertura_especial,
					ie_regime_atendimento, ie_saude_ocupacional
				from	pls_conta
				where	nr_sequencia	= nr_seq_conta_p;
				
				CALL pls_conta_tiss_pck.cria_copia_registro(nr_seq_conta_p, nr_seq_conta_w, nm_usuario_p);
				
			end if;

			qt_procedimento_ww	:= qt_procedimento_ww + 1;
			
			/*Verifica se nesta conta existe o procedimento */

			select	count(nr_sequencia)
			into STRICT	qt_procedimentos_w
			from	pls_conta_proc
			where	nr_seq_conta				= nr_seq_conta_w
			and	nr_seq_participante_hi			= nr_seq_conta_partic_w
			and	coalesce(dt_procedimento, dt_procedimento_w)	= dt_procedimento_w
			and	coalesce(dt_inicio_proc, dt_inicio_proc_w)	= dt_inicio_proc_w
			and	coalesce(dt_fim_proc, dt_fim_proc_w)		= dt_fim_proc_w;
			
			if (qt_procedimentos_w = 0) then /*Insere-se o procedimento nesta conta*/
				select	nextval('pls_conta_proc_seq')
				into STRICT	nr_seq_conta_proc_criada_w
				;
				
				insert into pls_conta_proc(nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, dt_procedimento,
					cd_procedimento, ie_origem_proced, qt_procedimento,
					vl_unitario, vl_procedimento, ie_via_acesso,
					nr_seq_conta, dt_procedimento_imp, cd_procedimento_imp,
					qt_procedimento_imp, vl_unitario_imp, vl_procedimento_imp,
					ie_via_acesso_imp, dt_inicio_proc, dt_fim_proc,
					dt_inicio_proc_imp, dt_fim_proc_imp, tx_participacao,
					vl_participacao, ds_procedimento_imp, cd_tipo_tabela_imp,
					tx_reducao_acrescimo_imp, ie_tipo_despesa_imp, ie_tecnica_utilizada,
					vl_liberado, vl_glosa, vl_saldo,
					nr_seq_regra, ie_tipo_despesa, ie_situacao,
					ie_status, dt_liberacao, nm_usuario_liberacao,
					tx_item, nr_seq_tiss_tabela, nr_seq_regra_horario,
					vl_custo_operacional, vl_anestesista, vl_materiais,
					vl_medico, vl_auxiliares, nr_seq_regra_liberacao,
					ds_log, cd_conta_cred, cd_conta_deb,
					cd_historico, cd_conta_glosa_cred, cd_conta_glosa_deb,
					cd_historico_glosa, nr_seq_regra_ctb_deb, nr_seq_regra_ctb_cred,
					nr_seq_grupo_ans, nr_auxiliares, nr_seq_participante_hi,
					nr_seq_proc_ref, ie_status_pagamento, ie_acao_analise)
				SELECT	nr_seq_conta_proc_criada_w, clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, dt_procedimento,
					cd_procedimento, ie_origem_proced, 0,
					0, 0, ie_via_acesso,
					nr_seq_conta_w, dt_procedimento_imp, cd_procedimento_imp,
					qt_procedimento_imp, 0, coalesce(vl_digitado_complemento_w, coalesce(vl_procedimento_imp,0)),
					ie_via_acesso_imp, dt_inicio_proc, dt_fim_proc,
					dt_inicio_proc_imp, dt_fim_proc_imp, tx_participacao,
					vl_participacao, ds_procedimento_imp, cd_tipo_tabela_imp,
					tx_reducao_acrescimo_imp, ie_tipo_despesa_imp, ie_tecnica_utilizada,
					0, 0, 0,
					null, ie_tipo_despesa, 'U',
					'U', null, null,
					tx_item, nr_seq_tiss_tabela, null,
					0, 0, 0,
					0, 0, null,
					null, cd_conta_cred, cd_conta_deb,
					cd_historico, cd_conta_glosa_cred, cd_conta_glosa_deb,
					cd_historico_glosa, nr_seq_regra_ctb_deb, nr_seq_regra_ctb_cred,
					null, null, nr_seq_conta_partic_w,
					nr_seq_conta_proc_w, 'I', ie_acao_analise
				from	pls_conta_proc
				where	nr_sequencia	= nr_seq_conta_proc_w;
				
				CALL pls_cta_proc_mat_regra_pck.cria_copia_regra_proc_tiss(nr_seq_conta_proc_w, nr_seq_conta_proc_criada_w, 'S', nm_usuario_p);
				
				if (ie_commit_p = 'S') then
					commit;
				end if;
				
				
				/* Francisco - 13/12/2012 - OS 530008 */

				ie_cancelamento_w	:= 'N';

				nr_seq_regra_w := pls_obter_canc_item_orig(nr_seq_conta_proc_w, nr_seq_regra_w);

				if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
					select	max(a.ie_cancelamento)
					into STRICT	ie_cancelamento_w
					from	pls_regra_canc_item_orig	a
					where	a.nr_sequencia	= nr_seq_regra_w;
					
					begin
					select	ie_status
					into STRICT	ie_status_proc_w
					from	pls_conta_proc a
					where	a.nr_sequencia	= nr_seq_conta_proc_w;
					exception
						when others then
						ie_status_proc_w	:= null;
					end;
				end if;

				if (ie_cancelamento_w = 'S') and (ie_status_proc_w <> 'D') then
					update	pls_conta_proc
					set	ie_status			= 'D',
						nr_seq_regra_canc_item_orig	= nr_seq_regra_w
					where	nr_sequencia			= nr_seq_conta_proc_w;
					
					/*pls_cancelar_item_conta('P',nr_seq_conta_p,nr_seq_conta_proc_w,nm_usuario_p,null,null,cd_estabelecimento_p);*/

				end if;
				/* Fim Francisco - 13/12/2012 - OS 530008 */

				
				qt_partic_gerado_w	:= qt_partic_gerado_w + 1;
			end if;
			
			update	pls_conta
			set	cd_guia		= cd_guia_proc_w
			where	nr_sequencia	= nr_seq_conta_w;
			
			/*Alterado o status do participante para evitar cobranca duplicada OS 451709*/

			update	pls_proc_participante
			set	ie_status 	= 'C',
				vl_participante	= 0,
				vl_calculado	= 0,
				ie_gerada_cta_honorario = 'S'
			where	nr_sequencia 	= nr_seq_conta_partic_w;
			
			/*Altera o situacao das Glosas e Ocorrencias que possam existir para participante*/

			update	pls_ocorrencia_benef
			set	ie_situacao		= 'I',
				ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
			where	nr_seq_proc_partic	= nr_seq_participante_w;
			
			update	pls_conta_glosa
			set	ie_situacao		= 'I',
				ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
			where	nr_seq_proc_partic	= nr_seq_participante_w;

			/*Necessario manter este tratamento para que nao sejam criadas contas sem procedimento*/

			if (coalesce(qt_procedimento_ww,0) = 0) then
				delete	FROM pls_conta
				where	nr_sequencia	= nr_seq_conta_w;
			end if;

			/*Necessario manter este tratamento para que nao sejam criadas contas sem procedimento*/

			select	count(1)
			into STRICT	qt_conta_w
			from	pls_conta
			where	nr_seq_protocolo	= nr_seq_protocolo_w  LIMIT 1;
			
			if (coalesce(qt_conta_w,0) = 0) then
				delete	FROM pls_protocolo_conta
				where	nr_sequencia	= nr_seq_protocolo_w;
			end if;
			end;
		end if;
		
		nr_seq_conta_proc_ant_w	:= nr_seq_conta_proc_w;
		end;
	end loop;
	close C01;

	open C03;
	loop
	fetch C03 into	
		nr_seq_conta_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		CALL pls_incluir_conta_analise(nr_seq_conta_w,nm_usuario_p);
/*cOMENTEI ESTA PARTE DE CoDIGO POIS SEMPRE QUE ESTA ROTINA e CHAMADA ELA PASSA POSTERIORMENTE POR ESTA ROTINA NOVAMENTE GERANDO UM CUSTO MUITO ALTO DGKORZ 583173
		pls_atualizar_agrup_analise(nr_seq_conta_w,nm_usuario_p,'C','S');*/
		end;
	end loop;
	close C03;

	ds_conta_gerada_p	:= '';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_conta_partic ( nr_seq_conta_p bigint, ie_tipo_guia_p text, cd_guia_ text, cd_guia_referencia_p text, cd_guia_conta_w text, nr_seq_tipo_acomodacao_p bigint, nr_seq_protocolo_p bigint, nr_seq_segurado_p bigint, ie_regime_internacao_p text, ie_carater_internacao_p text, nr_seq_tipo_atendimento_p bigint, nr_seq_saida_spsadt_p bigint, ie_tipo_segurado_p text, ie_origem_conta_p text, ie_tipo_conta_p text, nr_seq_fatura_p bigint, nr_seq_analise_p bigint, cd_senha_externa_p text, nm_usuario_p text, cd_estabelecimento_p bigint, dt_emissao_p timestamp, ds_conta_gerada_p INOUT text, ie_commit_p text, nr_seq_conta_proc_p text) FROM PUBLIC;
