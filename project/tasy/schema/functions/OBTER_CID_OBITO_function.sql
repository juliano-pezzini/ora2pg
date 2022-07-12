-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cid_obito (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

cd_cid_direta_w		varchar(10);


BEGIN

begin
select 	max(cd_cid_direta)
into STRICT	cd_cid_direta_w
from 	declaracao_obito
where 	nr_atendimento = nr_atendimento_p;
exception
	when others then
	cd_cid_direta_w:= '';
end;

return cd_cid_direta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cid_obito (nr_atendimento_p bigint) FROM PUBLIC;
