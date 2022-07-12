-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_conta_banco_tipo (nr_seq_tipo_conta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_tipo_conta_w		varchar(254);


BEGIN

begin
select	ds_tipo_conta
into STRICT	ds_tipo_conta_w
from	conta_banco_tipo
where	nr_sequencia	= nr_seq_tipo_conta_p;
exception
	when others then
		ds_tipo_conta_w	:= '';
end;

return	ds_tipo_conta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_conta_banco_tipo (nr_seq_tipo_conta_p bigint) FROM PUBLIC;

