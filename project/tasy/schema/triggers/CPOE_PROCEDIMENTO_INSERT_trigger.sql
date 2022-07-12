-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_procedimento_insert ON cpoe_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_procedimento_insert() RETURNS trigger AS $BODY$
DECLARE

cd_intervalo_w				intervalo_prescricao.cd_intervalo%type;
ie_dose_unica_cpoe_w		intervalo_prescricao.ie_dose_unica_cpoe%type;

BEGIN

if (coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'S') = 'S') then

NEW.ds_stack	:= substr(dbms_utility.format_call_stack,1,2000);

if (NEW.cd_perfil_ativo is null)  then
	NEW.cd_perfil_ativo := obter_perfil_ativo;
end if;

if ((NEW.ie_request_rad_interpret is null) and (pkg_i18n.get_user_locale() = 'ja_JP')) then
	NEW.ie_request_rad_interpret :=  obter_campo_exame_regra_cpoe(NEW.nr_seq_proc_interno, NEW.cd_setor_atendimento, 'R');
end if;

if (coalesce(NEW.ie_retrogrado, 'N') = 'S' or coalesce(NEW.ie_oncologia, 'N') = 'S') then
	NEW.dt_prox_geracao := coalesce(NEW.dt_inicio, LOCALTIMESTAMP);
end if;

if (NEW.nr_seq_cpoe_anterior is not null and NEW.dt_liberacao is null and NEW.cd_funcao_origem = 2314) then
	NEW.dt_liberacao_enf := null;
	NEW.dt_liberacao_farm := null;
	NEW.nm_usuario_lib_enf := null;
	NEW.nm_usuario_lib_farm := null;
	NEW.cd_farmac_lib := null;
end if;

if (NEW.nr_cirurgia is not null) and (NEW.ie_tipo_prescr_cirur is null) then
	NEW.ie_tipo_prescr_cirur := 2;
end if;

if (NEW.ie_duracao <> 'P') then
	NEW.dt_fim := null;
end if;

if (NEW.cd_intervalo is null)  then	

	if (NEW.nr_seq_prot_glic is not null) then
		cd_intervalo_w := obter_intervalo_ccg(NEW.nr_seq_prot_glic);	
		
		if (cd_intervalo_w is not null) then
			NEW.cd_intervalo :=  cd_intervalo_w;			
			CALL gravar_log_tasy(10007, 'CD_INTERVALO_NULO - Sequencia: '|| NEW.nr_sequencia || '  novo intervalo ' || cd_intervalo_w, NEW.nm_usuario);				
		end if;	
	end if;
	
end if;

if (NEW.cd_intervalo is not null) and (coalesce(NEW.ie_evento_unico, 'N') = 'N') then

	select	max(ie_dose_unica_cpoe)
	into STRICT	ie_dose_unica_cpoe_w
	from	intervalo_prescricao
	where	cd_intervalo = cd_intervalo_w;

	if (coalesce(ie_dose_unica_cpoe_w, 'N') = 'S') then
		NEW.ie_evento_unico := ie_dose_unica_cpoe_w;
	end if;

end if;

if (NEW.ie_evento_unico = 'S') then	
	if (NEW.dt_fim is null) and (NEW.ie_duracao = 'C') then
		NEW.ie_duracao := 'P';
		NEW.dt_fim := (NEW.dt_inicio + 1) -1/86400;
	end if;
end if;

end if;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_procedimento_insert() FROM PUBLIC;

CREATE TRIGGER cpoe_procedimento_insert
	BEFORE INSERT ON cpoe_procedimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_procedimento_insert();

