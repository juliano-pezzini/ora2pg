-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerencia_envio_ans_pck.obter_outros_lotes_mes ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(3000);
ie_lote_forn_dir_w	pls_monitor_tiss_lote.ie_fornec_direto%type;

-- retorna todos os lotes que esto em processo no ms e que no foram enviados para a ANS

-- e que no so o lote que est sendo requisitado no momento

c01 CURSOR(	nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type,
		dt_inicio_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		dt_fim_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type,
		ie_controla_estab_pc	pls_controle_estab.ie_monitoramento_ans%type) FOR
	SELECT	nr_sequencia
	from   	pls_monitor_tiss_lote
	where  	ie_status != 'LG'
	and    	dt_mes_competencia between dt_inicio_pc and dt_fim_pc
	and    	nr_sequencia != nr_seq_lote_pc
	and	ie_controla_estab_pc = 'N'
	and 	coalesce(ie_fornec_direto,'N') = ie_lote_forn_dir_w
	and	ie_tipo_lote = '0'
	
union all

	SELECT	nr_sequencia
	from   	pls_monitor_tiss_lote
	where  	ie_status != 'LG'
	and    	dt_mes_competencia between dt_inicio_pc and dt_fim_pc
	and    	nr_sequencia != nr_seq_lote_pc
	and	cd_estabelecimento = cd_estabelecimento_pc
	and	ie_controla_estab_pc = 'S'
	and 	coalesce(ie_fornec_direto,'N') = ie_lote_forn_dir_w 	
	and	ie_tipo_lote = '0';

c02 CURSOR(	nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type,
		dt_inicio_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		dt_fim_pc		pls_monitor_tiss_lote.dt_mes_competencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type,
		ie_controla_estab_pc	pls_controle_estab.ie_monitoramento_ans%type) FOR
	SELECT	nr_sequencia
	from   	pls_monitor_tiss_lote
	where  	ie_status != 'LG'
	and    	dt_mes_competencia between dt_inicio_pc and dt_fim_pc
	and    	nr_sequencia != nr_seq_lote_pc
	and	ie_controla_estab_pc = 'N'
	and 	coalesce(ie_fornec_direto,'N') = ie_lote_forn_dir_w 	
	and	ie_tipo_lote = '1'
	
union all

	SELECT	nr_sequencia
	from   	pls_monitor_tiss_lote
	where  	ie_status != 'LG'
	and    	dt_mes_competencia between dt_inicio_pc and dt_fim_pc
	and    	nr_sequencia != nr_seq_lote_pc
	and	cd_estabelecimento = cd_estabelecimento_pc
	and	ie_controla_estab_pc = 'S'
	and 	coalesce(ie_fornec_direto,'N') = ie_lote_forn_dir_w 	
	and	ie_tipo_lote = '1';
BEGIN
ds_retorno_w := null;

select 	coalesce(max(ie_fornec_direto),'N')
into STRICT	ie_lote_forn_dir_w
from	pls_monitor_tiss_lote
where	nr_sequencia = nr_seq_lote_p;

if (current_setting('pls_gerencia_envio_ans_pck.ie_tipo_lote_w')::pls_monitor_tiss_lote.ie_tipo_lote%type = '0') then
	for r_c01_w in c01(	nr_seq_lote_p, current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_ini_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_fim_w')::pls_monitor_tiss_lote.dt_mes_competencia%type,
				cd_estabelecimento_p, current_setting('pls_gerencia_envio_ans_pck.ie_controla_estab_w')::pls_controle_estab.ie_monitoramento_ans%type) loop

		if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
			ds_retorno_w := ds_retorno_w || ', ' || to_char(r_c01_w.nr_sequencia);
		else
			ds_retorno_w := to_char(r_c01_w.nr_sequencia);
		end if;

	end loop;
else
	for r_c02_w in c02(	nr_seq_lote_p, current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_ini_w')::pls_monitor_tiss_lote.dt_mes_competencia%type, current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_fim_w')::pls_monitor_tiss_lote.dt_mes_competencia%type,
				cd_estabelecimento_p, current_setting('pls_gerencia_envio_ans_pck.ie_controla_estab_w')::pls_controle_estab.ie_monitoramento_ans%type) loop

		if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
			ds_retorno_w := ds_retorno_w || ', ' || to_char(r_c02_w.nr_sequencia);
		else
			ds_retorno_w := to_char(r_c02_w.nr_sequencia);
		end if;

	end loop;
end if;

return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_gerencia_envio_ans_pck.obter_outros_lotes_mes ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
