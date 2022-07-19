-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_gerar_grupos_enc ( nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, ie_commit_p text, cd_estabelecimento_p bigint, ie_prox_ant_p bigint, nr_seq_grupo_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar grupos de encaminhamento da análise
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_ocor_benef_w		bigint;
nr_seq_grupo_w			bigint;
nr_seq_nova_ordem_w		bigint;
qt_grupo_w			bigint;
nr_seq_aud_conta_grupo_w	bigint;
nr_seq_aud_grupo_atual_w	bigint;
nr_seq_conta_w			bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_proc_partic_w		bigint;
nr_seq_aud_conta_grupo_atual_w	bigint;
nr_seq_analise_parecer_w	bigint;
ds_observacao_w			varchar(4000);

/* Ocorrências de encaminhamento da análise */

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		c.nr_seq_grupo,
		b.nr_seq_conta,
		b.nr_seq_conta_proc,
		b.nr_seq_conta_mat,
		b.nr_seq_proc_partic
	from	pls_analise_glo_ocor_grupo c,
		pls_ocorrencia_benef	b,
		pls_conta		a
	where	a.nr_sequencia		= b.nr_seq_conta
	and	b.nr_sequencia		= c.nr_seq_ocor_benef
	and	a.nr_seq_analise	= c.nr_seq_analise
	and	a.nr_seq_analise	= nr_seq_analise_p
	and	b.ie_encaminhamento	= 'S'
	and	coalesce(b.dt_encaminhamento::text, '') = '';


BEGIN
if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_analise_parecer_w
	from	pls_analise_pedido_parecer
	where	nr_seq_grupo_atual	= nr_seq_grupo_atual_p
	and	nr_seq_analise		= nr_seq_analise_p
	and	coalesce(dt_finalizacao::text, '') = '';

	if (coalesce(nr_seq_analise_parecer_w,0) > 0) then
		select	nr_seq_novo_fluxo
		into STRICT	nr_seq_nova_ordem_w
		from	pls_analise_pedido_parecer
		where	nr_sequencia = nr_seq_analise_parecer_w;
	end if;

	select	max(nr_sequencia)
	into STRICT	nr_seq_aud_conta_grupo_atual_w
	from	pls_auditoria_conta_grupo a
	where	nr_seq_analise	= nr_seq_analise_p
	and	nr_seq_grupo	= nr_seq_grupo_atual_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_ocor_benef_w,
		nr_seq_grupo_w,
		nr_seq_conta_w,
		nr_seq_conta_proc_w,
		nr_seq_conta_mat_w,
		nr_seq_proc_partic_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_observacao_w	:= '';
		update	pls_ocorrencia_benef
		set	nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			dt_encaminhamento	= clock_timestamp()
		where	nr_sequencia		= nr_seq_ocor_benef_w;

		select	count(1)
		into STRICT	qt_grupo_w
		from	pls_auditoria_conta_grupo	a
		where	a.nr_seq_analise	= nr_seq_analise_p
		and	a.nr_seq_grupo		= nr_seq_grupo_w  LIMIT 1;

		if (qt_grupo_w = 0) then
			select	nextval('pls_auditoria_conta_grupo_seq')
			into STRICT	nr_seq_aud_conta_grupo_w
			;

			insert into pls_auditoria_conta_grupo(nr_sequencia,
				nr_seq_analise,
				nr_seq_grupo,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_ordem,
				ie_manual,
				ds_observacao)
			values (nr_seq_aud_conta_grupo_w,
				nr_seq_analise_p,
				nr_seq_grupo_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_nova_ordem_w,
				'S',
				'Grupo inserido através de ação do usuário.');

			if (ie_prox_ant_p = 0) then
				CALL pls_finalizar_tempo_auditor(nr_seq_aud_conta_grupo_atual_w, nr_seq_analise_p, nm_usuario_p, cd_estabelecimento_p);
				CALL pls_finalizar_tempo_auditor(nr_seq_aud_conta_grupo_w, nr_seq_analise_p, nm_usuario_p, cd_estabelecimento_p);
			end if;

			ds_observacao_w := ds_observacao_w || pls_util_pck.enter_w || 'Observação: ' || ds_observacao_p || pls_util_pck.enter_w || 'Usuário: ' || nm_usuario_p  || pls_util_pck.enter_w || 'Grupo anterior: ' || pls_obter_nome_grupo_auditor(nr_seq_grupo_atual_p) || pls_util_pck.enter_w || 'Data: ' || to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss') || pls_util_pck.enter_w || 'Grupo Atual: ' || pls_obter_nome_grupo_auditor(nr_seq_grupo_p);

			CALL pls_inserir_hist_analise(null, nr_seq_analise_p, 4,
						null, null, null,
						null, 'Grupo inserido através de ação do usuário.' || pls_util_pck.enter_w || ds_observacao_w, nr_seq_grupo_atual_p,
						nm_usuario_p, cd_estabelecimento_p);

			CALL pls_atualizar_grupo_penden(nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);
		else
			select	max(nr_sequencia)
			into STRICT	nr_seq_aud_conta_grupo_w
			from	pls_auditoria_conta_grupo a
			where	nr_seq_analise	= nr_seq_analise_p
			and	nr_seq_grupo	= nr_seq_grupo_w;

			if (nr_seq_aud_conta_grupo_w IS NOT NULL AND nr_seq_aud_conta_grupo_w::text <> '') then

				update	pls_auditoria_conta_grupo
				set	nr_seq_ordem		= nr_seq_nova_ordem_w,
					dt_liberacao		 = NULL,
					dt_final_analise	 = NULL,
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
				where	nr_sequencia		= nr_seq_aud_conta_grupo_w;

				CALL pls_finalizar_tempo_auditor(nr_seq_aud_conta_grupo_atual_w,nr_seq_analise_p,nm_usuario_p,cd_estabelecimento_p);
				CALL pls_finalizar_tempo_auditor(nr_seq_aud_conta_grupo_w,nr_seq_analise_p,nm_usuario_p,cd_estabelecimento_p);
			end if;

			ds_observacao_w := substr(ds_observacao_w || pls_util_pck.enter_w || 'Observação: ' || ds_observacao_p || pls_util_pck.enter_w || 'Usuário: ' || nm_usuario_p  || pls_util_pck.enter_w || 'Grupo anterior: ' || pls_obter_nome_grupo_auditor(nr_seq_grupo_atual_p) || pls_util_pck.enter_w || 'Data: ' || to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss') || pls_util_pck.enter_w || 'Grupo Atual: ' || pls_obter_nome_grupo_auditor(nr_seq_grupo_p),1,4000);

			CALL pls_inserir_hist_analise(null, nr_seq_analise_p, 4,
						null, null, null,
						null, 'Grupo inserido através de ação do usuário.' || pls_util_pck.enter_w || ds_observacao_w, nr_seq_grupo_atual_p,
						nm_usuario_p, cd_estabelecimento_p);
		end if;

		CALL pls_gerar_fluxo_audit_item(nr_seq_analise_p,nr_seq_conta_w,nr_seq_conta_proc_w,nr_seq_conta_mat_w,nr_seq_proc_partic_w,nm_usuario_p);
		end;
	end loop;
	close C01;

	if (coalesce(ie_commit_p,'S') = 'S') then
		commit;
	end if;
	/* Não pode ter commit */

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_gerar_grupos_enc ( nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, ie_commit_p text, cd_estabelecimento_p bigint, ie_prox_ant_p bigint, nr_seq_grupo_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

