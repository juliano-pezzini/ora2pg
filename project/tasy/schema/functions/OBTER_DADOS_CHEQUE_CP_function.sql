-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cheque_cp (nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/* 
ie_opcao_p		"DS" dados do cheque 
			"E" emitente do cheque 
			"V" valor do cheque 
			"DTC" Data de conciliação 
			"P" Pessoa 
			"F" Fornecedor 
			"N" Nº do cheque 
			"BC" Banco / Conta 
*/
 
 
ds_resultado_w		varchar(254);

 

BEGIN 
 
ds_resultado_w		:= '';
 
if (coalesce(nr_sequencia_p,0) <> 0) then 
	if (Upper(ie_opcao_p) = 'DS') then 
		select	max(nr_cheque || ' - ' || DS_BANCO) 
		into STRICT	ds_resultado_w 
		from	cheque_v 
		where	nr_sequencia	= nr_sequencia_p;
	elsif (upper(ie_opcao_p) = 'E') then 
		select	max(ds_emitente) 
		into STRICT	ds_resultado_w 
		from	cheque_v 
		where	nr_sequencia	= nr_sequencia_p;
	elsif (upper(ie_opcao_p) = 'V') then 
		select	max(vl_cheque) 
		into STRICT	ds_resultado_w 
		from	cheque_v 
		where	nr_sequencia	= nr_sequencia_p;
	elsif (upper(ie_opcao_p) = 'N') then 
		select	max(nr_cheque) 
		into STRICT	ds_resultado_w 
		from	cheque_v 
		where	nr_sequencia	= nr_sequencia_p;
	elsif (upper(ie_opcao_p) = 'P') then 
		select	max(substr(obter_nome_pessoa_fisica(cd_pessoa_destinatario, null),1,80)) 
		into STRICT	ds_resultado_w 
		from	cheque_v 
		where	nr_sequencia	= nr_sequencia_p;
	elsif (upper(ie_opcao_p) = 'F') then 
		select	max(substr(obter_razao_social(cd_cgc_destinatario),1,80)) 
		into STRICT	ds_resultado_w 
		from	cheque_v 
		where	nr_sequencia	= nr_sequencia_p;
	elsif (upper(ie_opcao_p) = 'DTC') then 
		select	max(c.dt_movimento) 
		into STRICT	ds_resultado_w 
		from	banco_extrato_lanc c, 
			movto_trans_financ b 
		where	b.nr_seq_cheque_cp	= nr_sequencia_p 
		and	b.nr_seq_concil	= c.nr_seq_concil;
	elsif (upper(ie_opcao_p) = 'BC') then 
		select	ds_banco || ' / ' || cd_conta 
		into STRICT	ds_resultado_w 
		from	cheque_v 
		where	nr_sequencia	= nr_sequencia_p;
	end if;
 
end if;
 
return ds_resultado_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cheque_cp (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
