-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_remover_comment_linkage ( nr_sequence_p bigint, nm_field_p text) AS $body$
DECLARE


ds_sql_record			varchar(1000);


BEGIN

ds_sql_record := 	' delete	from cpoe_comment_linkage			' ||
					' where '	|| nm_field_p || ' = :nr_sequence_p ';
					
EXECUTE
		ds_sql_record
using
		nr_sequence_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_remover_comment_linkage ( nr_sequence_p bigint, nm_field_p text) FROM PUBLIC;

