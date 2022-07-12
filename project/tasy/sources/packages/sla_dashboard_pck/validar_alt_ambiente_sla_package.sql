-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sla_dashboard_pck.validar_alt_ambiente_sla ( nr_seq_ordem_serv_p bigint, nm_usuario_p text, ie_prioridade_p text, ie_classificacao_p text, nr_seq_localizacao_p bigint, nr_seq_grupo_trab_p bigint, dt_ordem_servico_p timestamp, dt_inicio_p timestamp, nr_seq_estagio_p bigint, nr_seq_equipamento_p bigint, nr_seq_classif_p bigint, ie_parado_p text, ie_ambiente_p text) AS $body$
DECLARE


dt_ordem_w		man_ordem_serv_sla.dt_ordem%type;
ie_tempo_w		man_ordem_serv_sla.ie_tempo%type;
ie_tipo_sla_w		man_ordem_serv_sla.ie_tipo_sla%type;
qt_min_inicio_w		man_ordem_serv_sla.qt_min_inicio%type;
qt_ordem_sla_w		bigint;
nm_usuario_w		man_ordem_servico.nm_usuario%type;
ie_prioridade_w		man_ordem_servico.ie_prioridade%type;
ie_classificacao_w	man_ordem_servico.ie_classificacao%type;
nr_seq_localizacao_w	man_ordem_servico.nr_seq_localizacao%type;
nr_grupo_trabalho_w	man_ordem_servico.nr_grupo_trabalho%type;
dt_ordem_servico_w	man_ordem_servico.dt_ordem_servico%type;
dt_inicio_real_w	man_ordem_servico.dt_inicio_real%type;
nr_seq_estagio_w	man_ordem_servico.nr_seq_estagio%type;
nr_seq_equipamento_w	man_ordem_servico.nr_seq_equipamento%type;
nr_seq_classif_w	man_ordem_servico.nr_seq_classif%type;
ie_parado_w		man_ordem_servico.ie_parado%type;
qt_nova_regra_w		bigint;
qt_sla_monitor_w	bigint;
nr_seq_grupo_sup_w	man_ordem_servico.nr_seq_grupo_sup%type;
ie_se_lista_sla_w	varchar(1);
cd_estabelecimento_w	man_localizacao.cd_estabelecimento%type;
ie_classificacao_regra_w	man_ordem_serv_sla.ie_classificacao%type;
ie_prioridade_regra_w		man_ordem_serv_sla.ie_prioridade%type;
qt_min_termino_regra_w		man_ordem_serv_sla.qt_min_termino%type;
qt_min_inicio_regra_w		man_ordem_serv_sla.qt_min_termino%type;
dt_inicio_sla_w			man_ordem_serv_sla.dt_inicio_sla%type;
ie_tipo_sla_termino_w	man_ordem_serv_sla.ie_tipo_sla_termino%type;
ie_tempo_termino_w	man_ordem_serv_sla.ie_tempo_termino%type;

BEGIN

select	max(dt_inicio_sla)
into STRICT	dt_inicio_sla_w
from	man_ordem_serv_sla
where	nr_seq_ordem = nr_seq_ordem_serv_p;

select 	count(1)
into STRICT	qt_sla_monitor_w
from	man_sla_monitor	
where	nr_seq_ordem_servico = nr_seq_ordem_serv_p;

if (nr_seq_localizacao_p IS NOT NULL AND nr_seq_localizacao_p::text <> '') then
	begin
	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	man_localizacao
	where	nr_sequencia		= nr_seq_localizacao_p;
	exception
	when others then
		--Estabelecimento da localizacao(' ||:new.nr_seq_localizacao|| ') nao encontrado ou localizacao inexistente.')

		CALL wheb_mensagem_pck.exibir_mensagem_abort(263156,'CD_LOCAL=' || nr_seq_localizacao_p);
	end;
end if;

ie_se_lista_sla_w := sla_dashboard_pck.man_se_regra_sla(nr_seq_ordem_serv_p, nm_usuario_p, cd_estabelecimento_w);

qt_nova_regra_w := sla_dashboard_pck.obter_regra_sla(	cd_estabelecimento_w, nr_seq_ordem_serv_p,nm_usuario_p,
						ie_prioridade_p, ie_classificacao_p,
						nr_seq_localizacao_p, nr_seq_grupo_trab_p, dt_ordem_servico_p, 
						dt_inicio_p, nr_seq_estagio_p, nr_seq_equipamento_p, nr_seq_classif_p, ie_parado_p, ie_ambiente_p);
						
if (ie_classificacao_p = 'E' and qt_nova_regra_w = 0 and nr_seq_localizacao_p <> 41) then
	qt_nova_regra_w := sla_dashboard_pck.obter_regra_alldef(sla_dashboard_pck.obter_nr_seq_regra_alldef(), ie_classificacao_p, ie_prioridade_p);
end if;
												
select	max(b.qt_min_inicio),
	max(b.qt_min_termino),
	max(b.ie_tipo_sla),
	max(b.ie_tipo_sla_termino),
	max(b.ie_tempo),
	max(b.ie_tempo_termino)
into STRICT	qt_min_inicio_regra_w,
	qt_min_termino_regra_w,
	ie_tipo_sla_w,
	ie_tipo_sla_termino_w,
	ie_tempo_w,
	ie_tempo_termino_w
from	man_sla_regra b
where	nr_sequencia = qt_nova_regra_w;

if (ie_se_lista_sla_w = 'S') then
	if (qt_nova_regra_w > 0) then
		if (qt_sla_monitor_w = 0) then
			CALL sla_dashboard_pck.man_incluir_os_monitor(nr_seq_ordem_serv_p, nm_usuario_p, cd_estabelecimento_w, 'N','N', ie_classificacao_p, ie_prioridade_p, qt_min_inicio_regra_w, qt_min_termino_regra_w,
			null, qt_nova_regra_w, 'S', ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_p);
			CALL sla_dashboard_pck.atualizar_valor_serv_sla(qt_nova_regra_w, nr_seq_ordem_serv_p, dt_ordem_servico_p, cd_estabelecimento_w, nr_seq_localizacao_p);
		end if;
		CALL sla_dashboard_pck.man_incluir_os_evento(nr_seq_ordem_serv_p, nm_usuario_p, cd_estabelecimento_w, null,'14', 'N', ie_classificacao_p, ie_prioridade_p, qt_min_inicio_regra_w, qt_min_termino_regra_w,
					sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), qt_nova_regra_w, null, null, ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_p);

		CALL sla_dashboard_pck.atualizar_valor_serv_sla(qt_nova_regra_w, nr_seq_ordem_serv_p, dt_ordem_servico_p, cd_estabelecimento_w, nr_seq_localizacao_p);
	end if;
else
	if (qt_nova_regra_w > 0) then
		if (qt_sla_monitor_w = 0) then
			CALL sla_dashboard_pck.man_incluir_os_monitor(nr_seq_ordem_serv_p, nm_usuario_p, cd_estabelecimento_w, 'N','N', ie_classificacao_p, ie_prioridade_p, qt_min_inicio_regra_w, qt_min_termino_regra_w, null,
						qt_nova_regra_w, 'S', ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_p);
		end if;
		CALL sla_dashboard_pck.man_incluir_os_evento(nr_seq_ordem_serv_p, nm_usuario_p, cd_estabelecimento_w, null,'14', 'N', ie_classificacao_p, ie_prioridade_p, qt_min_inicio_regra_w,
					qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), qt_nova_regra_w, null, null, ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_p);
		
		CALL sla_dashboard_pck.atualizar_valor_serv_sla(qt_nova_regra_w, nr_seq_ordem_serv_p, dt_ordem_servico_p, cd_estabelecimento_w, nr_seq_localizacao_p);
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sla_dashboard_pck.validar_alt_ambiente_sla ( nr_seq_ordem_serv_p bigint, nm_usuario_p text, ie_prioridade_p text, ie_classificacao_p text, nr_seq_localizacao_p bigint, nr_seq_grupo_trab_p bigint, dt_ordem_servico_p timestamp, dt_inicio_p timestamp, nr_seq_estagio_p bigint, nr_seq_equipamento_p bigint, nr_seq_classif_p bigint, ie_parado_p text, ie_ambiente_p text) FROM PUBLIC;
