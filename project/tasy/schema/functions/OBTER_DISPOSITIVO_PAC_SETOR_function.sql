-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dispositivo_pac_setor (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 		varchar(4000);
ds_dispositivo_w 	varchar(255);
C01 CURSOR FOR
	SELECT	DISTINCT SUBSTR(obter_descricao_padrao('DISPOSITIVO','DS_DISP_ADEP',nr_seq_dispositivo),1,80) ds_legenda
	FROM	   atend_pac_dispositivo
	WHERE	   nr_atendimento = nr_atendimento_p
	AND     coalesce(dt_retirada::text, '') = ''
	
UNION ALL

	SELECT	DISTINCT SUBSTR(b.ds_equipamento,1,100) ds_legenda
	FROM	   equipamento_cirurgia a,
			equipamento b
	WHERE	   a.cd_equipamento = b.cd_equipamento
	AND		   a.nr_atendimento = nr_atendimento_p
	AND   		coalesce(a.DT_FIM::text, '') = ''
	ORDER BY ds_legenda;


BEGIN

OPEN C01;
LOOP
FETCH C01 INTO
	ds_dispositivo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
	ds_dispositivo_w := substr(ds_dispositivo_w || ' - ',1,255);
	ds_retorno_w := substr(ds_retorno_w || ds_dispositivo_w,1,4000);

	END;
END LOOP;
CLOSE C01;
ds_retorno_w := SUBSTR(ds_retorno_w,1,LENGTH(ds_retorno_w)-3);
RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dispositivo_pac_setor (nr_atendimento_p bigint) FROM PUBLIC;

