-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nf_bem_equipamento ( nr_seq_equipamento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_nf_w		bigint;
nr_seq_bem_w		bigint;
nr_seq_retorno_w	bigint;


BEGIN

select	coalesce(max(nr_seq_bem),0)
into STRICT	nr_seq_bem_w
from	man_equipamento
where	nr_sequencia = nr_seq_equipamento_p;

if (nr_seq_bem_w <> 0) then
	begin

	select	coalesce(max(nr_seq_nota_fiscal),0)
	into STRICT	nr_seq_nf_w
	from	pat_bem
	where	nr_sequencia = nr_seq_bem_w;

	if (nr_seq_nf_w <> 0) then
		nr_seq_retorno_w	:= nr_seq_nf_w;
	end if;

	end;
end if;

return	nr_seq_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nf_bem_equipamento ( nr_seq_equipamento_p bigint) FROM PUBLIC;
