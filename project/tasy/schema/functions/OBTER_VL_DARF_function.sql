-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_darf (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

vl_darf_w	varchar(20);


BEGIN 
 
select	substr(wheb_mensagem_pck.get_texto(299361) || campo_mascara_virgula_casas(CASE WHEN sum(obter_valor_darf(b.nr_sequencia)) IS NULL THEN  0  ELSE sum(obter_valor_darf(b.nr_sequencia)) END , 2), 1, 20) 
into STRICT	vl_darf_w 
from	dctf_lote_darf a, 
	darf b 
where	a.nr_seq_darf = b.nr_sequencia 
and	a.nr_seq_lote = nr_sequencia_p;
 
return	vl_darf_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_darf (nr_sequencia_p bigint) FROM PUBLIC;
