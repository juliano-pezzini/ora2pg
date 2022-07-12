-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_indic_clinica_mat_prescr (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);

BEGIN

if (coalesce(nr_prescricao_p,0) > 0) and (coalesce(nr_seq_prescricao_p,0) > 0) then

	if (ie_opcao_p = 'D') then
		begin
		select	substr(obter_valor_dominio(1927,ie_indicacao),1,255)
		into STRICT	ds_retorno_w
		from	prescr_material
		where	nr_prescricao 	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_prescricao_p;
		exception
		when others then
			ds_retorno_w := null;
		end;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_indic_clinica_mat_prescr (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_opcao_p text) FROM PUBLIC;
