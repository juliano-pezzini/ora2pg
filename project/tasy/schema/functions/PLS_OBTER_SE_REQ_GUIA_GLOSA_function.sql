-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_req_guia_glosa ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, ie_tipo_item_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(2)	:= 'N';
qt_glosa_guia_w			bigint;
qt_glosa_req_w			bigint;


BEGIN

if (ie_tipo_item_p = 7) then
	select	count(1)
	into STRICT	qt_glosa_guia_w
	from	pls_guia_glosa
	where	nr_seq_guia		= nr_seq_guia_p
	and	(nr_seq_ocorrencia IS NOT NULL AND nr_seq_ocorrencia::text <> '');

	if (qt_glosa_guia_w	> 0) then
		ie_retorno_w	:= 'S';
	end if;

elsif (ie_tipo_item_p = 9) then
	select	count(1)
	into STRICT	qt_glosa_req_w
	from	pls_requisicao_glosa
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	(nr_seq_ocorrencia IS NOT NULL AND nr_seq_ocorrencia::text <> '');

	if (qt_glosa_req_w		> 0) then
		ie_retorno_w	:= 'S';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_req_guia_glosa ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, ie_tipo_item_p bigint) FROM PUBLIC;
