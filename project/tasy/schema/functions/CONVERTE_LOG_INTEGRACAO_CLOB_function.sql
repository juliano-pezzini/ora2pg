-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_log_integracao_clob ( nr_sequencia_p bigint, ie_integracao_p text) RETURNS text AS $body$
DECLARE


ds_retorno_w text;

c01 CURSOR FOR
SELECT	ds_xml ds_conteudo
from	log_integracao_xml
where	nr_sequencia = nr_sequencia_p
and	ie_integracao_p = 'XML'

union all

SELECT	ds_hl7
from	log_integracao_hl7
where	nr_sequencia = nr_sequencia_p
and	ie_integracao_p = 'HL7';

vet01 c01%rowtype;


BEGIN

open c01;
begin
 fetch	c01 into vet01;
 ds_retorno_w := (vet01.ds_conteudo);
 close c01;
exception when others then 
 if (c01%isopen) then
	close c01;
 end if;
end;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_log_integracao_clob ( nr_sequencia_p bigint, ie_integracao_p text) FROM PUBLIC;
