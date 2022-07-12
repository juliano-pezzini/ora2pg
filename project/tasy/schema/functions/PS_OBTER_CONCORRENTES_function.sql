-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ps_obter_concorrentes ( nr_seq_cliente_p bigint) RETURNS varchar AS $body$
DECLARE


nm_fantasia_w		varchar(80);
ds_produto_w		varchar(80);
ds_concorrente_w	varchar(165);
ds_concorrentes_w	varchar(2000);

c01 CURSOR FOR
SELECT	p.nm_fantasia,
	c.ds_produto
FROM com_fornec_sistema_ant f, com_prod_concorrente c
LEFT OUTER JOIN pessoa_juridica p ON (c.cd_cnpj = p.cd_cgc)
WHERE c.nr_sequencia = f.nr_seq_prod_conc and f.nr_seq_cliente = nr_seq_cliente_p and f.ie_sit_sist_conc = 'C' group by
	p.nm_fantasia,
	c.ds_produto
order by
	c.ds_produto,
	p.nm_fantasia;


BEGIN
if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') then
	begin
	open c01;
	loop
	fetch c01 into 	nm_fantasia_w,
			ds_produto_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (nm_fantasia_w IS NOT NULL AND nm_fantasia_w::text <> '') then
			begin
			ds_concorrente_w := ds_produto_w || ' (' || nm_fantasia_w || ')';
			end;
		else
			begin
			ds_concorrente_w := ds_produto_w;
			end;
		end if;


		if (coalesce(length(ds_concorrentes_w),0) <= 1835) then
			begin
			if (coalesce(ds_concorrentes_w::text, '') = '') then
				begin
				ds_concorrentes_w := ds_concorrente_w;
				end;
			else
				begin
				ds_concorrentes_w := ds_concorrentes_w || '; ' || ds_concorrente_w;
				end;
			end if;
			end;
		end if;
		end;
	end loop;
	close c01;
	end;
end if;
return ds_concorrentes_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ps_obter_concorrentes ( nr_seq_cliente_p bigint) FROM PUBLIC;

