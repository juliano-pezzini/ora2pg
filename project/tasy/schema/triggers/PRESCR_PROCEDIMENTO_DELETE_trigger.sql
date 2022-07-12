-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_procedimento_delete ON prescr_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_procedimento_delete() RETURNS trigger AS $BODY$
DECLARE
ie_erro_w	varchar(1);
ie_agrupada_w	pre_venda.ie_agrupada%type;
ie_liberada_w				varchar(1);
ie_info_rastre_prescr_w		varchar(1);
ds_alteracao_rastre_w		varchar(1800);
nm_usuario_w				usuario.nm_usuario%type;
cd_perfil_w					perfil.cd_perfil%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then

nm_usuario_w			:= coalesce(obter_usuario_ativo, 'TASY');
cd_perfil_w				:= obter_perfil_ativo;
cd_estabelecimento_w	:= obter_estabelecimento_ativo;

if (cd_perfil_w = 0 or cd_estabelecimento_w = 0) then

	select	cd_perfil_ativo,
			cd_estabelecimento
	into STRICT	cd_perfil_w,
			cd_estabelecimento_w
	from	prescr_medica
	where	nr_prescricao = OLD.nr_prescricao;

end if;

delete from PRESCR_PROCED_INF_ADIC
where nr_prescricao = OLD.NR_PRESCRICAO
and nr_seq_prescricao = OLD.NR_SEQUENCIA;

ie_info_rastre_prescr_w := obter_se_info_rastre_prescr('O', nm_usuario_w, cd_perfil_w, cd_estabelecimento_w);


if (OLD.NR_SEQ_EXAME is not null) then
	BEGIN
	DELETE FROM EXAME_LAB_RESULT_ITEM A
	WHERE A.NR_SEQ_RESULTADO  in (SELECT B.NR_SEQ_RESULTADO
					     FROM EXAME_LAB_RESULTADO B
					     WHERE B.NR_PRESCRICAO = OLD.NR_PRESCRICAO)
	  AND A.NR_SEQ_PRESCR   = OLD.NR_SEQUENCIA;
	exception
		when others then
			ie_erro_w := 'S';
	end;
end if;

BEGIN
update	frasco_pato_loc
set	nr_prescr_vinc_patol  = NULL,
	nr_seq_prescr_vinc  = NULL
where	nr_prescr_vinc_patol = OLD.nr_prescricao
and	nr_seq_prescr_vinc = OLD.nr_sequencia;
exception
	when others then
		ie_erro_w := 'S';
end;

update	ageint_exame_lab
set	nr_prescricao  = NULL
where	nr_sequencia = OLD.nr_seq_ageint_exame_lab
and	cd_procedimento = OLD.cd_procedimento;


if (ie_info_rastre_prescr_w = 'S') or (nm_usuario_w = 'TASY') then

	select	coalesce(max('S'), 'N')
	into STRICT	ie_liberada_w
	from	prescr_medica
	where	nr_prescricao = OLD.nr_prescricao
	and		coalesce(dt_liberacao_medico, dt_liberacao) is not null;

	if (ie_liberada_w = 'S') then

		ds_alteracao_rastre_w := substr('DELETE PRESCR_PROCEDIMENTO - '||pls_util_pck.enter_w
										||'nr_prescricao: '||OLD.nr_prescricao||pls_util_pck.enter_w
										||'cd_procedimento: '||OLD.cd_procedimento||pls_util_pck.enter_w
										||'dt_atualizacao: '||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_atualizacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||pls_util_pck.enter_w
										||'nm_usuario: '||OLD.nm_usuario||pls_util_pck.enter_w
										||'cd_intervalo: '||OLD.cd_intervalo||pls_util_pck.enter_w
										||'ds_horarios: '||OLD.ds_horarios||pls_util_pck.enter_w
										||'cd_setor_atendimento: '||OLD.cd_setor_atendimento||pls_util_pck.enter_w
										||'nr_seq_exame: '||OLD.nr_seq_exame||pls_util_pck.enter_w
										||'nr_seq_interno: '||OLD.nr_seq_interno||pls_util_pck.enter_w
										||'nr_seq_proc_interno: '||OLD.nr_seq_proc_interno||pls_util_pck.enter_w
										||'ie_erro: '||OLD.ie_erro||pls_util_pck.enter_w
										||'nr_prescricao_original: '||OLD.nr_prescricao_original||pls_util_pck.enter_w
										||'cd_funcao_origem: '||OLD.cd_funcao_origem||pls_util_pck.enter_w
										||'nr_seq_proc_cpoe: '||OLD.nr_seq_proc_cpoe||pls_util_pck.enter_w
										||'nr_sequencia: '||OLD.nr_sequencia||pls_util_pck.enter_w
										||'ds_stack: '||OLD.ds_stack||pls_util_pck.enter_w
										||'Stack exclusao: '||substr(dbms_utility.format_call_stack,1,1800),1,2000);

		CALL gravar_log_tasy(	cd_log_p => 10007,
							ds_log_p => ds_alteracao_rastre_w,
							nm_usuario_p => nm_usuario_w
						);

	end if;

end if;

end if;

  END;
RETURN OLD;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_procedimento_delete() FROM PUBLIC;

CREATE TRIGGER prescr_procedimento_delete
	BEFORE DELETE ON prescr_procedimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_procedimento_delete();

