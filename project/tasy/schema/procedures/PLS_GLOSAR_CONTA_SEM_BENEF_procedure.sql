-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_glosar_conta_sem_benef ( nr_seq_conta_p bigint, ie_origem_conta_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Glosar a conta inteira quando beneficiário não encontrado na base 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
IE_ORIGEM_CONTA_P 
A500 - OPS Contas de Intercâmbio 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_grupo_pre_analise_w	bigint	:= null;
nr_seq_analise_w		bigint	:= null;
nr_seq_fluxo_w			bigint;


BEGIN 
if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then 
	if (ie_origem_conta_p = 'A500') then 
		begin 
		select	a.nr_seq_grupo_pre_analise 
		into STRICT	nr_seq_grupo_pre_analise_w 
		from	pls_parametros a 
		where	a.cd_estabelecimento	= cd_estabelecimento_p;
		exception 
			when others then 
			nr_seq_grupo_pre_analise_w	:= null;
		end;
		 
		if (coalesce(nr_seq_grupo_pre_analise_w::text, '') = '') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(210732);
		end if;
	end if;
	 
	select	a.nr_seq_analise 
	into STRICT	nr_seq_analise_w 
	from	pls_conta a 
	where	a.nr_sequencia	= nr_seq_conta_p;
	 
	CALL pls_glosar_item_conta(nr_seq_conta_p, null, null, nm_usuario_p, cd_estabelecimento_p);
				 
	update	pls_conta_glosa		a 
	set	ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END , 
		ie_lib_manual		= 'S', 
		ie_situacao		= 'I' 
	where	a.nr_seq_conta	= nr_seq_conta_p 
	and	not exists (SELECT	1 
				from	tiss_motivo_glosa	y 
				where	y.nr_sequencia		= a.nr_seq_motivo_glosa 
				and	y.cd_motivo_tiss	= '1001');
				 
	update	pls_ocorrencia_benef		a 
	set	ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END , 
		ie_lib_manual		= 'S', 
		ie_situacao		= 'I' 
	where	a.nr_seq_conta	= nr_seq_conta_p 
	and	((exists (SELECT	1 
			from	pls_conta_glosa	y 
			where	y.nr_sequencia	= a.nr_seq_glosa 
			and	y.ie_situacao	= 'I')) or (not exists (select	1 
				from	pls_conta_glosa		x, 
					tiss_motivo_glosa	y 
				where	x.nr_sequencia		= a.nr_seq_glosa 
				and	y.nr_sequencia		= x.nr_seq_motivo_glosa 
				and	y.cd_motivo_tiss	= '1001')));
				 
	if (nr_seq_analise_w IS NOT NULL AND nr_seq_analise_w::text <> '') then 
		if (nr_seq_grupo_pre_analise_w IS NOT NULL AND nr_seq_grupo_pre_analise_w::text <> '') then 
			nr_seq_fluxo_w := pls_gravar_fluxo_analise_item(nr_seq_analise_w, nr_seq_conta_p, null, null, null, null, nr_seq_grupo_pre_analise_w, 'G', null, 'Conta glosada na pré-análise devido a não ter encontrado beneficiário', 'S', 'N', nm_usuario_p, 'N', 'P', '2', nr_seq_fluxo_w);
		end if;
		 
		update	pls_auditoria_conta_grupo 
		set	dt_liberacao	= clock_timestamp(), 
			ds_observacao	= 'Grupo liberado devido a glosa de beneficiário não encontrado.', 
			dt_atualizacao	= clock_timestamp(), 
			nm_usuario	= nm_usuario_p 
		where	nr_seq_analise = nr_seq_analise_w;
		 
		CALL pls_fechar_conta_analise('N',nr_seq_analise_w,nr_seq_grupo_pre_analise_w,'N',cd_estabelecimento_p,nm_usuario_p);
		 
		--pls_alterar_status_analise_cta(nr_seq_analise_w, 'T', 'PLS_GLOSAR_CONTA_SEM_BENEF', nm_usuario_p, cd_estabelecimento_p); 
		 
		-- Atualizar o status da fatura 
		CALL ptu_status_analise_finalizada(nr_seq_conta_p,nm_usuario_p,cd_estabelecimento_p);
	end if;
	 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_glosar_conta_sem_benef ( nr_seq_conta_p bigint, ie_origem_conta_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

