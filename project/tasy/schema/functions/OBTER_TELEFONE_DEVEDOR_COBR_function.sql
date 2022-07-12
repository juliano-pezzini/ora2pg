-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_telefone_devedor_cobr (nr_titulo_p bigint, nr_seq_cheque_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_telefone_w	varchar(254);


BEGIN 
ds_telefone_w := '';
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then 
	select	OBTER_DADOS_PF_PJ(CD_PESSOA_FISICA, CD_CGC, 'T') 
	into STRICT	ds_telefone_w 
	from	TITULO_RECEBER 
	where	nr_titulo = nr_titulo_p;
elsif (nr_seq_cheque_p IS NOT NULL AND nr_seq_cheque_p::text <> '') then 
	select	OBTER_DADOS_PF_PJ(CD_PESSOA_FISICA, CD_CGC, 'T') 
	into STRICT	ds_telefone_w 
	from	cheque_cr 
	where	nr_seq_cheque = nr_seq_cheque_p;
end if;
return ds_telefone_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_telefone_devedor_cobr (nr_titulo_p bigint, nr_seq_cheque_p bigint) FROM PUBLIC;

