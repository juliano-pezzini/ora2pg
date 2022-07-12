-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_atual_medic_prescr ( nr_atendimento_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

SELECT	MAX(nr_sequencia)
INTO STRICT	nr_sequencia_w
FROM	gedi_medic_atend
WHERE	nr_atendimento	= nr_atendimento_p
AND	coalesce(cd_material_prescrito,cd_material)	= cd_material_p;

RETURN nr_sequencia_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_atual_medic_prescr ( nr_atendimento_p bigint, cd_material_p bigint) FROM PUBLIC;
