-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_verificar_crm_medico_web ( nr_crm_p text, nr_seq_conselho_p bigint, uf_crm_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    	varchar(1) := 'N';
qt_registros_w		bigint;


BEGIN

select  count(1)
into STRICT	qt_registros_w
from	pessoa_fisica a,
	medico b
where 	a.cd_pessoa_fisica = b.cd_pessoa_fisica
and	b.nr_crm = nr_crm_p
and	b.uf_crm = uf_crm_p
and	a.nr_seq_conselho  = nr_seq_conselho_p;

if (qt_registros_w > 0) then
	ds_retorno_w := 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_verificar_crm_medico_web ( nr_crm_p text, nr_seq_conselho_p bigint, uf_crm_p text) FROM PUBLIC;

