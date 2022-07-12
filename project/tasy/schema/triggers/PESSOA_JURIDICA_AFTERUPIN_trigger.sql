-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_juridica_afterupin ON pessoa_juridica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_juridica_afterupin() RETURNS trigger AS $BODY$
BEGIN
	if (coalesce(OLD.CD_CEP, ' ') != coalesce(NEW.CD_CEP, ' ')
		or coalesce(OLD.DS_ENDERECO,' ') != coalesce(NEW.DS_ENDERECO, ' ')
		or coalesce(OLD.NR_ENDERECO, ' ') != coalesce(NEW.NR_ENDERECO, ' ')
		or coalesce(OLD.DS_BAIRRO , ' ')!= coalesce(NEW.DS_BAIRRO, ' ')
		or coalesce(OLD.DS_COMPLEMENTO, ' ') != coalesce(NEW.DS_COMPLEMENTO, ' ')
		or coalesce(OLD.DS_MUNICIPIO, ' ') != coalesce(NEW.DS_MUNICIPIO, ' ')
		or coalesce(OLD.CD_MUNICIPIO_IBGE, ' ') != coalesce(NEW.CD_MUNICIPIO_IBGE, ' ')
		or coalesce(OLD.SG_ESTADO, ' ') != coalesce(NEW.SG_ESTADO, ' ')
		or coalesce(OLD.NR_DDD_TELEFONE, ' ') != coalesce(NEW.NR_DDD_TELEFONE, ' ')
		or coalesce(OLD.NR_TELEFONE, ' ') != coalesce(NEW.NR_TELEFONE, ' ')) then
		insert into FIS_PESSOA_JURIDICA_HIST(
				NR_SEQUENCIA,
				CD_CEP,
				CD_CGC,
				CD_MUNICIPIO_IBGE,
				DS_BAIRRO,
				DS_COMPLEMENTO,
				DS_ENDERECO,
				DS_MUNICIPIO,
				DT_ATUALIZACAO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO,
				NM_USUARIO_NREC,
				NR_DDD_TELEFONE,
				NR_ENDERECO,
				NR_TELEFONE,
				SG_ESTADO)
			values (
				nextval('fis_pessoa_juridica_hist_seq'),
				NEW.CD_CEP,
				NEW.CD_CGC,
				NEW.CD_MUNICIPIO_IBGE,
				NEW.DS_BAIRRO,
				NEW.DS_COMPLEMENTO,
				NEW.DS_ENDERECO,
				NEW.DS_MUNICIPIO,
				LOCALTIMESTAMP,
				LOCALTIMESTAMP,
				NEW.NM_USUARIO,
				NEW.NM_USUARIO,
				NEW.NR_DDD_TELEFONE,
				NEW.NR_ENDERECO,
				NEW.NR_TELEFONE,
				NEW.SG_ESTADO);
	end if;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_juridica_afterupin() FROM PUBLIC;

CREATE TRIGGER pessoa_juridica_afterupin
	AFTER INSERT OR UPDATE ON pessoa_juridica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_juridica_afterupin();
