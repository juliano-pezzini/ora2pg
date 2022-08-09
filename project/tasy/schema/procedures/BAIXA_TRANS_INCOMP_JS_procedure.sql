-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_trans_incomp_js ( nr_trans_financ_p bigint, ie_cartao_credito_p INOUT text, ie_cartao_debito_p INOUT text) AS $body$
DECLARE


ie_cartao_credito_w 	varchar(1);
ie_cartao_debito_w		varchar(1);


BEGIN
if (nr_trans_financ_p IS NOT NULL AND nr_trans_financ_p::text <> '') then
	begin
	select	max(ie_cartao_cr),
		max(ie_cartao_debito)
	into STRICT 	ie_cartao_credito_w,
		ie_cartao_debito_w
	from  	transacao_financeira
	where  	nr_sequencia = nr_trans_financ_p;
	end;
end if;
ie_cartao_credito_p	:= ie_cartao_credito_w;
ie_cartao_debito_p	:= ie_cartao_debito_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_trans_incomp_js ( nr_trans_financ_p bigint, ie_cartao_credito_p INOUT text, ie_cartao_debito_p INOUT text) FROM PUBLIC;
