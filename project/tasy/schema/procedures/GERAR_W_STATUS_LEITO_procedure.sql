-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_status_leito ( dt_inicial_p timestamp, dt_final_p timestamp, cd_setor_Atendimento_p bigint, cd_motivo_interdicao_p bigint) AS $body$
DECLARE

 
	 
 
nr_seq_interno_w		bigint;
nr_atend_unidade_w		bigint;
dt_historico_w			timestamp;		
dt_fim_historico_w		timestamp;
cd_motivo_interdicao_w		bigint;
ie_status_unidade_w		varchar(3);
cd_motivo_interd_w		bigint;

/* atributos da tabela */
 
nr_seq_unidade_w		bigint;
nr_atendimento_w		bigint;
dt_alta_medica_w		timestamp;
dt_processo_alta_w		timestamp;
qt_minutos_alta_w		bigint;
qt_minutos_pos_alta_w		bigint;
dt_inicio_interdicao_w		timestamp;
dt_fim_interdicao_w		timestamp;
qt_minutos_interdicao_w		bigint;
qt_minutos_aguard_higi_w	bigint;
dt_inicio_higienizacao_w	timestamp;
dt_fim_higienizacao_w		timestamp;
qt_minutos_higienizacao_w	bigint;
				
c01 CURSOR FOR 
	SELECT	nr_seq_interno 
	from	unidade_atendimento a 
	where	exists (SELECT	1 
			from	unidade_atend_hist b 
			where	b.nr_seq_unidade = a.nr_seq_interno 
			and	dt_historico between dt_inicial_p and dt_final_p);
	
c02 CURSOR FOR 
	SELECT	distinct nr_atendimento 
	from	unidade_atend_hist a 
	where	dt_historico between dt_inicial_p and dt_final_p 
	and	nr_seq_unidade = nr_seq_interno_w 
	order by nr_atendimento;

c03 CURSOR FOR 
	SELECT	dt_historico, 
		dt_fim_historico, 
		cd_motivo_interdicao, 
		ie_status_unidade 
	from	unidade_atend_hist a 
	where	dt_historico between dt_inicial_p and dt_final_p 
	and	nr_seq_unidade = nr_seq_interno_w 
	and	nr_atendimento = nr_atend_unidade_w 
	order by nr_sequencia;	
	 

BEGIN 
 
delete	FROM w_status_leito;
 
open C01;
loop 
fetch 	C01 into	 
	nr_seq_interno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	 
	open C02;
	loop 
	fetch 	C02 into	 
		nr_atend_unidade_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		 
		nr_seq_unidade_w	 := nr_seq_interno_w;
		dt_alta_medica_w	 := null;
		dt_processo_alta_w	 := null;
		qt_minutos_alta_w	 := 0;
		qt_minutos_pos_alta_w	 := 0;
		dt_inicio_interdicao_w	 := null;
		dt_fim_interdicao_w	 := null;
		qt_minutos_interdicao_w	 := 0;
		qt_minutos_aguard_higi_w := 0;
		dt_inicio_higienizacao_w := null;
		dt_fim_higienizacao_w	 := null;
		qt_minutos_higienizacao_w := 0;
		nr_atendimento_w 	 := nr_atend_unidade_w;
		 
		open C03;
		loop 
		fetch C03 into	 
			dt_historico_w, 
			dt_fim_historico_w, 
			cd_motivo_interdicao_w, 
			ie_status_unidade_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
		 
			if (ie_status_unidade_w = 'A') then -- Em processo de alta			 
				 
				select	max(dt_alta_medico) 
				into STRICT	dt_alta_medica_w 
				from	atendimento_paciente 
				where	nr_atendimento = nr_atend_unidade_w;
			 
				dt_processo_alta_w := dt_historico_w;
			 
				if (dt_alta_medica_w IS NOT NULL AND dt_alta_medica_w::text <> '') and (dt_processo_alta_w IS NOT NULL AND dt_processo_alta_w::text <> '') then 
					qt_minutos_alta_w := obter_min_entre_datas(dt_alta_medica_w, dt_processo_alta_w, 1);
				end if;		
				 
			elsif (ie_status_unidade_w = 'I') then -- Interditado 
				 
				dt_inicio_interdicao_w := dt_historico_w;
				dt_fim_interdicao_w := coalesce(dt_fim_historico_w, clock_timestamp());
				cd_motivo_interd_w := cd_motivo_interdicao_w;
				 
				if (dt_inicio_interdicao_w IS NOT NULL AND dt_inicio_interdicao_w::text <> '') and (dt_processo_alta_w IS NOT NULL AND dt_processo_alta_w::text <> '') then 
					qt_minutos_pos_alta_w := obter_min_entre_datas(dt_processo_alta_w, dt_inicio_interdicao_w, 1);
				end if;		
				 
				if (dt_inicio_interdicao_w IS NOT NULL AND dt_inicio_interdicao_w::text <> '') and (dt_fim_interdicao_w IS NOT NULL AND dt_fim_interdicao_w::text <> '') then 
					qt_minutos_interdicao_w := obter_min_entre_datas(dt_inicio_interdicao_w, dt_fim_interdicao_w, 1);
				end if;	
				 
			elsif (ie_status_unidade_w = 'G') then -- Aguardando Higienização 
				 
				qt_minutos_aguard_higi_w := obter_min_entre_datas(dt_historico_w, coalesce(dt_fim_historico_w, clock_timestamp()), 1);
				 
			elsif (ie_status_unidade_w = 'H') then -- Higienização 
				 
				dt_inicio_higienizacao_w := dt_historico_w;
				dt_fim_higienizacao_w := coalesce(dt_fim_historico_w, clock_timestamp());
				 
				if (dt_inicio_higienizacao_w IS NOT NULL AND dt_inicio_higienizacao_w::text <> '') and (dt_fim_higienizacao_w IS NOT NULL AND dt_fim_higienizacao_w::text <> '') then 
					qt_minutos_pos_alta_w := obter_min_entre_datas(dt_inicio_higienizacao_w, dt_fim_higienizacao_w, 1);
				end if;		
				 
			end if;
		end loop;
		close C03;
	 
		insert into w_status_leito( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_unidade, 
			nr_atendimento, 
			dt_alta_medica, 
			dt_processo_alta, 
			qt_minutos_alta, 
			qt_minutos_pos_alta, 
			dt_inicio_interdicao, 
			dt_fim_interdicao, 
			qt_minutos_interdicao, 
			qt_minutos_aguard_higi, 
			dt_inicio_higienizacao, 
			dt_fim_higienizacao, 
			qt_minutos_higienizacao, 
			cd_motivo_interdicao) 
		values (nextval('w_status_leito_seq'), 
			clock_timestamp(), 
			'Tasy', 
			nr_seq_unidade_w, 
			nr_atendimento_w, 
			dt_alta_medica_w, 
			dt_processo_alta_w, 
			qt_minutos_alta_w, 
			qt_minutos_pos_alta_w, 
			dt_inicio_interdicao_w, 
			dt_fim_interdicao_w, 
			qt_minutos_interdicao_w, 
			qt_minutos_aguard_higi_w, 
			dt_inicio_higienizacao_w, 
			dt_fim_higienizacao_w, 
			qt_minutos_higienizacao_w, 
			cd_motivo_interd_w);
		 
	end loop;
	close C02;
	 
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_status_leito ( dt_inicial_p timestamp, dt_final_p timestamp, cd_setor_Atendimento_p bigint, cd_motivo_interdicao_p bigint) FROM PUBLIC;
