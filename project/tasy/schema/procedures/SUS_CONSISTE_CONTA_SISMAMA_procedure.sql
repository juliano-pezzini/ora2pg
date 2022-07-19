-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_consiste_conta_sismama ( nr_seq_protocolo_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_forma_envio_p text, nm_usuario_p text, nr_contas_p INOUT text) AS $body$
DECLARE

 
nr_interno_conta_w		bigint;
dt_mesano_referencia_w	timestamp;
qt_laudo_sismama_w	bigint;
nr_contas_w		varchar(2000) := ' ';
qt_registro_w		bigint := 0;
ie_consiste_conta_w	varchar(15) := 'S';
cd_estabelecimento_w	integer;
ie_considera_data_diag_w	varchar(15) := 'N';

c01 CURSOR FOR 
	SELECT	a.nr_interno_conta, 
		b.dt_mesano_referencia 
	from	conta_paciente a, 
		protocolo_convenio b 
	where	a.nr_seq_protocolo = nr_seq_protocolo_p 
	and	a.nr_seq_protocolo = b.nr_seq_protocolo 
	and	ie_forma_envio_p = 'P' 
	
union
 
	SELECT	a.nr_interno_conta, 
		a.dt_mesano_referencia 
	from	procedimento_paciente c, 
		atendimento_paciente e, 
		conta_paciente a 
	where	a.nr_interno_conta	= c.nr_interno_conta 
	and	a.cd_convenio_parametro = obter_dados_param_faturamento(a.cd_estabelecimento,'CSUS') 
	and	sus_obter_tiporeg_proc(c.cd_procedimento, c.ie_origem_proced, 'C', 1) in (1,2) 
	and	e.ie_tipo_atendimento	<> 1 
	and	a.ie_status_acerto 	= 2 
	and	coalesce(a.ie_cancelamento::text, '') = '' 
	and	a.dt_periodo_final between dt_inicial_p and dt_final_p 
	and	a.nr_atendimento 	= e.nr_atendimento 
	and	ie_forma_envio_p	= 'C'	 
	and	exists (select	1 
			from	sismama_atendimento x 
			where	x.nr_atendimento = a.nr_atendimento);


BEGIN 
 
begin 
select 	max(cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	conta_paciente 
where	nr_seq_protocolo = nr_seq_protocolo_p;
exception 
	when others then 
	cd_estabelecimento_w := null;
	end;
 
ie_consiste_conta_w 		:= coalesce(obter_valor_param_usuario(1125,89,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),'S');
ie_considera_data_diag_w		:= coalesce(obter_valor_param_usuario(1125,102,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),'N');
 
if (ie_consiste_conta_w = 'S') then 
	begin 
	open C01;
	loop 
	fetch C01 into 
		nr_interno_conta_w, 
		dt_mesano_referencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
 
		if (coalesce(ie_considera_data_diag_w,'N') = 'S') then 
			begin 
 
			begin 
			select	count(*) 
			into STRICT	qt_laudo_sismama_w 
			FROM conta_paciente b, sismama_atendimento a
LEFT OUTER JOIN sismama_mam_conclusao c ON (a.nr_sequencia = c.nr_seq_sismama)
WHERE a.nr_atendimento 	= b.nr_atendimento  and coalesce(c.dt_liberacao,a.dt_liberacao) between trunc(dt_mesano_referencia_w,'mm') and last_day(fim_dia(dt_mesano_referencia_w)) and a.nr_sequencia = (	SELECT	max(x.nr_sequencia) 
						from	sismama_atendimento x 
						where	x.nr_atendimento = a.nr_atendimento) and b.nr_interno_conta 	= nr_interno_conta_w;
			exception 
			when others then 
				qt_laudo_sismama_w := 0;
			end;
 
			end;
		elsif (coalesce(ie_considera_data_diag_w,'N') = 'P') then 
			begin 
 
			begin 
			select	count(*) 
			into STRICT	qt_laudo_sismama_w 
			FROM conta_paciente b, sismama_atendimento a
LEFT OUTER JOIN sismama_mam_conclusao c ON (a.nr_sequencia = c.nr_seq_sismama)
WHERE a.nr_atendimento 	= b.nr_atendimento  and (coalesce(c.dt_liberacao,a.dt_liberacao) between trunc(dt_mesano_referencia_w,'mm') and last_day(fim_dia(dt_mesano_referencia_w)) or (coalesce(c.dt_liberacao,a.dt_liberacao) < trunc(dt_mesano_referencia_w,'mm'))) and a.nr_sequencia = (	SELECT	max(x.nr_sequencia) 
						from	sismama_atendimento x 
						where	x.nr_atendimento = a.nr_atendimento) and b.nr_interno_conta 	= nr_interno_conta_w;
			exception 
			when others then 
				qt_laudo_sismama_w := 0;
			end;
 
			end;
		else 
			begin 
 
			begin 
			select	count(*) 
			into STRICT	qt_laudo_sismama_w 
			from	sismama_atendimento a, 
				conta_paciente b 
			where	a.nr_atendimento 	= b.nr_atendimento 
			and	a.dt_liberacao between trunc(dt_mesano_referencia_w,'mm') and last_day(fim_dia(dt_mesano_referencia_w)) 
			and	a.nr_sequencia = (	SELECT	max(x.nr_sequencia) 
						from	sismama_atendimento x 
						where	x.nr_atendimento = a.nr_atendimento) 
			and	b.nr_interno_conta 	= nr_interno_conta_w;
			exception 
			when others then 
				qt_laudo_sismama_w := 0;
			end;
 
			end;
		end if;
 
		if (coalesce(qt_laudo_sismama_w,0) = 0) and 
			((length(nr_contas_w)+length(nr_interno_conta_w)) <= 255)then 
			begin 
			if (qt_registro_w < 15) then 
				begin 
				nr_contas_w := nr_contas_w || nr_interno_conta_w || ',';
				qt_registro_w := qt_registro_w +1;
				end;
			else 
				begin 
				nr_contas_w := nr_contas_w || nr_interno_conta_w || ','||chr(13)||chr(10);
				qt_registro_w := 0;
				end;
			end if;
			end;
		end if;
 
		end;
	end loop;
	close C01;
	end;
end if;
 
nr_contas_p := substr(nr_contas_w,1,length(nr_contas_w) - 1);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_consiste_conta_sismama ( nr_seq_protocolo_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_forma_envio_p text, nm_usuario_p text, nr_contas_p INOUT text) FROM PUBLIC;

