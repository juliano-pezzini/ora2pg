-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_saldo_nf_pag_atend ( nr_sequencia_p bigint, ie_consiste_p INOUT text) AS $body$
DECLARE

 
vl_total_nota_w		double precision;
vl_total_item_w		double precision;
nr_interno_conta_w		bigint;
vl_total_conta_w		double precision;
vl_saldo_w		double precision;
ie_consiste_w		varchar(1) := 'N';


BEGIN 
 
select	nr_interno_conta 
into STRICT	nr_interno_conta_w 
from	conta_paciente_nf_pag 
where	nr_sequencia = nr_sequencia_p;
 
select	coalesce(sum(vl_total_item),0) 
into STRICT	vl_total_item_w 
from	conta_paciente_nf_pag_item 
where	nr_seq_registro = nr_sequencia_p;
 
select	coalesce(obter_valor_conta(nr_interno_conta_w,0),0) 
into STRICT	vl_total_conta_w
;
 
select	coalesce(obter_totais_nf_conta_pagador(nr_interno_conta_w, 0),0) 
into STRICT	vl_total_nota_w
;
 
vl_saldo_w	:= 0;
vl_saldo_w	:= vl_total_conta_w - vl_total_nota_w;
 
if (vl_total_item_w > vl_saldo_w) then 
	ie_consiste_w := 'S';
end if;
 
ie_consiste_p := ie_consiste_w;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_saldo_nf_pag_atend ( nr_sequencia_p bigint, ie_consiste_p INOUT text) FROM PUBLIC;
