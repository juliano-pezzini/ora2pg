-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cd_proc_tuss (nr_atendimento_p bigint, nr_linha_retorno_p bigint) RETURNS bigint AS $body$
DECLARE


cd_procedimento_w		bigint;

C01 CURSOR FOR
	SELECT cd_procedimento
	FROM (
		SELECT
		z.*,
			row_number() over (ORDER BY dt_atualizacao_nrec DESC) AS row_id_pagina
		FROM 	prescr_procedimento z,
				prescr_medica y
		WHERE 	z.nr_prescricao = y.nr_prescricao
		AND 	ie_origem_proced IN (1,8)
		AND 	y.nr_atendimento = nr_atendimento_p
		) alias3
	WHERE row_id_pagina = nr_linha_retorno_p;


BEGIN
open C01;
	loop
	fetch C01 into
		cd_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

	end loop;
close C01;

return	cd_procedimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cd_proc_tuss (nr_atendimento_p bigint, nr_linha_retorno_p bigint) FROM PUBLIC;
