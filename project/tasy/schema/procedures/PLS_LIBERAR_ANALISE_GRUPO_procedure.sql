-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_analise_grupo ( nr_seq_analise_p bigint, nm_usuario_p text, nr_seq_grupo_atual_p bigint, ie_consistir_pendencias_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
 
nm_usuario_exec_w		varchar(255);
ie_existe_grupo_final_w		varchar(1);
ie_existe_final_anali_w		varchar(1);
ie_analise_grupo_w		bigint;
nr_seq_grupo_analise_w		bigint;
nr_seq_grupo_w			bigint;
ie_existe_usuario_grupo_w	bigint;
ie_existe_grupos_abertos_w	bigint;
nr_seq_regra_w			bigint;
qt_grupos_analise_w		bigint;
nr_seq_fatura_w			bigint;


BEGIN 
if (coalesce(ie_consistir_pendencias_p, 'S') = 'S') then 
	/*Se houver análises de ocorrencia a fazer não é possivel liberar*/
 
	if (pls_obter_se_itens_aud_grupo(nr_seq_analise_p, nr_seq_grupo_atual_p, nm_usuario_p) = 'N') then 
		--Existe ocorrências que necessitam ser auditadas. Processo abortado. 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(183530);
	end if;
 
	/*Se houver ocorrencias a corrigir não é possivel liberar*/
 
	if (pls_obter_se_itens_cor_grupo(nr_seq_analise_p, nr_seq_grupo_atual_p, nm_usuario_p) = 'N') then 
		--Existe ocorrências que necessitam de correção. Processo abortado. 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(183531);
	end if;
end if;
 
update	pls_auditoria_conta_grupo 
set	dt_liberacao 		= clock_timestamp(), 
	dt_final_analise	= clock_timestamp(), 
	dt_atualizacao		= clock_timestamp(), 
	nm_usuario		= nm_usuario_p 
where	nr_sequencia	=	(SELECT	max(nr_sequencia) 
				from	pls_auditoria_conta_grupo 
				where	nr_seq_grupo 		= nr_seq_grupo_atual_p	 
				and	nr_seq_analise		= nr_seq_analise_p 
				and	coalesce(dt_liberacao::text, '') = ''		 
				and	nr_seq_ordem 		=	(select	min(nr_seq_ordem)		 
									from	pls_auditoria_conta_grupo 
									where	nr_seq_grupo 		= nr_seq_grupo_atual_p	 
									and	nr_seq_analise		= nr_seq_analise_p 
									and	coalesce(dt_liberacao::text, '') = ''	));
 
CALL pls_gravar_inicio_fim_analise(nr_seq_analise_p, nr_seq_grupo_atual_p, 'F', nm_usuario_p);
 
select	count(*) 
into STRICT	ie_existe_grupos_abertos_w 
from	pls_auditoria_conta_grupo	a		 
where	a.nr_seq_analise	= nr_seq_analise_p 
and	coalesce(ie_pre_analise,'N')	= 'N' 
and	coalesce(a.dt_liberacao::text, '') = '';
 
/*Fazer verificação se existe grupos de analise ainda em aberto se não houver fechar a analise*/
 
if (ie_existe_grupos_abertos_w = 0) then 
	/*Obter o grupo responsavel por fechar a conta*/
 
	SELECT * FROM pls_obter_grupo_fechar_analise(nr_seq_analise_p, cd_estabelecimento_p, nr_seq_regra_w, nr_seq_grupo_w) INTO STRICT nr_seq_regra_w, nr_seq_grupo_w;
	 
	if (coalesce(nr_seq_grupo_w,0) > 0) then 
		ie_existe_grupo_final_w	:= 'S';
	 
		/*obter se este grupo já foi inserido na análise*/
 
		select	CASE WHEN count(nr_sequencia)=0 THEN  'N'  ELSE 'S' END  
		into STRICT	ie_existe_final_anali_w 
		from	pls_auditoria_conta_grupo 
		where	nr_seq_grupo	= nr_seq_grupo_w 
		and	nr_seq_analise	= nr_seq_analise_p;
	else		 
		/*Caso não haja regra de grupo de finalização*/
 
		ie_existe_grupo_final_w	:= 'N';
	end if;	
	 
	/*Se não existe grupo de finalização na análise esta é encerrada*/
 
	if (ie_existe_grupo_final_w = 'N') then 
		CALL pls_alterar_status_analise_cta(nr_seq_analise_p, 'L', 'PLS_LIBERAR_ANALISE_GRUPO', nm_usuario_p, cd_estabelecimento_p);
		 
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
 
				CALL pls_desf_final_grupo_analise(nr_seq_analise_p, nr_seq_grupo_w, null, nm_usuario_p, cd_estabelecimento_p,'N');
			else 
				/*Se existir somente o grupo do auditor então é liberado a análise.*/
 
				CALL pls_alterar_status_analise_cta(nr_seq_analise_p, 'L', 'PLS_LIBERAR_ANALISE_GRUPO', nm_usuario_p, cd_estabelecimento_p);
				 
				update	pls_analise_conta 
				set	dt_liberacao_analise	= clock_timestamp(), 
					dt_final_analise	= clock_timestamp() 
				where	nr_sequencia		= nr_seq_analise_p;
			end if;
		else 
			/*Se o grupo de finalização não existir na análise este é acrescentado*/
 
			CALL pls_inserir_grupo_analise(nr_seq_analise_p, nr_seq_grupo_w, 'Grupo inserido através da regra de finalização '||nr_seq_regra_w, 
						nr_seq_grupo_atual_p, 'N', nm_usuario_p, cd_estabelecimento_p);
		end if;
	end if;	
end if;
 
CALL pls_inserir_hist_analise(null, nr_seq_analise_p, 7, null, null, null, null, null, nr_seq_grupo_atual_p, nm_usuario_p, cd_estabelecimento_p);
 
update	pls_analise_conta 
set	ie_status_pre_analise	= CASE WHEN ie_pre_analise='S' THEN  'F'  ELSE ie_status_pre_analise END  
where	nr_sequencia		= nr_seq_analise_p;
 
CALL pls_atualizar_grupo_penden(nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);
 
select max(a.nr_sequencia) 
into STRICT  nr_seq_fatura_w 
from  ptu_fatura       a, 
    pls_conta        b 
where  b.nr_seq_fatura     = a.nr_sequencia 
and   b.nr_seq_analise    = nr_seq_analise_p;
 
/* Atualizar valores PTU Fatura*/
 
CALL pls_atualizar_valor_ptu_fatura(nr_seq_fatura_w,'N');
				 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_analise_grupo ( nr_seq_analise_p bigint, nm_usuario_p text, nr_seq_grupo_atual_p bigint, ie_consistir_pendencias_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
