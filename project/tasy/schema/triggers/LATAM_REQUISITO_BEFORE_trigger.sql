-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS latam_requisito_before ON latam_requisito CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_latam_requisito_before() RETURNS trigger AS $BODY$
DECLARE

qt_reg_w		bigint;

BEGIN
	if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
		goto Final;
	end if;
	
	if (coalesce(NEW.ie_sob_medida,'N') = 'N'  and NEW.qt_tempo_horas is null) then
		BEGIN
			NEW.qt_tempo_horas :=  coalesce(calcular_esforco_requisito(NEW.nr_sequencia,
									NEW.nr_seq_gap,
									NEW.nr_seq_prs,
									NEW.ie_esforco_desenv,
									NEW.ie_complexidade,
									NEW.pr_confianca),0);
		end;
	end if;
	
	if (NEW.ie_necessita_tecnologia = 'S'  and NEW.qt_horas_tec is null) then
		BEGIN
			NEW.qt_horas_tec := coalesce(calcular_esforco_area(NEW.nr_sequencia,
								NEW.nr_seq_gap,
								NEW.nr_seq_prs,
								'TE',
								NEW.ie_necessita_design,
								NEW.ie_necessita_tecnologia,
								NEW.qt_tempo_horas),0);
		end;
	end if;
	
	if (NEW.ie_necessita_design = 'S'  and NEW.qt_horas_design is null) then
		BEGIN
			NEW.qt_horas_design := coalesce(calcular_esforco_area(NEW.nr_sequencia,
									NEW.nr_seq_gap,
									NEW.nr_seq_prs,
									'DE',
									NEW.ie_necessita_design,
									NEW.ie_necessita_tecnologia,
									NEW.qt_tempo_horas),0);
		end;
	end if;
	
	<<Final>>
	qt_reg_w	:= 0;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_latam_requisito_before() FROM PUBLIC;

CREATE TRIGGER latam_requisito_before
	BEFORE INSERT OR UPDATE ON latam_requisito FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_latam_requisito_before();
