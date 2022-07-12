-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_resp_financeiro ( nr_seq_fatura_p bigint) RETURNS varchar AS $body$
DECLARE

cd_unimed_destino_w		varchar(255);
nm_responsavel_w		varchar(255);
cd_cgc_w			varchar(14);
nr_seq_congenere_w		bigint;

BEGIN

select	max(cd_unimed_destino)
into STRICT	cd_unimed_destino_w
from	ptu_fatura
where	nr_sequencia	= nr_seq_fatura_p;

if (cd_unimed_destino_w IS NOT NULL AND cd_unimed_destino_w::text <> '') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_congenere_w
	from	pls_congenere
	where	cd_cooperativa = cd_unimed_destino_w;
	if (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
		select	pls_obter_coop_resp_financ(nr_seq_congenere_w,clock_timestamp())
		into STRICT	cd_cgc_w
		;

		if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_congenere_w
			from	pls_congenere
			where	cd_cgc = cd_cgc_w;
		end if;

		nm_responsavel_w	:= substr(pls_obter_nome_congenere(nr_seq_congenere_w),1,80);
	end if;
end if;

return	nm_responsavel_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_resp_financeiro ( nr_seq_fatura_p bigint) FROM PUBLIC;
