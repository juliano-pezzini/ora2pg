-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_falta_agecons (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_motivo_w		varchar(255);
ds_responsavel_w	varchar(40);


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then

	select	max(ds_motivo_status),
		'(' || max(nm_usuario_status) || ' em ' || to_char(max(dt_status),'dd/mm/yyyy hh24:mi:ss') || ')'
	into STRICT	ds_motivo_w,
		ds_responsavel_w
	from	agenda_consulta
	where	nr_sequencia = nr_seq_agenda_p;

	ds_motivo_w := substr(ds_motivo_w || ' ' || ds_responsavel_w,1,255);

end if;

return ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_falta_agecons (nr_seq_agenda_p bigint) FROM PUBLIC;
