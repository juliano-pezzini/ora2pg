-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS release_news_idioma_before ON release_news_idioma CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_release_news_idioma_before() RETURNS trigger AS $BODY$
declare

BEGIN

if (coalesce(NEW.DS_OBJETIVO,'XPTO') <> coalesce(OLD.DS_OBJETIVO,'XPTO')) or (TG_OP = 'INSERT' and NEW.DS_OBJETIVO is not null) and (coalesce(NEW.DS_ALTERACAO,'XPTO') <> coalesce(OLD.DS_ALTERACAO,'XPTO')) or (TG_OP = 'INSERT' and NEW.DS_ALTERACAO is not null) then

	if (NEW.DS_LOCALE = 'pt_BR') then
		NEW.DS_IDIOMA:= 'pt';
	elsif (NEW.DS_LOCALE = 'es_MX') then
		NEW.DS_IDIOMA:= 'es';		
	elsif (NEW.DS_LOCALE = 'en_US') then	
		NEW.DS_IDIOMA:= 'en';
	elsif (NEW.DS_LOCALE = 'en_AU') then	
		NEW.DS_IDIOMA:= 'en';		
	elsif (NEW.DS_LOCALE = 'de_DE') then
		NEW.DS_IDIOMA:= 'de';		
	elsif (NEW.DS_LOCALE = 'pl_PL') then
		NEW.DS_IDIOMA:= 'pl';
	end if;	
end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_release_news_idioma_before() FROM PUBLIC;

CREATE TRIGGER release_news_idioma_before
	BEFORE INSERT OR UPDATE ON release_news_idioma FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_release_news_idioma_before();

