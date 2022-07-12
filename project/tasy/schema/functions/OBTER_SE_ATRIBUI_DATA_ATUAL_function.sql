-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atribui_data_atual ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(10);
ie_verifica_w	bigint;

BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') then
	select	mod(count(*),2)
	into STRICT	ie_verifica_w
	from	prescr_solucao_evento
	where	nr_prescricao = nr_prescricao_p
	and	ie_tipo_solucao = 1
	and	ie_evento_valido = 'S'
	and	ie_alteracao in (1,2,3,4,35)
	and	nr_seq_solucao	= nr_seq_solucao_p;
	if (ie_verifica_w > 0) then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;
end if;

return coalesce(ds_retorno_w,'N');
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atribui_data_atual ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
