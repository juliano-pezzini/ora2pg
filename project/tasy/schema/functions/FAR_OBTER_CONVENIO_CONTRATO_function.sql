-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION far_obter_convenio_contrato ( nr_seq_contrato_conv_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		pessoa_juridica.ds_razao_social%type;
nr_seq_conv_venda_w	bigint;
cd_cgc_w		varchar(14);


BEGIN

select	nr_seq_conv_venda
into STRICT	nr_seq_conv_venda_w
from	far_contrato_conv
where	nr_sequencia = nr_seq_contrato_conv_p;

select	cd_cnpj
into STRICT	cd_cgc_w
from	far_convenio_venda
where	nr_sequencia = nr_seq_conv_venda_w;

if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
	begin

	select	ds_razao_social
	into STRICT	ds_retorno_w
	from	pessoa_juridica
	where	cd_cgc = cd_cgc_w;

	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION far_obter_convenio_contrato ( nr_seq_contrato_conv_p bigint) FROM PUBLIC;

