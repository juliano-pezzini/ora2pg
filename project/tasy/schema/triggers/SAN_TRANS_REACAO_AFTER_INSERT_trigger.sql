-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS san_trans_reacao_after_insert ON san_trans_reacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_san_trans_reacao_after_insert() RETURNS trigger AS $BODY$
declare
nr_seq_evento_w		bigint;
nr_atendimento_w	bigint;
cd_pessoa_fisica_w	varchar(10);
ie_classificacao_w	varchar(10);
ds_evento_w		varchar(4000);
BEGIN

nr_seq_evento_w := obter_param_usuario(450, 339, obter_perfil_ativo, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, nr_seq_evento_w);



if (nr_seq_evento_w is not null) then

	ie_classificacao_w := obter_classif_evento(nr_seq_evento_w);

	select	max(a.nr_atendimento),
		max(a.cd_pessoa_fisica)
	into STRICT	nr_atendimento_w,
		cd_pessoa_fisica_w
	from	san_transfusao a,
		san_producao b
	where	b.nr_seq_transfusao = a.nr_sequencia
	and	b.nr_sequencia = NEW.nr_seq_producao;
	
	ds_evento_w := coalesce(NEW.ds_sintoma,' ') || chr(13)||coalesce(substr(NEW.ds_conduta,1,2000),' ');

	if (Obter_Setor_Atendimento(nr_atendimento_w) is not null) then
	
		insert into qua_evento_paciente(nr_sequencia,
						cd_estabelecimento,
						dt_atualizacao,
						nm_usuario,
						nr_atendimento,
						nr_seq_evento,
						dt_evento,
						ds_evento,
						cd_setor_atendimento,
						dt_cadastro,
						nm_usuario_origem,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nm_usuario_reg,
						ie_situacao,
						dt_liberacao,
						cd_pessoa_fisica,
						cd_perfil_ativo,
						ie_status,
						ie_origem,
						ie_tipo_evento,
						ie_classificacao,
						cd_funcao_ativa)
					Values (nextval('qua_evento_paciente_seq'),
						wheb_usuario_pck.get_cd_estabelecimento,
						LOCALTIMESTAMP,
						NEW.nm_usuario,
						nr_atendimento_w,
						nr_seq_evento_w,
						coalesce(NEW.dt_reacao,LOCALTIMESTAMP),
						ds_evento_w,
						Obter_Setor_Atendimento(nr_atendimento_w),
						coalesce(NEW.dt_atualizacao_nrec,LOCALTIMESTAMP),
						NEW.nm_usuario,
						LOCALTIMESTAMP,
						NEW.nm_usuario,
						NEW.nm_usuario,
						'A',
						LOCALTIMESTAMP,
						cd_pessoa_fisica_w,
						obter_perfil_ativo,
						'1',
						'S',
						'E',
						ie_classificacao_w,
						obter_funcao_ativa);
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(244307);
	end if;						

end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_san_trans_reacao_after_insert() FROM PUBLIC;

CREATE TRIGGER san_trans_reacao_after_insert
	AFTER INSERT ON san_trans_reacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_san_trans_reacao_after_insert();
