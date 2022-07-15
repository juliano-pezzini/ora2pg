-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_observacao_tecnica ( cd_setor_atendimento_p bigint, dt_dieta_p timestamp, cd_refeicao_p text, ie_opcao_p text, ie_atualizar_obs_nula_p text, nm_usuario_p text) AS $body$
DECLARE

 
dt_dieta_w			timestamp;
nr_sequencia_w			bigint;
ds_observacao_tec_w		varchar(2000);
cd_pessoa_fisica_w		varchar(10);
ie_destino_dieta_w		varchar(1);
nr_seq_superior_w		bigint;
ie_somente_dieta_princ_w	varchar(1)	:= 'N';
nr_atendimento_w		bigint;
ie_obs_atend_atual_w		varchar(1)	:= 'N';
ds_observacao_tec_atual_w	mapa_dieta.ds_observacao_tec%type;

c01 CURSOR FOR 
SELECT	nr_sequencia, 
	cd_pessoa_fisica, 
	ie_destino_dieta, 
	nr_seq_superior, 
	nr_atendimento, 
	ds_observacao_tec 
from	mapa_dieta 
where	cd_setor_atendimento	=	cd_setor_atendimento_p 
and	dt_dieta		=	trunc(dt_dieta_p,'dd') 
and	cd_refeicao		=	cd_refeicao_p;


BEGIN 
 
ie_somente_dieta_princ_w := Obter_Param_Usuario(1000, 68, obter_perfil_ativo, nm_usuario_p, 0, ie_somente_dieta_princ_w);
ie_obs_atend_atual_w := Obter_Param_Usuario(1000, 72, obter_perfil_ativo, nm_usuario_p, 0, ie_obs_atend_atual_w);
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_w, 
	cd_pessoa_fisica_w, 
	ie_destino_dieta_w, 
	nr_seq_superior_w, 
	nr_atendimento_w, 
	ds_observacao_tec_atual_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	 
	ds_observacao_tec_w := null;
	 
	begin 
		if (ie_opcao_p <> 'IPU') and (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') then 
			begin 
			 
			begin 
			select	max(ds_observacao_tec) 
			into STRICT	ds_observacao_tec_w	 
			from	mapa_dieta 
			where	cd_pessoa_fisica	= 	cd_pessoa_fisica_w 
			and	ie_destino_dieta	= 	ie_destino_dieta_w 
			and	(ds_observacao_tec IS NOT NULL AND ds_observacao_tec::text <> '') 
			and	cd_refeicao		=	cd_refeicao_p 
			and	((ie_obs_atend_atual_w = 'N') or (coalesce(nr_atendimento,0) = coalesce(nr_atendimento_w,0))) 
			and	(nr_seq_superior IS NOT NULL AND nr_seq_superior::text <> '') 
			and	nr_sequencia 		<> nr_sequencia_w 
			and	dt_dieta		=	(	SELECT	trunc(max(a.dt_dieta),'dd') 
									from	atendimento_paciente b, 
										mapa_dieta a 
									where	b.nr_atendimento	= a.nr_atendimento 
									and	((coalesce(b.dt_alta::text, '') = '') or (ie_opcao_p in ('P','PU'))) 
									and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
									and	ie_destino_dieta	= 	ie_destino_dieta_w								 
									and	((dt_dieta		< dt_dieta_p) or (ie_opcao_p not in ('U','PU'))) 
									and	((a.ds_observacao_tec IS NOT NULL AND a.ds_observacao_tec::text <> '') or (ie_opcao_p in ('U','PU'))) 
									and	((ie_obs_atend_atual_w = 'N') or (coalesce(a.nr_atendimento,0) = coalesce(nr_atendimento_w,0))) 
									and	(nr_seq_superior IS NOT NULL AND nr_seq_superior::text <> '') 
									and	a.cd_refeicao		= cd_refeicao_p 
									and	a.nr_sequencia 		<> nr_sequencia_w);	
			exception 
			when others then 
				ds_observacao_tec_w	:= null;
			end;	
			end;
			 
		elsif (ie_opcao_p = 'IPU') and (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') then 
			begin 
			begin 
			 
			select	max(ds_observacao_tec) 
			into STRICT	ds_observacao_tec_w	 
			from	mapa_dieta 
			where	cd_pessoa_fisica	= 	cd_pessoa_fisica_w 
			and	ie_destino_dieta	= 	ie_destino_dieta_w 
			and	(nr_seq_superior IS NOT NULL AND nr_seq_superior::text <> '') 
			and	nr_sequencia 		<> nr_sequencia_w 
			and	((ie_obs_atend_atual_w = 'N') or (coalesce(nr_atendimento,0) = coalesce(nr_atendimento_w,0))) 
			and	nr_sequencia		=	(	SELECT	max(a.nr_Sequencia) 
									from	atendimento_paciente b, 
										mapa_dieta a 
									where	b.nr_atendimento	= a.nr_atendimento 
									and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
									and	ie_destino_dieta	= 	ie_destino_dieta_w 
									and	a.dt_dieta		<= dt_dieta_p 
									and	(nr_seq_superior IS NOT NULL AND nr_seq_superior::text <> '') 
									and	a.nr_sequencia 		<> nr_sequencia_w 
									and	((ie_obs_atend_atual_w = 'N') or (coalesce(a.nr_atendimento,0) = coalesce(nr_atendimento_w,0))) 
									and	a.nr_sequencia < (	select	max(a.nr_Sequencia) 
													from	atendimento_paciente b, 
														mapa_dieta a 
													where	b.nr_atendimento	= a.nr_atendimento 
													and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
													and	ie_destino_dieta	= 	ie_destino_dieta_w 
													and	a.dt_dieta		<= dt_dieta_p 
													and	(nr_seq_superior IS NOT NULL AND nr_seq_superior::text <> '') 
													and	((ie_obs_atend_atual_w = 'N') or (coalesce(a.nr_atendimento,0) = coalesce(nr_atendimento_w,0)))));	
			exception 
			when others then 
				ds_observacao_tec_w	:= null;
			end;
			end;
		 
		elsif (ie_opcao_p <> 'IPU') and (coalesce(nr_seq_superior_w::text, '') = '') then 
			begin 
			begin 
			select	max(ds_observacao_tec) 
			into STRICT	ds_observacao_tec_w	 
			from	mapa_dieta 
			where	cd_pessoa_fisica	= 	cd_pessoa_fisica_w 
			and	ie_destino_dieta	= 	ie_destino_dieta_w 
			and	(ds_observacao_tec IS NOT NULL AND ds_observacao_tec::text <> '') 
			and	cd_refeicao		=	cd_refeicao_p 
			and	coalesce(nr_seq_superior::text, '') = '' 
			and	nr_sequencia 		<> nr_sequencia_w 
			and	((ie_obs_atend_atual_w = 'N') or (coalesce(nr_atendimento,0) = coalesce(nr_atendimento_w,0))) 
			and	dt_dieta		=	(	SELECT	trunc(max(a.dt_dieta),'dd') 
									from	atendimento_paciente b, 
										mapa_dieta a 
									where	b.nr_atendimento	= a.nr_atendimento 
									and	((coalesce(b.dt_alta::text, '') = '') or (ie_opcao_p in ('P','PU'))) 
									and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
									and	ie_destino_dieta	= 	ie_destino_dieta_w								 
									and	((dt_dieta		< dt_dieta_p) or (ie_opcao_p not in ('U','PU'))) 
									and	((a.ds_observacao_tec IS NOT NULL AND a.ds_observacao_tec::text <> '') or (ie_opcao_p in ('U','PU'))) 
									and	((ie_obs_atend_atual_w = 'N') or (coalesce(a.nr_atendimento,0) = coalesce(nr_atendimento_w,0))) 
									and	coalesce(nr_seq_superior::text, '') = '' 
									and	a.cd_refeicao		= cd_refeicao_p 
									and	a.nr_sequencia 		<> nr_sequencia_w);	
			exception 
			when others then 
				ds_observacao_tec_w	:= null;
			end;	
			end;
		 
		elsif (ie_opcao_p = 'IPU') and (coalesce(nr_seq_superior_w::text, '') = '') then 
			begin 
			begin 
			 
			select	max(ds_observacao_tec) 
			into STRICT	ds_observacao_tec_w	 
			from	mapa_dieta 
			where	cd_pessoa_fisica	= 	cd_pessoa_fisica_w 
			and	ie_destino_dieta	= 	ie_destino_dieta_w 
			and	coalesce(nr_seq_superior::text, '') = '' 
			and	nr_sequencia 		<> nr_sequencia_w 
			and	((ie_obs_atend_atual_w = 'N') or (coalesce(nr_atendimento,0) = coalesce(nr_atendimento_w,0))) 
			and	nr_sequencia		=	(	SELECT	max(nr_sequencia) 
									from	atendimento_paciente b, 
										mapa_dieta a 
									where	b.nr_atendimento	= a.nr_atendimento 
									and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
									and	ie_destino_dieta	= ie_destino_dieta_w 
									and	a.dt_dieta		<= dt_dieta_p 
									and	((ie_obs_atend_atual_w = 'N') or (coalesce(a.nr_atendimento,0) = coalesce(nr_atendimento_w,0))) 
									and	coalesce(nr_seq_superior::text, '') = '' 
									and	a.nr_sequencia 		<> nr_sequencia_w 
									and	a.nr_sequencia < (	select	max(nr_sequencia) 
													from	atendimento_paciente b, 
														mapa_dieta a 
													where	b.nr_atendimento	= a.nr_atendimento 
													and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
													and	ie_destino_dieta	= ie_destino_dieta_w 
													and	a.dt_dieta		<= dt_dieta_p 
													and	((ie_obs_atend_atual_w = 'N') or (coalesce(a.nr_atendimento,0) = coalesce(nr_atendimento_w,0))) 
													and	coalesce(nr_seq_superior::text, '') = ''));	
			exception 
			when others then 
				ds_observacao_tec_w	:= null;
			end;
			end;
		 
		end if;
	 
		if	((ie_somente_dieta_princ_w	= 'N') or 
			((ie_somente_dieta_princ_w	= 'S') and (coalesce(nr_seq_superior_w::text, '') = ''))) then 
 
			update	mapa_dieta 
			set	ds_observacao_tec	= ds_observacao_tec_w	 
			where	nr_sequencia		= nr_sequencia_w 
			and	coalesce(dt_liberacao::text, '') = '' 
			and	((ie_atualizar_obs_nula_p = 'N') or ((ie_atualizar_obs_nula_p = 'S') and (coalesce(ds_observacao_tec::text, '') = '')));
		end if;
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_observacao_tecnica ( cd_setor_atendimento_p bigint, dt_dieta_p timestamp, cd_refeicao_p text, ie_opcao_p text, ie_atualizar_obs_nula_p text, nm_usuario_p text) FROM PUBLIC;

