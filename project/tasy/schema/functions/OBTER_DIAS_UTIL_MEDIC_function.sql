-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dias_util_medic ( nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE

nr_dia_util_w	bigint;


BEGIN

select	coalesce(nr_dia_util,0)
into STRICT	nr_dia_util_w
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia	= nr_sequencia_p;

RETURN nr_dia_util_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dias_util_medic ( nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
