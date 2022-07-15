-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_pf_codigo_externo ( ie_tipo_codigo_externo_p text, cd_pessoa_fisica_p text, cd_pessoa_fisica_externo_p text, nm_usuario_p text, cd_login_ext_p text, ds_senha_ext_p text) AS $body$
DECLARE


cd_pessoa_fisica_externo_w	varchar(20);
cd_estabelecimento_w estabelecimento.cd_estabelecimento%type;
				

BEGIN

if (ie_tipo_codigo_externo_p not in ('FD', 'FL')) then
  select wheb_usuario_pck.get_cd_estabelecimento
  into STRICT cd_estabelecimento_w
;
end if;

select	max(cd_pessoa_fisica_externo)
into STRICT	cd_pessoa_fisica_externo_w	
from	pf_codigo_externo
where 	cd_pessoa_fisica = cd_pessoa_fisica_p
and		coalesce(ie_tipo_codigo_externo, ie_tipo_codigo_externo_p) = ie_tipo_codigo_externo_p
and (coalesce(cd_estabelecimento,cd_estabelecimento_w, 0) = coalesce(cd_estabelecimento_w, cd_estabelecimento, 0));

if (coalesce(cd_pessoa_fisica_externo_w::text, '') = '') then

	insert into	pf_codigo_externo(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_tipo_codigo_externo,
			cd_pessoa_fisica,
			cd_pessoa_fisica_externo,
			cd_login_ext,
			ds_senha_ext,
			cd_estabelecimento
			)
		values (
			nextval('pf_codigo_externo_seq'),
			clock_timestamp(),
			substr('FWS-'||nm_usuario_p,1,15),
			clock_timestamp(),
			substr('FWS-'||nm_usuario_p,1,15),
			ie_tipo_codigo_externo_p,
			cd_pessoa_fisica_p,
			cd_pessoa_fisica_externo_p,
			cd_login_ext_p,
			ds_senha_ext_p,
			cd_estabelecimento_w
			);
			
elsif (cd_pessoa_fisica_externo_w <> cd_pessoa_fisica_externo_p) then

	update	pf_codigo_externo
	set		cd_pessoa_fisica_externo = cd_pessoa_fisica_externo_p,
			nm_usuario = substr('FWS-'||nm_usuario_p,1,15),
			dt_atualizacao = clock_timestamp()
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and		coalesce(ie_tipo_codigo_externo, ie_tipo_codigo_externo_p) = ie_tipo_codigo_externo_p
	and (coalesce(cd_estabelecimento,cd_estabelecimento_w, 0) = coalesce(cd_estabelecimento_w, cd_estabelecimento, 0));

end if;
	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_pf_codigo_externo ( ie_tipo_codigo_externo_p text, cd_pessoa_fisica_p text, cd_pessoa_fisica_externo_p text, nm_usuario_p text, cd_login_ext_p text, ds_senha_ext_p text) FROM PUBLIC;

