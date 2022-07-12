-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_ckp_dashboard (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter status de um checkpoint
---------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ]  Relatórios [ ] Outros:
 --------------------------------------------------------------------------------------------------------------------------------------------
Ponto de atenção:

Retornos:     2 = AZUL - checkpoint esta concluído
		1  = VERDE - checkpoints previsto para estar concluído até o momento, foi concluído ou ainda está dentro do prazo
	         4. = VERMELHO - checkpoint previsto para estar concluido até o momento, não foi realizado

  * O retorno desta função é um dos valores do domínio 8175
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_ckp_concluidos_w  bigint := 0;
qt_atrasado_w		bigint := 0;
qt_previsto_w		bigint := 0;
qt_concluido_w		bigint := 0;


BEGIN


	--Obtem se o checkpoint não está concluído
    select  count(e.nr_sequencia)
    into STRICT    ie_ckp_concluidos_w
    from    proj_cron_etapa e
    where   e.ie_checkpoint = 'S'
    and     coalesce(e.dt_fim_real::text, '') = ''
    and     e.nr_sequencia = nr_sequencia_p;

    --Obtem se  o checkpoint previstos para estar concluídos até o momento, foi concluído
    select  count(e.nr_sequencia)
    into STRICT    qt_atrasado_w
    from    proj_cron_etapa e
    where   e.ie_checkpoint = 'S'
	and	 	trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
	and		coalesce(e.dt_fim_real::text, '') = ''
    and     e.nr_sequencia = nr_sequencia_p;

	--Obtem quantidade de checkpoints previstos e realizados até o momento
	select ( select   count(e.nr_sequencia) qt_checkpoint_prev
              from     proj_cron_etapa e
              where    e.ie_checkpoint  = 'S'
              and      e.nr_sequencia =  t.nr_sequencia
			  and 	    trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
           ) qt_checkpoint_prev,
           ( select   count(e.nr_sequencia) qt_checkpoint_real
              from     proj_cron_etapa e
              where    e.ie_checkpoint = 'S'
              and      e.nr_sequencia =  t.nr_sequencia
              and      (e.dt_fim_real IS NOT NULL AND e.dt_fim_real::text <> '')
			  and 	    trunc(e.dt_fim_prev) <= trunc(clock_timestamp())
           ) qt_checkpoint_real
    into STRICT   qt_previsto_w, qt_concluido_w
    from   proj_cron_etapa t
    where  t.nr_sequencia = nr_sequencia_p;

if (ie_ckp_concluidos_w = 0) then
    -- 2- checkpoint concluído    Cor: Azul
	return 2;
else if (qt_concluido_w < qt_previsto_w) then
	-- 4 - checkpoint atrasado    Cor: Vermelho
	return 4;
else
  -- 1- O checkpoint previstos para estar concluídos até o momento, foi concluídos   Cor: Verde
  return 1;
end if;
end if;

return	null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_ckp_dashboard (nr_sequencia_p bigint) FROM PUBLIC;
