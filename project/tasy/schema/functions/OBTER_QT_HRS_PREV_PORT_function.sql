-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_hrs_prev_port (nr_seq_port_p bigint, dt_ref_p timestamp ) RETURNS bigint AS $body$
DECLARE


qt_hr_prev_retorno_w		double precision;
qt_total_hrs_crono_w		double precision;

BEGIN


/*Pega o total de horas previstas de todos os cronogramas deste portifolio*/

select	sum(e.qt_hora_prev)  qt_horas_prev
into STRICT 	qt_total_hrs_crono_w
	from	proj_portifolio pf,
		proj_programa pr,
		proj_projeto p,
		proj_cronograma c,
		proj_cron_etapa e
	where	pf.nr_sequencia = pr.nr_seq_portifolio
		and	pr.nr_sequencia = p.nr_seq_programa
		and	p.nr_sequencia = c.nr_seq_proj
		and	c.nr_sequencia = e.nr_seq_cronograma
		and c.ie_situacao = 'A'
		and c.ie_classificacao = 'D'
		and	(c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '')
		and not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia)
		and pf.nr_sequencia = nr_seq_port_p;


select (coalesce(qt_total_hrs_crono_w,0) - sum(e.qt_hora_prev))  qt_horas_prev
into STRICT 	qt_hr_prev_retorno_w
	from	proj_portifolio pf,
		proj_programa pr,
		proj_projeto p,
		proj_cronograma c,
		proj_cron_etapa e
	where	pf.nr_sequencia = pr.nr_seq_portifolio
		and	pr.nr_sequencia = p.nr_seq_programa
		and p.nr_sequencia = c.nr_seq_proj
		and	c.nr_sequencia = e.nr_seq_cronograma
		and c.ie_situacao = 'A'
		and c.ie_classificacao = 'D'
		and not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia)
		and pf.nr_sequencia = nr_seq_port_p
		and	(c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '')
		and e.dt_fim_prev <= pkg_date_utils.end_of(dt_ref_p	, 'DAY');


/*Se o valor está nulo, provalvemente é pq o portifolio começou antes da data prevista. Neste caso, retorna o valor total de horas previstas do cronograma*/

if (coalesce(qt_hr_prev_retorno_w::text, '') = '')then
	qt_hr_prev_retorno_w := coalesce(qt_total_hrs_crono_w, 0);
end if;


return	qt_hr_prev_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_hrs_prev_port (nr_seq_port_p bigint, dt_ref_p timestamp ) FROM PUBLIC;

