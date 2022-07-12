-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_leito_ocupacao ( ie_paciente_isolado_p text, ie_classif_etaria_p text, ie_sexo_paciente_p text, ie_status_unidade_p text, ie_temporario_p text, dt_alta_medico_p timestamp, ie_alta_medico_p text, nr_atend_alta_p bigint, ie_radiacao_p text, ie_int_radiacao_p text, dt_previsto_alta_p timestamp default null, ie_alta_tesouraria_p text default null, ie_alta_medico_prioridade_p text default null, nr_seq_interno_p bigint default 0, dt_saida_temp_p timestamp default null, dt_retorno_saida_temp_p timestamp default null, ie_html5_p text default 'N') RETURNS bigint AS $body$
DECLARE


nr_status_w			bigint	:= 5;
ie_status_serv_w		varchar(15);
ie_status_anterior_w		varchar(3);
ie_leito_adaptado_w		varchar(1);

nr_ult_atendimento_w		atendimento_paciente.nr_atendimento%type;
nr_seq_unidade_atend_hist_w	unidade_atend_hist.nr_sequencia%type;
dt_historico_w			timestamp;
dt_fim_historico_w		timestamp;
ie_existe_w			smallint;
dt_alta_tesouraria_w	timestamp;
nr_atendimento_w	bigint;
nr_sequencia_w			sl_unid_atend.nr_sequencia%type;


BEGIN


if (coalesce(nr_seq_interno_p,0)	> 0) then

	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	unidade_atendimento
	where	nr_Seq_interno = nr_seq_interno_p;

	if (coalesce(nr_atendimento_w,0) = 0) then
	
		select	max(nr_atendimento)
		into STRICT	nr_atendimento_w
		from	unidade_atend_hist	
		where	nr_sequencia = (SELECT	MAX(c.nr_sequencia)
					FROM    unidade_atend_hist c
					WHERE   c.nr_seq_unidade = nr_seq_interno_p)
		and	ie_status_unidade = 'A';
		
	end if;

end if;

if (ie_status_unidade_p = 'P') then
	if	((ie_alta_medico_p = 'S') or (ie_alta_medico_p = 'A')) and (nr_atend_alta_p IS NOT NULL AND nr_atend_alta_p::text <> '') then
		nr_status_w := 20;
	elsif	((ie_alta_medico_p = 'S') or (ie_alta_medico_p = 'M')) and (dt_alta_medico_p IS NOT NULL AND dt_alta_medico_p::text <> '') then
		nr_status_w := 19;
	elsif (ie_sexo_paciente_p = 'M') then
		if (ie_classif_etaria_p = 'A') then
			nr_status_w	:= 3;
		elsif (ie_classif_etaria_p = 'I') then
			nr_status_w	:= 16;
		elsif (ie_classif_etaria_p = 'C') then
			nr_status_w	:= 12;
		elsif (ie_classif_etaria_p = 'L') then
			nr_status_w	:= 14;
		end if;
	else
		if (ie_classif_etaria_p = 'A') then
			nr_status_w	:= 4;
		elsif (ie_classif_etaria_p = 'I') then
			nr_status_w	:= 17;
		elsif (ie_classif_etaria_p = 'C') then
			nr_status_w	:= 13;
		elsif (ie_classif_etaria_p = 'L') then
			nr_status_w	:= 15;
		end if;
	end if;
else
	if	(ie_status_unidade_p = 'L' AND ie_temporario_p = 'S') then
		nr_status_w	:= 10;
	elsif (ie_status_unidade_p = 'L') then
		select	coalesce(max(ie_leito_adaptado), 'N')
		into STRICT	ie_leito_adaptado_w
		from	unidade_atendimento
		where	nr_seq_interno = nr_seq_interno_p;

		if (ie_leito_adaptado_w = 'S') then
			nr_status_w	:= 31;
		else
			nr_status_w	:= 5;
		end if;
	elsif (ie_status_unidade_p = 'H') then
		nr_status_w	:= 1;
	elsif (ie_status_unidade_p = 'M') then
		nr_status_w	:= 7;
	elsif (ie_status_unidade_p = 'I') then
		nr_status_w	:= 8;
	elsif (ie_status_unidade_p = 'A') then
		nr_status_w	:= 6;
	elsif (ie_status_unidade_p = 'O') then
		nr_status_w	:= 9;
	elsif (ie_status_unidade_p = 'R') then
		nr_status_w	:= 2;
	elsif (ie_status_unidade_p = 'S') then
		nr_status_w	:= 18;
	elsif (ie_status_unidade_p = 'G') then
		
		select	max(ie_status_ant_unidade)
		into STRICT	ie_status_anterior_w
		from	unidade_atendimento
		where	nr_seq_interno = nr_seq_interno_p;
		
		if (ie_status_anterior_w = 'O') then
			nr_status_w	:= 30; -- Aguardando higienização (pós isolamento)
		else
			begin				
				-- Obter sequência do histórico da unidade
				select	max(nr_sequencia)
				into STRICT	nr_seq_unidade_atend_hist_w
				from	unidade_atend_hist
				where	nr_seq_unidade = nr_seq_interno_p
				and	ie_status_unidade = 'P';
				
				-- Obter dados do histórico da unidade
				select	max(nr_atendimento),
					max(dt_historico),
					max(dt_fim_historico)
				into STRICT	nr_ult_atendimento_w,
					dt_historico_w,
					dt_fim_historico_w
				from	unidade_atend_hist
				where	nr_sequencia = nr_seq_unidade_atend_hist_w;
				
				-- Verificar se o paciente estava em isolamento enquanto estava no leito
				begin
					select	1
					into STRICT	ie_existe_w
					from	atend_paciente_hist
					where	nr_atendimento = nr_ult_atendimento_w
					and		coalesce(dt_inativacao::text, '') = ''
					and	((dt_inicial between dt_historico_w and dt_fim_historico_w) or (dt_final between dt_historico_w and dt_fim_historico_w) or
						 (dt_inicial < dt_historico_w AND dt_final > dt_fim_historico_w))  LIMIT 1;
				exception
					when	others then
						ie_existe_w := null;
				end;
				
				-- se o paciente estava em isolamento enquanto estava no leito, utilizar o status Aguardando higienização (pós isolamento)
				if (ie_existe_w IS NOT NULL AND ie_existe_w::text <> '') then
					nr_status_w	:= 30; -- Aguardando higienização (pós isolamento)
				else
					nr_status_w	:= 23; -- Aguardando higienização
				end if;				
			
			exception
				when	others then
					nr_status_w	:= 23; -- Aguardando higienização
			end;
		end if;

	elsif (ie_status_unidade_p = 'E') then
		nr_status_w     := 24;
	elsif (ie_status_unidade_p = 'C') then
		nr_status_w     := 25;
	end if;
end if;

if (ie_paciente_isolado_p = 'S') then
	if (ie_sexo_paciente_p = 'M') then
		nr_status_w	:= 11;
	else
		nr_status_w	:= 9;
	end if;
elsif (ie_radiacao_p = 'S') then
	nr_status_w		:= 21;
elsif (ie_int_radiacao_p = 'S') then
	nr_status_w		:= 22;
end	if;


if (ie_paciente_isolado_p = 'N') and (ie_status_unidade_p = 'O') then
	if	((ie_sexo_paciente_p = 'M') or (ie_sexo_paciente_p = 'm')) then
		nr_status_w	:= 11;
	elsif	((ie_sexo_paciente_p = 'F') or (ie_sexo_paciente_p = 'f')) then
		nr_status_w	:= 9;
	else
		nr_status_w	:= 29;
	end if;
end if;

if	((dt_previsto_alta_p IS NOT NULL AND dt_previsto_alta_p::text <> '') and (ie_status_unidade_p in ('P','O'))) then
	nr_status_w 	:= 26;
end if;

if (ie_alta_tesouraria_p = 'S') then
	nr_status_w	:= 27;
end if;

if (ie_alta_medico_p = 'S') and (dt_alta_medico_p IS NOT NULL AND dt_alta_medico_p::text <> '') and (ie_alta_medico_prioridade_p = 'S') then
	nr_status_w := 19;
end if;

if (coalesce(nr_seq_interno_p,0) > 0) then

	select 	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	sl_unid_atend
	where	nr_seq_unidade = nr_seq_interno_p
	and	trunc(clock_timestamp()) between trunc(dt_inicio) and trunc(coalesce(dt_fim, clock_timestamp()))
	and	trunc(dt_inicio) >= trunc(clock_timestamp() - interval '1 days')
	and	(dt_pausa_servico IS NOT NULL AND dt_pausa_servico::text <> '');

	if (coalesce(nr_sequencia_w,0) > 0) then
		select	max(ie_status_serv)
		into STRICT	ie_status_serv_w
		from	sl_unid_atend
		where	nr_sequencia	= nr_sequencia_w;

		if (ie_status_serv_w IS NOT NULL AND ie_status_serv_w::text <> '') and (ie_status_serv_w = 'IP') then
			nr_status_w := 28;
		end if;
	end if;
end if;

if (dt_saida_temp_p IS NOT NULL AND dt_saida_temp_p::text <> '') and (coalesce(dt_retorno_saida_temp_p::text, '') = '') then
	nr_status_w := 32;
end if;


if (coalesce(nr_atendimento_w,0) > 0) then

	select	max(dt_alta_tesouraria)
	into STRICT	dt_alta_tesouraria_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;
	
	if (dt_alta_tesouraria_w IS NOT NULL AND dt_alta_tesouraria_w::text <> '') then
		nr_status_w	:= 33;
	end if;
end if;
if ie_html5_p = 'S' then
	if (coalesce(nr_atendimento_w,0) > 0) then
		if OBTER_SE_PACIENTE_AWAY(nr_atendimento_w) = 'S' then
			nr_status_w	:= 34;
		end if;
	end if;
end if;
return nr_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_leito_ocupacao ( ie_paciente_isolado_p text, ie_classif_etaria_p text, ie_sexo_paciente_p text, ie_status_unidade_p text, ie_temporario_p text, dt_alta_medico_p timestamp, ie_alta_medico_p text, nr_atend_alta_p bigint, ie_radiacao_p text, ie_int_radiacao_p text, dt_previsto_alta_p timestamp default null, ie_alta_tesouraria_p text default null, ie_alta_medico_prioridade_p text default null, nr_seq_interno_p bigint default 0, dt_saida_temp_p timestamp default null, dt_retorno_saida_temp_p timestamp default null, ie_html5_p text default 'N') FROM PUBLIC;

