-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_rem_ativ_tab_proj_migr () AS $body$
DECLARE


nr_seq_atividade_w	bigint;

c01 CURSOR FOR
SELECT	e.nr_sequencia
from  	proj_cron_etapa e,
	proj_cronograma c,
	proj_projeto p
where   e.nr_seq_cronograma = c.nr_sequencia
and     c.nr_seq_proj = p.nr_sequencia
and     p.nr_seq_estagio = 1
and     p.nr_seq_classif = 14
and     p.nr_sequencia not in (1430,1427,1061,580,581,582,583,584,656,494,654,498,1282)
and     e.ie_tipo_obj_proj_migr = 'TTabSheet'
order by
	p.nr_sequencia,
	c.nr_sequencia,
	e.nr_sequencia;


BEGIN
open c01;
loop
fetch c01 into nr_seq_atividade_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	update	proj_cron_etapa
	set	ie_situacao = 'I',
		pr_etapa = 100,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = 'Portuga'
	where	nr_sequencia = nr_seq_atividade_w;
	end;
end loop;
close c01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_rem_ativ_tab_proj_migr () FROM PUBLIC;
