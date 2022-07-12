-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cid_princ_concat ( nr_atendimento_p bigint, dt_diagnostico_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_doenca_w		varchar(255);
ds_doenca_w2	varchar(4000);

C01 CURSOR FOR
	SELECT	substr(obter_desc_cid(CD_DOENCA),1,200)
	FROM	diagnostico_doenca
	WHERE	nr_atendimento	= nr_atendimento_p
	AND	ie_classificacao_doenca = 'P'
	AND	dt_diagnostico = dt_diagnostico_p
	ORDER BY dt_atualizacao;


BEGIN

OPEN C01;
	LOOP
	FETCH C01 INTO
		ds_doenca_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ds_doenca_w2 IS NOT NULL AND ds_doenca_w2::text <> '') then
			ds_doenca_w2 := ds_doenca_w2||', '||ds_doenca_w;
		else
			ds_doenca_w2 := ds_doenca_w;
		end if;
		end;
	END LOOP;
CLOSE C01;

RETURN ds_doenca_w2;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cid_princ_concat ( nr_atendimento_p bigint, dt_diagnostico_p timestamp) FROM PUBLIC;

