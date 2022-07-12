-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_evento_adep ( ie_tipo_item_p text, nr_seq_mat_p bigint, nr_seq_sol_p bigint, nr_seq_gas_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255)	:= '';


BEGIN


begin
	if (nr_seq_sol_p IS NOT NULL AND nr_seq_sol_p::text <> '') then

        select	substr(obter_desc_evento_sol(nr_seq_sol_p),1,255)
		into STRICT	ds_retorno_w
		;

	elsif (nr_seq_mat_p IS NOT NULL AND nr_seq_mat_p::text <> '') then

        select	substr(obter_valor_dominio(1620,ie_alteracao),1,255)
		into STRICT	ds_retorno_w
		from	prescr_mat_alteracao
		where	nr_sequencia = nr_seq_mat_p;

	elsif (nr_seq_gas_p IS NOT NULL AND nr_seq_gas_p::text <> '') then

        select	substr(obter_valor_dominio(2702,ie_evento),1,255)
		into STRICT	ds_retorno_w
		from	prescr_gasoterapia_evento
	    where	nr_sequencia = nr_seq_gas_p;

	end if;

exception when others then
	null;
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_evento_adep ( ie_tipo_item_p text, nr_seq_mat_p bigint, nr_seq_sol_p bigint, nr_seq_gas_p bigint) FROM PUBLIC;

