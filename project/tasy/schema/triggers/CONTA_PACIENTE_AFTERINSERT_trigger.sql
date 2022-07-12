-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS conta_paciente_afterinsert ON conta_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_conta_paciente_afterinsert() RETURNS trigger AS $BODY$
declare
 
nr_sequencia_w		bigint;
nr_seq_etapa_padrao_w	bigint;
cd_convenio_w		integer;
cd_estabelecimento_w	bigint;
ie_tipo_atendimento_w	smallint;
nr_seq_classificacao_w	bigint;
cd_categoria_w		varchar(10);
ie_clinica_w		integer;
cd_setor_atendimento_w	bigint;
nr_seq_motivo_dev_w	bigint;
cd_setor_atend_etapa_w	bigint;
ie_pessoa_etapa_w	varchar(3);
ie_etapa_critica_w	varchar(1);
nm_usuario_original_w	varchar(15);
cd_pessoa_fisica_w	varchar(10);
cd_perfil_w		perfil.cd_perfil%type := obter_perfil_ativo;
qt_regra_restringe_w	bigint;
nr_seq_w		fatur_etapa_conta.nr_sequencia%type;
qt_regra_w		smallint;
 
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_etapa, 
		nr_seq_motivo_dev, 
		cd_setor_atend_etapa, 
		coalesce(ie_pessoa_etapa,'L'), 
		coalesce(ie_etapa_critica,'N') 
	from	fatur_etapa_conta 
	where	ie_situacao = 'A' 
	and 	coalesce(cd_convenio, coalesce(cd_convenio_w,0)) = coalesce(cd_convenio_w,0) 
	and 	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0) 
	and	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_w,0)) = coalesce(ie_tipo_atendimento_w,0) 
	and	coalesce(nr_seq_classificacao, coalesce(nr_seq_classificacao_w,0)) = coalesce(nr_seq_classificacao_w,0) 
	and	coalesce(cd_categoria, coalesce(cd_categoria_w,'0')) = coalesce(cd_categoria_w,'0') 
	and	coalesce(ie_clinica, coalesce(ie_clinica_w,0)) = coalesce(ie_clinica_w,0) 
	and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0)) = coalesce(cd_setor_atendimento_w,0) 
	and 	((coalesce(IE_CONTA_AJUSTE_CANCEL,'N') = 'N') or ((coalesce(IE_CONTA_AJUSTE_CANCEL,'N') = 'X') and (coalesce(NEW.nr_seq_conta_origem,0) = 0))) 
	and	((coalesce(ie_conta_desdobramento,'S') = 'S') or 
		((coalesce(ie_conta_desdobramento,'S') = 'N') and (NEW.nr_conta_orig_desdob is null))) 
	and	coalesce(cd_perfil,coalesce(cd_perfil_w,0))	= coalesce(cd_perfil_w,0) 
	order by coalesce(cd_convenio,0), 
		coalesce(cd_estabelecimento,0), 
		coalesce(ie_tipo_atendimento,0), 
		coalesce(nr_seq_classificacao,0), 
		coalesce(cd_categoria,'0'), 
		coalesce(ie_clinica,0), 
		coalesce(cd_setor_atendimento,0), 
		coalesce(cd_perfil,0);
 
BEGIN 
 
cd_convenio_w		:= NEW.cd_convenio_parametro;
cd_estabelecimento_w	:= NEW.cd_estabelecimento;
cd_categoria_w		:= NEW.cd_categoria_parametro;
cd_setor_atendimento_w	:= coalesce(obter_setor_atendimento(NEW.nr_atendimento),0);
 
 
nr_seq_etapa_padrao_w:= null;
 
select	coalesce(max(ie_tipo_atendimento),0), 
	coalesce(max(nr_seq_classificacao),0), 
	coalesce(max(ie_clinica),0) 
into STRICT	ie_tipo_atendimento_w, 
	nr_seq_classificacao_w, 
	ie_clinica_w 
from	atendimento_paciente 
where	nr_atendimento = NEW.nr_atendimento;
 
open C01;
loop 
fetch C01 into 
	nr_seq_w, 
	nr_seq_etapa_padrao_w, 
	nr_seq_motivo_dev_w, 
	cd_setor_atend_etapa_w, 
	ie_pessoa_etapa_w, 
	ie_etapa_critica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN 
	nr_seq_etapa_padrao_w	:= nr_seq_etapa_padrao_w;
	nr_seq_motivo_dev_w	:= nr_seq_motivo_dev_w;
	cd_setor_atend_etapa_w	:= cd_setor_atend_etapa_w;
	ie_pessoa_etapa_w	:= ie_pessoa_etapa_w;
	ie_etapa_critica_w	:= ie_etapa_critica_w;
	end;
end loop;
close C01;
 
select 	count(*) 
into STRICT	qt_regra_restringe_w 
from 	fatur_etapa_conta_conv 
where 	nr_seq_regra = nr_seq_w 
and 	cd_convenio = cd_convenio_w;
 
if (qt_regra_restringe_w > 0) then 
	nr_seq_etapa_padrao_w:= null;
end if;
 
 
if (nr_seq_etapa_padrao_w is not null) then 
 
	select	substr(Obter_Pessoa_Fisica_Usuario(CASE WHEN ie_pessoa_etapa_w='L' THEN  wheb_usuario_pck.get_nm_usuario   ELSE NEW.nm_usuario_original END ,'C'),1,10) 
	into STRICT	cd_pessoa_fisica_w 
	;
 
	select	nextval('conta_paciente_etapa_seq') 
	into STRICT	nr_sequencia_w 
	;
 
	insert into conta_paciente_etapa( 
		nr_sequencia, 
		nr_interno_conta, 
		dt_atualizacao, 
		nm_usuario, 
		dt_etapa, 
		nr_seq_etapa, 
		cd_setor_atendimento, 
		cd_pessoa_fisica, 
		nr_seq_motivo_dev, 
		ds_observacao, 
		nr_lote_barras, 
		ie_etapa_critica) 
	values (nr_sequencia_w, 
		NEW.nr_interno_conta, 
		LOCALTIMESTAMP, 
		NEW.nm_usuario, 
		LOCALTIMESTAMP, 
		nr_seq_etapa_padrao_w, 
		cd_setor_atend_etapa_w, 
		cd_pessoa_fisica_w, 
		nr_seq_motivo_dev_w, 
		substr(wheb_mensagem_pck.get_texto(304654),1,1999), --Etapa padrão gerada na criação da conta 
		null, 
		ie_etapa_critica_w);
 
end if;
 
select	count(1) 
into STRICT	qt_regra_w 
from	regra_prontuario_gestao 
where	cd_estabelecimento					= cd_estabelecimento_w 
and	coalesce(IE_FORMA_GERACAO,'A') = 'O';
 
if (qt_regra_w > 0) then 
	select	max(cd_pessoa_fisica) 
	into STRICT	cd_pessoa_fisica_w 
	from	atendimento_paciente 
	where	nr_atendimento = NEW.nr_atendimento;
	 
	CALL gerar_regra_prontuario_gestao(ie_tipo_atendimento_w,coalesce(cd_estabelecimento_w,0),NEW.nr_atendimento,cd_pessoa_fisica_w,wheb_usuario_pck.get_nm_usuario, 
					null, 
					null, 
					null, 
					ie_clinica_w, 
					cd_setor_atend_etapa_w, 
					null, 
					null, 
					coalesce(NEW.nr_interno_conta,OLD.nr_interno_conta), 
					NEW.dt_periodo_inicial, 
					NEW.dt_periodo_final);
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_conta_paciente_afterinsert() FROM PUBLIC;

CREATE TRIGGER conta_paciente_afterinsert
	AFTER INSERT ON conta_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_conta_paciente_afterinsert();

