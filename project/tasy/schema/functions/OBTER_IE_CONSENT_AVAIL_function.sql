-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ie_consent_avail ( nr_atendimento_p bigint, cd_profissional_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';


BEGIN

if (coalesce(nr_atendimento_p, 0) > 0 and (cd_profissional_p IS NOT NULL AND cd_profissional_p::text <> '')) then
	begin
		select CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ds_retorno_w
		from 	PEP_PAC_CI
		where 	nr_atendimento = nr_atendimento_p
		and 	cd_profissional = cd_profissional_p
		and 	ie_tipo_consentimento = 'T';
	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ie_consent_avail ( nr_atendimento_p bigint, cd_profissional_p text) FROM PUBLIC;

