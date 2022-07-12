-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nf_tit_unif (nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_titulo_w			titulo_pagar.nr_titulo%type;
nr_nf_w				titulo_pagar.nr_seq_nota_fiscal%type;
nr_nota_fiscal_w	nota_fiscal.nr_nota_fiscal%type;

C01 CURSOR FOR
	SELECT	nr_titulo
	from	titulo_pagar
	where	nr_titulo_dest = nr_titulo_p
	order by nr_titulo;

BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

			if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then

				select	max(nr_seq_nota_fiscal)
				into STRICT	nr_nf_w
				from	titulo_pagar
				where	nr_titulo = nr_titulo_w;

				if (nr_nf_w IS NOT NULL AND nr_nf_w::text <> '') then
					select 	max(nr_nota_fiscal)
					into STRICT	nr_nota_fiscal_w
					from	nota_fiscal
					where 	nr_sequencia = nr_nf_w;

				end if;

				if (nr_nota_fiscal_w IS NOT NULL AND nr_nota_fiscal_w::text <> '') then
					if (coalesce(ds_retorno_w::text, '') = '') then
						ds_retorno_w := substr(nr_titulo_w||'/'||nr_nota_fiscal_w,1,255);
					else
						ds_retorno_w := substr(ds_retorno_w || ',  ' || nr_titulo_w||'/'||nr_nota_fiscal_w,1,255);
					end if;
				end if;
			end if;
		end;
	end loop;
	close C01;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nf_tit_unif (nr_titulo_p bigint) FROM PUBLIC;
