-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_hemo_qt_exames_pend ( nr_seq_producao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_exames_pendentes_w	smallint := 0;


BEGIN
if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') then

	SELECT 	COUNT(*)
	into STRICT	qt_exames_pendentes_w
	FROM   	SAN_EXAME_LOTE a,
		SAN_EXAME_REALIZADO b
	WHERE  	a.nr_sequencia = b.nr_seq_exame_lote
	AND	a.nr_seq_producao = nr_seq_producao_p
	AND	coalesce(b.dt_liberacao::text, '') = ''
	and 	san_obter_se_exame_auxiliar(b.nr_seq_exame_lote,b.nr_seq_exame,1,'E') = 'S';

end if;

return 	qt_exames_pendentes_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_hemo_qt_exames_pend ( nr_seq_producao_p bigint) FROM PUBLIC;

