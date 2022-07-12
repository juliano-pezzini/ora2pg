-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_execucao_cirurgica_pck.estornar_participacoes_proc ( nr_seq_exec_cirurgica_proc_p pls_exec_cirurgica_proc.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Estornar/corrigir as participacoes do procedimento.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
		
nr_seq_exec_cirurgica_w		pls_execucao_cirurgica.nr_sequencia%type;


BEGIN

begin
	select	b.nr_seq_exec_cirurgica
	into STRICT	nr_seq_exec_cirurgica_w
	from	pls_exec_cirurgica_proc a,
		pls_exec_cirurgica_guia b
	where	a.nr_seq_execucao_guia	= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_exec_cirurgica_proc_p;
exception
when others then
	nr_seq_exec_cirurgica_w	:= null;
end;

if (nr_seq_exec_cirurgica_w IS NOT NULL AND nr_seq_exec_cirurgica_w::text <> '') then
	
	update	pls_exec_cirurg_bio_partic
	set	nr_seq_exec_cirurg_bio	 = NULL,
		ie_status		= 'A',
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_seq_exec_cirurg_proc	= nr_seq_exec_cirurgica_proc_p;

	--Realizado o estorno das participacoes do procedimento sequencia #@NR_SEQ_PROC#@ pelo usuario #@NM_USUARIO#@.
	CALL pls_execucao_cirurgica_pck.gerar_log_exec_cirurgica(nr_seq_exec_cirurgica_w, wheb_mensagem_pck.get_texto(1148566,'NR_SEQ_PROC=' || nr_seq_exec_cirurgica_proc_p || ';' || 'NM_USUARIO=' || nm_usuario_p), cd_estabelecimento_p, nm_usuario_p);
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_execucao_cirurgica_pck.estornar_participacoes_proc ( nr_seq_exec_cirurgica_proc_p pls_exec_cirurgica_proc.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;