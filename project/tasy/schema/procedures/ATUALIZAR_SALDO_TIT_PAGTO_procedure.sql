-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_saldo_tit_pagto (nr_seq_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_titulo_w	bigint;

c01 CURSOR FOR 
SELECT	a.nr_titulo 
from	titulo_pagar_escrit a 
where	a.nr_seq_escrit	= nr_seq_escrit_p;


BEGIN 
 
open	c01;
loop 
fetch	c01 into 
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	CALL atualizar_saldo_tit_pagar(nr_titulo_w,nm_usuario_p);
	CALL Gerar_W_Tit_Pag_imposto(nr_titulo_w,nm_usuario_p);
 
end	loop;
close	c01;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_saldo_tit_pagto (nr_seq_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

