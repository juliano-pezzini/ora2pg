-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS iscv_agenda_pac_proc_aftinsup ON agenda_paciente_proc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_iscv_agenda_pac_proc_aftinsup() RETURNS trigger AS $BODY$
declare
cd_pessoa_fisica_w			agenda_paciente.cd_pessoa_fisica%type;
cd_setor_atendimento_w		agenda_paciente.cd_setor_atendimento%type;
ds_sep_bv_w					varchar(100)	:= obter_separador_bv;

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

	function retornaAcaoHistorico(nr_sequencia_p number)
	return varchar is
		ds_retorno_w	agenda_historico_acao.IE_ACAO%type;
	BEGIN
		select	coalesce(max(IE_ACAO), ' ')
		into STRICT	ds_retorno_w
		from	agenda_historico_acao
		where	nr_Sequencia =  nr_sequencia_p;
	return	ds_retorno_w;
	end;

	function transferidoAgenda(nr_sequencia_p number)
	return boolean is
	ds_retorno_w	agenda_paciente.ie_transferido%type;
	BEGIN

	select	max(ie_transferido),
			max(cd_pessoa_fisica)
	into STRICT	ds_retorno_w,
			cd_pessoa_fisica_w
	from	agenda_paciente
	where	nr_sequencia = nr_sequencia_p;

	return ds_retorno_w = 'S';
	end;


BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then
	if	permiteIntegrarISCV then
		if	(OLD.nr_seq_proc_interno is null AND NEW.nr_seq_proc_interno is not null)
		and	transferidoAgenda(NEW.nr_sequencia)
		and (retornaAcaoHistorico(NEW.nr_sequencia) = 'T')
		and (Obter_Se_Integr_Proc_Interno(NEW.nr_seq_proc_interno, 17,null,NEW.ie_lado,wheb_usuario_pck.get_cd_estabelecimento) = 'S')
		then
			CALL gravar_agend_integracao(742, 'nr_sequencia=' || NEW.nr_sequencia || ds_sep_bv_w || 'cd_pessoa_fisica=' || cd_pessoa_fisica_w || ds_sep_bv_w, cd_setor_atendimento_w);
		end if;
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_iscv_agenda_pac_proc_aftinsup() FROM PUBLIC;

CREATE TRIGGER iscv_agenda_pac_proc_aftinsup
	AFTER INSERT OR UPDATE ON agenda_paciente_proc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_iscv_agenda_pac_proc_aftinsup();

