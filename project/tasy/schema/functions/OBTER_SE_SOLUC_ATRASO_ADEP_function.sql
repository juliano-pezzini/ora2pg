-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_soluc_atraso_adep ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_status_hor_p text, qt_minutos_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(1) := 'N';

-- Utilizada no drawcollumncell  ADEP
-- Retorna "S" se estiver atrasado
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_status_hor_p IS NOT NULL AND ie_status_hor_p::text <> '') and (qt_minutos_p IS NOT NULL AND qt_minutos_p::text <> '') then

	select 	coalesce(max('N'),'S')
	into STRICT	ds_retorno_w
	from 	prescr_mat_hor
	where 	nr_prescricao = nr_prescricao_p
	and     nr_seq_solucao = nr_sequencia_p
	and 	dt_horario + qt_minutos_p / 1440 > clock_timestamp();

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_soluc_atraso_adep ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_status_hor_p text, qt_minutos_p bigint) FROM PUBLIC;
