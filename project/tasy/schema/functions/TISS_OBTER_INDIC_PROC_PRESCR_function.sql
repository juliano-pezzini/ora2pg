-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_indic_proc_prescr (nr_prescricao_p bigint, nr_seq_proc_prescr_p bigint, ie_tiss_tipo_guia_p text) RETURNS varchar AS $body$
DECLARE


/*ie_opcao_p
I	- Indicação clínica do procedimento na prescrição
*/
ds_retorno_w	varchar(255) := null;

BEGIN

if (ie_tiss_tipo_guia_p = '4') then --Somente retorno se for SADT, para não ter problema de duplicidade
	begin
	select	substr(ds_dado_clinico,1,255)
	into STRICT	ds_retorno_w
	from	prescr_procedimento
	where	nr_prescricao	= nr_prescricao_p
	and	nr_sequencia	= nr_seq_proc_prescr_p  LIMIT 1;
	exception
		when others then
		ds_retorno_w := null;
	end;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_indic_proc_prescr (nr_prescricao_p bigint, nr_seq_proc_prescr_p bigint, ie_tiss_tipo_guia_p text) FROM PUBLIC;
