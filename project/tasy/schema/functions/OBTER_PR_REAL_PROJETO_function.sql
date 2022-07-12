-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pr_real_projeto ( nr_seq_proj_p bigint, ie_tipo_cronograma_p text default null, ie_apenas_cron_aprov_p text default 'N') RETURNS bigint AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter percentual real de execucao de um projeto
---------------------------------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatorios [ ] Outros: 
 --------------------------------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
pr_retorno_w double precision := 0;


BEGIN

  select ( select dividir(t.per_exec * 100,t.qt_hora_prev) pr_realizado
           from   (
			select	sum(pe.qt_hora_prev) qt_hora_prev,
					sum(dividir(pe.qt_hora_prev * pe.pr_etapa,100)) per_exec
			from	proj_cronograma pc,
				proj_cron_etapa pe
			where	pc.nr_sequencia = pe.nr_seq_cronograma 
			and	pc.nr_seq_proj  = nr_seq_proj_p
			and	pc.ie_situacao  = 'A'
			and	((ie_apenas_cron_aprov_p =  'N') or (ie_apenas_cron_aprov_p = 'S' and (pc.dt_aprovacao IS NOT NULL AND pc.dt_aprovacao::text <> '')))
			and	pe.ie_fase = 'N'
			and	not exists (select 1 from proj_cron_etapa xx where xx.nr_seq_superior =  pe.nr_sequencia)
			and	pc.ie_tipo_cronograma in (WITH RECURSIVE cte AS (

								select	coalesce(trim(both regexp_substr(ie_tipo_cronograma_p,'[^,]+', 1, level)), ie_tipo_cronograma)
								
								(regexp_substr(ie_tipo_cronograma_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(ie_tipo_cronograma_p, '[^,]+', 1, level))::text <> '')
							  UNION ALL

								select	coalesce(trim(both regexp_substr(ie_tipo_cronograma_p,'[^,]+', 1, level)), ie_tipo_cronograma) JOIN cte c ON ()

) SELECT * FROM cte;
)
                  ) t
         ) pr_real
  into STRICT   pr_retorno_w
;

  return  pr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pr_real_projeto ( nr_seq_proj_p bigint, ie_tipo_cronograma_p text default null, ie_apenas_cron_aprov_p text default 'N') FROM PUBLIC;

