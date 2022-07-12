-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_lote_pagamento_pck.obter_restricao_inconsistencia ( ie_tipo_data_p text, dt_inicio_p timestamp, dt_fim_p timestamp, ie_sem_evento_vinc_p text, ie_sem_lote_pagamento_p text, nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_evento_p pls_evento.nr_sequencia%type, nr_seq_tipo_prestador_p pls_tipo_prestador.nr_sequencia%type, ds_tab_extra_mat_p out text, ds_tab_extra_proc_p out text, ds_restricao_mat_p out text, ds_restricao_proc_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

					
ds_restricao_w 		varchar(2000);


BEGIN

-- inicia a variavel com null

ds_restricao_w := null;
ds_tab_extra_mat_p := null;
ds_tab_extra_proc_p := null;
ds_restricao_mat_p := null;
ds_restricao_proc_p := null;

-- se for para usar a data do protocolo

if (ie_tipo_data_p in ('0', '1')) then
	ds_tab_extra_mat_p := ds_tab_extra_mat_p || ',' || pls_util_pck.enter_w || 'pls_protocolo_conta prot' || pls_util_pck.enter_w;
	ds_tab_extra_proc_p := ds_tab_extra_proc_p || ',' || pls_util_pck.enter_w || 'pls_protocolo_conta prot' || pls_util_pck.enter_w;
	
	ds_restricao_w := ds_restricao_w || 'and prot.nr_sequencia = a.nr_seq_protocolo' || pls_util_pck.enter_w;
end if;
	
-- data de competencia do protocolo

if (ie_tipo_data_p = '0') then
	ds_restricao_w := ds_restricao_w || ' and prot.dt_mes_competencia between :dt_inicio_pc and :dt_fim_pc' || pls_util_pck.enter_w;

-- data de liberacao de pagamento do protocolo

elsif (ie_tipo_data_p = '1') then
	ds_restricao_w := ds_restricao_w || ' and prot.dt_lib_pagamento between :dt_inicio_pc and :dt_fim_pc' || pls_util_pck.enter_w;
	
-- data de competencia do resumo de conta medica

elsif (ie_tipo_data_p = '2') then
	ds_restricao_w := ds_restricao_w || ' and a.dt_competencia_pgto between :dt_inicio_pc and :dt_fim_pc' || pls_util_pck.enter_w;	
end if;
-- binds variables dos filtros de data acima

valor_bind_p := sql_pck.bind_variable(':dt_inicio_pc', dt_inicio_p, valor_bind_p);
valor_bind_p := sql_pck.bind_variable(':dt_fim_pc', dt_fim_p, valor_bind_p);

-- item sem evento vinculado

if (ie_sem_evento_vinc_p = 'S') then
	ds_restricao_w := ds_restricao_w || 'and a.nr_seq_lote_pgto is null' || pls_util_pck.enter_w ||
					    'and a.nr_seq_pp_evento is null' || pls_util_pck.enter_w;
end if;

-- item sem lote de pagamento

if (ie_sem_lote_pagamento_p = 'S') then
	ds_restricao_w := ds_restricao_w || 	'and a.nr_seq_lote_pgto is null' || pls_util_pck.enter_w ||
						'and a.nr_seq_pp_lote is null' || pls_util_pck.enter_w;
end if;

-- Prestador pagamento

if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then
	ds_restricao_w := ds_restricao_w || ' and a.nr_seq_prestador_pgto = :nr_seq_prestador_pc ' || pls_util_pck.enter_w;	
	valor_bind_p := sql_pck.bind_variable(':nr_seq_prestador_pc', nr_seq_prestador_p, valor_bind_p);
end if;

-- Evento producao medica

if (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') then
	ds_restricao_w := ds_restricao_w || ' and a.nr_seq_pp_evento = :nr_seq_evento_pc ' || pls_util_pck.enter_w;	
	valor_bind_p := sql_pck.bind_variable(':nr_seq_evento_pc', nr_seq_evento_p, valor_bind_p);
end if;

-- Tipo do prestador de pagamento

if (nr_seq_tipo_prestador_p IS NOT NULL AND nr_seq_tipo_prestador_p::text <> '') then
	ds_restricao_w := ds_restricao_w || ' and pp.nr_seq_tipo_prestador = :nr_seq_tipo_prestador_pc ' || pls_util_pck.enter_w;	
	valor_bind_p := sql_pck.bind_variable(':nr_seq_tipo_prestador_pc', nr_seq_tipo_prestador_p, valor_bind_p);
end if;

-- retorna a restricao que sera utilizada no select

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_lote_pagamento_pck.obter_restricao_inconsistencia ( ie_tipo_data_p text, dt_inicio_p timestamp, dt_fim_p timestamp, ie_sem_evento_vinc_p text, ie_sem_lote_pagamento_p text, nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_evento_p pls_evento.nr_sequencia%type, nr_seq_tipo_prestador_p pls_tipo_prestador.nr_sequencia%type, ds_tab_extra_mat_p out text, ds_tab_extra_proc_p out text, ds_restricao_mat_p out text, ds_restricao_proc_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;