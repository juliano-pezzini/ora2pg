-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_mlt_dashboard_pmo (ie_tipo_p text, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter status geral dos milestones um portifolio/ programa/ projeto conforme o parametro ie_tipo_p
---------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatórios [ ] Outros:
 --------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
* Valores tratos para ie_tipo_p:
  'PJ' = Projeto
  'PR' = Programa
  'PF' = Portifolio


Retornos:     2 = AZUL - todos os milestones do projeto foram concluídos
		1  = VERDE - todos os milestones previstos para estarem concluídos até o momento, foram concluídos
	         4. = VERMELHO - o total de milestone concluído até o momento é menor do que o previsto

  * O retorno desta função é um dos valores do domínio 8175
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_mlt_concluidos_w  bigint := 0;
qt_atrasado_w		bigint := 0;
qt_previsto_w		bigint := 0;
qt_concluido_w		bigint := 0;


BEGIN


if ie_tipo_p = 'PJ' then
	--Obtem se algum milestone não está concluído
    select  count(e.nr_sequencia)
    into STRICT    ie_mlt_concluidos_w
    from    proj_portifolio pf,
            proj_programa pr,
            proj_projeto p,
            proj_cronograma c,
            proj_cron_etapa e
    where   pf.nr_sequencia = pr.nr_seq_portifolio
    and     pr.nr_sequencia = p.nr_seq_programa
    and     p.nr_sequencia  = c.nr_seq_proj
    and     c.nr_sequencia  = e.nr_seq_cronograma
    and     c.ie_situacao   = 'A'
    and     e.ie_milestone = 'S'
    and     coalesce(e.dt_fim_real::text, '') = ''
    and     p.nr_sequencia = nr_sequencia_p;

    --Obtem se todos os milestones previstos para estarem concluídos até o momento, foram concluídos
    select  count(e.nr_sequencia)
    into STRICT    qt_atrasado_w
    from    proj_portifolio pf,
            proj_programa pr,
            proj_projeto p,
            proj_cronograma c,
            proj_cron_etapa e
    where   pf.nr_sequencia = pr.nr_seq_portifolio
    and     pr.nr_sequencia = p.nr_seq_programa
    and     p.nr_sequencia  = c.nr_seq_proj
    and     c.nr_sequencia  = e.nr_seq_cronograma
    and     c.ie_situacao   = 'A'
    and     e.ie_milestone = 'S'
	and	 	trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
	and		coalesce(e.dt_fim_real::text, '') = ''
    and     p.nr_sequencia = nr_sequencia_p;


	 --Obtem quantidade de milestones previstos e realizados até o momento
    select ( select   count(e.nr_sequencia) qt_milestone_prev
              from     proj_portifolio pf,
                       proj_programa pr,
                       proj_projeto p,
                       proj_cronograma c,
                       proj_cron_etapa e
              where    pf.nr_sequencia = pr.nr_seq_portifolio
              and      pr.nr_sequencia = p.nr_seq_programa
              and      p.nr_sequencia  = c.nr_seq_proj
              and      c.nr_sequencia  = e.nr_seq_cronograma
              and      c.ie_situacao   = 'A'
              and      e.ie_milestone  = 'S'
              and      p.nr_sequencia =  t.nr_sequencia
			  and 	    trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
           ) qt_milestone_prev,
           ( select   count(e.nr_sequencia) qt_milestone_real
              from     proj_portifolio pf,
                       proj_programa pr,
                       proj_projeto p,
                       proj_cronograma c,
                       proj_cron_etapa e
              where    pf.nr_sequencia = pr.nr_seq_portifolio
              and      pr.nr_sequencia = p.nr_seq_programa
              and      p.nr_sequencia  = c.nr_seq_proj
              and      c.nr_sequencia  = e.nr_seq_cronograma
              and      c.ie_situacao   = 'A'
              and      e.ie_milestone = 'S'
              and      p.nr_sequencia =  t.nr_sequencia
              and      (e.dt_fim_real IS NOT NULL AND e.dt_fim_real::text <> '')
			  and 	    trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
           ) qt_milestone_real
    into STRICT   qt_previsto_w, qt_concluido_w
    from   proj_projeto t
    where  t.nr_sequencia = nr_sequencia_p;

  end if;



 if ie_tipo_p = 'PR' then
	--Obtem se algum milestone não está concluído
    select  count(e.nr_sequencia)
    into STRICT    ie_mlt_concluidos_w
    from    proj_portifolio pf,
            proj_programa pr,
            proj_projeto p,
            proj_cronograma c,
            proj_cron_etapa e
    where   pf.nr_sequencia = pr.nr_seq_portifolio
    and     pr.nr_sequencia = p.nr_seq_programa
    and     p.nr_sequencia  = c.nr_seq_proj
    and     c.nr_sequencia  = e.nr_seq_cronograma
    and     c.ie_situacao   = 'A'
    and     e.ie_milestone = 'S'
    and     coalesce(e.dt_fim_real::text, '') = ''
    and     pr.nr_sequencia = nr_sequencia_p;

    --Obtem se todos os milestones previstos para estarem concluídos até o momento, foram concluídos
    select  count(e.nr_sequencia)
    into STRICT    qt_atrasado_w
    from    proj_portifolio pf,
            proj_programa pr,
            proj_projeto p,
            proj_cronograma c,
            proj_cron_etapa e
    where   pf.nr_sequencia = pr.nr_seq_portifolio
    and     pr.nr_sequencia = p.nr_seq_programa
    and     p.nr_sequencia  = c.nr_seq_proj
    and     c.nr_sequencia  = e.nr_seq_cronograma
    and     c.ie_situacao   = 'A'
    and     e.ie_milestone = 'S'
	and	 	trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
	and		coalesce(e.dt_fim_real::text, '') = ''
    and     pr.nr_sequencia = nr_sequencia_p;


	 --Obtem quantidade de milestones previstos e realizados até o momento
    select ( select   count(e.nr_sequencia) qt_milestone_prev
              from     proj_portifolio pf,
                       proj_programa pr,
                       proj_projeto p,
                       proj_cronograma c,
                       proj_cron_etapa e
              where    pf.nr_sequencia = pr.nr_seq_portifolio
              and      pr.nr_sequencia = p.nr_seq_programa
              and      p.nr_sequencia  = c.nr_seq_proj
              and      c.nr_sequencia  = e.nr_seq_cronograma
              and      c.ie_situacao   = 'A'
              and      e.ie_milestone  = 'S'
              and      pr.nr_sequencia =  t.nr_sequencia
			  and 	    trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
           ) qt_milestone_prev,
           ( select   count(e.nr_sequencia) qt_milestone_real
              from     proj_portifolio pf,
                       proj_programa pr,
                       proj_projeto p,
                       proj_cronograma c,
                       proj_cron_etapa e
              where    pf.nr_sequencia = pr.nr_seq_portifolio
              and      pr.nr_sequencia = p.nr_seq_programa
              and      p.nr_sequencia  = c.nr_seq_proj
              and      c.nr_sequencia  = e.nr_seq_cronograma
              and      c.ie_situacao   = 'A'
              and      e.ie_milestone = 'S'
              and      pr.nr_sequencia =  t.nr_sequencia
              and      (e.dt_fim_real IS NOT NULL AND e.dt_fim_real::text <> '')
			  and 	    trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
           ) qt_milestone_real
    into STRICT   qt_previsto_w, qt_concluido_w
    from   proj_programa t
    where  t.nr_sequencia = nr_sequencia_p;

  end if;

  if ie_tipo_p = 'PF' then
	--Obtem se algum milestone não está concluído
    select  count(e.nr_sequencia)
    into STRICT    ie_mlt_concluidos_w
    from    proj_portifolio pf,
            proj_programa pr,
            proj_projeto p,
            proj_cronograma c,
            proj_cron_etapa e
    where   pf.nr_sequencia = pr.nr_seq_portifolio
    and     pr.nr_sequencia = p.nr_seq_programa
    and     p.nr_sequencia  = c.nr_seq_proj
    and     c.nr_sequencia  = e.nr_seq_cronograma
    and     c.ie_situacao   = 'A'
    and     e.ie_milestone = 'S'
    and     coalesce(e.dt_fim_real::text, '') = ''
    and     pf.nr_sequencia = nr_sequencia_p;

    --Obtem se todos os milestones previstos para estarem concluídos até o momento, foram concluídos
    select  count(e.nr_sequencia)
    into STRICT    qt_atrasado_w
    from    proj_portifolio pf,
            proj_programa pr,
            proj_projeto p,
            proj_cronograma c,
            proj_cron_etapa e
    where   pf.nr_sequencia = pr.nr_seq_portifolio
    and     pr.nr_sequencia = p.nr_seq_programa
    and     p.nr_sequencia  = c.nr_seq_proj
    and     c.nr_sequencia  = e.nr_seq_cronograma
    and     c.ie_situacao   = 'A'
    and     e.ie_milestone = 'S'
	and	 	trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
	and		coalesce(e.dt_fim_real::text, '') = ''
    and     pf.nr_sequencia = nr_sequencia_p;


	 --Obtem quantidade de milestones previstos e realizados até o momento
    select ( select   count(e.nr_sequencia) qt_milestone_prev
              from     proj_portifolio pf,
                       proj_programa pr,
                       proj_projeto p,
                       proj_cronograma c,
                       proj_cron_etapa e
              where    pf.nr_sequencia = pr.nr_seq_portifolio
              and      pr.nr_sequencia = p.nr_seq_programa
              and      p.nr_sequencia  = c.nr_seq_proj
              and      c.nr_sequencia  = e.nr_seq_cronograma
              and      c.ie_situacao   = 'A'
              and      e.ie_milestone  = 'S'
              and      pf.nr_sequencia =  t.nr_sequencia
			  and 	    trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
           ) qt_milestone_prev,
           ( select   count(e.nr_sequencia) qt_milestone_real
              from     proj_portifolio pf,
                       proj_programa pr,
                       proj_projeto p,
                       proj_cronograma c,
                       proj_cron_etapa e
              where    pf.nr_sequencia = pr.nr_seq_portifolio
              and      pr.nr_sequencia = p.nr_seq_programa
              and      p.nr_sequencia  = c.nr_seq_proj
              and      c.nr_sequencia  = e.nr_seq_cronograma
              and      c.ie_situacao   = 'A'
              and      e.ie_milestone = 'S'
              and      pf.nr_sequencia =  t.nr_sequencia
              and      (e.dt_fim_real IS NOT NULL AND e.dt_fim_real::text <> '')
			  and 	    trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
           ) qt_milestone_real
    into STRICT   qt_previsto_w, qt_concluido_w
    from   proj_portifolio t
    where  t.nr_sequencia = nr_sequencia_p;

  end if;


if (ie_mlt_concluidos_w = 0) then
    -- 2- Todos Mlts concluídos     Cor: Azul
	return 2;
else if (qt_concluido_w < qt_previsto_w) then
	-- 4 - Todos Mlts concluídos menor que o previsto    Cor: Vermelho
	return 4;
else
  -- 1- todos os milestones previstos para estarem concluídos até o momento, foram concluídoss   Cor: Verde
  return 1;
end if;
end if;

return	null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_mlt_dashboard_pmo (ie_tipo_p text, nr_sequencia_p bigint) FROM PUBLIC;

