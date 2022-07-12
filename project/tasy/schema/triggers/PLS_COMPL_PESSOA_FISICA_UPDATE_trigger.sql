-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_compl_pessoa_fisica_update ON compl_pessoa_fisica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_compl_pessoa_fisica_update() RETURNS trigger AS $BODY$
DECLARE

ie_insere_registro_w		varchar(10) := 'N';
qt_beneficiarios_repasse_w	bigint;
nr_seq_segurado_w		bigint;
BEGIN
  BEGIN

ie_insere_registro_w		:= 'N';
qt_beneficiarios_repasse_w	:= 0;

/*Essa trigger irá verificar apenas beneficiários de repasse com responsabilidade transferida*/

if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then
	if (OLD.nm_usuario is not null) and (NEW.ie_tipo_complemento in (1,2)) then

		select	count(*)
		into STRICT	qt_beneficiarios_repasse_w
		from	pls_segurado
		where	cd_pessoa_fisica	= OLD.cd_pessoa_fisica
		and	ie_tipo_segurado	= 'R';

		if (qt_beneficiarios_repasse_w	> 0) then

			select	max(nr_sequencia)
			into STRICT	nr_seq_segurado_w
			from	pls_segurado
			where	cd_pessoa_fisica	= OLD.cd_pessoa_fisica
			and	ie_tipo_segurado	= 'R';

			if (coalesce(OLD.ds_endereco,'0') <> coalesce(NEW.ds_endereco,'0')) then
				ie_insere_registro_w := 'S';
			end if;

			if (coalesce(OLD.nr_endereco,'0') <> coalesce(NEW.nr_endereco,'0')) then
				ie_insere_registro_w := 'S';
			end if;

			if (coalesce(OLD.ds_bairro,'0') <> coalesce(NEW.ds_bairro,'0')) then
				ie_insere_registro_w := 'S';
			end if;

			if (coalesce(OLD.cd_municipio_ibge,'0') <> coalesce(NEW.cd_municipio_ibge,'0')) then
				ie_insere_registro_w := 'S';
			end if;

			if (coalesce(OLD.sg_estado,'0') <> coalesce(NEW.sg_estado,'0')) then
				ie_insere_registro_w := 'S';
			end if;

			if (coalesce(OLD.cd_cep,'0') <> coalesce(NEW.cd_cep,'0')) then
				ie_insere_registro_w := 'S';
			end if;

			if (ie_insere_registro_w	= 'S') then
				BEGIN
				insert into pls_segurado_alteracao(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						nr_seq_segurado)
				values (	nextval('pls_segurado_alteracao_seq'),trunc(LOCALTIMESTAMP,'dd'),NEW.nm_usuario,trunc(LOCALTIMESTAMP,'dd'),NEW.nm_usuario,
						nr_seq_segurado_w);
				exception
				when others then
					ie_insere_registro_w	:= 'N';
				end;

			end if;
		end if;
	end if;
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_compl_pessoa_fisica_update() FROM PUBLIC;

CREATE TRIGGER pls_compl_pessoa_fisica_update
	AFTER INSERT OR UPDATE ON compl_pessoa_fisica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_compl_pessoa_fisica_update();

