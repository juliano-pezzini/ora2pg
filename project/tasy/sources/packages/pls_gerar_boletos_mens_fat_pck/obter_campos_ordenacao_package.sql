-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerar_boletos_mens_fat_pck.obter_campos_ordenacao (ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


	ds_retorno_w		varchar(4000);
	ie_informacao_w		pls_regra_bol_ordem_atrib.ie_informacao%type;
	ie_tipo_ordenacao_w	pls_regra_bol_ordem_atrib.ie_tipo_ordenacao%type;
	ds_tipo_ordenacao_w	varchar(20);

	c01 CURSOR FOR
		SELECT	ie_informacao,
			CASE WHEN coalesce(ie_tipo_ordenacao,'A')='A' THEN '' WHEN coalesce(ie_tipo_ordenacao,'A')='D' THEN 'desc' END
		from	pls_regra_bol_ordem_atrib
		where	nr_seq_regra	= nr_seq_regra_ordenacao_w
		order by nr_ordem;

	
BEGIN

	ds_retorno_w	:= 'order by ';

	open C01;
	loop
	fetch C01 into
		ie_informacao_w,
		ds_tipo_ordenacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (ie_informacao_w = 'CEP') THEN
			if (ie_tipo_p = 'C') then
				ds_retorno_w	:= ds_retorno_w|| ' b.cd_cep ' || ds_tipo_ordenacao_w||', ';
			elsif (ie_tipo_p = 'D') then
				ds_retorno_w	:= ds_retorno_w|| ' CEP ' || ds_tipo_ordenacao_w||', ';
			end if;
		elsif (ie_informacao_w = 'PAG') THEN
			if (ie_tipo_p = 'C') then
				ds_retorno_w	:= ds_retorno_w|| ' a.nm_pagador ' || ds_tipo_ordenacao_w||', ';
			elsif (ie_tipo_p = 'D') then
				ds_retorno_w	:= ds_retorno_w|| ' NOME PAGADOR ' || ds_tipo_ordenacao_w||', ';
			end if;
		elsif (ie_informacao_w = 'TIT') THEN
			if (ie_tipo_p = 'C') then
				ds_retorno_w	:= ds_retorno_w|| ' a.nr_titulo ' || ds_tipo_ordenacao_w||', ';
			elsif (ie_tipo_p = 'D') then
				ds_retorno_w	:= ds_retorno_w|| ' TÍTULO ' || ds_tipo_ordenacao_w||', ';
			end if;
		end if;

		end;
	end loop;
	close C01;

	ds_retorno_w	:= substr(ds_retorno_w,1,length(ds_retorno_w) -2);

	if (length(ds_retorno_w) > 10) then
		return ds_retorno_w;
	else
		return '';
	end if;

	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_gerar_boletos_mens_fat_pck.obter_campos_ordenacao (ie_tipo_p text) FROM PUBLIC;
