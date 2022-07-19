-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_acao_item_recurso ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_rec_p pls_rec_glosa_conta.nr_sequencia%type, nr_seq_proc_rec_p pls_rec_glosa_proc.nr_sequencia%type, nr_seq_mat_rec_p pls_rec_glosa_mat.nr_sequencia%type, nr_seq_regra_valor_p pls_rec_regra_valor.nr_sequencia%type, ds_justificativa_p pls_rec_regra_valor.ds_justificativa%type, nm_usuario_p usuario.nm_usuario%type, ie_acao_p text) AS $body$
DECLARE


nr_seq_parecer_w	pls_analise_parecer_rec.nr_sequencia%type;


BEGIN
if (ie_acao_p = 'S') then
	if (nr_seq_proc_rec_p IS NOT NULL AND nr_seq_proc_rec_p::text <> '') then

		update	pls_rec_glosa_proc
		set	ie_status		= 'N',
			vl_acatado 		= 0,
			nr_seq_regra_valor 	= nr_seq_regra_valor_p,
			nm_usuario 		= nm_usuario_p,
			dt_atualizacao 		= clock_timestamp()
		where	nr_sequencia 		= nr_seq_proc_rec_p;
	else

		update	pls_rec_glosa_mat
		set	ie_status 		= 'N',
			vl_acatado 		= 0,
			nr_seq_regra_valor 	= nr_seq_regra_valor_p,
			nm_usuario 		= nm_usuario_p,
			dt_atualizacao 		= clock_timestamp()
		where	nr_sequencia 		= nr_seq_mat_rec_p;
	end if;
else
	if (nr_seq_proc_rec_p IS NOT NULL AND nr_seq_proc_rec_p::text <> '') then

		update	pls_rec_glosa_proc
		set	ie_status		= 'A',
			vl_acatado 		= vl_recursado,
			nr_seq_regra_valor 	= nr_seq_regra_valor_p,
			nm_usuario 		= nm_usuario_p,
			dt_atualizacao 		= clock_timestamp()
		where	nr_sequencia 		= nr_seq_proc_rec_p;
	else

		update	pls_rec_glosa_mat
		set	ie_status 		= 'A',
			vl_acatado 		= vl_recursado,
			nr_seq_regra_valor 	= nr_seq_regra_valor_p,
			nm_usuario 		= nm_usuario_p,
			dt_atualizacao 		= clock_timestamp()
		where	nr_sequencia 		= nr_seq_mat_rec_p;
	end if;
end if;

CALL pls_atualizar_valor_recurso(nr_seq_conta_rec_p, 'C', nm_usuario_p);

select	nextval('pls_analise_parecer_rec_seq')
into STRICT	nr_seq_parecer_w
;

insert into pls_analise_parecer_rec(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_analise,
	nr_seq_conta_rec,
	nr_seq_mat_rec,
	nr_seq_proc_rec,
	ds_parecer)
values (nr_seq_parecer_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_analise_p,
	nr_seq_conta_rec_p,
	nr_seq_mat_rec_p,
	nr_seq_proc_rec_p,
	ds_justificativa_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_acao_item_recurso ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_rec_p pls_rec_glosa_conta.nr_sequencia%type, nr_seq_proc_rec_p pls_rec_glosa_proc.nr_sequencia%type, nr_seq_mat_rec_p pls_rec_glosa_mat.nr_sequencia%type, nr_seq_regra_valor_p pls_rec_regra_valor.nr_sequencia%type, ds_justificativa_p pls_rec_regra_valor.ds_justificativa%type, nm_usuario_p usuario.nm_usuario%type, ie_acao_p text) FROM PUBLIC;

