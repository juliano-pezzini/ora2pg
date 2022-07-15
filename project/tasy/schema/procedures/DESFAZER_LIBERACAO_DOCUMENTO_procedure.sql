-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_liberacao_documento ( nr_seq_documento_p bigint) AS $body$
DECLARE


nm_usuario_w   usuario.nm_usuario%type;


BEGIN
nm_usuario_w   := wheb_usuario_pck.get_nm_usuario;

if (coalesce(nr_seq_documento_p,0) > 0) then
	update	documento
	set		dt_liberacao    = NULL,
            dt_atualizacao = clock_timestamp(),
            nm_usuario     = nm_usuario_w
	where	   nr_sequencia   = nr_seq_documento_p;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_liberacao_documento ( nr_seq_documento_p bigint) FROM PUBLIC;

