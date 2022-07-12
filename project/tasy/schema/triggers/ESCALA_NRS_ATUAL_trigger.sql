-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_nrs_atual ON escala_nrs CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_nrs_atual() RETURNS trigger AS $BODY$
declare
  qt_total_w		   bigint;
  nr_seq_evento_w      bigint;
  cd_estabelecimento_w smallint;
  cd_pessoa_fisica_w   varchar(10);
  qt_idade_w           bigint;
  sql_w                varchar(200);
  peso_parte_w         real;
  qt_imc_w             real;
  ds_erro_w   varchar(4000);
  ds_parametro_w  varchar(4000);
C01 CURSOR FOR
	SELECT nr_seq_evento
	  from regra_envio_sms
	 where ((cd_estabelecimento_w = 0) or (cd_estabelecimento	= cd_estabelecimento_w))
	   and ie_evento_disp = 'LNRS'
	   and qt_idade_w between coalesce(qt_idade_min, 0)
	   and coalesce(qt_idade_max, 9999)
	   and coalesce(ie_situacao, 'A') = 'A';
BEGIN
  BEGIN

  if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	
	qt_imc_w := Obter_IMC(NEW.qt_peso,
	                      NEW.qt_altura_cm,
						  obter_pessoa_atendimento(NEW.nr_atendimento, 'C')
						 );

    if (NEW.qt_imc <= 0 or NEW.qt_imc is null) and (qt_imc_w is not null) then
	  NEW.qt_imc := qt_imc_w;
	end if;

	if (NEW.nr_hora is null) or (NEW.dt_avaliacao <> OLD.dt_avaliacao) then
	  NEW.nr_hora := (to_char(round(NEW.dt_avaliacao,'hh24'),'hh24'))::numeric;
	end if;

	BEGIN
	  sql_w := 'call obter_score_escala_nrs_md(:1, :2, :3) into :qt_total_w';
	  EXECUTE sql_w using in NEW.QT_ESTADO_NUTRICIONAL,
									in NEW.QT_GRAVIDADE_DOENCA,
									in NEW.qt_idade,
									out qt_total_w;
	exception
	  when others then
	    qt_total_w := null;
        ds_erro_w := substr(sqlerrm, 1, 4000);
        ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
        || ' - :new.QT_ESTADO_NUTRICIONAL: ' || NEW.QT_ESTADO_NUTRICIONAL || ' - :new.QT_GRAVIDADE_DOENCA: ' || NEW.QT_GRAVIDADE_DOENCA
        || ' - :new.qt_idade: ' || NEW.qt_idade || ' - qt_total_w: ' || qt_total_w, 1, 4000);
        CALL gravar_log_medical_device('escala_nrs_atual', 'obter_score_escala_nrs_md', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
	end;

    NEW.qt_pontuacao := qt_total_w;

	if (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) and (NEW.qt_pontuacao >= 3)then
		BEGIN
		select	max(cd_estabelecimento),
			max(cd_pessoa_fisica)
		into STRICT	cd_estabelecimento_w,
			cd_pessoa_fisica_w
		from	atendimento_paciente
		where	nr_atendimento	= NEW.nr_atendimento;
		qt_idade_w	:= coalesce(obter_idade_pf(cd_pessoa_fisica_w,LOCALTIMESTAMP,'A'),0);
		open C01;
		loop
		fetch C01 into
			nr_seq_evento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			BEGIN
			CALL gerar_evento_paciente_trigger(nr_seq_evento_w,NEW.nr_atendimento,cd_pessoa_fisica_w,null,NEW.nm_usuario);
			end;
		end loop;
		close C01;
		end;
	end if;

  end if;
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_nrs_atual() FROM PUBLIC;

CREATE TRIGGER escala_nrs_atual
	BEFORE INSERT OR UPDATE ON escala_nrs FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_nrs_atual();
