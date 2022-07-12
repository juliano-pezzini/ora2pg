-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sla_dashboard_pck.insert_coin ( dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE

				
c01 CURSOR FOR
SELECT  b.nr_sequencia
from   man_ordem_serv_sla a,
       man_ordem_servico b
where  a.nr_seq_ordem = b.nr_sequencia
and    a.qt_desvio = 1
and    ie_status_ordem <> 3
and	ie_tipo_sla = 3
and	ie_tipo_sla_termino = 3
and    obter_se_os_pend_cliente(b.nr_sequencia) = 'N'  
and    a.dt_inicio_sla between trunc(dt_referencia_p, 'mm') and fim_mes(dt_referencia_p)
and    (a.dt_inicio_sla IS NOT NULL AND a.dt_inicio_sla::text <> '');

c01_w	c01%rowtype;

qt_sla_monitor_w	bigint;
dt_inicio_sla_w		man_ordem_serv_sla.dt_inicio_sla%type;
ie_tempo_termino_w	man_ordem_serv_sla.ie_tempo_termino%type;
ie_tipo_sla_termino_w	man_ordem_serv_sla.ie_tipo_sla_termino%type;
qt_min_termino_w	man_ordem_serv_sla.qt_min_termino%type;
ie_classificacao_w	man_ordem_serv_sla.ie_classificacao%type;
ie_prioridade_w		man_ordem_serv_sla.ie_prioridade%type;
qt_min_inicio_w		man_ordem_serv_sla.qt_min_inicio%type;
nr_seq_sla_regra_w	man_ordem_serv_sla.nr_seq_sla_regra%type;
ie_tempo_w		man_ordem_serv_sla.ie_tempo%type;
cd_estabelecimento_w	man_ordem_serv_sla.cd_estabelecimento%type;
nr_seq_grupo_des_w	man_ordem_servico.nr_seq_grupo_des%type;
nr_seq_grupo_sup_w	man_ordem_servico.nr_seq_grupo_sup%type;
dt_ordem_w		timestamp;
ie_tipo_sla_w		man_ordem_serv_sla.ie_tipo_sla%type;
ie_ambiente_w		man_ordem_servico.ie_ambiente%type;



BEGIN
open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		select 	count(1)
		into STRICT	qt_sla_monitor_w
		from	man_sla_monitor	
		where	nr_seq_ordem_servico = c01_w.nr_sequencia;
		
		select	coalesce(add_months(trunc(dt_inicio_sla, 'mm'), 1), clock_timestamp()),
			max(ie_tempo_termino),
			max(ie_tipo_sla_termino),
			max(qt_min_termino),
			max(ie_classificacao),
			max(ie_prioridade),
			max(qt_min_inicio),
			max(nr_seq_sla_regra),
			max(ie_tempo),
			max(cd_estabelecimento),
			max(dt_ordem),
			max(ie_tipo_sla)
		into STRICT	dt_inicio_sla_w,
			ie_tempo_termino_w,
			ie_tipo_sla_termino_w,
			qt_min_termino_w,
			ie_classificacao_w,
			ie_prioridade_w,
			qt_min_inicio_w,
			nr_seq_sla_regra_w,
			ie_tempo_w,
			cd_estabelecimento_w,
			dt_ordem_w,
			ie_tipo_sla_w
		from	man_ordem_serv_sla
		where	nr_seq_ordem = c01_w.nr_sequencia
		group by dt_inicio_sla;
		
		select  max(nr_seq_grupo_des),
			max(nr_seq_grupo_sup),
			max(ie_ambiente)
		into STRICT	nr_seq_grupo_des_w,
			nr_seq_grupo_sup_w,
			ie_ambiente_w
		from	man_ordem_servico
		where	nr_sequencia = c01_w.nr_sequencia;
		
		
		if (qt_sla_monitor_w = 0) then
			CALL sla_dashboard_pck.man_incluir_os_monitor(c01_w.nr_sequencia, nm_usuario_p, cd_estabelecimento_w, 'N','N', ie_classificacao_w, ie_prioridade_w, qt_min_inicio_w, qt_min_termino_w,
						null, nr_seq_sla_regra_w, 'S', ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
		end if;
		CALL sla_dashboard_pck.man_incluir_os_evento(c01_w.nr_sequencia, nm_usuario_p, cd_estabelecimento_w, nr_seq_grupo_des_w,'12', 'S', ie_classificacao_w, ie_prioridade_w, qt_min_inicio_w, qt_min_termino_w,
					sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, nr_seq_grupo_sup_w, null, ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
		CALL sla_dashboard_pck.atualizar_valor_insert_coin(nr_seq_sla_regra_w, c01_w.nr_sequencia, coalesce(dt_inicio_sla_w, dt_ordem_w), cd_estabelecimento_w);
	end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sla_dashboard_pck.insert_coin ( dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;