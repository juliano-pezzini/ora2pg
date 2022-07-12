-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_conv_rec ( nr_interno_conta_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
DTR - Data do recebimento
VLR - Valor recebimento
*/
ds_retorno_w		varchar(255);
nr_seq_receb_w		double precision;
vl_retorno_w		double precision;
dt_retorno_w		timestamp;


BEGIN
select	max(nr_seq_receb)
into STRICT	nr_seq_receb_w
from	convenio_retorno_item
where	nr_interno_conta	= nr_interno_conta_p;

if (ie_opcao_p	= 'DTR') then
	select	dt_recebimento
	into STRICT	dt_retorno_w
	from	convenio_receb
	where	nr_Sequencia	= nr_seq_receb_w;
	ds_retorno_w		:= dt_retorno_w;
elsif (ie_opcao_p	= 'VLR') then
	select	vl_vinculacao
	into STRICT	vl_retorno_w
	from	convenio_ret_receb
	where	nr_Seq_receb	= nr_seq_receb_w;
	ds_retorno_w		:= vl_retorno_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_conv_rec ( nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;
