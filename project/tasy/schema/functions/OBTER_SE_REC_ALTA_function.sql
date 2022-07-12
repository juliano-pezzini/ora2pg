-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_rec_alta ( nr_prescricao_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


ie_rec_alta_w	char(1) := 'N';

BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	select 	coalesce(max('S') ,'N')
	into STRICT 	ie_rec_alta_w
	from   	tipo_recomendacao b,
		prescr_recomendacao a where	b.cd_tipo_recomendacao 		= a.cd_recomendacao
	and    	a.nr_prescricao  		= nr_prescricao_p
	and    	coalesce(ie_recomendacao_alta, 'N') 	= 'S'
	and	a.nr_sequencia	 		= nr_seq_item_p LIMIT 1;
end if;

return	ie_rec_alta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_rec_alta ( nr_prescricao_p bigint, nr_seq_item_p bigint) FROM PUBLIC;

