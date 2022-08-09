-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_senha_guia_conta ( cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_tipo_atendimento_p bigint, ie_doc_autorizacao_p INOUT text, ie_atualiza_guia_p INOUT text, ie_atualiza_senha_p INOUT text, ie_autor_qtde_p INOUT text) AS $body$
DECLARE


ie_doc_autorizacao_w 	varchar(2) := 'N';
ie_atualiza_guia_w 	varchar(1) := 'S';
ie_atualiza_senha_w 	varchar(1) := 'S';
ie_autor_qtde_w 	varchar(1) := 'N';

c01 CURSOR FOR
SELECT 	ie_doc_autorizacao,
	ie_atualiza_guia,
	ie_atualiza_senha,
	ie_autor_qtde
from 	regra_guia_senha_autor
where 	coalesce(cd_convenio, coalesce(cd_convenio_p, 0))			= coalesce(cd_convenio_p,0)
and 	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0))	= coalesce(ie_tipo_atendimento_p,0)
and 	cd_estabelecimento = cd_estabelecimento_p
order by cd_convenio desc, ie_tipo_atendimento desc;


BEGIN

select 	coalesce(max(ie_doc_autorizacao), 'N')
into STRICT 	ie_doc_autorizacao_w
from 	convenio_estabelecimento
where	cd_convenio		= cd_convenio_p
and	cd_estabelecimento	= cd_estabelecimento_p;

open c01;
loop
fetch c01 into 	ie_doc_autorizacao_w,
		ie_atualiza_guia_w,
		ie_atualiza_senha_w,
		ie_autor_qtde_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

ie_doc_autorizacao_p	:= ie_doc_autorizacao_w;
ie_atualiza_guia_p	:= ie_atualiza_guia_w;
ie_atualiza_senha_p	:= ie_atualiza_senha_w;
ie_autor_qtde_p		:= ie_autor_qtde_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_senha_guia_conta ( cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_tipo_atendimento_p bigint, ie_doc_autorizacao_p INOUT text, ie_atualiza_guia_p INOUT text, ie_atualiza_senha_p INOUT text, ie_autor_qtde_p INOUT text) FROM PUBLIC;
