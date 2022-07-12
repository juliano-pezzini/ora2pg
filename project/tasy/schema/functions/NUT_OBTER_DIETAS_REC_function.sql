-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_dietas_rec ( nr_seq_receita_p bigint) RETURNS varchar AS $body$
DECLARE


ds_dietas_w	varchar(250);
qt_registros_w	integer;


BEGIN

select  count(*) qt_registros
into STRICT 	qt_registros_w
from   	nut_dieta_rec
where  	nr_seq_receita = nr_seq_receita_p
and  	(cd_dieta IS NOT NULL AND cd_dieta::text <> '');WITH RECURSIVE cte AS (


if (nr_seq_receita_p IS NOT NULL AND nr_seq_receita_p::text <> '') then
	if (qt_registros_w > 1) then

		SELECT SUBSTR(LTRIM(ds_dieta,','),1,250) nr_seq_evento
		into STRICT ds_dietas_w
		FROM (
			 SELECT SUBSTR(obter_nome_dieta(cd_dieta),1,200) ds_dieta,
				row_number() over (ORDER BY nr_sequencia) AS fila
			  FROM   NUT_DIETA_REC
		      WHERE  nr_seq_receita = nr_seq_receita_p   AND  (cd_dieta IS NOT NULL AND cd_dieta::text <> '')) alias10 WHERE fila = 1
  UNION ALL


if (nr_seq_receita_p IS NOT NULL AND nr_seq_receita_p::text <> '') then
	if (qt_registros_w > 1) then

		SELECT c.ds_dietas_w || ',' || SUBSTR(LTRIM(ds_dieta,','),1,250) nr_seq_evento
		into STRICT ds_dietas_w
		FROM (
			 SELECT SUBSTR(obter_nome_dieta(cd_dieta),1,200) ds_dieta,
				row_number() over (ORDER BY nr_sequencia) AS fila
			  FROM   NUT_DIETA_REC
		      WHERE  nr_seq_receita = nr_seq_receita_p   AND  (cd_dieta IS NOT NULL AND cd_dieta::text <> '')) JOIN cte c ON (c.fila = alias10.(fila-1))

) SELECT * FROM cte WHERE connect_by_isleaf = 1;
;
	else
		select 	substr(obter_nome_dieta(cd_dieta),1,200) ds_dieta
		into STRICT	ds_dietas_w
		from   	nut_dieta_rec
		where  	nr_seq_receita = nr_seq_receita_p
		and    	(cd_dieta IS NOT NULL AND cd_dieta::text <> '');
	end if;
end if;

return	ds_dietas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_dietas_rec ( nr_seq_receita_p bigint) FROM PUBLIC;

