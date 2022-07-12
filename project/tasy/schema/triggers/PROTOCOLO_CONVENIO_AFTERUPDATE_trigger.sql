-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS protocolo_convenio_afterupdate ON protocolo_convenio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_protocolo_convenio_afterupdate() RETURNS trigger AS $BODY$
DECLARE

nr_sequencia_w	bigint;
ie_historico_w	varchar(01);
dt_referencia_w	timestamp;
nr_interno_conta_w	bigint;
vl_conta_w		double precision;
nr_atendimento_w	bigint;
vl_protocolo_w		double precision;
ds_observacao_w		varchar(255);
ie_grava_log_w		varchar(01);
enviar_fat_int_w 		varchar(1);

nr_seq_status_fat_w bigint;
nr_seq_status_mob_w bigint;
nr_seq_regra_fluxo_w bigint;

c01 CURSOR FOR
SELECT	nr_interno_conta,
	nr_atendimento,
	vl_conta
from	conta_paciente
where	nr_seq_protocolo	= NEW.nr_seq_protocolo
and	coalesce(vl_conta,0)	> 0;

c02 CURSOR FOR
	SELECT 	nr_interno_conta
	from conta_paciente
	where nr_seq_protocolo 	= NEW.nr_seq_protocolo;

BEGIN

ie_grava_log_w := Obter_Param_Usuario(85, 141, obter_perfil_ativo, NEW.nm_usuario, NEW.cd_estabelecimento, ie_grava_log_w);
enviar_fat_int_w := Obter_Param_Usuario(85, 258, obter_perfil_ativo, NEW.nm_usuario, NEW.cd_estabelecimento, enviar_fat_int_w);

ie_historico_w	:= 'N';
if (NEW.ie_status_protocolo <> OLD.ie_status_protocolo) then
	select coalesce(max(ie_historico_conta),'N')
	into STRICT	ie_historico_w
	from	parametro_faturamento
	where	cd_estabelecimento	= NEW.cd_estabelecimento;
	if (ie_historico_w = 'S') then
		OPEN C01;
		LOOP
		FETCH C01 into
			nr_interno_conta_w,
			nr_atendimento_w,
			vl_conta_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			select	nextval('conta_paciente_hist_seq')
			into STRICT	nr_sequencia_w
			;
			insert into conta_paciente_hist(
				nr_sequencia, dt_atualizacao, nm_usuario,
				vl_conta, nr_seq_protocolo, nr_interno_conta,
				nr_nivel_anterior, nr_nivel_atual, dt_referencia,
				nr_atendimento, cd_convenio)
			values (
				nr_sequencia_w, LOCALTIMESTAMP, NEW.nm_usuario,
				vl_conta_w, NEW.nr_seq_protocolo, nr_interno_conta_w,
				CASE WHEN OLD.ie_status_protocolo=2 THEN  10  ELSE 8 END ,
				CASE WHEN NEW.ie_status_protocolo=2 THEN  10  ELSE 8 END ,
				trunc(LOCALTIMESTAMP,'dd'), nr_atendimento_w, NEW.cd_convenio);
		END LOOP;
		CLOSE C01;
	end if;
end if;

if	(ie_grava_log_w = 'N') or -- Se ie_grava_log_w = 'S' então o sistema já gravou o log na procedure  Atualizar_Ref_Protocolo_Conv(Obter_Funcao_Ativa <> 85) then

	if (NEW.DT_MESANO_REFERENCIA <> OLD.DT_MESANO_REFERENCIA) then

		select 	coalesce(obter_total_protocolo(NEW.nr_seq_protocolo),0)
		into STRICT	vl_protocolo_w
		;

		ds_observacao_w	:= wheb_mensagem_pck.get_texto(298741,	'DT_MESANO_REFERENCIA_OLD_W='||to_char(OLD.DT_MESANO_REFERENCIA,'dd/mm/yyyy')||
									';DT_MESANO_REFERENCIA_NEW_W='||to_char(NEW.DT_MESANO_REFERENCIA,'dd/mm/yyyy'));
		--ds_observacao_w:= 'Data de Referência ' || '(De: ' || :old.DT_MESANO_REFERENCIA || '  p/ ' || :new.DT_MESANO_REFERENCIA || ')';
		insert into protocolo_convenio_log(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_protocolo,
			ds_arquivo_envio,
			vl_protocolo,
			ie_tipo_log,
			ds_observacao)
		values (nextval('protocolo_convenio_log_seq'),
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			NEW.nr_seq_protocolo,
			NEW.ds_arquivo_envio,
			vl_protocolo_w,
			'D',
			ds_observacao_w);

	end if;
end if;

if (OLD.ie_status_protocolo = 2 and NEW.ie_status_protocolo = 1) then
	OPEN C02;
	LOOP
	FETCH C02 into
		 nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

	cf_retornar_status_fat(nr_interno_conta_w,
				 'P',
				 nr_seq_status_fat_w,
				 nr_seq_status_mob_w,
				 NEW.nm_usuario);

	END LOOP;
	CLOSE C02;

end if;

CALL WHEB_USUARIO_PCK.set_ie_commit('N');
if	((coalesce(OLD.ie_status_protocolo,0) <> coalesce(NEW.ie_status_protocolo,0))
	 and (coalesce(NEW.ie_status_protocolo,0) = 2) and (enviar_fat_int_w = 'S'))then
	CALL enviar_fat_intercompany(NEW.nr_seq_protocolo, wheb_usuario_pck.get_nm_usuario);
end if;
CALL WHEB_USUARIO_PCK.set_ie_commit('S');

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_protocolo_convenio_afterupdate() FROM PUBLIC;

CREATE TRIGGER protocolo_convenio_afterupdate
	AFTER UPDATE ON protocolo_convenio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_protocolo_convenio_afterupdate();
