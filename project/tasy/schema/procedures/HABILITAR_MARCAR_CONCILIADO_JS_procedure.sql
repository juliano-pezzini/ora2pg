-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE habilitar_marcar_conciliado_js ( nr_sequencia_p bigint, qt_reg_cons_01_p INOUT bigint, qt_reg_cons_02_p INOUT bigint, qt_reg_cons_03_p INOUT bigint) AS $body$
DECLARE


qt_reg_cons_01_w	bigint := 0;
qt_reg_cons_02_w	bigint := 0;
qt_reg_cons_03_w	bigint := 0;

/* Procedure criada para retornar os valores das consultas, para habilitação da opção de menu marcar_conciliado_mi
Pasta Grupo Bandeiras */
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	-- Consulta 01
	select 	count(*)
	into STRICT 	qt_reg_cons_01_w
	from 	extrato_cartao_cr_movto 
	where 	nr_seq_extrato_arq = nr_sequencia_p;
	
	-- Consulta 02
	select	count(*)
	into STRICT	qt_reg_cons_02_w
	from	extrato_cartao_cr_movto 
	where	nr_seq_extrato_arq = nr_sequencia_p 
	and	((vl_saldo_concil_fin = 0)  
	or (ie_pagto_indevido = 'S'));
	
	-- Consulta 03
	select 	count(*)
	into STRICT 	qt_reg_cons_03_w
	from 	extrato_cartao_cr_movto a 
	where 	nr_seq_extrato_arq = nr_sequencia_p
	and 	obter_se_parcela_cartao_concil(nr_sequencia,null) = 'N';
	end;
end if;
qt_reg_cons_01_p := qt_reg_cons_01_w;
qt_reg_cons_02_p := qt_reg_cons_02_w;
qt_reg_cons_03_p := qt_reg_cons_03_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE habilitar_marcar_conciliado_js ( nr_sequencia_p bigint, qt_reg_cons_01_p INOUT bigint, qt_reg_cons_02_p INOUT bigint, qt_reg_cons_03_p INOUT bigint) FROM PUBLIC;

