-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_timi_risk_atual ON atend_timi_risk CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_timi_risk_atual() RETURNS trigger AS $BODY$
declare
qt_reg_w         	smallint;
ds_sql_w            varchar(500);
ds_erro_w        	varchar(4000);
ds_parametros_w  	varchar(4000);
BEGIN
  BEGIN
    if ( NEW.nr_hora is null ) or ( NEW.dt_avaliacao <> OLD.dt_avaliacao ) then
        BEGIN
            NEW.nr_hora := (to_char(round(NEW.dt_avaliacao, 'hh24'), 'hh24'))::numeric;
        end;
    end if;

    if ( wheb_usuario_pck.get_ie_executar_trigger = 'N' ) then
        goto final;
    end if;

    BEGIN
        ds_sql_w := 'begin calcula_timi_risk_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17); end;';
        EXECUTE ds_sql_w using in NEW.qt_ano,
										 in NEW.ie_fator_risco, 
										 in NEW.ie_dac, 
										 in NEW.ie_aas, 
										 in NEW.ie_angina_24h, 
										 in NEW.ie_elev_enzima,
										 in NEW.ie_desvio_st, 
										 out NEW.qt_escore_ano, 
										 out NEW.qt_escore_fat_risco, 
										 out NEW.qt_escore_dac, 
										 out NEW.qt_escore_aas,
										 out NEW.qt_escore_angina, 
										 out NEW.qt_escore_elev_enzima, 
										 out NEW.qt_escore_desvio, 
										 out NEW.qt_escore, 
										 out NEW.pr_morte_infarto,
										 out NEW.pr_morte_infarto_revasc;

    exception
        when others then
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametros_w := substr( ':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.qt_ano: '||NEW.qt_ano||'-'||'new.ie_fator_risco: '||NEW.ie_fator_risco||'-'||':new.ie_dac: '||NEW.ie_dac||
									   '-'||':new.ie_aas: '||NEW.ie_aas||'-'||':new.ie_angina_24h: '||NEW.ie_angina_24h||'-'||':new.ie_elev_enzima: '||NEW.ie_elev_enzima||'-'||':new.ie_desvio_st: '||NEW.ie_desvio_st||
									   '-'||':new.qt_escore_ano: '||NEW.qt_escore_ano||'-'||'new.qt_escore_fat_risco: '||NEW.qt_escore_fat_risco||'-'||':new.qt_escore_dac: '||NEW.qt_escore_dac||'-'||':new.qt_escore_aas: '||NEW.qt_escore_aas||
									   '-'||':new.qt_escore_angina: '||NEW.qt_escore_angina||'-'||':new.qt_escore_elev_enzima: '||NEW.qt_escore_elev_enzima||'-'||':new.qt_escore_desvio: '||NEW.qt_escore_desvio||'-'||':new.qt_escore: '||NEW.qt_escore||
									   '-'||':new.pr_morte_infarto: '||NEW.pr_morte_infarto||'-'||':new.pr_morte_infarto_revasc: '||NEW.pr_morte_infarto_revasc, 1, 4000);

            CALL gravar_log_medical_device('atend_timi_risk_atual', 'CALCULA_TIMI_RISK_MD', ds_parametros_w, ds_erro_w, NEW.nm_usuario,
                                     'N');

            NEW.qt_escore_ano := 0;
            NEW.qt_escore_fat_risco := 0;
            NEW.qt_escore_dac := 0;
            NEW.qt_escore_aas := 0;
            NEW.qt_escore_angina := 0;
            NEW.qt_escore_elev_enzima := 0;
            NEW.qt_escore_desvio := 0;
            NEW.qt_escore := 0;
            NEW.pr_morte_infarto := 0;
            NEW.pr_morte_infarto_revasc := 0;
    end;

    << final >>
	qt_reg_w := 0;
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_timi_risk_atual() FROM PUBLIC;

CREATE TRIGGER atend_timi_risk_atual
	BEFORE INSERT OR UPDATE ON atend_timi_risk FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_timi_risk_atual();
