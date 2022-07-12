-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_estag_aut_readonly (nr_seq_estagio_p bigint) RETURNS varchar AS $body$
DECLARE


ie_somente_leitura_w	estagio_autorizacao.ie_somente_leitura%type;


BEGIN

begin
select 	ie_somente_leitura
into STRICT	ie_somente_leitura_w
from   	estagio_autorizacao
where  	nr_sequencia = nr_seq_estagio_p  LIMIT 1;
exception
when others then
	ie_somente_leitura_w	:= 'N';
end;

return	ie_somente_leitura_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_estag_aut_readonly (nr_seq_estagio_p bigint) FROM PUBLIC;
