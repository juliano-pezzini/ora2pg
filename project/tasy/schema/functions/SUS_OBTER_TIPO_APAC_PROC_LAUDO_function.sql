-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_tipo_apac_proc_laudo (cd_procedimento_p sus_procedimento.cd_procedimento%type, ie_origem_proced_p sus_procedimento.ie_origem_proced%type) RETURNS varchar AS $body$
DECLARE


ie_tipo_laudo_apac_w		sus_procedimento.ie_tipo_laudo_apac%type;
ds_retorno_w			bigint := 0;


BEGIN

select	coalesce(max(ie_tipo_laudo_apac),'0')
into STRICT	ie_tipo_laudo_apac_w
from	sus_procedimento
where	ie_origem_proced = ie_origem_proced_p
and	cd_procedimento = cd_procedimento_p;

if (coalesce(ie_tipo_laudo_apac_w,'0') > '0') then
	begin
	if (ie_tipo_laudo_apac_w = '01') then
		ds_retorno_w := 12;
	elsif (ie_tipo_laudo_apac_w = '02') then
		ds_retorno_w := 8;
	elsif (ie_tipo_laudo_apac_w = '03') then
		ds_retorno_w := 1;
	elsif (ie_tipo_laudo_apac_w = '04') then
		ds_retorno_w := 2;
	elsif (ie_tipo_laudo_apac_w = '06') then
		ds_retorno_w := 12;
	elsif (ie_tipo_laudo_apac_w = '07') then
		ds_retorno_w := 22;
	elsif (ie_tipo_laudo_apac_w = '10') then
		ds_retorno_w := 8;
	elsif (ie_tipo_laudo_apac_w = '12') then
		ds_retorno_w := 19;
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_tipo_apac_proc_laudo (cd_procedimento_p sus_procedimento.cd_procedimento%type, ie_origem_proced_p sus_procedimento.ie_origem_proced%type) FROM PUBLIC;

