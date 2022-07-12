-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_juridica_compl_pls_rps ON pessoa_juridica_compl CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_juridica_compl_pls_rps() RETURNS trigger AS $BODY$
declare
ie_alterou_w	varchar(1) := 'N';
BEGIN
  BEGIN
BEGIN
	if (coalesce(NEW.cd_cep,'0')		!= coalesce(OLD.cd_cep,'0')) or (coalesce(NEW.cd_cgc,'0')		!= coalesce(OLD.cd_cgc,'0')) or (coalesce(NEW.cd_municipio_ibge,'0')!= coalesce(OLD.cd_municipio_ibge,'0')) or (coalesce(NEW.ds_bairro,'0') 	!= coalesce(OLD.ds_bairro,'0')) or (coalesce(NEW.ds_complemento,'0')	!= coalesce(OLD.ds_complemento,'0')) or (coalesce(NEW.ds_endereco,'0')	!= coalesce(OLD.ds_endereco,'0')) or (coalesce(NEW.ds_municipio,'0')	!= coalesce(OLD.ds_municipio,'0')) or (coalesce(NEW.nr_endereco,0)	!= coalesce(OLD.nr_endereco,0)) or (coalesce(NEW.sg_estado,'0')	!= coalesce(OLD.sg_estado,'0')) then
		ie_alterou_w := 'S';
	end if;

	if (ie_alterou_w = 'S') then
		CALL pls_gerar_alt_prest_rps(NEW.cd_cgc, null, null, OLD.cd_cgc, OLD.cd_municipio_ibge, null, NEW.nm_usuario, null, null, NEW.nr_sequencia);
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
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_juridica_compl_pls_rps() FROM PUBLIC;

CREATE TRIGGER pessoa_juridica_compl_pls_rps
	AFTER UPDATE ON pessoa_juridica_compl FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_juridica_compl_pls_rps();
