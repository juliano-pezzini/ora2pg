-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_fim_prev_pmo (nr_seq_prog_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_fim_real_w 		timestamp;
ie_possue_vazio_w	varchar(1);


BEGIN

/*
S = programa contém atividades que ainda não foram finalizadas
N = todas as atividades do programa já foram realizadas
*/
select  coalesce(max('S'),'N')
into STRICT	ie_possue_vazio_w
from	proj_programa pr,
		proj_projeto p,
		proj_cronograma c,
		proj_cron_etapa e
where 	pr.nr_sequencia = p.nr_seq_programa
and     p.nr_sequencia  = c.nr_seq_proj
and     c.nr_sequencia  = e.nr_seq_cronograma
and		coalesce(e.dt_fim_real::text, '') = ''
and 	e.ie_fase = 'N'
and 	c.ie_situacao = 'A'
and		pr.nr_sequencia = nr_seq_prog_p
and  	not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia);

begin
-- pega a data da ultima atividade realizada
	if (ie_possue_vazio_w = 'N') then
		select  max(e.dt_fim_real)
		into STRICT	dt_fim_real_w
		from	proj_programa pr,
				proj_projeto p,
				proj_cronograma c,
				proj_cron_etapa e
		where 	pr.nr_sequencia = p.nr_seq_programa
		and     p.nr_sequencia  = c.nr_seq_proj
		and     c.nr_sequencia  = e.nr_seq_cronograma
		and		(e.dt_fim_real IS NOT NULL AND e.dt_fim_real::text <> '')
		and 	e.ie_fase = 'N'
		and 	c.ie_situacao = 'A'
		and		pr.nr_sequencia = nr_seq_prog_p
		and  	not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia);
end if;
exception
when others then
	dt_fim_real_w := null;
end;

return	dt_fim_real_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_fim_prev_pmo (nr_seq_prog_p bigint) FROM PUBLIC;

