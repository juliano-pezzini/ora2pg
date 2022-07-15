-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_documento_ged ( nr_seq_documento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_liberacao_w		timestamp;


BEGIN

select	max(dt_liberacao)
into STRICT	dt_liberacao_w
from	ged_atendimento
where	nr_sequencia	= nr_seq_documento_p;

if (coalesce(dt_liberacao_w::text, '') = '') then
	update	ged_atendimento
	set	dt_liberacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_documento_p;
else
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(280449);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_documento_ged ( nr_seq_documento_p bigint, nm_usuario_p text) FROM PUBLIC;

