-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_medico_setor ( nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE


cd_medico_resp_w	varchar(10);


BEGIN
if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') then
	select	cd_medico_resp
	into STRICT	cd_medico_resp_w
	from	paciente_setor
	where	nr_seq_paciente	= nr_seq_paciente_p;
end if;

return	cd_medico_resp_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_medico_setor ( nr_seq_paciente_p bigint) FROM PUBLIC;

