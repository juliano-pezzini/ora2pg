-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_etapa_gas ( nr_seq_gasoterapia_p bigint, nr_etapa_p bigint, dt_fim_horario_p timestamp, dt_suspensao_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_status_etapa_w	varchar(5);
ie_evento_atual_w	varchar(5);
ie_inicio_w			prescr_gasoterapia.ie_inicio%type;


BEGIN

if (dt_fim_horario_p IS NOT NULL AND dt_fim_horario_p::text <> '') then
	ie_status_etapa_w := 'A';
elsif (dt_suspensao_p IS NOT NULL AND dt_suspensao_p::text <> '') then
	ie_status_etapa_w := 'S';
else

	select	coalesce(ie_evento,'N')
	into STRICT	ie_evento_atual_w
	from	prescr_gasoterapia_evento
	where	nr_seq_gasoterapia = nr_seq_gasoterapia_p
	and		coalesce(ie_evento_valido,'N') = 'S'
	and		nr_etapa_evento = coalesce(nr_etapa_p,1)
	and		nr_sequencia = (	SELECT	max(nr_sequencia)
								from	prescr_gasoterapia_evento
								where	nr_seq_gasoterapia = nr_seq_gasoterapia_p
								and 	coalesce(ie_evento_valido,'N') = 'S'
								and		nr_etapa_evento = coalesce(nr_etapa_p,1)
								and 	ie_evento <> 'CR');

	if (ie_evento_atual_w = 'I') then
		ie_status_etapa_w := 'I';
	elsif (ie_evento_atual_w = 'IN') then
		ie_status_etapa_w := 'T';
	elsif (ie_evento_atual_w = 'R') then
		ie_status_etapa_w := 'I';
	elsif (ie_evento_atual_w = 'TE') then
		ie_Status_etapa_w := 'TE';
	end if;
end if;

return	coalesce(ie_status_etapa_w,'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_etapa_gas ( nr_seq_gasoterapia_p bigint, nr_etapa_p bigint, dt_fim_horario_p timestamp, dt_suspensao_p timestamp) FROM PUBLIC;
