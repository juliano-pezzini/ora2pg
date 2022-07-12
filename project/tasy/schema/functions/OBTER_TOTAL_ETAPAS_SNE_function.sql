-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_etapas_sne ( nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_etapas_w		bigint := 0;

BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	count(1)
	into STRICT	nr_etapas_w
	from	prescr_mat_hor
	where	coalesce(dt_suspensao::text, '') = ''
	and		coalesce(ie_situacao,'A') = 'A'
	and		coalesce(ie_horario_especial,'N') = 'N'
	and		ie_agrupador = 8
	and		nr_seq_material = nr_sequencia_p
	and		nr_prescricao = nr_prescricao_p;
end if;

return	nr_etapas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_etapas_sne ( nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
