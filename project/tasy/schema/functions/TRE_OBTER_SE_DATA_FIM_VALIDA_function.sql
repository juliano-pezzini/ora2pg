-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tre_obter_se_data_fim_valida ( dt_parametro_p timestamp, nr_seq_evento_p bigint, dt_fim_real_p timestamp, dt_fim_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1) := 'N';


BEGIN
if (dt_parametro_p IS NOT NULL AND dt_parametro_p::text <> '') and (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') and
	((dt_fim_real_p IS NOT NULL AND dt_fim_real_p::text <> '') or (dt_fim_p IS NOT NULL AND dt_fim_p::text <> '')) then

	if ((tre_obter_ultima_data_presenca(nr_seq_evento_p) IS NOT NULL AND (tre_obter_ultima_data_presenca(nr_seq_evento_p))::text <> '')) then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	
	where	dt_parametro_p <= tre_obter_ultima_data_presenca(nr_seq_evento_p);

	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tre_obter_se_data_fim_valida ( dt_parametro_p timestamp, nr_seq_evento_p bigint, dt_fim_real_p timestamp, dt_fim_p timestamp) FROM PUBLIC;
