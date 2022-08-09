-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desdobrar_conta_periodo ( dt_parametro_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
qt_dias_desdobramento_w	bigint;
nr_interno_conta_w	bigint;
cd_convenio_w		bigint;
cd_categoria_w		varchar(10);
cd_estabelecimento_w	smallint;
dt_periodo_inicial_w	timestamp;
ds_erro_w		varchar(255);
nr_atendimento_w	bigint;
ie_tipo_atendimento_w	smallint;
qt_regras_w		bigint;
nr_interno_conta_ww	bigint;
ie_fecha_conta_w	varchar(1);
ie_dia_seguinte_w	varchar(1):= 'N';
cd_plano_w		varchar(10);
nr_seq_desdob_w		bigint;
hr_desdobramento_w	timestamp;
dt_referencia_w		timestamp;
dt_alta_w		timestamp;
dt_periodo_final_ww	timestamp;

C01 CURSOR FOR 
	SELECT	a.nr_interno_conta, 
		a.cd_convenio_parametro, 
		a.cd_categoria_parametro, 
		a.cd_estabelecimento, 
		a.dt_periodo_inicial, 
		b.nr_atendimento, 
		b.ie_tipo_atendimento, 
		b.dt_alta 
	from	conta_paciente a, 
		atendimento_paciente b 
	where	a.nr_atendimento = b.nr_atendimento 
	and 	b.ie_tipo_atendimento = 1 
	and 	coalesce(b.dt_alta::text, '') = '' 
	and 	coalesce(b.dt_fim_conta::text, '') = '' 
	and 	coalesce(b.dt_cancelamento::text, '') = '' 
	and 	a.ie_status_acerto = 1 
	order by coalesce(a.cd_estabelecimento,0), 
		coalesce(a.cd_convenio_parametro,0), 
		coalesce(a.cd_categoria_parametro,0), 
		coalesce(a.nr_interno_conta,0);
				

BEGIN 
 
select 	count(*) 
into STRICT	qt_regras_w 
from 	conv_regra_desdobramento;
 
if (qt_regras_w > 0) then 
 
	ie_dia_seguinte_w := coalesce(Obter_valor_param_usuario(67, 613, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento),'N');
 
	-- Contas abertas e sem alta 
	open C01;
	loop 
	fetch C01 into	 
		nr_interno_conta_w, 
		cd_convenio_w, 
		cd_categoria_w, 
		cd_estabelecimento_w, 
		dt_periodo_inicial_w, 
		nr_atendimento_w, 
		ie_tipo_atendimento_w, 
		dt_alta_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		select	max(obter_plano_convenio_atend(nr_atendimento_w, 'C')) 
		into STRICT	cd_plano_w 
		;
		 
		-- Criar uma tabela de regra por convênio / categoria / tipo de atendimento / Plano convênio / estabelecimento 
		 
		select	coalesce(max(qt_dias_desdobramento),0), 
			coalesce(max(ie_fecha_conta),'S'), 
			max(hr_desdobramento) 
		into STRICT	qt_dias_desdobramento_w, 
			ie_fecha_conta_w, 
			hr_desdobramento_w 
		from 	conv_regra_desdobramento 
		where 	cd_convenio = cd_convenio_w 
		and 	coalesce(cd_categoria, coalesce(cd_categoria_w,'0')) = coalesce(cd_categoria_w,'0') 
		and 	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w) = ie_tipo_atendimento_w 
		and	coalesce(cd_plano, coalesce(cd_plano_w, '0')) = coalesce(cd_plano_w, '0') 
		and 	ie_situacao = 'A' 
		and 	cd_estabelecimento = cd_estabelecimento_w;
 
		if (qt_dias_desdobramento_w > 0) then 
		 
			ds_erro_w:= null;
			if (trunc(dt_periodo_inicial_w + qt_dias_desdobramento_w) = trunc(dt_parametro_p)) then 
									 
				if (ie_dia_seguinte_w = 'N') then 
					dt_referencia_w:= trunc(dt_parametro_p,'dd');
				else 
					dt_referencia_w:= trunc(dt_parametro_p,'dd') + 1;
				end if;
 
				if (hr_desdobramento_w IS NOT NULL AND hr_desdobramento_w::text <> '') then 
					select 	to_date(to_char(trunc(dt_referencia_w),'dd/mm/yyyy') ||' ' || to_char(hr_desdobramento_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') 
					into STRICT	dt_referencia_w 
					;
				end if;				
				 
				nr_interno_conta_ww := desdobrar_conta_paciente(nr_interno_conta_w, dt_referencia_w, null, null, null, nm_usuario_p, nr_interno_conta_ww, null);
				 
				begin 
				select	obter_data_final_conta(dt_referencia_w, dt_alta_w, cd_convenio_w, cd_estabelecimento_w) 
				into STRICT	dt_periodo_final_ww 
				;
				exception 
					when others then 
					begin 
					dt_periodo_final_ww	:= dt_referencia_w + 365;
					end;
				end;
 
				if (dt_referencia_w < clock_timestamp()) then 
					dt_periodo_final_ww:= clock_timestamp() + interval '365 days';
				end if;	
				 
				update 	conta_paciente 
				set 	dt_periodo_final = dt_periodo_final_ww 
				where 	nr_interno_conta = nr_interno_conta_ww;
				 
				select	max(nr_sequencia) 
				into STRICT	nr_seq_desdob_w 
				from 	conta_paciente_desdob 
				where 	nr_atendimento = nr_atendimento_w;
				 
				update	conta_paciente_desdob 
				set	ie_desdob_auto = 'S' 
				where	nr_sequencia  = nr_seq_desdob_w;
				 
				if (coalesce(ie_fecha_conta_w,'S') = 'S') then 
					ds_erro_w := Fechar_Conta_Paciente(nr_interno_conta_w, nr_atendimento_w, 2, nm_usuario_p, ds_erro_w);
				end if;
										 
			end if;
		 
		end if;
			 
		end;
	end loop;
	close C01;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desdobrar_conta_periodo ( dt_parametro_p timestamp, nm_usuario_p text) FROM PUBLIC;
