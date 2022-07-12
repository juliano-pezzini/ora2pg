-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pr_real_proj_fase ( nr_seq_projeto_p bigint, nr_seq_area_fase_p bigint ) RETURNS bigint AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter percentual real de execução da fase de um programa
---------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatórios [ ] Outros:
 --------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
pr_retorno_w double precision := 0;


BEGIN

  select ( select dividir(t.per_exec * 100,t.qt_hora_prev) pr_realizado
           from ( select sum(pe.qt_hora_prev) qt_hora_prev,
                           sum(dividir(pe.qt_hora_prev * pe.pr_etapa,100)) per_exec
                    from   proj_cronograma pc,
                           proj_cron_etapa pe,
                           proj_projeto    pp
                    where  pc.nr_sequencia = pe.nr_seq_cronograma
                    and    pp.nr_sequencia = pc.nr_seq_proj
                    and    pp.nr_sequencia = nr_seq_projeto_p
                    and    pe.nr_seq_area_fase  = nr_seq_area_fase_p
                    and    pc.ie_situacao = 'A'
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
-- REVOKE ALL ON FUNCTION obter_pr_real_proj_fase ( nr_seq_projeto_p bigint, nr_seq_area_fase_p bigint ) FROM PUBLIC;

