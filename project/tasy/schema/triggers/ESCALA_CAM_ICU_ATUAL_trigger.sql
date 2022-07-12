-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_cam_icu_atual ON escala_cam_icu CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_cam_icu_atual() RETURNS trigger AS $BODY$
declare
 
qt_pens_desorg_presente 	bigint;
 
 
BEGIN 
 
NEW.ie_inicio_agudo_presente := 'A';
if (coalesce(NEW.ie_alt_estado_mental,'N') = 'S') or (coalesce(NEW.ie_comport_anormal,'N') = 'S') then 
	NEW.ie_inicio_agudo_presente := 'P';
end if;
 
NEW.ie_atencao_presente := 'A';
if (coalesce(NEW.ie_focar_atencao,'N') = 'S') or (coalesce(NEW.ie_distraido,'N') = 'S') then 
	NEW.ie_atencao_presente := 'P';
end if;
 
NEW.ie_pens_desorg_presente := 'A';
qt_pens_desorg_presente:= 0;
if (coalesce(NEW.ie_pedra_flutuam,'N') = 'S') then 
	qt_pens_desorg_presente := qt_pens_desorg_presente + 1;
end if;
if (coalesce(NEW.ie_peixe_mar,'N') = 'S') then 
	qt_pens_desorg_presente := qt_pens_desorg_presente + 1;
end if;
if (coalesce(NEW.ie_quilograma,'N') = 'S') then 
	qt_pens_desorg_presente := qt_pens_desorg_presente + 1;
end if;
if (coalesce(NEW.ie_martelo_madeira,'N') = 'S') then 
	qt_pens_desorg_presente := qt_pens_desorg_presente + 1;
end if;
if (qt_pens_desorg_presente > 1) then	 
	NEW.ie_pens_desorg_presente := 'P';
end if;
 
NEW.ie_nivel_conc_presente := 'A';
if (coalesce(NEW.ie_agitado,'N') = 'S') or (coalesce(NEW.ie_letagico,'N') = 'S') or (coalesce(NEW.ie_estuporoso,'N') = 'S') or (coalesce(NEW.ie_camatoso,'N') = 'S') then 
	NEW.ie_nivel_conc_presente := 'P';
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_cam_icu_atual() FROM PUBLIC;

CREATE TRIGGER escala_cam_icu_atual
	BEFORE INSERT OR UPDATE ON escala_cam_icu FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_cam_icu_atual();

