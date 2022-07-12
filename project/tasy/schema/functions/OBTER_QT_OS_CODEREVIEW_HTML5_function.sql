-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_os_codereview_html5 ( dt_parametro_p timestamp, nr_seq_tipo_p bigint, ie_tipo_inf_p text, ie_tipo_valor_p text, ie_area_gerencia_p text, nr_seq_gerencia_p bigint ) RETURNS bigint AS $body$
DECLARE

/*
ie_tipo_inf_p

PRGCD - Percentual geral de code review (calculado sobre o montante geral de OS com atividade de programação e montante de OS que teve histórico do tipo CODEVIEW "nr_seq_tipo_p")

*/
pr_retorno_w      double precision;
dt_ref_mes_w      timestamp;
dt_fim_mes_w      timestamp;



BEGIN

dt_ref_mes_w      := TRUNC(dt_parametro_p,'month');
dt_fim_mes_w      := LAST_DAY(dt_ref_mes_w) + 86399/86400;

IF (ie_tipo_valor_p  = 'A') THEN /*Mês corrente*/
  dt_ref_mes_w    := ADD_MONTHS(TRUNC(dt_parametro_p,'month'), -11);
  dt_fim_mes_w    := TRUNC(dt_parametro_p,'month');
ELSIF (ie_tipo_valor_p  = 'AC') THEN /*Ano corrente de 01/01/xxxx até a data atual*/
  dt_ref_mes_w    := TRUNC(dt_parametro_p,'YEAR');
  dt_fim_mes_w    := LAST_DAY(TRUNC(dt_parametro_p)) + 86399/86400;
ELSIF (ie_tipo_valor_p  = 'ACM') THEN /*Ano corrente de 01/01/xxxx até o último mês cheio*/
  dt_ref_mes_w    := TRUNC(dt_parametro_p,'YEAR');
  dt_fim_mes_w    := LAST_DAY(TRUNC(dt_parametro_p,'month') - 1) + 86399/86400;
END IF;

pr_retorno_w      := 0;
IF (ie_tipo_inf_p IN ('PRGCD')) THEN

/*resumo code review*/

SELECT coalesce(ROUND((SUM(os_code_review.qt_code_review)/SUM(os_programacao.qt_programacao))*100,1),0) pr_atingimento
INTO STRICT pr_retorno_w
  FROM
      (-- total de os com atividade de programação
        SELECT r.ds_gerencia
                 , COUNT(r.nr_seq_ordem_serv) qt_programacao
          FROM (
              SELECT a.nr_seq_ordem_serv
                     ,c.ds_gerencia
                FROM man_ordem_serv_ativ a
                     ,grupo_desenvolvimento b
                     ,gerencia_wheb c
                     ,man_ordem_servico o
                     ,man_estagio_processo ep
               WHERE a.nr_seq_grupo_des = b.nr_sequencia
                 AND b.nr_seq_gerencia = c.nr_sequencia
                 AND o.nr_sequencia = a.nr_seq_ordem_serv
                 AND o.nr_seq_estagio = ep.nr_sequencia
                 AND o.ie_classificacao IN ('E','S')
                 AND c.ie_area_gerencia = ie_area_gerencia_p
                 AND (coalesce(ep.ie_desenv,'X') <> 'S' AND coalesce(Ep.Ie_Tecnologia,'X') <>'S')
                 AND a.nr_seq_funcao IN (11,551, 1288)
                 AND a.dt_atividade BETWEEN TO_DATE(dt_ref_mes_w) AND TO_DATE(dt_fim_mes_w)
                 AND ((coalesce(nr_seq_gerencia_p,0) = 0) OR (b.nr_seq_gerencia = nr_seq_gerencia_p))
                 AND EXISTS -- colocadas em cliente teste após atividade de programação
                    (SELECT 1
                       FROM man_estagio_processo c1,
                            man_ordem_serv_estagio d
                      WHERE c1.nr_sequencia = d.nr_seq_estagio
                        AND d.nr_seq_ordem   = a.nr_seq_ordem_serv
                        AND d.nr_seq_estagio  IN (2, 9) -- 2 cliente teste , 9 ok cliente encerrado
                        AND d.dt_atualizacao BETWEEN TO_DATE(dt_ref_mes_w) AND TO_DATE(dt_fim_mes_w)
                    )
              GROUP BY a.nr_seq_ordem_serv
                     ,c.ds_gerencia
               ) r
          GROUP BY r.ds_gerencia
      ) os_programacao
    ,
      (-- total de os com atividade de programação
        SELECT r.ds_gerencia
                 , COUNT(r.nr_seq_ordem_serv) qt_code_review
          FROM (
              SELECT a.nr_seq_ordem_serv
                     ,c.ds_gerencia
                     ,MAX(a.nr_sequencia) nr_seq_ativ
                FROM man_ordem_serv_ativ a
                     ,grupo_desenvolvimento b
                     ,gerencia_wheb c
                     ,man_ordem_servico o
                     ,man_estagio_processo ep
               WHERE a.nr_seq_grupo_des = b.nr_sequencia
                 AND b.nr_seq_gerencia = c.nr_sequencia
                 AND o.nr_sequencia = a.nr_seq_ordem_serv
                 AND o.nr_seq_estagio = ep.nr_sequencia
                 AND o.ie_classificacao IN ('E','S')
                 AND c.ie_area_gerencia = ie_area_gerencia_p
                 AND (coalesce(ep.ie_desenv,'X') <> 'S' AND coalesce(Ep.Ie_Tecnologia,'X') <>'S')
                 AND a.nr_seq_funcao IN (11,551, 1288)
                 AND a.dt_atividade BETWEEN TO_DATE(dt_ref_mes_w) AND TO_DATE(dt_fim_mes_w)
                 AND ((coalesce(nr_seq_gerencia_p,0) = 0) OR (b.nr_seq_gerencia = nr_seq_gerencia_p))
                 AND EXISTS -- colocadas em cliente teste após atividade de programação
                    (SELECT 1
                       FROM man_estagio_processo c1,
                            man_ordem_serv_estagio d
                      WHERE c1.nr_sequencia = d.nr_seq_estagio
                        AND d.nr_seq_ordem   = a.nr_seq_ordem_serv
                        AND d.nr_seq_estagio  IN (2, 9) -- 2 cliente teste , 9 ok cliente encerrado
                        AND d.dt_atualizacao BETWEEN TO_DATE(dt_ref_mes_w) AND TO_DATE(dt_fim_mes_w)
                    )
                 AND EXISTS --com histórico do tipo aprovação de code review
                     (SELECT 1
                        FROM man_ordem_serv_tecnico x
                       WHERE x.nr_seq_ordem_serv = a.nr_seq_ordem_serv
                       --31 teste do analista ou  163 aprovação de code review
                         AND x.nr_seq_tipo         = nr_seq_tipo_p
                     )
              GROUP BY a.nr_seq_ordem_serv
                     ,c.ds_gerencia
               ) r
          GROUP BY r.ds_gerencia
      ) os_code_review
WHERE os_programacao.ds_gerencia = os_code_review.ds_gerencia;

END IF;

RETURN pr_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_os_codereview_html5 ( dt_parametro_p timestamp, nr_seq_tipo_p bigint, ie_tipo_inf_p text, ie_tipo_valor_p text, ie_area_gerencia_p text, nr_seq_gerencia_p bigint ) FROM PUBLIC;
