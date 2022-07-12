-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proximo_agrup_supl (nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


nr_agrupamento_w	double precision;


BEGIN

select		coalesce(max(a.nr_agrupamento),0)
into STRICT		nr_agrupamento_w
from		material b,
		prescr_material a
where		a.nr_prescricao 		= nr_prescricao_p
  and		a.cd_material			= b.cd_material
  --and		ie_tipo_material		> 1
  and		ie_agrupador			= 12
  and		coalesce(nr_sequencia_dieta::text, '') = ''
  and		coalesce(nr_sequencia_proc::text, '') = ''
  and		coalesce(nr_sequencia_solucao::text, '') = ''
  and		coalesce(nr_sequencia_diluicao::text, '') = '';


nr_agrupamento_w	:= nr_agrupamento_w + 1;

Return nr_agrupamento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proximo_agrup_supl (nr_prescricao_p bigint) FROM PUBLIC;

