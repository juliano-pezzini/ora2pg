-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_analise_som_visualiz ( nr_seq_conta_princ_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1)	:= 'N';
nr_seq_fatura_w		bigint;
ie_status_w		varchar(10);


BEGIN

select	max(nr_seq_fatura)
into STRICT	nr_seq_fatura_w
from	pls_conta
where	nr_sequencia = nr_seq_conta_princ_p;

if (coalesce(nr_seq_fatura_w,0) > 0) then

	select	max(ie_status)
	into STRICT	ie_status_w
	from	ptu_fatura
	where	nr_sequencia = nr_seq_fatura_w;

	if (ie_status_w <> 'V') then
		ds_retorno_w := 'S';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_analise_som_visualiz ( nr_seq_conta_princ_p bigint ) FROM PUBLIC;
