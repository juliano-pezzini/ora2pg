-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_solic_recebida ( nr_solic_compra_p bigint) RETURNS varchar AS $body$
DECLARE

 
dt_recebimento_w	timestamp;
ie_recebimento_w	varchar(1) := 'N';

BEGIN
 
select	dt_recebimento 
into STRICT	dt_recebimento_w 
from	solic_compra 
where	nr_solic_compra = nr_solic_compra_p;
 
if (dt_recebimento_w IS NOT NULL AND dt_recebimento_w::text <> '') then 
	ie_recebimento_w := 'S';
end if;
 
return	ie_recebimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_solic_recebida ( nr_solic_compra_p bigint) FROM PUBLIC;

