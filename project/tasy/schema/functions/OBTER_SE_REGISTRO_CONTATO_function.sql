-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_registro_contato ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_tipo_doc_w	bigint;
nr_seq_forma_cont_w 	bigint;
ie_retorno_w		varchar(1);


BEGIN

select	max(nr_seq_forma_contato_soro),
	max(nr_seq_tipo_doc_soro)
into STRICT	nr_seq_forma_cont_w,
	nr_seq_tipo_doc_w
from	san_parametro
where	cd_estabelecimento = cd_estabelecimento_p;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
from	pessoa_fisica_contato
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_registro_contato ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;
