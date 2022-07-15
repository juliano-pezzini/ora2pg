-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_obs_tec_dia_ant_acomp ( cd_setor_atendimento_p bigint, dt_dieta_p timestamp, cd_refeicao_p text, nm_usuario_p text) AS $body$
DECLARE

 
dt_dieta_w			timestamp;
nr_sequencia_w			bigint;
ds_observacao_tec_w		varchar(2000);
cd_pessoa_fisica_w		varchar(10);
nr_seq_superior_w		bigint;
ie_somente_dieta_princ_w	varchar(5);
ie_atualizar_obs_nula_w		varchar(5);
vl_parametro_w			varchar(5);
c01 CURSOR FOR
SELECT	nr_sequencia, 
	cd_pessoa_fisica, 
	nr_seq_superior 
from	mapa_dieta 
where	cd_setor_atendimento	=	cd_setor_atendimento_p 
and	dt_dieta		=	trunc(dt_dieta_p,'dd') 
and	cd_refeicao		=	cd_refeicao_p 
and	ie_destino_dieta	=	'A';


BEGIN 
 
ie_somente_dieta_princ_w := Obter_Param_Usuario(1000, 68, obter_perfil_ativo, nm_usuario_p, 0, ie_somente_dieta_princ_w);
ie_atualizar_obs_nula_w := obter_param_usuario(1000, 38, obter_perfil_ativo, nm_usuario_p, 0, ie_atualizar_obs_nula_w);
vl_parametro_w	:= coalesce(obter_valor_param_usuario(1000, 8, obter_perfil_ativo, nm_usuario_p,1),'N');
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_w, 
	cd_pessoa_fisica_w, 
	nr_seq_superior_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	 
	ds_observacao_tec_w := null;
	 
	begin 
 
	if (vl_parametro_w <> 'IPU') and (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') then 
		begin 
		begin 
		select	max(ds_observacao_tec) 
		into STRICT	ds_observacao_tec_w	 
		from	mapa_dieta 
		where	cd_pessoa_fisica	= 	cd_pessoa_fisica_w 
		and	ie_destino_dieta	= 	'A' 
		and	(ds_observacao_tec IS NOT NULL AND ds_observacao_tec::text <> '') 
		and	cd_refeicao		=	cd_refeicao_p 
		and	(nr_seq_superior IS NOT NULL AND nr_seq_superior::text <> '') 
		and	dt_dieta		=	(	SELECT	trunc(max(a.dt_dieta),'dd') 
								from	atendimento_paciente b, 
									mapa_dieta a 
								where	b.nr_atendimento	= a.nr_atendimento 
								and	((coalesce(b.dt_alta::text, '') = '') or (vl_parametro_w in ('P','PU'))) 
								and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
								and	ie_destino_dieta	= 	'A'								 
								and	((dt_dieta		< dt_dieta_p) or (vl_parametro_w not in ('U','PU'))) 
								and	((a.ds_observacao_tec IS NOT NULL AND a.ds_observacao_tec::text <> '') or (vl_parametro_w in ('U','PU'))) 
								and	(nr_seq_superior IS NOT NULL AND nr_seq_superior::text <> '') 
								and	a.cd_refeicao		= cd_refeicao_p);	
		exception 
		when others then 
			ds_observacao_tec_w	:= null;
		end;	
		end;
		 
	elsif (vl_parametro_w = 'IPU') and (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') then 
		begin 
		begin 
		 
		select	max(ds_observacao_tec) 
		into STRICT	ds_observacao_tec_w	 
		from	mapa_dieta 
		where	cd_pessoa_fisica	= 	cd_pessoa_fisica_w 
		and	ie_destino_dieta	= 	'A' 
		and	(ds_observacao_tec IS NOT NULL AND ds_observacao_tec::text <> '') 
		and	(nr_seq_superior IS NOT NULL AND nr_seq_superior::text <> '') 
		and	dt_dieta		=	(	SELECT	trunc(max(a.dt_dieta),'dd') 
								from	atendimento_paciente b, 
									mapa_dieta a 
								where	b.nr_atendimento	= a.nr_atendimento 
								and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
								and	ie_destino_dieta	= 	'A' 
								and	a.dt_dieta		<= dt_dieta_p 
								and	(nr_seq_superior IS NOT NULL AND nr_seq_superior::text <> '') 
								and	(a.ds_observacao_tec IS NOT NULL AND a.ds_observacao_tec::text <> ''));	
		exception 
		when others then 
			ds_observacao_tec_w	:= null;
		end;
		end;
	 
	elsif (vl_parametro_w <> 'IPU') and (coalesce(nr_seq_superior_w::text, '') = '') then 
		begin 
		begin 
		select	max(ds_observacao_tec) 
		into STRICT	ds_observacao_tec_w	 
		from	mapa_dieta 
		where	cd_pessoa_fisica	= 	cd_pessoa_fisica_w 
		and	ie_destino_dieta	= 	'A' 
		and	(ds_observacao_tec IS NOT NULL AND ds_observacao_tec::text <> '') 
		and	cd_refeicao		=	cd_refeicao_p 
		and	coalesce(nr_seq_superior::text, '') = '' 
		and	dt_dieta		=	(	SELECT	trunc(max(a.dt_dieta),'dd') 
								from	atendimento_paciente b, 
									mapa_dieta a 
								where	b.nr_atendimento	= a.nr_atendimento 
								and	((coalesce(b.dt_alta::text, '') = '') or (vl_parametro_w in ('P','PU'))) 
								and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
								and	ie_destino_dieta	= 	'A'								 
								and	((dt_dieta		< dt_dieta_p) or (vl_parametro_w not in ('U','PU'))) 
								and	((a.ds_observacao_tec IS NOT NULL AND a.ds_observacao_tec::text <> '') or (vl_parametro_w in ('U','PU'))) 
								and	coalesce(nr_seq_superior::text, '') = '' 
								and	a.cd_refeicao		= cd_refeicao_p);	
		exception 
		when others then 
			ds_observacao_tec_w	:= null;
		end;	
		end;
	 
	elsif (vl_parametro_w = 'IPU') and (coalesce(nr_seq_superior_w::text, '') = '') then 
		begin 
		begin 
		 
		select	max(ds_observacao_tec) 
		into STRICT	ds_observacao_tec_w	 
		from	mapa_dieta 
		where	cd_pessoa_fisica	= 	cd_pessoa_fisica_w 
		and	ie_destino_dieta	= 	'A' 
		and	(ds_observacao_tec IS NOT NULL AND ds_observacao_tec::text <> '') 
		and	coalesce(nr_seq_superior::text, '') = '' 
		and	dt_dieta		=	(	SELECT	trunc(max(a.dt_dieta),'dd') 
								from	atendimento_paciente b, 
									mapa_dieta a 
								where	b.nr_atendimento	= a.nr_atendimento 
								and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
								and	ie_destino_dieta	= 	'A' 
								and	a.dt_dieta		<= dt_dieta_p 
								and	coalesce(nr_seq_superior::text, '') = '' 
								and	(a.ds_observacao_tec IS NOT NULL AND a.ds_observacao_tec::text <> ''));	
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
		and	((ie_atualizar_obs_nula_w = 'N') or ((ie_atualizar_obs_nula_w = 'S') and (coalesce(ds_observacao_tec::text, '') = '')));
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
-- REVOKE ALL ON PROCEDURE copiar_obs_tec_dia_ant_acomp ( cd_setor_atendimento_p bigint, dt_dieta_p timestamp, cd_refeicao_p text, nm_usuario_p text) FROM PUBLIC;

