-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_setor_atual ON paciente_setor CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_setor_atual() RETURNS trigger AS $BODY$
declare
qt_tempo_medic_w	bigint;
nr_seq_evento_w		bigint;
cd_estabelecimento_w	bigint;
nr_atendimento_W    bigint;
ie_cancelar_agend_w	varchar(1);
nm_usuario_w		varchar(15);
 
C01 CURSOR FOR 
	SELECT	nr_seq_evento 
	from 	regra_envio_sms 
	where	cd_estabelecimento = cd_estabelecimento_w 
	and	ie_evento_disp 	= 'IPO' 
	and	coalesce(cd_protocolo,coalesce(NEW.cd_protocolo,0)) = coalesce(NEW.cd_protocolo,0) 
	and	coalesce(nr_seq_protocolo,coalesce(NEW.nr_seq_medicacao,0)) = coalesce(NEW.nr_seq_medicacao,0) 
	and	coalesce(ie_situacao,'A') = 'A';
 
C02 CURSOR FOR 
	SELECT	nr_seq_evento 
	from 	regra_envio_sms 
	where	cd_estabelecimento = cd_estabelecimento_w 
	and	ie_evento_disp 	= 'APO' 
	and	coalesce(cd_protocolo,coalesce(NEW.cd_protocolo,0)) = coalesce(NEW.cd_protocolo,0) 
	and	coalesce(nr_seq_protocolo,coalesce(NEW.nr_seq_medicacao,0)) = coalesce(NEW.nr_seq_medicacao,0) 
	and	coalesce(ie_situacao,'A') = 'A';
 
C03 CURSOR FOR 
	SELECT	nr_seq_evento 
	from 	regra_envio_sms 
	where	cd_estabelecimento = cd_estabelecimento_w 
	and	ie_evento_disp 	= 'EPT' 
	and	coalesce(cd_protocolo,coalesce(NEW.cd_protocolo,0)) = coalesce(NEW.cd_protocolo,0) 
	and	coalesce(nr_seq_protocolo,coalesce(NEW.nr_seq_medicacao,0)) = coalesce(NEW.nr_seq_medicacao,0) 
	and	coalesce(ie_situacao,'A') = 'A';
BEGIN
  BEGIN 
If (NEW.ie_status is not null) and (OLD.ie_status <> NEW.ie_status) and (NEW.ie_status <> 'I') and (NEW.ie_status <> 'F') then 
	CALL Abortar_Se_Protoc_Inativo(NEW.nr_seq_paciente);
end if;
 
if (OLD.ie_status is not null) and (OLD.ie_status <> NEW.ie_status) and (NEW.ie_status = 'F') then 
	CALL Abortar_se_dia_ciclo_ativo(NEW.nr_seq_paciente,NEW.cd_pessoa_fisica);
end if;
 
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
 
if (coalesce(OLD.DT_PROTOCOLO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_PROTOCOLO) and (NEW.DT_PROTOCOLO is not null) then 
	NEW.ds_utc				:= obter_data_utc(NEW.DT_PROTOCOLO, 'HV');	
end if;
 
if (coalesce(OLD.DT_LIB_AUTORIZADOR,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIB_AUTORIZADOR) and (NEW.DT_LIB_AUTORIZADOR is not null) then 
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIB_AUTORIZADOR,'HV');
end if;
 
if (NEW.nr_seq_medicacao is not null) and 
	((OLD.nr_seq_medicacao is null) or (NEW.nr_seq_medicacao <> OLD.nr_seq_medicacao)) and (NEW.qt_tempo_medic	is null )then 
	BEGIN 
	select	max(qt_tempo_medic) 
	into STRICT	NEW.qt_tempo_medic 
	from	protocolo_medicacao 
	where	cd_protocolo	= NEW.cd_protocolo 
	and	nr_sequencia	= NEW.nr_seq_medicacao;
	end;
end if;
 
nm_usuario_w :=wheb_usuario_pck.get_nm_usuario;
ie_cancelar_agend_w  := Obter_Param_Usuario(281, 1255, obter_perfil_ativo, nm_usuario_w, cd_estabelecimento_w, ie_cancelar_agend_w );
 
if (OLD.ie_status is not null) and (OLD.ie_status <> NEW.ie_status) and 
	((NEW.ie_status = 'I') or 
	(NEW.ie_status = 'F' AND OLD.ie_status <> 'I'))then 
		if (ie_cancelar_agend_w = 'S') or 
			(NEW.ie_status = 'I' AND ie_cancelar_agend_w = 'I') or 
			(NEW.ie_status = 'F' AND ie_cancelar_agend_w = 'F') then 
				CALL inativar_dia_tratamento_onco(NEW.nr_seq_paciente, NEW.nm_usuario);
		end if;
end if;
 
if (TG_OP = 'INSERT') then 
 
	BEGIN 
	open C01;
	loop 
	fetch C01 into 
		nr_seq_evento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN 
		CALL gerar_evento_protocolo_onc( 	nr_seq_evento_w, 
						NEW.cd_pessoa_fisica, 
						NEW.cd_protocolo, 
						NEW.nr_seq_medicacao, 
						NEW.nm_usuario);
		end;
	end loop;
	close C01;
	exception 
		when others then 
		null;
	end;
end if;
 
if (TG_OP = 'UPDATE') then 
 
	BEGIN 
	open C02;
	loop 
	fetch C02 into 
		nr_seq_evento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		BEGIN 
		CALL gerar_evento_protocolo_onc( 	nr_seq_evento_w, 
						NEW.cd_pessoa_fisica, 
						NEW.cd_protocolo, 
						NEW.nr_seq_medicacao, 
						NEW.nm_usuario);
		end;
	end loop;
	close C02;
	exception 
		when others then 
		null;
	end;
 
end if;
 
if (TG_OP = 'INSERT') then 
	BEGIN 
	SELECT MAX(NR_ATENDIMENTO) 
	INTO STRICT nr_atendimento_W 
	FROM ATENDIMENTO_PACIENTE 
	WHERE CD_PESSOA_FISICA = NEW.cd_PESSOA_FISICA;
	open C03;
	loop 
	fetch C03 into 
		nr_seq_evento_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		BEGIN 
		CALL gerar_evento_paciente_trigger(nr_seq_evento_w,nr_atendimento_W,NEW.cd_pessoa_fisica,null,NEW.nm_usuario,null,NEW.DT_PROTOCOLO,NULL);
		end;
	end loop;
	close C03;
	end;
 
end if;
 
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_setor_atual() FROM PUBLIC;

CREATE TRIGGER paciente_setor_atual
	BEFORE INSERT OR UPDATE ON paciente_setor FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_setor_atual();
