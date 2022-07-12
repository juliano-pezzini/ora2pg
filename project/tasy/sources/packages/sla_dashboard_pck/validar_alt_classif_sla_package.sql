-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sla_dashboard_pck.validar_alt_classif_sla ( nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p bigint, ie_classificacao_p man_ordem_servico.ie_classificacao%type) AS $body$
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
cd_estabelecimento_w	man_localizacao.cd_estabelecimento%type;
ie_classificacao_regra_w	man_ordem_serv_sla.ie_classificacao%type;
ie_prioridade_regra_w		man_ordem_serv_sla.ie_prioridade%type;
qt_min_termino_regra_w		man_ordem_serv_sla.qt_min_termino%type;
qt_min_inicio_regra_w		man_ordem_serv_sla.qt_min_termino%type;
nr_seq_serv_sla_w		man_ordem_serv_sla.nr_sequencia%type;
nr_seq_sla_regra_w		man_ordem_serv_sla.nr_seq_sla_regra%type;
nr_seq_grupo_des_w		man_ordem_servico.nr_seq_grupo_des%type;
dt_inicio_sla_w			man_ordem_serv_sla.dt_inicio_sla%type;
ie_classificacao_cliente_w	man_ordem_servico.ie_classificacao_cliente%type;
ie_tipo_sla_termino_w		man_ordem_serv_sla.ie_tipo_sla_termino%type;
ie_tempo_termino_w		man_ordem_serv_sla.ie_tempo_termino%type;
ie_ambiente_w		man_ordem_servico.ie_ambiente%type;
cd_funcao_w			man_ordem_servico.cd_funcao%type;


BEGIN

select	count(1)
into STRICT	qt_ordem_sla_w
from	man_ordem_serv_sla
where	nr_seq_ordem = nr_seq_ordem_serv_p;

select 	max(nm_usuario),
	max(ie_prioridade),
	max(ie_classificacao),
	max(nr_seq_localizacao),
	max(nr_grupo_trabalho),
	max(dt_ordem_servico),
	max(dt_inicio_real),
	max(nr_seq_estagio),
	max(nr_seq_equipamento),
	max(nr_seq_classif),
	max(ie_parado),
	max(nr_seq_grupo_des),
	max(nr_seq_grupo_sup),
	max(ie_classificacao_cliente),
	max(ie_ambiente),
	max(cd_funcao)
into STRICT	nm_usuario_w,
	ie_prioridade_w,
	ie_classificacao_w,
	nr_seq_localizacao_w,
	nr_grupo_trabalho_w,
	dt_ordem_servico_w,
	dt_inicio_real_w,
	nr_seq_estagio_w,
	nr_seq_equipamento_w,
	nr_seq_classif_w,
	ie_parado_w,
	nr_seq_grupo_des_w,
	nr_seq_grupo_sup_w,
	ie_classificacao_cliente_w,
	ie_ambiente_w,
	cd_funcao_w
from man_ordem_servico
where	nr_sequencia = nr_seq_ordem_serv_p;

select	max(qt_min_inicio),
	max(qt_min_termino),
	max(ie_classificacao),
	max(ie_prioridade),
	max(nr_sequencia),
	max(nr_seq_sla_regra),
	max(dt_inicio_sla),
	max(dt_ordem),
	max(ie_tipo_sla),
	max(ie_tipo_sla_termino),
	max(ie_tempo),
	max(ie_tempo_termino)
into STRICT	qt_min_inicio_regra_w,
	qt_min_termino_regra_w,
	ie_classificacao_regra_w,
	ie_prioridade_regra_w,
	nr_seq_serv_sla_w,
	nr_seq_sla_regra_w,
	dt_inicio_sla_w,
	dt_ordem_w,
	ie_tipo_sla_w,
	ie_tipo_sla_termino_w,
	ie_tempo_w,
	ie_tempo_termino_w
from	man_ordem_serv_sla
where	nr_seq_ordem = nr_seq_ordem_serv_p;


qt_nova_regra_w := sla_dashboard_pck.obter_se_tem_regra_sla(	cd_estabelecimento_p, nr_seq_ordem_serv_p,nm_usuario_w,
						ie_prioridade_w, ie_classificacao_p,
						nr_seq_localizacao_w, nr_grupo_trabalho_w, dt_ordem_servico_w, 
						dt_inicio_real_w, nr_seq_estagio_w, nr_seq_equipamento_w, nr_seq_classif_w, ie_parado_w, ie_ambiente_w);

select 	count(1)
into STRICT	qt_sla_monitor_w
from	man_sla_monitor	
where	nr_seq_ordem_servico = nr_seq_ordem_serv_p;

if (nr_seq_localizacao_w IS NOT NULL AND nr_seq_localizacao_w::text <> '') then
	begin
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	man_localizacao
	where	nr_sequencia = nr_seq_localizacao_w;
	exception
	when others then
		--Estabelecimento da localizacao(' ||:new.nr_seq_localizacao|| ') nao encontrado ou localizacao inexistente.')

		CALL wheb_mensagem_pck.exibir_mensagem_abort(263156,'CD_LOCAL=' || nr_seq_localizacao_w);
	end;
end if;
if (qt_ordem_sla_w > 0) then
	if (qt_nova_regra_w > 0) then
		if (nr_seq_serv_sla_w IS NOT NULL AND nr_seq_serv_sla_w::text <> '') then
			if (ie_classificacao_regra_w <> ie_classificacao_cliente_w) then
				update	man_ordem_serv_sla set dt_inicio_sla = clock_timestamp() where nr_sequencia = nr_seq_serv_sla_w;
			else
				update	man_ordem_serv_sla set dt_inicio_sla = dt_ordem_w where nr_sequencia = nr_seq_serv_sla_w;
			end if;
		end if;
		
		if (qt_sla_monitor_w = 0) then
			CALL sla_dashboard_pck.man_incluir_os_monitor(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, 'S','N', ie_classificacao_regra_w, ie_prioridade_regra_w, qt_min_inicio_regra_w,
						qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, 'S', ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
		end if;
		CALL sla_dashboard_pck.man_incluir_os_evento(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, nr_seq_grupo_des_w ,'11', 'S', ie_classificacao_regra_w, ie_prioridade_regra_w,
					qt_min_inicio_regra_w, qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, nr_seq_grupo_sup_w, null, 
					ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
	else
		if (qt_sla_monitor_w > 0) then
			if (nr_seq_serv_sla_w IS NOT NULL AND nr_seq_serv_sla_w::text <> '') then
				if (ie_classificacao_regra_w <> ie_classificacao_cliente_w) then
					update	man_ordem_serv_sla set dt_inicio_sla = clock_timestamp() where nr_sequencia = nr_seq_serv_sla_w;
				else
					update	man_ordem_serv_sla set dt_inicio_sla = dt_ordem_w where nr_sequencia = nr_seq_serv_sla_w;
				end if;
			end if;
			CALL sla_dashboard_pck.man_incluir_os_evento(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, nr_seq_grupo_des_w,'3', 'S', ie_classificacao_regra_w, ie_prioridade_regra_w,
							qt_min_inicio_regra_w, qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, nr_seq_grupo_sup_w,
							null, ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
		else
			CALL sla_dashboard_pck.man_incluir_os_monitor(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, 'S','N', ie_classificacao_regra_w, ie_prioridade_regra_w, qt_min_inicio_regra_w,
						qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, 'S', ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
			CALL sla_dashboard_pck.man_incluir_os_evento(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, nr_seq_grupo_des_w,'3', 'S', ie_classificacao_regra_w, ie_prioridade_regra_w,
						qt_min_inicio_regra_w, qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, nr_seq_grupo_sup_w,
						null, ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
			if (nr_seq_serv_sla_w IS NOT NULL AND nr_seq_serv_sla_w::text <> '') then
				if (ie_classificacao_regra_w <> ie_classificacao_cliente_w) then
					update	man_ordem_serv_sla set dt_inicio_sla = clock_timestamp() where nr_sequencia = nr_seq_serv_sla_w;
				else
					update	man_ordem_serv_sla set dt_inicio_sla = dt_ordem_w where nr_sequencia = nr_seq_serv_sla_w;
				end if;
			end if;
		end if;
	end if;
else
	if (qt_nova_regra_w > 0) then
		CALL sla_dashboard_pck.man_incluir_os_monitor(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, 'S','N', ie_classificacao_regra_w, ie_prioridade_regra_w, qt_min_inicio_regra_w,
					qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, 'S', ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
		CALL sla_dashboard_pck.man_incluir_os_evento(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, nr_seq_grupo_des_w ,'3', 'S', ie_classificacao_regra_w, ie_prioridade_regra_w,
						qt_min_inicio_regra_w, qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, nr_seq_grupo_sup_w,
						null, ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
		if (nr_seq_serv_sla_w IS NOT NULL AND nr_seq_serv_sla_w::text <> '') then
			if (ie_classificacao_regra_w <> ie_classificacao_cliente_w) then
				update	man_ordem_serv_sla set dt_inicio_sla = clock_timestamp() where nr_sequencia = nr_seq_serv_sla_w;
			else
				update	man_ordem_serv_sla set dt_inicio_sla = dt_ordem_w where nr_sequencia = nr_seq_serv_sla_w;
			end if;
		end if;
	else
		if ((ie_classificacao_p = 'E') and (sla_dashboard_pck.obter_regra_loc_sla(nr_seq_localizacao_w, cd_funcao_w) = 'N')) then
			if (qt_ordem_sla_w = 0) then
				CALL sla_dashboard_pck.incluir_os_sla_recebidas(cd_estabelecimento_w, nr_seq_ordem_serv_p, nm_usuario_w, ie_prioridade_w, ie_classificacao_p, dt_ordem_servico_w,
						dt_inicio_real_w, sla_dashboard_pck.obter_regra_alldef(sla_dashboard_pck.obter_nr_seq_regra_alldef(), ie_classificacao_p, ie_prioridade_w), 'S', null, ie_ambiente_w);
			end if;
			CALL sla_dashboard_pck.man_incluir_os_evento(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, nr_seq_grupo_des_w,'3', 'S', ie_classificacao_regra_w, ie_prioridade_regra_w,
					qt_min_inicio_regra_w, qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, nr_seq_grupo_sup_w, null,
					ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
			if (ie_classificacao_p <> ie_classificacao_cliente_w) then
				update	man_ordem_serv_sla set dt_inicio_sla = clock_timestamp() where nr_seq_ordem = nr_seq_ordem_serv_p;
			else
				update	man_ordem_serv_sla set dt_inicio_sla = dt_ordem_w where nr_seq_ordem = nr_seq_ordem_serv_p;
			end if;
		else

			if (qt_sla_monitor_w > 0) then
				CALL sla_dashboard_pck.man_incluir_os_evento(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, nr_seq_grupo_des_w,'7', 'S', ie_classificacao_regra_w, ie_prioridade_regra_w,
							qt_min_inicio_regra_w, qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, nr_seq_grupo_sup_w,
							null, ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
				CALL sla_dashboard_pck.man_delete_os_monitor(nr_seq_ordem_serv_p);
			else
				CALL sla_dashboard_pck.man_incluir_os_evento(nr_seq_ordem_serv_p, 'Tasy', cd_estabelecimento_w, nr_seq_grupo_des_w,'7', 'S', ie_classificacao_regra_w, ie_prioridade_regra_w,
							qt_min_inicio_regra_w, qt_min_termino_regra_w, sla_dashboard_pck.obter_tempo_abertura(dt_inicio_sla_w), nr_seq_sla_regra_w, nr_seq_grupo_sup_w,
							null, ie_tipo_sla_w, ie_tipo_sla_termino_w, ie_tempo_w, ie_tempo_termino_w, ie_ambiente_w);
			end if;
		end if;
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sla_dashboard_pck.validar_alt_classif_sla ( nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p bigint, ie_classificacao_p man_ordem_servico.ie_classificacao%type) FROM PUBLIC;