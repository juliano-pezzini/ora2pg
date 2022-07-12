-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_segundo_cid_secun_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_doenca_w			varchar(10);

C01 CURSOR FOR
	SELECT cd_doenca
	FROM (
		SELECT
		a.*,
			ROW_NUMBER() OVER (ORDER BY a.dt_atualizacao DESC) AS row_id_pagina
		FROM diagnostico_doenca a,
			 diagnostico_medico b
		WHERE b.dT_diagnostico = (SELECT MAX(x.dt_diagnostico) FROM diagnostico_doenca x WHERE x.nr_atendimento = 40143 AND x.IE_TIPO_DIAGNOSTICO = 2)
		AND	  a.dT_diagnostico = b.dT_diagnostico
		AND	  a.nr_atendimento = b.nr_atendimento
		AND a.nr_atendimento = nr_atendimento_p
		AND b.IE_TIPO_DIAGNOSTICO = 2
		AND	a.IE_CLASSIFICACAO_DOENCA = 'S'
	) alias4
	WHERE row_id_pagina = 2;


BEGIN
open C01;
	loop
	fetch C01 into
		cd_doenca_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

	end loop;
close C01;


return	cd_doenca_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_segundo_cid_secun_atend (nr_atendimento_p bigint) FROM PUBLIC;

