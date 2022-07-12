-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_retorno_convenio (nr_seq_retorno_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(100);


BEGIN

if (nr_seq_retorno_item_p IS NOT NULL AND nr_seq_retorno_item_p::text <> '') then
	begin

	select	to_char(a.nr_sequencia) || ' - ' ||
		to_char(a.dt_retorno,'dd/mm/yyyy') || ' - ' ||
		b.cd_autorizacao
	into STRICT	ds_retorno_w
	from	convenio_retorno a,
		convenio_retorno_item b
	where	a.nr_sequencia		= b.nr_seq_retorno
	and	b.nr_sequencia		= nr_seq_retorno_item_p;

	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_retorno_convenio (nr_seq_retorno_item_p bigint) FROM PUBLIC;
