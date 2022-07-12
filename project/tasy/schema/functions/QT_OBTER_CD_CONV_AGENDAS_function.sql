-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_cd_conv_agendas (nr_seq_paciente_p bigint) RETURNS bigint AS $body$
DECLARE


cd_convenio_w	bigint;


BEGIN

if (coalesce(nr_seq_paciente_p,0) > 0) then

	select  max(cd_convenio)
	into STRICT	cd_convenio_w
	from	paciente_setor_convenio
	where	nr_seq_paciente = nr_seq_paciente_p;

end if;


return	cd_convenio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_cd_conv_agendas (nr_seq_paciente_p bigint) FROM PUBLIC;

