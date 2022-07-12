-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lote_ent_obter_ultimo_lote (nr_seq_instituicao_p bigint, nr_seq_posto_p bigint) RETURNS bigint AS $body$
DECLARE


nr_ultimo_lote_w	bigint;


BEGIN

if (coalesce(nr_seq_instituicao_p,0) <> 0) and (coalesce(nr_seq_posto_p,0) <> 0) then

	SELECT	MAX(a.nr_ultimo_lote)
	into STRICT	nr_ultimo_lote_w
	FROM	LOTE_ENT_INST_POSTO a,
			lote_ent_instituicao b
	WHERE	a.nr_seq_instituicao = b.nr_sequencia
	AND		a.nr_seq_instituicao = nr_seq_instituicao_p
	AND		a.nr_sequencia = nr_seq_posto_p;

end if;

return	nr_ultimo_lote_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lote_ent_obter_ultimo_lote (nr_seq_instituicao_p bigint, nr_seq_posto_p bigint) FROM PUBLIC;
