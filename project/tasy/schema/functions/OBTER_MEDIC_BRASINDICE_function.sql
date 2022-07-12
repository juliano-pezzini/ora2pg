-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medic_brasindice ( CD_ESTABELECIMENTO_P bigint, CD_MATERIAL_P bigint, DT_VIGENCIA_P timestamp) RETURNS varchar AS $body$
DECLARE



cd_medicamento_w	varchar(06);
dt_vigencia_w		timestamp;
cd_brasindice_w		varchar(255);

C01 CURSOR FOR
	SELECT	CD_MEDICAMENTO
	FROM	MATERIAL_BRASINDICE
	WHERE	CD_MATERIAL			= CD_MATERIAL_P
	and	coalesce(IE_SITUACAO, 'A')	= 'A'
	and	coalesce(dt_vigencia,dt_vigencia_w)	<= dt_vigencia_w
	and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p, 0)) = coalesce(cd_estabelecimento_p, 0)
	order by coalesce(dt_vigencia,clock_timestamp() - interval '1000 days');


BEGIN

DT_VIGENCIA_W 	:= coalesce(DT_VIGENCIA_P,clock_timestamp());

OPEN C01;
LOOP
FETCH C01 into
		cd_medicamento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
END LOOP;
CLOSE C01;

cd_brasindice_w	:= cd_medicamento_w;

Return cd_brasindice_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medic_brasindice ( CD_ESTABELECIMENTO_P bigint, CD_MATERIAL_P bigint, DT_VIGENCIA_P timestamp) FROM PUBLIC;

