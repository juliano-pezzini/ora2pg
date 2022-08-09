-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_finaliza_analise_grupo_pos (nr_seq_analise_p bigint, nm_usuario_p usuario.nm_usuario%type, nr_seq_grupo_atual_p bigint, ie_consistir_pendencias_p text, ie_alerta_confirmado_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_mensagem_retorno_p INOUT text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Finalizar a análise do grupo auditor atual (Análise Nova) 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ X] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
  
 
ie_forma_final_analise_w	varchar(3);
ie_existe_grupo_final_w		varchar(1);
ie_existe_final_anali_w		varchar(1);
ie_pendencia_grupo_w		varchar(1)	:= 'N';
nr_seq_grupo_w			bigint;
qt_grupos_abertos_w		integer;
nr_seq_regra_w			bigint;
qt_grupos_analise_w		integer;
nr_seq_fatura_w			bigint;
qt_sem_fluxo_w			integer;


BEGIN 
ie_forma_final_analise_w := obter_param_usuario(	1365, 3, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_forma_final_analise_w);
/*	ie_forma_final_analise_w 
	I - Impedir 
	A - Alertar e depois glosar 
	G - Glosar itens pendentes */
 
 
ds_mensagem_retorno_p	:= null;
 
if (coalesce(ie_consistir_pendencias_p,'S') = 'S') then 
	/*Se houver ocorrencias a corrigir não é possivel liberar*/
 
	if (pls_obter_se_grupo_fim_analise(nr_seq_analise_p,null,null,null,null,nr_seq_grupo_atual_p) = 'S') then 
		/*Existem ocorrências ainda pendentes que não permitem finalizar a análise (Status de análise vermelho). 
		É necessário corrigi-las primeiro. */
 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(205161, null, -20012);
	end if;
	 
	/* Glosar primeiro para consistir depois */
 
	if (ie_forma_final_analise_w = 'G') or (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'S') then 
		 
		CALL pls_analise_glosar_itens_pend(	nr_seq_analise_p, nr_seq_grupo_atual_p, cd_estabelecimento_p, 
						nm_usuario_p,'N');
	end if;
	 
	ie_pendencia_grupo_w := pls_obter_pend_grupo_analise(	nr_seq_analise_p, null, null, 
								null, null, nr_seq_grupo_atual_p, 
								'N');
	 
	if (ie_pendencia_grupo_w = 'S') then 
		/* A análise não pôde ser finalizada pois existem ocorrências ainda pendentes para seu grupo de análise (Status de análise do item amarelo). 
		Você pode marcar a opção "Pendentes" para verificar quais são estes itens. */
 
		if (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N') then 
 
			ds_mensagem_retorno_p	:= 'Atenção! Há itens pendentes de análise para seu grupo.' || 
							chr(13) || chr(10) || 
							'Se você finalizar a análise todos esses itens serão glosados. Confirma a finalização?';
		else 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(205163);
		end if;
	end if;
	 
	/* Se for o último grupo do fluxo, devem verificar se há itens sem fluxo ainda pendentes */
 
	if (pls_obter_se_fim_fluxo_analise(nr_seq_analise_p,nr_seq_grupo_atual_p) = 'S') then 
		/*Se houver análises de ocorrencia a fazer não é possivel liberar*/
 
		select	count(1) 
		into STRICT	qt_sem_fluxo_w 
		from	w_pls_analise_item a 
		where	a.nr_seq_analise	= nr_seq_analise_p 
		and	a.nm_usuario		= nm_usuario_p 
		and	a.ie_status_analise	= 'A' -- Amarelo 
		and	a.ie_sem_fluxo		= 'S' -- Só verificar na primeira vez se há sem fluxo 
		and (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N');
		 
		if (qt_sem_fluxo_w > 0) then 
 
			if (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N') then 
 
				ds_mensagem_retorno_p	:= 'Atenção! Há itens sem fluxo de auditoria definido e ainda pendentes.' || 
								chr(13) || chr(10) || 
								'Se você finalizar a análise todos esses itens serão glosados. Confirma a finalização?';
			else 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(205163);
			end if;
		end if;
	end if;
end if;
 
if (coalesce(ds_mensagem_retorno_p::text, '') = '') then 
	 
	update	pls_auditoria_conta_grupo 
	set	dt_liberacao	= clock_timestamp(), 
		dt_final_analise = clock_timestamp(), 
		dt_atualizacao	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p 
	where	nr_sequencia	= (	SELECT	max(nr_sequencia) 
					from	pls_auditoria_conta_grupo 
					where	nr_seq_grupo	= nr_seq_grupo_atual_p	 
					and	nr_seq_analise	= nr_seq_analise_p 
					and	coalesce(dt_liberacao::text, '') = ''		 
					and	nr_seq_ordem	= (	select	min(nr_seq_ordem) 
									from	pls_auditoria_conta_grupo 
									where	nr_seq_grupo 	= nr_seq_grupo_atual_p	 
									and	nr_seq_analise	= nr_seq_analise_p 
									and	coalesce(dt_liberacao::text, '') = ''	));
 
	CALL pls_gravar_inicio_fim_analise(	nr_seq_analise_p, nr_seq_grupo_atual_p, 'F', nm_usuario_p);
 
	select	count(*) 
	into STRICT	qt_grupos_abertos_w 
	from	pls_auditoria_conta_grupo a 
	where	a.nr_seq_analise = nr_seq_analise_p 
	and	coalesce(a.dt_liberacao::text, '') = '' 
	and	coalesce(ie_pre_analise,'N')	 = 'N';
 
	-- Fazer verificação se existe grupos de analise ainda em aberto se não houver fechar a analise 
	if (qt_grupos_abertos_w = 0) then 
 
		-- Obter o grupo responsavel por fechar a conta 
		SELECT * FROM pls_obter_grupo_fechar_analise(	nr_seq_analise_p, cd_estabelecimento_p, nr_seq_regra_w, nr_seq_grupo_w) INTO STRICT nr_seq_regra_w, nr_seq_grupo_w;
		 
		if (coalesce(nr_seq_grupo_w,0) > 0) then 
			ie_existe_grupo_final_w	:= 'S';
		 
			-- obter se este grupo já foi inserido na análise 
			select	CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END  
			into STRICT	ie_existe_final_anali_w 
			from	pls_auditoria_conta_grupo 
			where	nr_seq_grupo	= nr_seq_grupo_w 
			and	nr_seq_analise	= nr_seq_analise_p;
		else		 
			-- Caso não haja regra de grupo de finalização 
			ie_existe_grupo_final_w := 'N';
		end if;	
		 
		-- Se não existe grupo de finalização na análise esta é encerrada 
		if (ie_existe_grupo_final_w = 'N') then 
 
			CALL pls_alterar_status_analise_cta(	nr_seq_analise_p, 'L', 'PLS_FINALIZA_ANALISE_GRUPO_POS', 
							nm_usuario_p, cd_estabelecimento_p);
			 
			update	pls_analise_conta 
			set	dt_liberacao_analise	= clock_timestamp(), 
				dt_final_analise	= clock_timestamp() 
			where	nr_sequencia		= nr_seq_analise_p;
		else			 
			/*Se o grupo de finalização existir na análise.*/
 
			if (ie_existe_final_anali_w = 'S') then 
 
				select	count(nr_sequencia) 
				into STRICT	qt_grupos_analise_w 
				from	pls_auditoria_conta_grupo 
				where	nr_seq_analise = nr_seq_analise_p;
				 
				/*Se existir mais de uma grupo de analise*/
 
				if (qt_grupos_analise_w > 1) and (pls_obter_se_auditor_grupo(nr_seq_grupo_w, nm_usuario_p) = 'N') then 
					 
					/*Se o grupo de finalização existir na análise então seu sua liberação é desfeita. Permitindo que o mesmo se torne o fluxo da vez. */
 
					CALL pls_desf_final_grupo_analise(	nr_seq_analise_p, nr_seq_grupo_w, null, 
									nm_usuario_p, cd_estabelecimento_p,'N');
				else 
					/*Se existir somente o grupo do auditor então é liberado a análise.*/
 
					CALL pls_alterar_status_analise_cta(	nr_seq_analise_p, 'L', 'PLS_FINALIZA_ANALISE_GRUPO_POS', 
									nm_usuario_p, cd_estabelecimento_p);
					 
					update	pls_analise_conta 
					set	dt_liberacao_analise	= clock_timestamp(), 
						dt_final_analise	= clock_timestamp() 
					where	nr_sequencia 		= nr_seq_analise_p;
				end if;
			else 
				/*Se o grupo de finalização não existir na análise este é acrescentado*/
 
				CALL pls_inserir_grupo_analise(	nr_seq_analise_p, nr_seq_grupo_w, 'Grupo inserido através da regra de finalização ' || nr_seq_regra_w, 
								nr_seq_grupo_atual_p, 'N', nm_usuario_p, 
								cd_estabelecimento_p);
			end if;
		end if;	
	end if;
 
	CALL pls_inserir_hist_analise(	null, nr_seq_analise_p, 7, null, 
					null, null, null, null, 
					nr_seq_grupo_atual_p, nm_usuario_p, cd_estabelecimento_p);
				 
	update	pls_analise_conta 
	set	ie_status_pre_analise	= CASE WHEN ie_pre_analise='S' THEN 'F'  ELSE ie_status_pre_analise END  
	where	nr_sequencia		= nr_seq_analise_p;
 
	CALL pls_atualizar_grupo_penden(	nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);
 
	select max(a.nr_sequencia) 
	into STRICT  nr_seq_fatura_w 
	from  ptu_fatura       a, 
		pls_conta        b 
	where  b.nr_seq_fatura     = a.nr_sequencia 
	and   b.nr_seq_analise    = nr_seq_analise_p;
 
	/* Atualizar valores PTU Fatura*/
 
	CALL pls_atualizar_valor_ptu_fatura(nr_seq_fatura_w,'N');	
	--commit; 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_finaliza_analise_grupo_pos (nr_seq_analise_p bigint, nm_usuario_p usuario.nm_usuario%type, nr_seq_grupo_atual_p bigint, ie_consistir_pendencias_p text, ie_alerta_confirmado_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ds_mensagem_retorno_p INOUT text) FROM PUBLIC;
