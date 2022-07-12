-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_grupo_dietas_rec ( nr_seq_receita_p bigint) RETURNS varchar AS $body$
DECLARE


ds_grupo_dietas_w	varchar(100);WITH RECURSIVE cte AS (



BEGIN
if (nr_seq_receita_p IS NOT NULL AND nr_seq_receita_p::text <> '') then

	SELECT LTRIM(ds_grupo,',') nr_seq_evento
        INTO STRICT 	ds_grupo_dietas_w
	FROM (
		SELECT ds_grupo,
		row_number() over (ORDER BY a.nr_sequencia) AS fila
		FROM   NUT_DIETA_REC a,
			NUT_GRUPO_PRODUCAO b
		WHERE  a.nr_seq_grupo = b.nr_sequencia
		AND    b.ie_situacao = 'A'
		AND    a.nr_seq_receita = nr_seq_receita_p
		AND    (a.nr_seq_grupo IS NOT NULL AND a.nr_seq_grupo::text <> '')
	      ) alias6 WHERE fila = 1
  UNION ALL



BEGIN
if (nr_seq_receita_p IS NOT NULL AND nr_seq_receita_p::text <> '') then

	SELECT c.ds_grupo_dietas_w || ',' || LTRIM(ds_grupo,',') nr_seq_evento
        INTO STRICT 	ds_grupo_dietas_w
	FROM (
		SELECT ds_grupo,
		row_number() over (ORDER BY a.nr_sequencia) AS fila
		FROM   NUT_DIETA_REC a,
			NUT_GRUPO_PRODUCAO b
		WHERE  a.nr_seq_grupo = b.nr_sequencia
		AND    b.ie_situacao = 'A'
		AND    a.nr_seq_receita = nr_seq_receita_p
		AND    (a.nr_seq_grupo IS NOT NULL AND a.nr_seq_grupo::text <> '')
	      ) JOIN cte c ON (c.fila = alias6.(fila-1))

) SELECT * FROM cte WHERE connect_by_isleaf = 1;
;

end if;

return	ds_grupo_dietas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_grupo_dietas_rec ( nr_seq_receita_p bigint) FROM PUBLIC;
