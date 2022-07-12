-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS gestao_vaga_after_insert ON gestao_vaga CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_gestao_vaga_after_insert() RETURNS trigger AS $BODY$
declare

ds_param_integ_hl7_w		varchar(1000);
gestao_vaga_r 			gestao_vaga%rowtype;
ie_save_insurance_holder_w 	varchar(1);

BEGIN

ie_save_insurance_holder_w := obter_dados_param_atend(wheb_usuario_pck.get_cd_estabelecimento, 'SI');

if (ie_save_insurance_holder_w = 'S') and (NEW.cd_pessoa_fisica is not null) and (NEW.cd_convenio is not null) and
	((coalesce(NEW.cd_convenio, 0) <> coalesce(OLD.cd_convenio, 0)) or (coalesce(NEW.cd_pessoa_fisica, '0') <> coalesce(OLD.cd_pessoa_fisica, '0')) or (coalesce(NEW.cd_categoria, 0) <> coalesce(OLD.cd_categoria, 0)) or (coalesce(NEW.ds_cod_usuario, '0') <> coalesce(OLD.ds_cod_usuario, '0'))) then
	CALL insere_atualiza_titular_conv(
				NEW.nm_usuario,
				NEW.cd_convenio,
				NEW.cd_categoria,
				NEW.cd_pessoa_fisica,
				NEW.cd_plano_convenio,
				null,
				NEW.dt_validade,
				NEW.dt_validade,
				null,
				NEW.ds_cod_usuario,
				null,
				'N',
				'2');
end if;


if (obter_funcao_ativa <> '1002') then

	gestao_vaga_r.nr_sequencia := NEW.nr_sequencia;
	gestao_vaga_r.cd_convenio := NEW.cd_convenio;
	gestao_vaga_r.ie_tipo_vaga := NEW.ie_tipo_vaga;
	gestao_vaga_r.ie_status := NEW.ie_status;
	gestao_vaga_r.ie_solicitacao := NEW.ie_solicitacao;
	gestao_vaga_r.cd_setor_atual := NEW.cd_setor_atual;
	gestao_vaga_r.cd_setor_desejado := NEW.cd_setor_desejado;
	gestao_vaga_r.cd_tipo_acomod_desej := NEW.cd_tipo_acomod_desej;
	gestao_vaga_r.nr_seq_status_pac := NEW.nr_seq_status_pac;
	gestao_vaga_r.nr_atendimento := NEW.nr_atendimento;
	gestao_vaga_r.dt_prevista	:=	NEW.dt_prevista;
	gestao_vaga_r.nm_paciente	:= NEW.nm_paciente;
	
	CALL gerar_evento_gestao_vaga_auto(NEW.cd_pessoa_fisica,NEW.nm_usuario,NEW.cd_estabelecimento,NEW.nr_sequencia,NEW.nm_paciente,'VA',NEW.ie_status, gestao_vaga_r);
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_gestao_vaga_after_insert() FROM PUBLIC;

CREATE TRIGGER gestao_vaga_after_insert
	AFTER INSERT ON gestao_vaga FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_gestao_vaga_after_insert();
