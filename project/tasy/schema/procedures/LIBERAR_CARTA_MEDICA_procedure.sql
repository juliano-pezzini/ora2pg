-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_carta_medica ( nr_seq_carta_p bigint, cd_pessoa_usuario_p text) AS $body$
DECLARE


nr_seq_carta_mae_w		carta_medica.nr_sequencia%type;


BEGIN

select	coalesce(nr_seq_carta_mae,nr_sequencia)
into STRICT	nr_seq_carta_mae_w
from	carta_medica
where	nr_sequencia = nr_seq_carta_p;


update	carta_medica
set	dt_liberacao			= clock_timestamp(),
	cd_medico				= cd_pessoa_usuario_p,
	dt_liberacao_preliminar	= clock_timestamp()
where	nr_sequencia = nr_seq_carta_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_carta_medica ( nr_seq_carta_p bigint, cd_pessoa_usuario_p text) FROM PUBLIC;
