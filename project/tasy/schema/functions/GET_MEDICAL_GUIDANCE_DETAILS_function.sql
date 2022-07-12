-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_medical_guidance_details ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
ie_opcao_p  CD - Code
DS - Description
*/
ds_return_w varchar(255);

BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '' AND ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then

if ( ie_opcao_p = 'CD') then

select max(cd_procedimento)
into STRICT ds_return_w
from medical_guidance_order
where nr_sequencia = nr_sequencia_p;

end if;

if ( ie_opcao_p = 'DS') then
select Obter_Desc_Procedimento(cd_procedimento,ie_origem_proced)
into STRICT ds_return_w
from medical_guidance_order
where nr_sequencia = nr_sequencia_p;
end if;

end if;
return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_medical_guidance_details ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

