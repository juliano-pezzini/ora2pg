-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE imp_extrato_004_js ( vl_extrato_p bigint, nr_sequencia_p bigint, ie_deb_cred_p text) AS $body$
BEGIN
update 	banco_extrato
set 	vl_saldo_inicial = vl_saldo_inicial + ((vl_extrato_p / 100) * CASE WHEN ie_deb_cred_p='C' THEN  1  ELSE -1 END )
where 	nr_sequencia = nr_sequencia_p;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE imp_extrato_004_js ( vl_extrato_p bigint, nr_sequencia_p bigint, ie_deb_cred_p text) FROM PUBLIC;

