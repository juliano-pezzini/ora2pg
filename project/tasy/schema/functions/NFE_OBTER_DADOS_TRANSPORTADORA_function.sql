-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nfe_obter_dados_transportadora (nr_sequencia_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(10);

/*Tipo retorno:
EX - Se existe transportadora para a nota
TF - Tipo Frete
*/
BEGIN

if (ie_tipo_p = 'EX') then
	select  case
          		when count(*) >= 1
          		then 'S'
          		else 'N'
        	end  existe
	into STRICT	ds_retorno_w
	from    nota_fiscal_transportadora a,
	      	nota_fiscal b
	where   a.nr_seq_nota = b.nr_sequencia
	and	    a.nr_seq_nota = nr_sequencia_p;
elsif (ie_tipo_p = 'TF') then
	select  min(nr_sequencia)
	into STRICT	ds_retorno_w
	from    nota_fiscal_transportadora a
	where   a.nr_seq_nota = nr_sequencia_p;

	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		select  max(ie_tipo_frete)
		into STRICT	ds_retorno_w
		from    nota_fiscal_transportadora a
		where   a.nr_sequencia = ds_retorno_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nfe_obter_dados_transportadora (nr_sequencia_p bigint, ie_tipo_p text) FROM PUBLIC;
