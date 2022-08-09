-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_taxa_tit_receber ( cd_cgc_p text, tx_juros_p INOUT bigint, tx_multa_p INOUT bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

tx_juros_w	double precision;
tx_multa_w	double precision;

BEGIN
if (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
	begin
	tx_juros_w := obter_juros_multa_pf_pj(cd_estabelecimento_p, null, cd_cgc_p, 'J');
	tx_multa_w := obter_juros_multa_pf_pj(cd_estabelecimento_p, null, cd_cgc_p, 'M');
	commit;
	end;
end if;
tx_juros_p	:=	tx_juros_w;
tx_multa_p	:=	tx_multa_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_taxa_tit_receber ( cd_cgc_p text, tx_juros_p INOUT bigint, tx_multa_p INOUT bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
