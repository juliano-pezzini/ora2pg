-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cotado ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) RETURNS varchar AS $body$
DECLARE


/*Se o nr_item_solic_compra_p for zero, é para saber se todos os itens da cotação de compras estão cotados
    Se o nr_item_solic_compra_p for <> zero, é para saber se aquele item ja foi cotado*/
ie_existe_w			varchar(1) := 'N';
qt_existe_w			bigint;
nr_cot_compra_w			bigint;
nr_item_cot_compra_w		integer;

c01 CURSOR FOR
SELECT	nr_cot_compra,
	nr_item_cot_compra
from	cot_compra_item
where	nr_solic_compra = nr_solic_compra_p
and (nr_item_solic_compra = nr_item_solic_compra_p or nr_item_solic_compra_p = 0);


BEGIN

/*Para saber se o item está cotado em alguma cotação de compras
Se retornar N é porque o item não está cotado em nenhuma cotação*/
if (nr_item_solic_compra_p > 0) then

	open C01;
	loop
	fetch C01 into
		nr_cot_compra_w,
		nr_item_cot_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (ie_existe_w = 'N') then
			select	count(*)
			into STRICT	qt_existe_w
			from	cot_compra_forn_item
			where	nr_cot_compra = nr_cot_compra_w
			and	nr_item_cot_compra = nr_item_cot_compra_w;

			if (qt_existe_w > 0) then
				ie_existe_w := 'S';
			end if;
		end if;
		end;
	end loop;
	close C01;
/*Para saber se todos os itens da solicitação estão cotados.
Se retornar N é porque nenhum item da solicitação foi cotado, se retornar S é porque algum item já foi cotado*/
else
	open C01;
	loop
	fetch C01 into
		nr_cot_compra_w,
		nr_item_cot_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (ie_existe_w = 'N') then
			select	count(*)
			into STRICT	qt_existe_w
			from	cot_compra_forn_item
			where	nr_cot_compra = nr_cot_compra_w
			and	nr_item_cot_compra = nr_item_cot_compra_w;

			if (qt_existe_w > 0) then
				ie_existe_w := 'S';
			end if;
		end if;
		end;
	end loop;
	close C01;
end if;

return	ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cotado ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) FROM PUBLIC;

