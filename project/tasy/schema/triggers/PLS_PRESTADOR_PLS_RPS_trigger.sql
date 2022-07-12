-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_prestador_pls_rps ON pls_prestador CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_prestador_pls_rps() RETURNS trigger AS $BODY$
declare
ie_alterou_w 		varchar(1) := 'N';
cd_cgc_cpf_old_w	pls_alt_prest_rps.cd_cgc_cpf_old%type;
BEGIN
  BEGIN
BEGIN
	if (coalesce(NEW.cd_cgc,'0')			!= coalesce(OLD.cd_cgc,'0')) or (coalesce(NEW.cd_pessoa_fisica,'0')		!= coalesce(OLD.cd_pessoa_fisica,'0')) or (coalesce(NEW.dt_inicio_servico,LOCALTIMESTAMP)	!= coalesce(OLD.dt_inicio_servico,LOCALTIMESTAMP))or (coalesce(NEW.dt_inicio_contrato,LOCALTIMESTAMP)	!= coalesce(OLD.dt_inicio_contrato,LOCALTIMESTAMP)) or (coalesce(NEW.ie_tipo_relacao,'0')		!= coalesce(OLD.ie_tipo_relacao,'0')) or (coalesce(NEW.ie_urgencia_emergencia,'0')	!= coalesce(OLD.ie_urgencia_emergencia,'0')) or (coalesce(NEW.ie_tipo_classif_ptu,0)	!= coalesce(OLD.ie_tipo_classif_ptu,0)) or (coalesce(NEW.ie_disponibilidade_serv,'0')	!= coalesce(OLD.ie_disponibilidade_serv,'0')) or (coalesce(NEW.sg_uf_sip,'0')		!= coalesce(OLD.sg_uf_sip,'0')) then
		ie_alterou_w := 'S';
	end if;

	if (ie_alterou_w = 'S') then
		if (NEW.cd_cgc is not null) or (OLD.cd_cgc is not null) then
			cd_cgc_cpf_old_w := OLD.cd_cgc;

		elsif (NEW.cd_pessoa_fisica is not null) or (OLD.cd_pessoa_fisica is not null) then
			select	max(nr_cpf)
			into STRICT	cd_cgc_cpf_old_w
			from	pessoa_fisica
			where	cd_pessoa_fisica = NEW.cd_pessoa_fisica;
		end if;

		CALL pls_gerar_alt_prest_rps( null, null, NEW.nr_sequencia, cd_cgc_cpf_old_w, null, null, NEW.nm_usuario, null, null, null);
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
-- REVOKE ALL ON FUNCTION trigger_fct_pls_prestador_pls_rps() FROM PUBLIC;

CREATE TRIGGER pls_prestador_pls_rps
	AFTER UPDATE ON pls_prestador FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_prestador_pls_rps();
