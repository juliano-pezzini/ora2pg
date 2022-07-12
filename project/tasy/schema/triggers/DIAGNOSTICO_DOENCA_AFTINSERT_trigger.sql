-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS diagnostico_doenca_aftinsert ON diagnostico_doenca CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_diagnostico_doenca_aftinsert() RETURNS trigger AS $BODY$
DECLARE
 
nr_sequencia_w			dados_envio_cross.nr_sequencia%type;
ie_integra_cross_w		varchar(1);
cd_classif_setor_cross_w 	bigint;
qt_conv_int_cross_w		bigint;
cd_Setor_atendimento_w	setor_Atendimento.cd_setor_atendimento%type;
nr_Seq_atepacu_w		atend_paciente_unidade.nr_Seq_interno%type;
 
BEGIN 
 
nr_Seq_atepacu_w := obter_atepacu_paciente(NEW.nr_atendimento, 'IA');
 
select	max(cd_setor_Atendimento) 
into STRICT	cd_Setor_atendimento_w 
from	atend_paciente_unidade 
where	nr_Seq_interno	= nr_Seq_atepacu_w;
 
cd_classif_setor_cross_w := obter_classif_setor_cross(cd_Setor_atendimento_w);
qt_conv_int_cross_w := obter_conv_int_cross(NEW.nr_atendimento);
 
select coalesce(max(ie_integra_cross),'N') 
into STRICT	ie_integra_cross_w 
from 	parametro_atendimento 
where 	CD_ESTABELECIMENTO = wheb_usuario_pck.get_cd_estabelecimento;
 
if (ie_integra_cross_w = 'S') and (obter_funcao_ativa = 916) and (cd_classif_setor_cross_w > 0) and (qt_conv_int_cross_w > 0) then 
	--internacao 
	CALL gravar_integracao_cross(277, 'NR_ATENDIMENTO='|| NEW.nr_atendimento || ';CD_ESTABELECIMENTO='|| wheb_usuario_pck.get_cd_estabelecimento || ';');
end if;
 
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_diagnostico_doenca_aftinsert() FROM PUBLIC;

CREATE TRIGGER diagnostico_doenca_aftinsert
	AFTER INSERT ON diagnostico_doenca FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_diagnostico_doenca_aftinsert();

