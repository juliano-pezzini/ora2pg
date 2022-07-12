-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_valor_tit_pag_contr ( nr_titulo_p bigint, nr_contrato_p bigint) RETURNS bigint AS $body$
DECLARE

 
vl_titulo_w			titulo_pagar.vl_titulo%type;
vl_titulo_ww			titulo_pagar.vl_titulo%type := 0;
vl_adiant_w			titulo_pagar.vl_titulo%type;
			

BEGIN 
 
select	vl_titulo 
into STRICT	vl_titulo_w 
from	titulo_pagar 
where	nr_titulo = nr_titulo_p;
 
select coalesce(sum(a.vl_titulo),0) 
into STRICT	vl_adiant_w 
from  titulo_pagar a, 
    solic_compra b 
where  a.nr_solic_compra = b.nr_solic_compra 
and   b.ie_tipo_servico = 'SP' 
and   (a.nr_seq_contrato IS NOT NULL AND a.nr_seq_contrato::text <> '') 
and   a.nr_seq_contrato = nr_contrato_p;
 
 
vl_titulo_ww	:= vl_titulo_w - vl_adiant_w;
 
if (vl_titulo_ww < 0) then 
	vl_titulo_ww := 0;
end if;
 
return	vl_titulo_ww;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_valor_tit_pag_contr ( nr_titulo_p bigint, nr_contrato_p bigint) FROM PUBLIC;

