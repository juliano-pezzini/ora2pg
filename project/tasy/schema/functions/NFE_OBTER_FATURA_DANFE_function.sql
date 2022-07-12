-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nfe_obter_fatura_danfe (nr_nf bigint) RETURNS varchar AS $body$
DECLARE


c01 CURSOR FOR
	SELECT 	nr_titulo_pagar || ' ' ||
	       	dt_vencimento || ' ' ||
	       	to_char(vl_vencimento,'fm999999.0099') ds_fatura
	from  	nota_fiscal_venc a,
		nota_fiscal b,
		operacao_nota c
	where 	a.nr_sequencia = nr_nf
	and	a.nr_sequencia = b.nr_sequencia
	and	b.cd_operacao_nf = c.cd_operacao_nf
	and	coalesce(c.ie_envia_cobranca_sefaz,'S') = 'S';

ds_retorno_w	varchar(255);
ds_fatura_w	varchar(255);


BEGIN

open c01;
loop
fetch c01 into
	ds_fatura_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_retorno_w := ds_retorno_w || '   ' || ds_fatura_w;
	end;
end loop;
close c01;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nfe_obter_fatura_danfe (nr_nf bigint) FROM PUBLIC;

