-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lib_oc_pre_fatura ( nr_seq_fatura_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_mot_liberacao_p bigint, ds_parecer_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_conta_p pls_conta.nr_sequencia%type) AS $body$
DECLARE

 
ie_tipo_motivo_w		varchar(255);
ie_liberar_imp_w		varchar(255);
ie_liberado_w			varchar(255);
ie_status_w			varchar(255);
ie_finalizar_analise_w		varchar(255);
ie_fechar_conta_w		varchar(255);
ds_ocorrencia_w			varchar(255);
ie_lib_manual_w			varchar(255);
ie_inserido_w			varchar(255);
ie_situacao_w			varchar(255);
ie_parecer_w			varchar(255)	:= 'S';	
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_w		pls_conta_mat.nr_sequencia%type;
nr_seq_proc_partic_w		pls_proc_participante.nr_sequencia%type;
nr_seq_analise_w		pls_analise_conta.nr_sequencia%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_grupo_pre_analise_w	bigint;
nr_seq_fluxo_w			bigint;
nr_seq_ocor_benef_w		bigint;
qt_fluxo_w			integer;
nr_seq_glosa_w			bigint;

C01 CURSOR FOR 
	SELECT	a.nr_seq_conta, 
		a.nr_seq_conta_proc, 
		a.nr_seq_conta_mat, 
		a.nr_seq_proc_partic, 
		c.nr_seq_analise, 
		a.nr_sequencia, 
		a.nr_seq_glosa, 
		a.ie_lib_manual, 
		a.ie_situacao 
	from  pls_analise_glo_ocor_grupo b, 
		pls_ocorrencia_benef a, 
		pls_conta c 
	where	a.nr_sequencia	= b.nr_seq_ocor_benef 
	and	c.nr_sequencia	= a.nr_seq_conta 
	and	b.nr_seq_grupo	= nr_seq_grupo_pre_analise_w 
	and	c.nr_seq_fatura	= nr_seq_fatura_p 
	and (a.nr_seq_conta	= nr_seq_conta_p or coalesce(nr_seq_conta_p::text, '') = '') 
	and	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_p 
	group by 
		a.nr_seq_conta, 
		a.nr_seq_conta_proc, 
		a.nr_seq_conta_mat, 
		a.nr_seq_proc_partic, 
		c.nr_seq_analise, 
		a.nr_sequencia, 
		a.nr_seq_glosa, 
		a.ie_lib_manual, 
		a.ie_situacao;


BEGIN 
select	max(a.ie_tipo_motivo) 
into STRICT	ie_tipo_motivo_w 
from	pls_mot_lib_analise_conta	a 
where	a.nr_sequencia	= nr_seq_mot_liberacao_p;
 
select	max(a.nr_seq_grupo_pre_analise) 
into STRICT	nr_seq_grupo_pre_analise_w 
from	pls_parametros	a 
where	a.cd_estabelecimento	= cd_estabelecimento_p;
 
if (pls_obter_se_auditor_grupo(nr_seq_grupo_pre_analise_w, nm_usuario_p) = 'N') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(213858);
end if;
 
open C01;
loop 
fetch C01 into 
	nr_seq_conta_w, 
	nr_seq_conta_proc_w, 
	nr_seq_conta_mat_w, 
	nr_seq_proc_partic_w, 
	nr_seq_analise_w, 
	nr_seq_ocor_benef_w, 
	nr_seq_glosa_w, 
	ie_lib_manual_w, 
	ie_situacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then 
		ie_parecer_w	:= 'S';
	else 
		select	CASE WHEN count(1)=0 THEN  'S'  ELSE 'N' END  
		into STRICT	ie_parecer_w 
		from	pls_conta	a 
		where	a.nr_sequencia	= nr_seq_conta_w 
		and	coalesce(a.nr_seq_segurado::text, '') = '' 
		and	coalesce(a.ie_glosa, 'N') = 'N';
	end if;
	 
	if (ie_parecer_w = 'S') then 
		/* Desfavorável a glosa */
 
		if (ie_tipo_motivo_w = 'S') then 
			ie_liberar_imp_w	:= pls_obter_permissao_auditor(nr_seq_analise_w, nr_seq_grupo_pre_analise_w, nm_usuario_p, 'LC');
		 
			/* Gravar o fluxo de análise do item - histórico */
 
			nr_seq_fluxo_w := pls_gravar_fluxo_analise_item(	nr_seq_analise_w, nr_seq_conta_w, nr_seq_conta_proc_w, nr_seq_conta_mat_w, nr_seq_proc_partic_w, null, nr_seq_grupo_pre_analise_w, 'L', nr_seq_mot_liberacao_p, ds_parecer_p, 'S', 'N', nm_usuario_p, 'N', null, '1', nr_seq_fluxo_w);
			 
			ie_liberado_w	:= pls_obter_se_nivel_lib_auditor(nr_seq_ocorrencia_p, nr_seq_grupo_pre_analise_w, nm_usuario_p, 'S');
			 
			select	max(ds_ocorrencia), 
				coalesce(max(ie_finalizar_analise), 'S'), 
				coalesce(max(ie_fechar_conta),'S') 
			into STRICT	ds_ocorrencia_w, 
				ie_finalizar_analise_w, 
				ie_fechar_conta_w 
			from	pls_ocorrencia 
			where	nr_sequencia	= nr_seq_ocorrencia_p;
			 
			if (ie_liberado_w = 'N') then		 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(207091, 'DS_OCORR=' || ds_ocorrencia_w);
			end if;
			 
			ie_status_w	:= 'L';
			 
			select	count(1) 
			into STRICT	qt_fluxo_w 
			from	pls_analise_glo_ocor_grupo x, 
				pls_ocorrencia_benef	a 
			where	x.nr_seq_analise	= nr_seq_analise_w 
			and	x.nr_seq_ocor_benef	= a.nr_sequencia 
			and	a.nr_sequencia		= nr_seq_ocor_benef_w;
 
			/* Se não tem fluxo para a ocorrência, dar insert do fluxo */
 
			if (qt_fluxo_w = 0) then 
				insert into pls_analise_glo_ocor_grupo(nr_sequencia, 
					nm_usuario, 
					dt_atualizacao, 
					nm_usuario_nrec, 
					dt_atualizacao_nrec, 
					nr_seq_analise, 
					nr_seq_ocor_benef, 
					nr_seq_grupo, 
					nr_seq_fluxo, 
					ie_fluxo_gerado, 
					nm_usuario_analise, 
					dt_analise, 
					ie_status) 
				values (nextval('pls_analise_glo_ocor_grupo_seq'), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nr_seq_analise_w, 
					nr_seq_ocor_benef_w, 
					nr_seq_grupo_pre_analise_w, 
					nr_seq_fluxo_w, 
					'S', 
					nm_usuario_p, 
					clock_timestamp(), 
					ie_status_w);
			else 
				update	pls_analise_glo_ocor_grupo 
				set	ie_status		= ie_status_w, 
					nm_usuario		= nm_usuario_p, 
					dt_atualizacao		= clock_timestamp(), 
					nm_usuario_analise	= nm_usuario_p, 
					dt_analise		= clock_timestamp() 
				where	nr_seq_ocor_benef	= nr_seq_ocor_benef_w 
				and	nr_seq_grupo		= nr_seq_grupo_pre_analise_w;
			end if;
			 
			/* Francisco - 23/11/2012 - Só inativar as ocorrências que não são de valor */
 
			if	((ie_finalizar_analise_w = 'S' AND ie_fechar_conta_w = 'S') or (ie_liberar_imp_w = 'S')) then 
				update	pls_ocorrencia_benef 
				set	ie_situacao		= 'I', 
					nm_usuario		= nm_usuario_p, 
					dt_atualizacao		= clock_timestamp(), 
					ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END  
				where	nr_sequencia		= nr_seq_ocor_benef_w;
				 
				update	pls_ocorrencia_benef 
				set	ie_situacao		= 'I', 
					nm_usuario		= nm_usuario_p, 
					dt_atualizacao		= clock_timestamp(), 
					ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END  
				where	nr_seq_ocor_pag		= nr_seq_ocor_benef_w;
				 
				if (coalesce(nr_seq_glosa_w::text, '') = '') then 
					select	max(a.nr_sequencia) 
					into STRICT	nr_seq_glosa_w 
					from	pls_conta_glosa a 
					where	a.nr_seq_ocorrencia_benef	= nr_seq_ocor_benef_w;
				end if;
				 
				if (nr_seq_glosa_w IS NOT NULL AND nr_seq_glosa_w::text <> '') then 
					update	pls_conta_glosa 
					set	ie_situacao		= 'I', 
						nm_usuario		= nm_usuario_p, 
						dt_atualizacao		= clock_timestamp(), 
						ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END  
					where	nr_sequencia		= nr_seq_glosa_w;
				end if;
				 
				-- Liberar também os itens. 
				-- Quando a ocorrência for para a conta já libera todos os itens. 
				if (coalesce(nr_seq_conta_proc_w::text, '') = '' and 
					coalesce(nr_seq_conta_mat_w::text, '') = '' and 
					coalesce(nr_seq_proc_partic_w::text, '') = '') then 
					 
					CALL pls_propagar_lib_conta(	nr_seq_analise_w, nr_seq_conta_w, 
								nr_seq_grupo_pre_analise_w, nr_seq_mot_liberacao_p, 
								cd_estabelecimento_p, nm_usuario_p);
				else 
					CALL pls_analise_lib_pag_total(	nr_seq_analise_w, nr_seq_conta_w, 
									nr_seq_conta_proc_w, nr_seq_conta_mat_w, 
									nr_seq_proc_partic_w, nr_seq_mot_liberacao_p, 
									'Item liberado pelo grupo de pré-análise através da função ' || 
									'OPS - Contas de Intercâmbio(A500)', cd_estabelecimento_p, 
									nr_seq_grupo_pre_analise_w, nm_usuario_p, 
									'S', 'S');
				end if;
			end if;
			 
		/* Favorável a glosa */
 
		else 
			/* Gravar o fluxo de análise do item - histórico */
 
			nr_seq_fluxo_w := pls_gravar_fluxo_analise_item(	nr_seq_analise_w, nr_seq_conta_w, nr_seq_conta_proc_w, nr_seq_conta_mat_w, nr_seq_proc_partic_w, null, nr_seq_grupo_pre_analise_w, 'G', nr_seq_mot_liberacao_p, ds_parecer_p, 'S', 'N', nm_usuario_p, 'N', null, '2', nr_seq_fluxo_w);
							 
			select	count(1) 
			into STRICT	qt_fluxo_w 
			from	pls_analise_glo_ocor_grupo x 
			where	x.nr_seq_analise	= nr_seq_analise_w 
			and	x.nr_seq_ocor_benef	= nr_seq_ocor_benef_w 
			and	x.nr_seq_grupo		= nr_seq_grupo_pre_analise_w;
			 
			if (qt_fluxo_w = 0) and (ie_lib_manual_w = 'S') then 
				insert into pls_analise_glo_ocor_grupo(nr_sequencia, 
					nm_usuario, 
					dt_atualizacao, 
					nm_usuario_nrec, 
					dt_atualizacao_nrec, 
					nr_seq_analise, 
					nr_seq_ocor_benef, 
					nr_seq_grupo, 
					nr_seq_fluxo, 
					ie_fluxo_gerado, 
					nm_usuario_analise, 
					dt_analise, 
					ie_status) 
				values (nextval('pls_analise_glo_ocor_grupo_seq'), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nr_seq_analise_w, 
					nr_seq_ocor_benef_w, 
					nr_seq_grupo_pre_analise_w, 
					nr_seq_fluxo_w, 
					'S', 
					nm_usuario_p, 
					clock_timestamp(), 
					'N');
			else 
				update	pls_analise_glo_ocor_grupo 
				set	ie_status		= 'N', 
					nm_usuario		= nm_usuario_p, 
					dt_atualizacao		= clock_timestamp(), 
					nm_usuario_analise	= nm_usuario_p, 
					dt_analise		= clock_timestamp(), 
					ie_finalizacao		= ie_finalizacao 
				where	nr_seq_analise		= nr_seq_analise_w 
				and	nr_seq_ocor_benef	= nr_seq_ocor_benef_w 
				and	nr_seq_grupo		= nr_seq_grupo_pre_analise_w;
			end if;
			 
			if (coalesce(nr_seq_glosa_w::text, '') = '') then 
				select	max(a.nr_sequencia) 
				into STRICT	nr_seq_glosa_w 
				from	pls_conta_glosa a 
				where	a.nr_seq_ocorrencia_benef	= nr_seq_ocor_benef_w;
			end if;
			/* Se estiver ativa a ocorrência, gravar vinculando ao parecer */
 
			if (ie_situacao_w = 'A') then 
				select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END  
				into STRICT	ie_inserido_w 
				from	w_pls_analise_glosa_ocor a 
				where	a.nr_seq_analise	= nr_seq_analise_w 
				and	a.nm_usuario		= nm_usuario_p 
				and	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_p 
				and	a.ie_inserido_auditor	= 'S';
			 
				insert into pls_analise_fluxo_ocor(nr_sequencia, 
					nm_usuario, 
					dt_atualizacao, 
					nm_usuario_nrec, 
					dt_atualizacao_nrec, 
					nr_seq_analise, 
					nr_seq_fluxo_item, 
					nr_seq_ocor_benef, 
					nr_seq_conta_proc, 
					nr_seq_conta_mat, 
					ie_inserido) 
				values (nextval('pls_analise_fluxo_ocor_seq'), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nr_seq_analise_w, 
					nr_seq_fluxo_w, 
					nr_seq_ocor_benef_w, 
					nr_seq_conta_proc_w, 
					nr_seq_conta_mat_w, 
					ie_inserido_w);
			end if;
			 
			CALL pls_propagar_glosa_conta(nr_seq_analise_w, nr_seq_glosa_w, nr_seq_grupo_pre_analise_w, 
						nr_seq_mot_liberacao_p, ds_parecer_p, 'S', 
						cd_estabelecimento_p, nm_usuario_p);
		end if;
		 
		update	pls_analise_conta 
		set	ie_pre_analise		= 'S', 
			ie_status_pre_analise 	= 'F' 
		where	nr_sequencia 		= nr_seq_analise_w;
	end if;
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lib_oc_pre_fatura ( nr_seq_fatura_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_mot_liberacao_p bigint, ds_parecer_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_conta_p pls_conta.nr_sequencia%type) FROM PUBLIC;

