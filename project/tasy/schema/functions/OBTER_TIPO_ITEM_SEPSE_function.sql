-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_item_sepse (nr_seq_atributo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_tipo_w	varchar(255);
ie_versao_w varchar(1);


BEGIN

select	max(ie_tipo), max(ie_versao)
into STRICT	ds_tipo_w, ie_versao_w
from	sepse_atributo
where	nr_sequencia = nr_seq_atributo_p;

if (ie_opcao_p = 'DS') then
	select	max(CASE WHEN ds_tipo_w='S' THEN 				CASE WHEN ie_versao_w='2' THEN obter_desc_expressao(924719,'Critério SIRS para Sepse')  ELSE obter_desc_expressao(757662,'Sinal de alerta para sepse') END  WHEN ds_tipo_w='G' THEN obter_desc_expressao(757666,'Sinal de disfunção orgânica') WHEN ds_tipo_w='A' THEN obter_desc_expressao(308326,'Ambos') END )
	into STRICT	ds_tipo_w
	;
end if;

return	ds_tipo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_item_sepse (nr_seq_atributo_p bigint, ie_opcao_p text) FROM PUBLIC;
