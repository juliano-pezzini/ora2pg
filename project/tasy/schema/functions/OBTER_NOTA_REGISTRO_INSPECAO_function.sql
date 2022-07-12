-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nota_registro_inspecao (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_nf_w		bigint;
nr_nota_fiscal_w		varchar(255);


BEGIN

select	coalesce(max(nr_seq_nf),0)
into STRICT	nr_seq_nf_w
from	inspecao_registro
where	nr_sequencia = nr_sequencia_p;

if (nr_seq_nf_w > 0) then
	select	nr_nota_fiscal
	into STRICT	nr_nota_fiscal_w
	from	nota_fiscal
	where	nr_sequencia = nr_seq_nf_w;
else
	select	max(nr_nota_fiscal)
	into STRICT	nr_nota_fiscal_w
	from	inspecao_recebimento
	where	nr_seq_registro = nr_sequencia_p;
end if;

return	nr_nota_fiscal_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nota_registro_inspecao (nr_sequencia_p bigint) FROM PUBLIC;
