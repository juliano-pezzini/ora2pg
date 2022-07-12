-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_desc_prot_livre (nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE


ds_protocolo_livre_w	varchar(255) := '';


BEGIN

if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') then

	select	max(substr(ds_protocolo_livre,1,255))
	into STRICT	ds_protocolo_livre_w
	from	paciente_setor
	where	nr_seq_paciente =  nr_seq_paciente_p;

end if;

return	ds_protocolo_livre_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_desc_prot_livre (nr_seq_paciente_p bigint) FROM PUBLIC;
