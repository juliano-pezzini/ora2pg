-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_tipo_conta_prot ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_tipo_conta_p pls_conta.nr_seq_tipo_conta%type, nm_usuario_p text) AS $body$
DECLARE


ds_observacao_w		varchar(4000);
nr_seq_tipo_conta_w	pls_conta.nr_seq_tipo_conta%type;

C01 CURSOR FOR

	SELECT	nr_sequencia,
		nr_seq_tipo_conta
	from	pls_conta
	where	nr_seq_protocolo = nr_seq_protocolo_p;



BEGIN

ds_observacao_w := '';

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then

	for r_c01_w in C01 loop
		begin
			ds_observacao_w :=	'Tipo conta: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||r_c01_w.nr_seq_tipo_conta ||' - Modificado: '||nr_seq_tipo_conta_p||chr(13)||chr(10);

			insert into	pls_conta_log(	nr_sequencia,dt_atualizacao, nm_usuario,
								dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
								nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
								dt_alteracao, ds_alteracao)
					values (	nextval('pls_conta_log_seq'), clock_timestamp(), nm_usuario_p,
								clock_timestamp(), nm_usuario_p, r_c01_w.nr_sequencia,
								null,  NULL, nm_usuario_p,
								clock_timestamp(), ds_observacao_w);
			ds_observacao_w := '';
		end;
	end loop;

	update	pls_conta
	set	nr_seq_tipo_conta 	= nr_seq_tipo_conta_p,
		nm_usuario 		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_seq_protocolo	= nr_seq_protocolo_p;

elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then

	select	max(nr_seq_tipo_conta)
	into STRICT	nr_seq_tipo_conta_w
	from	pls_conta
	where 	nr_sequencia = nr_seq_conta_p;

	ds_observacao_w :=	'Tipo conta: '||chr(13)||chr(10)||
						chr(9)||'Anterior: '||nr_seq_tipo_conta_w ||' - Modificado: '||nr_seq_tipo_conta_p||chr(13)||chr(10);

	insert into	pls_conta_log(	nr_sequencia,dt_atualizacao, nm_usuario,
						dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
						nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
						dt_alteracao, ds_alteracao)
			values (	nextval('pls_conta_log_seq'), clock_timestamp(), nm_usuario_p,
						clock_timestamp(), nm_usuario_p, nr_seq_conta_p,
						null,  NULL, nm_usuario_p,
						clock_timestamp(), ds_observacao_w);

	update	pls_conta
	set	nr_seq_tipo_conta 	= nr_seq_tipo_conta_p,
		nm_usuario 		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_conta_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_tipo_conta_prot ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_tipo_conta_p pls_conta.nr_seq_tipo_conta%type, nm_usuario_p text) FROM PUBLIC;

