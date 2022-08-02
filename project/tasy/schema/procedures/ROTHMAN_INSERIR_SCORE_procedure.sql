-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rothman_inserir_score ( nr_sequencia_p bigint, qt_score_p text, nm_usuario_p text, DT_ROTHMAN_INDEX_p text default null) AS $body$
DECLARE

DT_ROTHMAN_INDEX_w	timestamp;

BEGIN

if (DT_ROTHMAN_INDEX_p IS NOT NULL AND DT_ROTHMAN_INDEX_p::text <> '') then
	DT_ROTHMAN_INDEX_w := to_date(DT_ROTHMAN_INDEX_p, 'yyyymmddhh24miss');
end if;
update	escala_rothman
set		qt_score	= replace(qt_score_p,'.',','),
		DT_ROTHMAN_INDEX = DT_ROTHMAN_INDEX_w
where	nr_sequencia = nr_sequencia_p;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rothman_inserir_score ( nr_sequencia_p bigint, qt_score_p text, nm_usuario_p text, DT_ROTHMAN_INDEX_p text default null) FROM PUBLIC;

