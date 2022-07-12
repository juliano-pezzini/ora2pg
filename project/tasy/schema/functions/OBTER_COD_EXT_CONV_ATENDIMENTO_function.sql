-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cod_ext_conv_atendimento ( nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


cd_convenio_w			integer;
cd_externo_w	convenio.CD_EXTERNO%type;


BEGIN

select 	Obter_Convenio_Atendimento(nr_atendimento_p)
into STRICT 	cd_convenio_w
;

if (cd_convenio_w > 0) then
	select max(CD_EXTERNO)
	into STRICT cd_externo_w
	from convenio
	where cd_convenio = cd_convenio_w;
end if;


RETURN cd_externo_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cod_ext_conv_atendimento ( nr_atendimento_p bigint) FROM PUBLIC;
