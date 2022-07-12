-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION med_obter_cod_item_convenio (NR_ATENDIMENTO_P bigint, NR_SEQ_ITEM_P bigint) RETURNS varchar AS $body$
DECLARE


CD_ITEM_CONVENIO_W	varchar(20);
NR_SEQ_PLANO_W		bigint;


BEGIN

SELECT	coalesce(MAX(NR_SEQ_PLANO),0)
INTO STRICT	NR_SEQ_PLANO_W
FROM	MED_ATENDIMENTO
WHERE	NR_ATENDIMENTO	= NR_ATENDIMENTO_P;


IF (NR_SEQ_PLANO_W <> 0) THEN
	BEGIN

	SELECT	MAX(CD_ITEM_CONVENIO)
	INTO STRICT	CD_ITEM_CONVENIO_W
	FROM	MED_ITEM_CONVENIO
	WHERE	NR_SEQ_ITEM	= NR_SEQ_ITEM_P
	AND	NR_SEQ_PLANO	= NR_SEQ_PLANO_W;

	END;
END IF;


RETURN CD_ITEM_CONVENIO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION med_obter_cod_item_convenio (NR_ATENDIMENTO_P bigint, NR_SEQ_ITEM_P bigint) FROM PUBLIC;

