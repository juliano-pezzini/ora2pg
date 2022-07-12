-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_impr_prescr_lista ( nr_prescricao_p bigint, cd_local_estoque_p text) RETURNS bigint AS $body$
DECLARE


qt_imprime_w			bigint := 0;


BEGIN

select	count(*)
into STRICT	qt_imprime_w
from	prescr_medica
where	coalesce(dt_emissao_farmacia::text, '') = ''
and	nr_prescricao 	= nr_prescricao_p
and	not exists (	SELECT	1
			from	Prescr_emissao_local b
			where	b.nr_prescricao		= nr_prescricao_p
			and (obter_se_contido(b.cd_local_estoque, cd_local_estoque_p) = 'S'));

return qt_imprime_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_impr_prescr_lista ( nr_prescricao_p bigint, cd_local_estoque_p text) FROM PUBLIC;

