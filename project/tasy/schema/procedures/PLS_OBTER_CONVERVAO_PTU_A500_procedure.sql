-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_convervao_ptu_a500 ( nm_campo_conversao_p pls_conversao_ptu.nm_campo%type, ds_valor_original_p pls_conversao_ptu.ds_valor_original%type, ds_valor_convertido_p INOUT pls_conversao_ptu.ds_valor_convertido%type, cd_estabelecimento_p bigint) AS $body$
DECLARE


ds_valor_original_w		pls_conversao_ptu.ds_valor_original%type;
ds_valor_convertido_w		pls_conversao_ptu.ds_valor_convertido%type;
ds_valor_convertido_aux_w	pls_conversao_ptu.ds_valor_convertido%type;


BEGIN

ds_valor_original_w		:= upper(ds_valor_original_p);
ds_valor_convertido_aux_w	:= ds_valor_original_p;

select	max(ds_valor_convertido)
into STRICT	ds_valor_convertido_w
from	pls_conversao_ptu
where	nm_campo			= nm_campo_conversao_p
and	upper(ds_valor_original)	= ds_valor_original_w;

if (ds_valor_convertido_w IS NOT NULL AND ds_valor_convertido_w::text <> '') then
	ds_valor_convertido_aux_w	:= ds_valor_convertido_w;
end if;

ds_valor_convertido_p	:= ds_valor_convertido_aux_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_convervao_ptu_a500 ( nm_campo_conversao_p pls_conversao_ptu.nm_campo%type, ds_valor_original_p pls_conversao_ptu.ds_valor_original%type, ds_valor_convertido_p INOUT pls_conversao_ptu.ds_valor_convertido%type, cd_estabelecimento_p bigint) FROM PUBLIC;
