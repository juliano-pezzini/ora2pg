-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_dados_prop_pagador (cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_dia_venc_p bigint, cd_estabelecimento_p text, ds_email_p INOUT text, dt_dia_vencimento_p INOUT bigint) AS $body$
BEGIN
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') or (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then 
	select	obter_dados_pf_pj_estab(cd_estabelecimento_p, cd_pessoa_fisica_p, cd_cgc_p, 'M') 
	into STRICT	ds_email_p 
	;
end if;
 
if (nr_seq_dia_venc_p IS NOT NULL AND nr_seq_dia_venc_p::text <> '') then 
	select	dt_dia_vencimento 
	into STRICT	dt_dia_vencimento_p 
	from	pls_regra_dia_vencimento 
	where	nr_sequencia = nr_seq_dia_venc_p;
else 
	dt_dia_vencimento_p	:= 0;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_dados_prop_pagador (cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_dia_venc_p bigint, cd_estabelecimento_p text, ds_email_p INOUT text, dt_dia_vencimento_p INOUT bigint) FROM PUBLIC;
