-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE marcar_ciencia_regulacao ( nr_sequencia_p bigint) AS $body$
DECLARE


nm_usuario_w	varchar(15);


BEGIN

if (nr_sequencia_p > 0) then

	nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

	update	regulacao_atend
	set		ie_ciente = 'S',
			nm_usuario_ciente = nm_usuario_w,
			dt_ciente = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;


	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE marcar_ciencia_regulacao ( nr_sequencia_p bigint) FROM PUBLIC;
