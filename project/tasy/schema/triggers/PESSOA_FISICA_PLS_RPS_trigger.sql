-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_fisica_pls_rps ON pessoa_fisica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_fisica_pls_rps() RETURNS trigger AS $BODY$
declare
ie_alterou_w		varchar(1) := 'N';
BEGIN
  BEGIN
BEGIN
	if (coalesce(NEW.nr_cpf,'0') 		!= coalesce(OLD.nr_cpf,'0')) or (coalesce(NEW.nm_pessoa_fisica,'0')	!= coalesce(OLD.nm_pessoa_fisica,'0')) or (coalesce(NEW.cd_cnes,'0')		!= coalesce(OLD.cd_cnes,'0')) or (coalesce(NEW.cd_municipio_ibge,'0')!= coalesce(OLD.cd_municipio_ibge,'0')) then
		ie_alterou_w := 'S';
	end if;

	if (ie_alterou_w = 'S') then
		CALL pls_gerar_alt_prest_rps(null, NEW.cd_pessoa_fisica, null, OLD.nr_cpf, OLD.cd_municipio_ibge, OLD.cd_cnes, NEW.nm_usuario, null, null, null);
	end if;
exception
when others then
	null;
end;
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_fisica_pls_rps() FROM PUBLIC;

CREATE TRIGGER pessoa_fisica_pls_rps
	AFTER UPDATE ON pessoa_fisica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_fisica_pls_rps();

