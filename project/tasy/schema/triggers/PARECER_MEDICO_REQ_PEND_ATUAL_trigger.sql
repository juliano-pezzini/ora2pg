-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS parecer_medico_req_pend_atual ON parecer_medico_req CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_parecer_medico_req_pend_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w		smallint;
nm_usuario_w		varchar(15);
ie_lib_parecer_medico_w	varchar(10);
ie_pend_parecer_w	varchar(10);
ie_gerar_evol_in_ref_w varchar(5);

C01 CURSOR FOR
	SELECT	substr(obter_usuario_pf(cd_pessoa_fisica),1,100)
	from	medico_especialidade
	where	obter_se_corpo_clinico(cd_pessoa_fisica) = 'S'
	and	cd_especialidade = NEW.cd_especialidade_dest
	and	substr(obter_usuario_pf(cd_pessoa_fisica),1,100) is not null
	and	NEW.cd_pessoa_parecer is null
	and	coalesce(NEW.cd_especialidade_dest_prof,0) = 0
	
union

	SELECT	substr(obter_usuario_pf(cd_pessoa_fisica),1,100)
	from	profissional_especialidade
	where	cd_especialidade_prof = NEW.cd_especialidade_dest_prof
	and	substr(obter_usuario_pf(cd_pessoa_fisica),1,100) is not null
	and	NEW.cd_pessoa_parecer is null
	and	coalesce(NEW.cd_especialidade_dest,0) = 0
	
union

	select	substr(obter_usuario_pf(NEW.cd_pessoa_parecer),1,100)
	
	where	NEW.cd_pessoa_parecer is not null;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

ie_gerar_evol_in_ref_w := obter_param_usuario(281, 1641, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1), ie_gerar_evol_in_ref_w);

select	max(ie_lib_parecer_medico)
into STRICT	ie_lib_parecer_medico_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

select	max(ie_pend_parecer)
into STRICT	ie_pend_parecer_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (coalesce(ie_lib_parecer_medico_w,'N') = 'S') and (coalesce(ie_pend_parecer_w,'S') = 'S') 	then
	if (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null)then
    CALL Gerar_registro_pendente_PEP(
          cd_tipo_registro_p => 'XPM',
          nr_sequencia_registro_p => NEW.nr_parecer,
          cd_pessoa_fisica_p => NEW.cd_pessoa_fisica,
          nr_atendimento_p => NEW.nr_atendimento, 
          nm_usuario_p => NEW.nm_usuario,
          nr_atend_cons_pepa_p=> NEW.nr_seq_atend_cons_pepa
        );
		open C01;
		loop
		fetch C01 into
			nm_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			if (nm_usuario_w	<> NEW.nm_usuario) then
        CALL Gerar_registro_pendente_PEP(
          cd_tipo_registro_p => 'PM',
          nr_sequencia_registro_p => NEW.nr_parecer,
          cd_pessoa_fisica_p => NEW.cd_pessoa_fisica,
          nr_atendimento_p => NEW.nr_atendimento, 
          nm_usuario_p => nm_usuario_w,
          nr_atend_cons_pepa_p=> NEW.nr_seq_atend_cons_pepa
        );
			end if;
		end loop;
		close C01;
	elsif (NEW.dt_liberacao 	is null) then
		CALL Gerar_registro_pendente_PEP(
      cd_tipo_registro_p => 'PM',
      nr_sequencia_registro_p => NEW.nr_parecer,
      cd_pessoa_fisica_p => NEW.cd_pessoa_fisica,
      nr_atendimento_p => NEW.nr_atendimento, 
      nm_usuario_p => NEW.nm_usuario,
      nr_atend_cons_pepa_p=> NEW.nr_seq_atend_cons_pepa
    );


	end if;
end if;

if ( ie_gerar_evol_in_ref_w ='S' and NEW.cd_evolucao is not null and NEW.dt_inativacao is not null and OLD.dt_inativacao is null) then

	delete from clinical_note_soap_data where cd_evolucao = NEW.cd_evolucao and ie_med_rec_type = 'INTERNAL_REF' and nr_seq_med_item = NEW.NR_PARECER;
    end if;
<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_parecer_medico_req_pend_atual() FROM PUBLIC;

CREATE TRIGGER parecer_medico_req_pend_atual
	AFTER INSERT OR UPDATE ON parecer_medico_req FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_parecer_medico_req_pend_atual();

