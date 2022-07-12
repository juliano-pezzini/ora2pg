-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS compl_pessoa_fisica_sib_insert ON compl_pessoa_fisica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_compl_pessoa_fisica_sib_insert() RETURNS trigger AS $BODY$
DECLARE

qt_beneficiarios_plano_w	bigint;
cd_estabelecimento_w		bigint;

/* IE_ATRIBUTO : 

9   - DS_ENDERECO
10 - NR_ENDERECO
11 - DS_BAIRRO
12 - CD_MUNICIPIO_IBGE
13 - SG_ESTADO
14 - CD_CEP
15 - CD_PESSOA_FISICA_REF
16 - NM_CONTATO

*/

BEGIN
  BEGIN

qt_beneficiarios_plano_w	:= 0;
cd_estabelecimento_w		:= wheb_usuario_pck.get_cd_estabelecimento;

if (cd_estabelecimento_w is null) then
	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = coalesce(OLD.cd_pessoa_fisica, NEW.cd_pessoa_fisica);
end if;

--if	(wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then -- OS 1250067 / Unimed Sao Jose do Rio Preto

	if (OLD.nm_usuario is not null) and (cd_estabelecimento_w is not null) then
	
		select	count(1)
		into STRICT	qt_beneficiarios_plano_w
		from	pls_segurado
		where	cd_pessoa_fisica	= OLD.cd_pessoa_fisica
		and	ie_tipo_segurado	in ('A','B','R');
		
		if (qt_beneficiarios_plano_w > 0) then
			if (OLD.ie_tipo_complemento in (1,2)) then -- 1 = Residencial / 2 = Comercial
				--Endereco

				if (coalesce(OLD.ds_endereco,'0') <> coalesce(NEW.ds_endereco,'0')) then
					BEGIN
					insert into PLS_PESSOA_FISICA_SIB(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,cd_pessoa_fisica,dt_ocorrencia_sib,ie_atributo)
					values (	nextval('pls_pessoa_fisica_sib_seq'),LOCALTIMESTAMP,NEW.nm_usuario,LOCALTIMESTAMP,NEW.nm_usuario,
							cd_estabelecimento_w,OLD.cd_pessoa_fisica,ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(LOCALTIMESTAMP),'9');
					exception
					when others then
						cd_estabelecimento_w := cd_estabelecimento_w;
					end;
				end if;
				--Numero do endereco

				if (coalesce(OLD.nr_endereco,'0') <> coalesce(NEW.nr_endereco,'0')) then
					BEGIN
					insert into PLS_PESSOA_FISICA_SIB(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,cd_pessoa_fisica,dt_ocorrencia_sib,ie_atributo)
					values (	nextval('pls_pessoa_fisica_sib_seq'),LOCALTIMESTAMP,NEW.nm_usuario,LOCALTIMESTAMP,NEW.nm_usuario,
							cd_estabelecimento_w,OLD.cd_pessoa_fisica,ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(LOCALTIMESTAMP),'10');
					exception
					when others then
						cd_estabelecimento_w := cd_estabelecimento_w;
					end;
				end if;
				--Bairro

				if (coalesce(OLD.ds_bairro,'0') <> coalesce(NEW.ds_bairro,'0')) then
					BEGIN
					insert into PLS_PESSOA_FISICA_SIB(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,cd_pessoa_fisica,dt_ocorrencia_sib,ie_atributo)
					values (	nextval('pls_pessoa_fisica_sib_seq'),LOCALTIMESTAMP,NEW.nm_usuario,LOCALTIMESTAMP,NEW.nm_usuario,
							cd_estabelecimento_w,OLD.cd_pessoa_fisica,ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(LOCALTIMESTAMP),'11');
					exception
					when others then
						cd_estabelecimento_w := cd_estabelecimento_w;
					end;
				end if;
				--Codigo de IBGE

				if (coalesce(OLD.cd_municipio_ibge,'0') <> coalesce(NEW.cd_municipio_ibge,'0')) then
					BEGIN
					insert into PLS_PESSOA_FISICA_SIB(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,cd_pessoa_fisica,dt_ocorrencia_sib,ie_atributo)
					values (	nextval('pls_pessoa_fisica_sib_seq'),LOCALTIMESTAMP,NEW.nm_usuario,LOCALTIMESTAMP,NEW.nm_usuario,
							cd_estabelecimento_w,OLD.cd_pessoa_fisica,ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(LOCALTIMESTAMP),'12');
					exception
					when others then
						cd_estabelecimento_w := cd_estabelecimento_w;
					end;
				end if;
				--Estado UF

				if (coalesce(OLD.sg_estado,'0') <> coalesce(NEW.sg_estado,'0')) then
					BEGIN
					insert into PLS_PESSOA_FISICA_SIB(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,cd_pessoa_fisica,dt_ocorrencia_sib,ie_atributo)
					values (	nextval('pls_pessoa_fisica_sib_seq'),LOCALTIMESTAMP,NEW.nm_usuario,LOCALTIMESTAMP,NEW.nm_usuario,
							cd_estabelecimento_w,OLD.cd_pessoa_fisica,ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(LOCALTIMESTAMP),'13');
					exception
					when others then
						cd_estabelecimento_w := cd_estabelecimento_w;
					end;
				end if;
				--CEP

				if (coalesce(OLD.cd_cep,'0') <> coalesce(NEW.cd_cep,'0')) then
					BEGIN
					insert into PLS_PESSOA_FISICA_SIB(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,cd_pessoa_fisica,dt_ocorrencia_sib,ie_atributo)
					values (	nextval('pls_pessoa_fisica_sib_seq'),LOCALTIMESTAMP,NEW.nm_usuario,LOCALTIMESTAMP,NEW.nm_usuario,
							cd_estabelecimento_w,OLD.cd_pessoa_fisica,ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(LOCALTIMESTAMP),'14');
					exception
					when others then
						cd_estabelecimento_w := cd_estabelecimento_w;
					end;
				end if;
				--Complemento

				if (coalesce(OLD.ds_complemento,'0') <> coalesce(NEW.ds_complemento,'0')) then
					BEGIN
					insert into PLS_PESSOA_FISICA_SIB(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,cd_pessoa_fisica,dt_ocorrencia_sib,ie_atributo)
					values (	nextval('pls_pessoa_fisica_sib_seq'),LOCALTIMESTAMP,NEW.nm_usuario,LOCALTIMESTAMP,NEW.nm_usuario,
							cd_estabelecimento_w,OLD.cd_pessoa_fisica,ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(LOCALTIMESTAMP),'17');
					exception
					when others then
						cd_estabelecimento_w := cd_estabelecimento_w;
					end;
				end if;
			elsif (OLD.ie_tipo_complemento = 5) then -- 5 = da Mae			
				--Pessoa responsavel

				if (coalesce(OLD.cd_pessoa_fisica_ref,0) <> coalesce(NEW.cd_pessoa_fisica_ref,0)) then
					BEGIN
					insert into PLS_PESSOA_FISICA_SIB(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,cd_pessoa_fisica,dt_ocorrencia_sib,ie_atributo)
					values (	nextval('pls_pessoa_fisica_sib_seq'),LOCALTIMESTAMP,NEW.nm_usuario,LOCALTIMESTAMP,NEW.nm_usuario,
							cd_estabelecimento_w,OLD.cd_pessoa_fisica,ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(LOCALTIMESTAMP),'15');
					exception
					when others then
						cd_estabelecimento_w := cd_estabelecimento_w;
					end;
				end if;
				--Contato

				if (coalesce(OLD.nm_contato,'0') <> coalesce(NEW.nm_contato,'0')) then
					BEGIN
					insert into PLS_PESSOA_FISICA_SIB(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,cd_pessoa_fisica,dt_ocorrencia_sib,ie_atributo)
					values (	nextval('pls_pessoa_fisica_sib_seq'),LOCALTIMESTAMP,NEW.nm_usuario,LOCALTIMESTAMP,NEW.nm_usuario,
							cd_estabelecimento_w,OLD.cd_pessoa_fisica,ESTABLISHMENT_TIMEZONE_UTILS.startOfMonth(LOCALTIMESTAMP),'16');
					exception
					when others then
						cd_estabelecimento_w := cd_estabelecimento_w;
					end;
				end if;				
			end if;
		end if;
	end if;
--end if;


  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_compl_pessoa_fisica_sib_insert() FROM PUBLIC;

CREATE TRIGGER compl_pessoa_fisica_sib_insert
	AFTER INSERT OR UPDATE ON compl_pessoa_fisica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_compl_pessoa_fisica_sib_insert();
