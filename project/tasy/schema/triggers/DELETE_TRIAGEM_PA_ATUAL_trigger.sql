-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS delete_triagem_pa_atual ON triagem_pronto_atend CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_delete_triagem_pa_atual() RETURNS trigger AS $BODY$
declare
ie_gerar_clinical_notes_w varchar(1);
nm_user_w varchar(100) :=wheb_usuario_pck.get_nm_usuario;
BEGIN

ie_gerar_clinical_notes_w := obter_param_usuario(281, 1643, Obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1), ie_gerar_clinical_notes_w);
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
if (OLD.cd_evolucao is not null and ie_gerar_clinical_notes_w ='S') then
	delete from clinical_note_soap_data where cd_evolucao = OLD.cd_evolucao and ie_med_rec_type = 'EMERG_SERV_CONS' and ie_stage = 1  and ie_soap_type = 'P' and nr_seq_med_item=OLD.nr_sequencia;
end if;
end if;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_delete_triagem_pa_atual() FROM PUBLIC;

CREATE TRIGGER delete_triagem_pa_atual
	BEFORE DELETE ON triagem_pronto_atend FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_delete_triagem_pa_atual();

