-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_del_ecf_valor_contabil ( cd_estabelecimento_p bigint, nr_seq_lote_p bigint) AS $body$
BEGIN
	
	delete from fis_ecf_valor_contabil_w
	where cd_estabelecimento = cd_estabelecimento_p
	and nr_seq_lote = nr_seq_lote_p;
					
	commit;
							
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_del_ecf_valor_contabil ( cd_estabelecimento_p bigint, nr_seq_lote_p bigint) FROM PUBLIC;
