-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_crusade_atual ON escala_crusade CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_crusade_atual() RETURNS trigger AS $BODY$
declare
  qt_reg_w           smallint;
  qt_score_w         double precision;
  pr_risco_w         double precision;
  cd_pessoa_fisica_w varchar(15);
  ie_sexo_w          varchar(1);
  sql_score          varchar(200);
  sql_risco          varchar(200);
BEGIN
  BEGIN
 
  if (wheb_usuario_pck.get_ie_executar_trigger	= 'N') then
    goto Final;
  end if;
 
  NEW.qt_score	:= null;
  NEW.pr_risco	:= null;
 
  cd_pessoa_fisica_w := obter_pessoa_atendimento(NEW.Nr_atendimento, 'C');
  ie_sexo_w          := obter_sexo_pf(cd_pessoa_fisica_w, 'C');

  /** Medical Device **/


  BEGIN
    sql_score := 'call obter_score_escala_crusade_md(:1, :2, :3, :4, :5, :6, :7, :8) into :qt_score_w';
    EXECUTE sql_score using in ie_sexo_w,
	    	                          in NEW.qt_hematocrito,
                                      in NEW.qt_clearance,
			                          in NEW.qt_freq_cardiaca,
                                      in NEW.qt_pa_sistolica,
                                      in NEW.ie_diabete,
                                      in NEW.ie_doenca_vasc_previa,
                                      in NEW.ie_sinais_ic,			                    
                                      out qt_score_w;
  exception
    when others then
	  qt_score_w := null;
  end;
  NEW.qt_score := qt_score_w;
  
  BEGIN  
    sql_risco := 'call obter_risco_escala_crusade_md(:1) into :pr_risco_w';
    EXECUTE sql_risco using in NEW.qt_score,			                    
                                     out pr_risco_w;
  exception
    when others then
	  pr_risco_w := null;
  end;
  NEW.pr_risco := pr_risco_w;
 
  <<Final>> 
  qt_reg_w := 0;
 
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_crusade_atual() FROM PUBLIC;

CREATE TRIGGER escala_crusade_atual
	BEFORE INSERT OR UPDATE ON escala_crusade FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_crusade_atual();
