-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_execucao_cirurgica_pck.copiar_participacoes_proc ( nr_seq_proc_original_p pls_exec_cirurgica_proc.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Copiar as participacoes do item substituido para o novo.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_exec_cirurg_proc_w	pls_exec_cirurgica_proc.nr_sequencia%type;
nr_seq_execucao_guia_w		pls_exec_cirurgica_guia.nr_sequencia%type;		
nr_seq_exec_cirurgica_w		pls_execucao_cirurgica.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_seq_grau_partic,
		nr_seq_exec_cirurg_bio,
		ie_status
	from	pls_exec_cirurg_bio_partic
	where	nr_seq_exec_cirurg_proc	= nr_seq_proc_original_p
	and	ie_status 		<> 'C'
	and	(nr_seq_exec_cirurg_bio IS NOT NULL AND nr_seq_exec_cirurg_bio::text <> '')
	order	by nr_seq_grau_partic;


BEGIN

begin
	select	a.nr_sequencia,
		a.nr_seq_execucao_guia,
		b.nr_seq_exec_cirurgica
	into STRICT	nr_seq_exec_cirurg_proc_w,
		nr_seq_execucao_guia_w,
		nr_seq_exec_cirurgica_w
	from	pls_exec_cirurgica_proc a,
		pls_exec_cirurgica_guia b
	where	a.nr_seq_execucao_guia		= b.nr_sequencia
	and	a.nr_seq_exec_proc_original	= nr_seq_proc_original_p;
exception
when others then
	nr_seq_exec_cirurg_proc_w	:= null;
end;

if (nr_seq_exec_cirurg_proc_w IS NOT NULL AND nr_seq_exec_cirurg_proc_w::text <> '') then
	for C01_w in C01 loop
		begin				
			update	pls_exec_cirurg_bio_partic
			set	nr_seq_exec_cirurg_bio	= C01_w.nr_seq_exec_cirurg_bio,
				ie_status		= C01_w.ie_status,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p
			where	nr_seq_exec_cirurg_proc	= nr_seq_exec_cirurg_proc_w
			and	nr_seq_grau_partic	= C01_w.nr_seq_grau_partic
			and	ie_status		= 'A';
		end;
	end loop;
	
	update	pls_exec_cirurgica_guia
	set	ie_status		= 'E',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()	
	where	nr_sequencia		= nr_seq_execucao_guia_w
	and	ie_status		= 'A';
	
	--Realizada copia das participacoes do procedimento sequencia #@NR_SEQ_PROC_ORIGINAL#@ para o procedimento sequencia #@NR_SEQ_PROC#@.
	CALL pls_execucao_cirurgica_pck.gerar_log_exec_cirurgica(nr_seq_exec_cirurgica_w, wheb_mensagem_pck.get_texto(1148357,'NR_SEQ_PROC_ORIGINAL=' || nr_seq_proc_original_p || ';' || 'NR_SEQ_PROC=' || nr_seq_exec_cirurg_proc_w), cd_estabelecimento_p, nm_usuario_p);
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_execucao_cirurgica_pck.copiar_participacoes_proc ( nr_seq_proc_original_p pls_exec_cirurgica_proc.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;