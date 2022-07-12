-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_informacao_os_codereview ( dt_parametro_p timestamp, nr_seq_tipo_p bigint, ie_tipo_inf_p text, ie_tipo_valor_p text, ie_area_gerencia_p text, nr_seq_gerencia_p bigint ) RETURNS bigint AS $body$
DECLARE

/*
ie_tipo_inf_p

PRGCD - Percentual geral de code review (calculado sobre o montante geral de OS com atividade de programacao e montante de OS que teve historico do tipo CODEVIEW "nr_seq_tipo_p")

*/
pr_retorno_w      double precision;
dt_ref_mes_w      timestamp;
dt_fim_mes_w      timestamp;



BEGIN

dt_ref_mes_w      := trunc(dt_parametro_p,'month');
dt_fim_mes_w      := last_day(dt_ref_mes_w) + 86399/86400;

if (ie_tipo_valor_p  = 'A') then /*Mes corrente*/
  dt_ref_mes_w    := add_months(trunc(dt_parametro_p,'month'), -11);
  dt_fim_mes_w    := trunc(dt_parametro_p,'month');
elsif (ie_tipo_valor_p  = 'AC') then /*Ano corrente de 01/01/xxxx ate a data atual*/
  dt_ref_mes_w    := trunc(dt_parametro_p,'YEAR');
  dt_fim_mes_w    := last_day(TRUNC(dt_parametro_p)) + 86399/86400;
elsif (ie_tipo_valor_p  = 'ACM') then /*Ano corrente de 01/01/xxxx ate o ultimo mes cheio*/
  dt_ref_mes_w    := trunc(dt_parametro_p,'YEAR');
  dt_fim_mes_w    := last_day(TRUNC(dt_parametro_p,'month') - 1) + 86399/86400;
end if;

pr_retorno_w      := 0;
if (ie_tipo_inf_p in ('PRGCD')) then

/*resumo code review*/

select coalesce(round((sum(os_code_review.qt_code_review)/sum(os_programacao.qt_programacao))*100,1),0) pr_atingimento
into STRICT pr_retorno_w
  from
      (-- total de os com atividade de programacao
        SELECT r.ds_gerencia
                 , count(r.nr_seq_ordem_serv) qt_programacao
          from (       
              SELECT a.nr_seq_ordem_serv
                     ,c.ds_gerencia
                from man_ordem_serv_ativ a
                     ,grupo_desenvolvimento b
                     ,gerencia_wheb c
                     ,man_ordem_servico o
                     ,man_estagio_processo ep
               where a.nr_seq_grupo_des = b.nr_sequencia
			     and b.ie_situacao = 'A' and c.ie_situacao = 'A'
                 and b.nr_seq_gerencia = c.nr_sequencia
                 and o.nr_sequencia = a.nr_seq_ordem_serv
                 and o.nr_seq_estagio = ep.nr_sequencia
                 and o.ie_classificacao in ('E','S')
                 and c.ie_area_gerencia = ie_area_gerencia_p
                 and (coalesce(ep.ie_desenv,'X') <> 'S' AND coalesce(Ep.Ie_Tecnologia,'X') <>'S')
                 and a.nr_seq_funcao in (11,551, 1288)
                 and trunc(a.dt_atividade) between to_date(dt_ref_mes_w) and to_date(dt_fim_mes_w)
                 and ((coalesce(nr_seq_gerencia_p,0) = 0) or (b.nr_seq_gerencia = nr_seq_gerencia_p))
                 and exists -- colocadas em cliente teste apos atividade de programacao
                    (select 1
                       from man_estagio_processo c1,
                            man_ordem_serv_estagio d
                      where c1.nr_sequencia = d.nr_seq_estagio
                        and d.nr_seq_ordem   = a.nr_seq_ordem_serv
                        and d.nr_seq_estagio  in (2, 9) -- 2 cliente teste , 9 ok cliente encerrado
                        and d.dt_atualizacao between to_date(dt_ref_mes_w) and to_date(dt_fim_mes_w)
                    )
              group by a.nr_seq_ordem_serv
                     ,c.ds_gerencia
               ) r
          group by r.ds_gerencia
      ) os_programacao
    ,
      (-- total de os com atividade de programacao
        select r.ds_gerencia
                 , count(r.nr_seq_ordem_serv) qt_code_review
          from (       
              select a.nr_seq_ordem_serv
                     ,c.ds_gerencia
                     ,max(a.nr_sequencia) nr_seq_ativ
                from man_ordem_serv_ativ a
                     ,grupo_desenvolvimento b
                     ,gerencia_wheb c
                     ,man_ordem_servico o
                     ,man_estagio_processo ep
               where a.nr_seq_grupo_des = b.nr_sequencia
				 and b.ie_situacao = 'A' and c.ie_situacao = 'A'
                 and b.nr_seq_gerencia = c.nr_sequencia
                 and o.nr_sequencia = a.nr_seq_ordem_serv
                 and o.nr_seq_estagio = ep.nr_sequencia
                 and o.ie_classificacao in ('E','S')
                 and c.ie_area_gerencia = ie_area_gerencia_p
                 and (coalesce(ep.ie_desenv,'X') <> 'S' AND coalesce(Ep.Ie_Tecnologia,'X') <>'S')
                 and a.nr_seq_funcao in (11,551, 1288)
                 and trunc(a.dt_atividade) between to_date(dt_ref_mes_w) and to_date(dt_fim_mes_w)
                 and ((coalesce(nr_seq_gerencia_p,0) = 0) or (b.nr_seq_gerencia = nr_seq_gerencia_p))
                 and exists -- colocadas em cliente teste apos atividade de programacao
                    (select 1
                       from man_estagio_processo c1,
                            man_ordem_serv_estagio d
                      where c1.nr_sequencia = d.nr_seq_estagio
                        and d.nr_seq_ordem   = a.nr_seq_ordem_serv
                        and d.nr_seq_estagio  in (2, 9) -- 2 cliente teste , 9 ok cliente encerrado
                        and d.dt_atualizacao between to_date(dt_ref_mes_w) and to_date(dt_fim_mes_w)
                    )
                 and exists --com historico do tipo aprovacao de code review
                     (select 1
                        from man_ordem_serv_tecnico x
                       where x.nr_seq_ordem_serv = a.nr_seq_ordem_serv
                       --31 teste do analista ou  163 aprovacao de code review
                         and x.nr_seq_tipo         = nr_seq_tipo_p
                     )
              group by a.nr_seq_ordem_serv
                     ,c.ds_gerencia
               ) r
          group by r.ds_gerencia
      ) os_code_review
where os_programacao.ds_gerencia = os_code_review.ds_gerencia;

end if;

return pr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_informacao_os_codereview ( dt_parametro_p timestamp, nr_seq_tipo_p bigint, ie_tipo_inf_p text, ie_tipo_valor_p text, ie_area_gerencia_p text, nr_seq_gerencia_p bigint ) FROM PUBLIC;

