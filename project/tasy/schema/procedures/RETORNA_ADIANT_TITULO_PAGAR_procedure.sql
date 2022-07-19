-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE retorna_adiant_titulo_pagar ( nr_titulo_p bigint, nr_adiantamentos_p INOUT text, vl_adiantamentos_p INOUT text, nm_fornec_adiant_pago_p INOUT text, nr_ordem_compra_adiant_p INOUT text ) AS $body$
DECLARE



ds_temp_w			varchar(255);
ds_temp2_w			varchar(255);
nr_adiantamento_w		varchar(255);
vl_adiantamento_w		varchar(255);
nm_fornec_adiant_pago_w		varchar(255);
nr_ordem_compra_adiant_w	varchar(255);
primeiro_registro_w		boolean := True;

c01 CURSOR FOR
	SELECT	nr_adiantamento
	from titulo_pagar_adiant
	where nr_titulo = nr_titulo_p;

c02 CURSOR FOR
	SELECT	vl_adiantamento
	from titulo_pagar_adiant
	where nr_titulo = nr_titulo_p;

BEGIN

open c01;
loop
fetch c01 into
ds_temp_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (primeiro_registro_w) then
		begin
		primeiro_registro_w := False;
		nr_adiantamento_w   := coalesce(ds_temp_w,0);

		select	max(obter_nome_pf_pj('',cd_cgc))
		into STRICT	nm_fornec_adiant_pago_w
		from	adiantamento_pago
		where	nr_adiantamento = coalesce(ds_temp_w,0);

		select	max(nr_ordem_compra)
		into STRICT	nr_ordem_compra_adiant_w
		from	ordem_compra_adiant_pago
		where	nr_adiantamento = coalesce(ds_temp_w,0);

		end;
	else
		begin
		nr_adiantamento_w   := substr(nr_adiantamento_w || ', ' || ds_temp_w,1,255);

		select	max(obter_nome_pf_pj('',cd_cgc))
		into STRICT	ds_temp2_w
		from	adiantamento_pago
		where	nr_adiantamento = coalesce(ds_temp_w,0);

		if (nm_fornec_adiant_pago_w IS NOT NULL AND nm_fornec_adiant_pago_w::text <> '') then
			begin
			nm_fornec_adiant_pago_w := substr(nm_fornec_adiant_pago_w || ', ' || ds_temp2_w,1,255);
			end;
		else
			begin
			nm_fornec_adiant_pago_w := substr(ds_temp2_w,1,255);
			end;
		end if;


		select	max(nr_ordem_compra)
		into STRICT	ds_temp2_w
		from	ordem_compra_adiant_pago
		where	nr_adiantamento = coalesce(ds_temp_w,0);

		if (nr_ordem_compra_adiant_w IS NOT NULL AND nr_ordem_compra_adiant_w::text <> '') then
			begin
			nr_ordem_compra_adiant_w := substr(nr_ordem_compra_adiant_w || ', ' || ds_temp2_w,1,255);
			end;
		else
			begin
			nr_ordem_compra_adiant_w := substr(ds_temp2_w,1,255);
			end;
		end if;

		end;
	end if;

	end;
end loop;
close c01;

primeiro_registro_w := True;
open c02;
loop
fetch c02 into
ds_temp_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	if (primeiro_registro_w) then
		begin
		primeiro_registro_w := False;
		vl_adiantamento_w   := ds_temp_w;
		end;
	else
		begin

		if (vl_adiantamento_w IS NOT NULL AND vl_adiantamento_w::text <> '') then
			begin
			vl_adiantamento_w   := substr(vl_adiantamento_w || ', ' || ds_temp_w,1,255);
			end;
		else
			begin
			vl_adiantamento_w   := substr(ds_temp_w,1,255);
			end;
		end if;

		end;
	end if;
	end;
end loop;
close c02;

nr_adiantamentos_p       := substr(nr_adiantamento_w,1,255);
vl_adiantamentos_p       := substr(vl_adiantamento_w,1,255);
nm_fornec_adiant_pago_p  := substr(nm_fornec_adiant_pago_w,1,255);
nr_ordem_compra_adiant_p := substr(nr_ordem_compra_adiant_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE retorna_adiant_titulo_pagar ( nr_titulo_p bigint, nr_adiantamentos_p INOUT text, vl_adiantamentos_p INOUT text, nm_fornec_adiant_pago_p INOUT text, nr_ordem_compra_adiant_p INOUT text ) FROM PUBLIC;

