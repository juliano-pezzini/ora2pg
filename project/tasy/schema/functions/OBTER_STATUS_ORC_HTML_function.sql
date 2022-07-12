-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_orc_html ( nr_seq_tabela_p bigint, ie_meses_anteriores_p text, ie_atualiza_custo_p text, cd_estabelecimento_p bigint, ie_verif_p bigint) RETURNS varchar AS $body$
DECLARE


dt_mes_referencia_w	timestamp;
dt_referencia_w		timestamp;
ie_retorno_w 		varchar(1) := 'N';
ie_resultado_w		varchar(1) := 'N';


BEGIN

select 	dt_mes_referencia
into STRICT	dt_mes_referencia_w
from 	tabela_custo
where 	nr_sequencia = nr_seq_tabela_p;

if (nr_seq_tabela_p IS NOT NULL AND nr_seq_tabela_p::text <> '' AND dt_mes_referencia_w IS NOT NULL AND dt_mes_referencia_w::text <> '') then

	select	max(dt_referencia)
	into STRICT	dt_referencia_w
	from 	parametro_custo y
	where 	cd_estabelecimento = cd_estabelecimento_p;
	
	if (((dt_referencia_w IS NOT NULL AND dt_referencia_w::text <> '') and dt_referencia_w > dt_mes_referencia_w and
		ie_meses_anteriores_p <> 'S') or ie_atualiza_custo_p <> 'S') then
		ie_resultado_w := 'S';
	else
		ie_resultado_w := 'N';
	end if;
	
	if (ie_verif_p = 1) then
		ie_retorno_w := ie_resultado_w;
	else
		if (ie_resultado_w = 'N') then
			ie_retorno_w := 'S';
		else
			ie_retorno_w := 'N';
		end if;
	end if;
else
	if (ie_verif_p = 1) then
		ie_retorno_w := 'S';
	else
		ie_retorno_w := 'N';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_orc_html ( nr_seq_tabela_p bigint, ie_meses_anteriores_p text, ie_atualiza_custo_p text, cd_estabelecimento_p bigint, ie_verif_p bigint) FROM PUBLIC;
