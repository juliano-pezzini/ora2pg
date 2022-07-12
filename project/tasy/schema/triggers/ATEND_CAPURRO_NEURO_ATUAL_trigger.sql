-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_capurro_neuro_atual ON escala_capurro_neuro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_capurro_neuro_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w		        bigint;
cd_estabelecimento_w	bigint;
ie_ig_capurro_w		    varchar(5);
sql_w                   varchar(200);
ds_erro_w               varchar(4000);
ds_parametros_w         varchar(4000);
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N') then
	goto Final;
end if;


--- Inicio MD1
    BEGIN
    sql_w := 'begin CALC_DIA_SEM_CAPURRO_NEURO_MD(:1, :2, :3, :4, :5, :6, :7, :8); end;';


    EXECUTE sql_w  USING IN NEW.QT_TEXTURA_PELE, 
                                   IN NEW.QT_PREGAS_PLANTARES,
                                   IN NEW.QT_GLANDULA_MAMARIA, 
                                   IN NEW.QT_FORMATO_ORELHA, 
                                   IN NEW.QT_ANGULO_CABECA,
                                   IN NEW.QT_SINAL_XALE,
                                   OUT NEW.qt_dias, 
                                   OUT NEW.QT_SEMANAS;
     EXCEPTION
     WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.dt_atualizacao: '||NEW.dt_atualizacao||'-'||'new.nm_usuario: '||NEW.nm_usuario||'-'||'new.nr_atendimento: '||NEW.nr_atendimento||'-'||
                         ':new.QT_TEXTURA_PELE: '||NEW.QT_TEXTURA_PELE||'-'||':new.QT_PREGAS_PLANTARES: '||NEW.QT_PREGAS_PLANTARES||'-'||':new.QT_GLANDULA_MAMARIA: '||NEW.QT_GLANDULA_MAMARIA||'-'||
                         ':new.QT_FORMATO_ORELHA: '||NEW.QT_FORMATO_ORELHA||'-'||':new.QT_ANGULO_CABECA: '||NEW.QT_ANGULO_CABECA||'-'||':new.QT_SINAL_XALE: '||NEW.QT_SINAL_XALE||'-'||
                         ':new.qt_dias: '||NEW.qt_dias|| '-'||':new.QT_SEMANAS: '||NEW.QT_SEMANAS);
      CALL gravar_log_medical_device('ATEND_CAPURRO_NEURO_ATUAL','CALC_DIA_SEM_CAPURRO_NEURO_MD'
                                 ,ds_parametros_w,ds_erro_w,NEW.nm_usuario,'N');
     
       NEW.qt_dias := null;
       NEW.QT_SEMANAS := null;
     END;

--- Fim MD1
select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	atendimento_paciente
where	nr_atendimento	= NEW.nr_atendimento;

select	count(*)
into STRICT	qt_reg_w
from	nascimento
where	nr_atendimento = NEW.nr_atendimento;

select	coalesce(max(ie_ig_capurro),'N')
into STRICT	ie_ig_capurro_w
from	parametro_medico
where	cd_estabelecimento	= cd_estabelecimento_w;

if (qt_reg_w > 0) and (ie_ig_capurro_w = 'S') then
	update	nascimento
	set	qt_sem_ig = NEW.QT_SEMANAS,
		qt_dia_ig = NEW.QT_DIAS
	where	nr_atendimento = NEW.nr_atendimento;	
end if;
<<Final>>
qt_reg_w	:= 0;

  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_capurro_neuro_atual() FROM PUBLIC;

CREATE TRIGGER atend_capurro_neuro_atual
	BEFORE INSERT OR UPDATE ON escala_capurro_neuro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_capurro_neuro_atual();

