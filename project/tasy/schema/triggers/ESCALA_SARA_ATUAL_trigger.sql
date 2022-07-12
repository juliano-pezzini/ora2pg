-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_sara_atual ON escala_sara CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_sara_atual() RETURNS trigger AS $BODY$
declare
qt_rel_pao_w		bigint := 0;
qt_topografia_w		bigint := 0;
qt_cmhml_w			bigint := 0;
qt_presssao_w		bigint := 0;
qt_divisor_w		bigint := 0;
qt_total_w			double precision := 0;

BEGIN

if (NEW.ie_radiografia_torax >= 0 ) then
	qt_topografia_w	:= NEW.ie_radiografia_torax;
end if;

if (NEW.QT_REL_PAO2_FIO2 >= 300 ) then
	qt_rel_pao_w	:= 0;
elsif (NEW.QT_REL_PAO2_FIO2 between 225 and 299) then
	qt_rel_pao_w	:= 1;
elsif (NEW.QT_REL_PAO2_FIO2 between 175 and	224) then
	qt_rel_pao_w	:= 2;
elsif (NEW.QT_REL_PAO2_FIO2 between 100 and	174) then
	qt_rel_pao_w	:= 3;
elsif (NEW.QT_REL_PAO2_FIO2 < 100) then
	qt_rel_pao_w	:= 4;
end if;

if (NEW.qt_compl_cmh2o >= 80) then
	qt_cmhml_w := 0;
elsif (NEW.qt_compl_cmh2o between 60 and 79) then
		qt_cmhml_w := 1;
elsif (NEW.qt_compl_cmh2o between 40 and 59) then
		qt_cmhml_w := 2;
elsif (NEW.qt_compl_cmh2o between 20 and 39) then
		qt_cmhml_w := 3;
elsif (NEW.qt_compl_cmh2o <= 20) then
		qt_cmhml_w := 4;
end if;

if (NEW.qt_pressao_cmh2o <= 5) then
	qt_presssao_w := 0;
elsif (NEW.qt_pressao_cmh2o between 6 and 8) then
	qt_presssao_w := 1;
elsif (NEW.qt_pressao_cmh2o between 9 and 11) then
	qt_presssao_w := 2;
elsif (NEW.qt_pressao_cmh2o between 12 and 14) then
	qt_presssao_w := 3;
elsif (NEW.qt_pressao_cmh2o >=15) then
	qt_presssao_w := 4;
end if;

if (NEW.ie_radiografia_torax is not null) then
	qt_divisor_w := qt_divisor_w + 1;
end if;
if (NEW.qt_rel_pao2_fio2 is not null) then
	qt_divisor_w := qt_divisor_w + 1;
end if;
if (NEW.qt_compl_cmh2o is not null) then
	qt_divisor_w := qt_divisor_w + 1;
end if;
if (NEW.qt_pressao_cmh2o is not null) then
	qt_divisor_w := qt_divisor_w + 1;
end if;

if (qt_divisor_w = 0) then
	qt_divisor_w 	:= 1;
end if;
qt_total_w	:= 	((coalesce(qt_topografia_w,0) + coalesce(qt_rel_pao_w,0) + coalesce(qt_cmhml_w,0) + coalesce(qt_presssao_w,0))/qt_divisor_w);

NEW.qt_pontuacao := round((qt_total_w)::numeric,2);
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_sara_atual() FROM PUBLIC;

CREATE TRIGGER escala_sara_atual
	BEFORE INSERT OR UPDATE ON escala_sara FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_sara_atual();
