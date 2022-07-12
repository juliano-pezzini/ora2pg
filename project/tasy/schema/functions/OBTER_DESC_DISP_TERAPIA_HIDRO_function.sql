-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_disp_terapia_hidro (NR_SEQ_AGENTE bigint, NR_SEQ_TERAPIA bigint) RETURNS varchar AS $body$
DECLARE


DS_RESULTADO_W	varchar(400);


BEGIN

IF (NR_SEQ_AGENTE IS NOT NULL AND NR_SEQ_AGENTE::text <> '' AND NR_SEQ_TERAPIA IS NOT NULL AND NR_SEQ_TERAPIA::text <> '') THEN
	SELECT a.ds_expressao
	INTO STRICT   DS_RESULTADO_W
	FROM   valor_dominio_v a,
		   CIRURGIA_AGENTE_ANESTESICO b
	WHERE  cd_dominio = 1583
	AND    b.nr_sequencia = nr_seq_terapia
	AND    b.IE_DISP_INFUSAO = a.vl_dominio
	AND    obter_se_agente_gas(NR_SEQ_AGENTE) = 'G'
	AND    UPPER(a.vl_dominio) IN ('R','V')
	
UNION

	SELECT  a.ds_expressao
	FROM   valor_dominio_v  a,
		   CIRURGIA_AGENTE_ANESTESICO b
	WHERE  a.cd_dominio = 1583
	AND    b.nr_sequencia = nr_seq_terapia
	AND    b.IE_DISP_INFUSAO = a.vl_dominio
	AND    obter_se_agente_gas(NR_SEQ_AGENTE) = 'LG'
	AND    UPPER(a.vl_dominio) IN ('A','N','S','V')
	
UNION

	SELECT a.ds_expressao
	FROM valor_dominio_v a,
		 CIRURGIA_AGENTE_ANESTESICO b
	WHERE a.cd_dominio = 1583
	AND   b.nr_sequencia = nr_seq_terapia
	AND   b.IE_DISP_INFUSAO = a.vl_dominio
	AND   obter_se_agente_gas(NR_SEQ_AGENTE) NOT IN ('LG','G')
	AND   UPPER(a.vl_dominio) IN ('A','N','S');
END IF;

RETURN DS_RESULTADO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_disp_terapia_hidro (NR_SEQ_AGENTE bigint, NR_SEQ_TERAPIA bigint) FROM PUBLIC;

