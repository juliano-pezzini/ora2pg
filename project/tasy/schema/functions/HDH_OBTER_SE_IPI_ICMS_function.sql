-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hdh_obter_se_ipi_icms (nr_seq_nota_p bigint, nr_item_nf_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registro_IPI_w 		bigint;
qt_registro_ICMS_w 		bigint;
qt_registro_w			bigint;
ds_retorno_w			varchar(10);


BEGIN

select 	count(*)
into STRICT 	qt_registro_w
from	nota_fiscal_item_trib a,
		tributo b
where	a.cd_tributo = b.cd_tributo
and		a.nr_sequencia = nr_seq_nota_p;

if (qt_registro_w > 0) then

	if (coalesce(nr_item_nf_p,0) <> 0) then

		select 	count(*)
		into STRICT 	qt_registro_IPI_w
		from 	nota_fiscal_item a,
			nota_fiscal_item_trib b,
			tributo c
		where	a.nr_sequencia = b.nr_sequencia
		and	a.nr_item_nf = b.nr_item_nf
		and	a.nr_sequencia = nr_seq_nota_p
		and	a.nr_item_nf  = nr_item_nf_p
		and	b.cd_tributo = c.cd_tributo
		and	c.ie_tipo_tributo = 'IPI';

		select 	count(*)
		into STRICT 	qt_registro_ICMS_w
		from 	nota_fiscal_item a,
			nota_fiscal_item_trib b,
			tributo c
		where	a.nr_sequencia = b.nr_sequencia
		and	a.nr_item_nf = b.nr_item_nf
		and	a.nr_sequencia = nr_seq_nota_p
		and	a.nr_item_nf  = nr_item_nf_p
		and	b.cd_tributo = c.cd_tributo
		and	c.ie_tipo_tributo = 'ICMS';

	else

		select 	count(*)
		into STRICT 	qt_registro_IPI_w
		from 	nota_fiscal_item a,
			nota_fiscal_item_trib b,
			tributo c
		where	a.nr_sequencia = b.nr_sequencia
		and	a.nr_item_nf = b.nr_item_nf
		and	a.nr_sequencia = nr_seq_nota_p
		and	b.cd_tributo = c.cd_tributo
		and	c.ie_tipo_tributo = 'IPI';

		select 	count(*)
		into STRICT 	qt_registro_ICMS_w
		from 	nota_fiscal_item a,
			nota_fiscal_item_trib b,
			tributo c
		where	a.nr_sequencia = b.nr_sequencia
		and	a.nr_item_nf = b.nr_item_nf
		and	a.nr_sequencia = nr_seq_nota_p
		and	b.cd_tributo = c.cd_tributo
		and	c.ie_tipo_tributo = 'ICMS';

	end if;

	if (qt_registro_IPI_w > 0) and (qt_registro_ICMS_w = 0) then
		ds_retorno_w := 'IPI';
	elsif (qt_registro_IPI_w = 0) and (qt_registro_ICMS_w > 0) then
		ds_retorno_w := 'ICMS';
	elsif (qt_registro_IPI_w > 0) and (qt_registro_ICMS_w > 0) then
		ds_retorno_w := 'IPI/ICMS';
	end if;

else
	ds_retorno_w := 'ICMS';
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hdh_obter_se_ipi_icms (nr_seq_nota_p bigint, nr_item_nf_p bigint) FROM PUBLIC;

