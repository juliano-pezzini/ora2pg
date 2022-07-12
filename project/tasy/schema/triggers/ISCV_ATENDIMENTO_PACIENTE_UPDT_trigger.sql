-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS iscv_atendimento_paciente_updt ON atendimento_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_iscv_atendimento_paciente_updt() RETURNS trigger AS $BODY$
declare
x varchar(100);
ds_sep_bv_w		varchar(100)	:= obter_separador_bv;
nr_seq_proc_interno_w	agenda_paciente.nr_seq_proc_interno%type;
cd_setor_atendimento_w 	agenda_paciente.cd_setor_atendimento%type;

/* Verifica se existe alguma integração cadastrada para o domínio 17, para certificar que há o que ser procurado, para aí então executar todas as verificações. */

	function permiteIntegrarISCV
	return boolean is
	qt_resultado_w	bigint;

	BEGIN
	select	count(*) qt_resultado
	into STRICT	qt_resultado_w
	from 	regra_proc_interno_integra
	where	ie_tipo_integracao = 17; --Dominio criado para a integração
	return qt_resultado_w > 0;
	end;

	function permiteIntegrar return boolean is	--Verificar se há algum procedimento interno que deva integrar
	ds_retorno_w		varchar2(1);
	BEGIN
	if	permiteIntegrarISCV then
		select	coalesce(max(Obter_Se_Integr_Proc_Interno(pp.nr_seq_proc_interno, 17,null,pp.ie_lado,coalesce(pm.cd_estabelecimento,wheb_usuario_pck.get_cd_estabelecimento))),'N') ie_permite_proc_integ
		into STRICT	ds_retorno_w
		from	prescr_procedimento pp,
				prescr_medica pm
		where	pm.nr_atendimento = NEW.nr_atendimento
		and		pp.nr_seq_proc_interno is not null
		and		pp.nr_sequencia = pm.nr_prescricao;

		if (ds_retorno_w = 'N') then

			select	coalesce(max(Obter_Se_Integr_Proc_Interno(nr_seq_proc_interno, 17,null,ie_lado,wheb_usuario_pck.get_cd_estabelecimento)),'N') ie_permite_proc_integ
			into STRICT	ds_retorno_w
			from	agenda_paciente
			where	nr_seq_proc_interno is not null
			and		nr_atendimento = NEW.nr_atendimento;

			if (ds_retorno_w = 'N') then
				select	coalesce(max(Obter_Se_Integr_Proc_Interno(app.nr_seq_proc_interno, 17,null,app.ie_lado,wheb_usuario_pck.get_cd_estabelecimento)),'N') ie_permite_proc_integ
				into STRICT	ds_retorno_w
				from	agenda_paciente ap,
						agenda_paciente_proc app
				where	ap.nr_seq_proc_interno is not null
				and		ap.nr_atendimento = NEW.nr_atendimento
				and		ap.nr_sequencia = app.nr_sequencia;
			end if;
		end if;

		return ds_retorno_w = 'S';
	else
		return false;
	end if;

	end;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then
	if	(OLD.dt_alta is null AND NEW.dt_alta is not null)
	and	permiteIntegrar then
		CALL gravar_agend_integracao(747, 'cd_pessoa_fisica=' || NEW.cd_pessoa_fisica || ds_sep_bv_w || 'nr_atendimento=' || NEW.nr_atendimento || ds_sep_bv_w, Obter_Setor_Atendimento(NEW.nr_atendimento));
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_iscv_atendimento_paciente_updt() FROM PUBLIC;

CREATE TRIGGER iscv_atendimento_paciente_updt
	AFTER UPDATE ON atendimento_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_iscv_atendimento_paciente_updt();

