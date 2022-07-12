-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_cd_inst_externo ( nr_seq_instituicao_p text) RETURNS varchar AS $body$
DECLARE


retorno_w	varchar(10);


BEGIN

if (nr_seq_instituicao_p IS NOT NULL AND nr_seq_instituicao_p::text <> '') then

	SELECT	MAX(a.cd_inst_externo)
	into STRICT	retorno_w
	FROM	lote_ent_instituicao a,
			lote_ent_secretaria b
	WHERE	a.nr_sequencia = b.nr_seq_instituicao
	AND		a.nr_sequencia = nr_seq_instituicao_p;

end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_cd_inst_externo ( nr_seq_instituicao_p text) FROM PUBLIC;

