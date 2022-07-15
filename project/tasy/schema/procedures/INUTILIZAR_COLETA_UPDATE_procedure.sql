-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inutilizar_coleta_update ( nr_sequencia_p bigint, nm_usuario_p text, ds_motivo_inut_p text default null) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	update	san_doacao
	set 	dt_inutilizacao = clock_timestamp(),
		nm_usuario_inut = nm_usuario_p
	where 	nr_sequencia 	= nr_sequencia_p;
end if;

if (ds_motivo_inut_p IS NOT NULL AND ds_motivo_inut_p::text <> '') then
	update	san_doacao
	set 	ds_motivo_inutil = SUBSTR(ds_motivo_inut_p,1,255)
	where 	nr_sequencia 	= nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inutilizar_coleta_update ( nr_sequencia_p bigint, nm_usuario_p text, ds_motivo_inut_p text default null) FROM PUBLIC;

