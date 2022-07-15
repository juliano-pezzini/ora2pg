-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_receptor_js ( nr_seq_doador_orgao_p bigint, nr_seq_receptor_p bigint) AS $body$
BEGIN

if (nr_seq_doador_orgao_p IS NOT NULL AND nr_seq_doador_orgao_p::text <> '')	then
	begin

	update  tx_doador_potencial
        set     ie_doador_efetivo    	=	'N'
        where   nr_seq_doador_orgao  	=	nr_seq_doador_orgao_p
	and     nr_seq_receptor      	=	nr_seq_receptor_p;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_receptor_js ( nr_seq_doador_orgao_p bigint, nr_seq_receptor_p bigint) FROM PUBLIC;

