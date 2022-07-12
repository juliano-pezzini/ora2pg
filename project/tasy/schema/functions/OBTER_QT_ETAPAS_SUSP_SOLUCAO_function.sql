-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_etapas_susp_solucao ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_tipo_solucao_p bigint, nr_etapa_atual_p bigint) RETURNS bigint AS $body$
DECLARE

--Os parâmetros abaixo não serão utilizados incialmente
--ie_tipo_solucao_p
--nr_etapa_atual_p
qt_etapas_susp_w	smallint	:= 0;


BEGIN

select	count(distinct nr_etapa_sol)
into STRICT	qt_etapas_susp_w
from	prescr_mat_hor
where	nr_prescricao = nr_prescricao_p
and		nr_seq_solucao = nr_seq_solucao_p
and		(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '')
and		ie_agrupador = 4
and		coalesce(ie_horario_especial, 'S') = 'N';

return	qt_etapas_susp_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_etapas_susp_solucao ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_tipo_solucao_p bigint, nr_etapa_atual_p bigint) FROM PUBLIC;
