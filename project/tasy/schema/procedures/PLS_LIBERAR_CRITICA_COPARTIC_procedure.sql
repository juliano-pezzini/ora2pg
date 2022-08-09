-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_critica_copartic ( nr_seq_copartic_critica_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_lib_copartic_w	pls_coparticipacao_critica.nr_seq_lib_copartic%type;
qt_critica_pendente_w	bigint;


BEGIN

if (nr_seq_copartic_critica_p IS NOT NULL AND nr_seq_copartic_critica_p::text <> '') then
	update	pls_coparticipacao_critica
	set	dt_liberacao		= clock_timestamp(),
		nm_usuario_liberacao	= nm_usuario_p
	where	nr_sequencia		= nr_seq_copartic_critica_p;

	select	nr_seq_lib_copartic
	into STRICT	nr_seq_lib_copartic_w
	from	pls_coparticipacao_critica
	where	nr_sequencia	= nr_seq_copartic_critica_p;

	select	count(1)
	into STRICT	qt_critica_pendente_w
	from	pls_coparticipacao_critica
	where	nr_seq_lib_copartic	= nr_seq_lib_copartic_w
	and	coalesce(dt_liberacao::text, '') = '';

	if (qt_critica_pendente_w = 0) then
		update	pls_lib_coparticipacao
		set	ie_critica_pendente	= 'N'
		where	nr_sequencia		= nr_seq_lib_copartic_w;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_critica_copartic ( nr_seq_copartic_critica_p bigint, nm_usuario_p text) FROM PUBLIC;
