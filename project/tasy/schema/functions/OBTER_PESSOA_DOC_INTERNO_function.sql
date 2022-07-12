-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pessoa_doc_interno ( nr_doc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


ie_pessoa_doc_interno_w		varchar(1)	:= 'N';
nm_pessoa_w			varchar(100);
nr_doc_interno_w			varchar(40);


BEGIN

nm_pessoa_w:= '';
ie_pessoa_doc_interno_w := coalesce(Obter_valor_param_usuario(24, 171, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'N');
nr_doc_interno_w := substr(to_char(nr_doc_interno_p),1,40);

if (ie_pessoa_doc_interno_w = 'S') and (coalesce(nr_doc_interno_p,'0') <> '0') then

	select	max(ds_usuario)
	into STRICT	nm_pessoa_w
	from	usuario
	where	(cd_barras IS NOT NULL AND cd_barras::text <> '')
	and	cd_barras = nr_doc_interno_w;

end if;

return nm_pessoa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pessoa_doc_interno ( nr_doc_interno_p bigint) FROM PUBLIC;
