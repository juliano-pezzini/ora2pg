-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS fis_efd_icmsipi_pf_atual ON pessoa_fisica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_fis_efd_icmsipi_pf_atual() RETURNS trigger AS $BODY$
declare
ie_efd_icmsipi_w	varchar(1);
ds_valor_alterior_w varchar(100);
ds_se_nome_social_w varchar(1);

BEGIN
ie_efd_icmsipi_w := obter_param_usuario(5500, 61, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_efd_icmsipi_w);
ds_se_nome_social_w := pkg_name_utils.get_social_name_enabled(obter_estabelecimento_ativo);

if (wheb_usuario_pck.get_ie_executar_trigger = 'S' ) then
	if (coalesce(ie_efd_icmsipi_w,'N') = 'S') then
		ds_valor_alterior_w := '';
		-- REGISTRO 0150.NOME
		if (ds_se_nome_social_w = 'S') then
			if (coalesce(NEW.nm_social,coalesce(NEW.nm_pessoa_fisica,'XPTO')) <> coalesce(OLD.nm_social,coalesce(OLD.nm_pessoa_fisica,'XPTO'))) then
				ds_valor_alterior_w := substr(coalesce(OLD.nm_social, OLD.nm_pessoa_fisica), 1, 100);
			end if;
		elsif (ds_se_nome_social_w = 'T') then
			if (coalesce(NEW.nm_social,'XPTO') <> coalesce(OLD.nm_social,'XPTO'))
			or (coalesce(NEW.nm_pessoa_fisica,'XPTO') <> coalesce(OLD.nm_pessoa_fisica,'XPTO')) then
				if (OLD.nm_social is not null) then
					ds_valor_alterior_w := substr(OLD.nm_social || '(' || OLD.nm_pessoa_fisica || ')', 1, 100);
				else
					ds_valor_alterior_w := substr(OLD.nm_pessoa_fisica, 1, 100);
				end if;
			end if;
		else
			if (coalesce(NEW.nm_pessoa_fisica,'XPTO') <> coalesce(OLD.nm_pessoa_fisica,'XPTO')) then
				ds_valor_alterior_w := substr(OLD.nm_pessoa_fisica, 1, 100);
			end if;
		end if;
		if (ds_valor_alterior_w is not null or ds_valor_alterior_w <> '') then
			insert into fis_efd_icmsipi_alteracao(
				nr_sequencia,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_campo_alterado,
				ds_valor_anterior,
				cd_pessoa_fisica)
			values (nextval('fis_efd_icmsipi_alteracao_seq'),
				LOCALTIMESTAMP,
				obter_usuario_ativo,
				'03', -- Domínio 8965 - EFD ICMS/IPI - Campo alterado
				ds_valor_alterior_w,
				NEW.cd_pessoa_fisica);
		end if;

		-- REGISTRO 0150.COD_PAIS
		if (coalesce(NEW.nr_seq_pais,0) <> coalesce(OLD.nr_seq_pais,0)) then
			insert into fis_efd_icmsipi_alteracao(
				nr_sequencia,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_campo_alterado,
				ds_valor_anterior,
				cd_pessoa_fisica)
			values (nextval('fis_efd_icmsipi_alteracao_seq'),
				LOCALTIMESTAMP,
				obter_usuario_ativo,
				'04', -- Domínio 8965 - EFD ICMS/IPI - Campo alterado
				to_char(OLD.nr_seq_pais),
				NEW.cd_pessoa_fisica);
		end if;

		-- REGISTRO 0150.CPF
		if (coalesce(NEW.nr_cpf,'XPTO') <> coalesce(OLD.nr_cpf,'XPTO')) then
			insert into fis_efd_icmsipi_alteracao(
				nr_sequencia,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_campo_alterado,
				ds_valor_anterior,
				cd_pessoa_fisica)
			values (nextval('fis_efd_icmsipi_alteracao_seq'),
				LOCALTIMESTAMP,
				obter_usuario_ativo,
				'06', -- Domínio 8965 - EFD ICMS/IPI - Campo alterado
				elimina_caracteres_especiais(OLD.nr_cpf),
				NEW.cd_pessoa_fisica);
		end if;
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_fis_efd_icmsipi_pf_atual() FROM PUBLIC;

CREATE TRIGGER fis_efd_icmsipi_pf_atual
	AFTER UPDATE OF nm_social,nm_pessoa_fisica,nr_seq_pais,nr_cpf ON pessoa_fisica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_fis_efd_icmsipi_pf_atual();

