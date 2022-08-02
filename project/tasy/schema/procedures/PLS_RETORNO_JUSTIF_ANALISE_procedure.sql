-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_retorno_justif_analise ( nr_seq_conta_p pls_conta.nr_sequencia%type, ds_mensagem_p pls_regra_cta_just_aut.ds_mensagem%type, ie_desfazer_justif_p text, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Retorno  da justificativa para a analise, pode ser utilizada tambem para desfazer uma 
solicitacao de justificativa
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  X] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ie_desfazer_justif_w	varchar(1) := coalesce(ie_desfazer_justif_p,'N');
nr_seq_analise_w	pls_analise_conta.nr_sequencia%type;
qt_contas_aguardando_w	integer;

BEGIN

if (coalesce(nr_seq_conta_p::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(386250);
end if;

if (coalesce(ds_mensagem_p::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(386248);
end if;

select	nr_seq_analise
into STRICT	nr_seq_analise_w
from	pls_conta	
where	nr_sequencia	= nr_seq_conta_p  LIMIT 1;

if (nr_seq_analise_w IS NOT NULL AND nr_seq_analise_w::text <> '') then

	insert into pls_hist_analise_conta(	nr_sequencia,
						nr_seq_conta,
						nr_seq_analise,
						ie_tipo_historico,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_item,
						ie_tipo_item,
						nr_seq_ocorrencia,
						ds_observacao,
						nr_seq_glosa,
						nr_seq_grupo,
						nr_seq_conta_proc,
						nr_seq_conta_mat,
						nr_seq_proc_partic,
						nr_seq_ocor_benef,
						nr_seq_conta_glosa)
	SELECT	nextval('pls_hist_analise_conta_seq'),
		nr_seq_conta_p,
		nr_seq_analise_w,
		CASE WHEN ie_desfazer_justif_w='N' THEN  '38'  ELSE '37' END , -- 37 Desfeita a solicitação de justificativa médica,  38 -Resposta prestador da justificativa médica
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		null,
		null,
		null,
		ds_mensagem_p,
		null,
		null,
		nr_sequencia,
		null,
		null,
		null,
		null
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_status	= 'J';
	
	insert into pls_hist_analise_conta(	nr_sequencia,
						nr_seq_conta,
						nr_seq_analise,
						ie_tipo_historico,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_item,
						ie_tipo_item,
						nr_seq_ocorrencia,
						ds_observacao,
						nr_seq_glosa,
						nr_seq_grupo,
						nr_seq_conta_proc,
						nr_seq_conta_mat,
						nr_seq_proc_partic,
						nr_seq_ocor_benef,
						nr_seq_conta_glosa)
	SELECT	nextval('pls_hist_analise_conta_seq'),
		nr_seq_conta_p,
		nr_seq_analise_w,
		CASE WHEN ie_desfazer_justif_w='N' THEN  '38'  ELSE '37' END , -- 37 Desfeita a solicitação de justificativa médica,  38 -Resposta prestador da justificativa médica
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		null,
		null,
		null,
		ds_mensagem_p,
		null,
		null,
		null,
		nr_sequencia,
		null,
		null,
		null
	from	pls_conta_mat
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_status	= 'J';

	update	pls_conta
	set	ie_analise_justificativa	= 'R'
	where	nr_sequencia			= nr_seq_conta_p;
	
	-- atualiza os procedimento pendentes de justificativa
	update	pls_conta_proc
	set	ie_status	= 'A'
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_status	= 'J';
	
	-- atualiza os materiais pendentes de justificativa
	update	pls_conta_mat
	set	ie_status	= 'A'
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_status	= 'J';
	
	-- Para alterar o status da conta  de "aguardando justificativa", não pode possuir mais nenhuma  conta aguardando justificativa

	-- O status da analise, caso o retorno seja do prestador, a analise fica como "aguardando auditoria".

	-- se a justificativa estiver sendo desfeita, o status fica como "em auditoria", pois somente um auditor pode desfazer a solicitação de justificativa.
	select	count(1)
	into STRICT	qt_contas_aguardando_w
	from	pls_conta
	where	nr_seq_analise			= nr_seq_analise_w
	and	ie_analise_justificativa	= 'A';
	
	if (qt_contas_aguardando_w = 0) then
		update	pls_analise_conta
		set	ie_status	= CASE WHEN ie_desfazer_justif_w='N' THEN  'G'  ELSE 'A' END
		where	nr_sequencia	= nr_seq_analise_w;
	end if;
	
	--Gera pendência de notificação do Portal
	CALL pls_gerar_notificacao_tws(nm_usuario_p, 'JC', 'V', nr_seq_conta_p);

	if (ie_commit_p = 'S') then
		commit;
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_retorno_justif_analise ( nr_seq_conta_p pls_conta.nr_sequencia%type, ds_mensagem_p pls_regra_cta_just_aut.ds_mensagem%type, ie_desfazer_justif_p text, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;

