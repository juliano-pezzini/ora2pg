-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pepo_cirurgia_atual ON pepo_cirurgia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pepo_cirurgia_atual() RETURNS trigger AS $BODY$
declare

ie_atual_tipo_anest_w 	varchar(1);
ie_medico_partic_w	   varchar(1);
ie_atualiza_medico_w	   varchar(1);
cd_funcao_ativa_w		   integer                                 := obter_funcao_ativa;
cd_estabelecimento_w    estabelecimento.cd_estabelecimento%type   := wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w             perfil.cd_perfil%type                     := wheb_usuario_pck.get_cd_perfil;
nm_usuario_w            usuario.nm_usuario%type                   := wheb_usuario_pck.get_nm_usuario;
BEGIN
  BEGIN

ie_atual_tipo_anest_w := obter_param_usuario(872, 424, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_atual_tipo_anest_w);
ie_medico_partic_w := obter_param_usuario(10026, 41, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_medico_partic_w);
ie_atualiza_medico_w := obter_param_usuario(10026, 50, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_atualiza_medico_w);

if (NEW.cd_estabelecimento is null) then
   NEW.cd_estabelecimento  := cd_estabelecimento_w;
end if;

BEGIN 
if (ie_atual_tipo_anest_w = 'S') then
	if 	coalesce(OLD.cd_tipo_anestesia,'XPTO') <> coalesce(NEW.cd_tipo_anestesia,'XPTO') then
		update 		cirurgia
		set		dt_atualizacao 		=	LOCALTIMESTAMP,
				nm_usuario		= 	nm_usuario_w,
				cd_tipo_anestesia 	= 	NEW.cd_tipo_anestesia
		where 		nr_seq_pepo 		= 	NEW.nr_sequencia;
	end if;
end if;

if 	((ie_medico_partic_w = 'S') and (cd_funcao_ativa_w <> 871) and (cd_funcao_ativa_w <> 900) and (cd_funcao_ativa_w <> 872) and
	((OLD.cd_medico_anestesista is null AND NEW.cd_medico_anestesista is not null) or (OLD.cd_medico_anestesista <> NEW.cd_medico_anestesista))) then
	CALL gerar_partic_proc_fanep(NEW.nr_sequencia,NEW.cd_medico_anestesista,'N',nm_usuario_w);
end if;

if 	coalesce(OLD.ie_asa_estado_paciente,'XPTO') <> coalesce(NEW.ie_asa_estado_paciente,'XPTO') then
	update 		cirurgia
	set		dt_atualizacao 		=	LOCALTIMESTAMP,
			nm_usuario		= 	nm_usuario_w,
			ie_asa_estado_paciente 	= 	NEW.ie_asa_estado_paciente
	where 		nr_seq_pepo 		= 	NEW.nr_sequencia;
end if;

if 	coalesce(OLD.cd_medico_anestesista,'XPTO') <> coalesce(NEW.cd_medico_anestesista,'XPTO') then
	update 		cirurgia
	set		dt_atualizacao 		=	LOCALTIMESTAMP,
			nm_usuario		= 	nm_usuario_w,
			cd_medico_anestesista	=	NEW.cd_medico_anestesista
	where 		nr_seq_pepo 		= 	NEW.nr_sequencia;
end if;

if 	coalesce(OLD.ie_tipo_cirurgia,'XPTO') <> coalesce(NEW.ie_tipo_cirurgia,'XPTO') then
	update 		cirurgia
	set		dt_atualizacao 		=	LOCALTIMESTAMP,
			nm_usuario		= 	nm_usuario_w,
			ie_tipo_cirurgia	=	NEW.ie_tipo_cirurgia
	where 		nr_seq_pepo 		= 	NEW.nr_sequencia;
end if;


if (ie_atualiza_medico_w = 'S') and (cd_funcao_ativa_w = 10026) and (NEW.nr_prescricao > 0) and (coalesce(OLD.cd_medico_anestesista,'XPTO') <> coalesce(NEW.cd_medico_anestesista,'XPTO')) then
	
	update	prescr_medica
	set	cd_medico 	= NEW.cd_medico_anestesista
	where	nr_prescricao	= NEW.nr_prescricao;
end if;

if (cd_funcao_ativa_w = 10026) and (NEW.nr_atendimento > 0) and (coalesce(OLD.nr_atendimento,0) <> coalesce(NEW.nr_atendimento,0)) then
	
	update	prescr_medica
	set	nr_atendimento 	= NEW.nr_atendimento
	where	nr_prescricao	= NEW.nr_prescricao;
end if;
	
	

	

exception
		when others then
		null;
end;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pepo_cirurgia_atual() FROM PUBLIC;

CREATE TRIGGER pepo_cirurgia_atual
	BEFORE INSERT OR UPDATE ON pepo_cirurgia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pepo_cirurgia_atual();
