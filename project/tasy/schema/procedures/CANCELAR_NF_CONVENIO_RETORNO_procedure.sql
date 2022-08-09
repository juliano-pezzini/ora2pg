-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_nf_convenio_retorno (nr_seq_retorno_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_nota_fiscal_w	bigint;

c01 CURSOR FOR 
SELECT	a.nr_seq_nota_fiscal 
from	convenio_retorno_nf a 
where	a.nr_seq_retorno	= nr_seq_retorno_p;


BEGIN 
 
open	c01;
loop 
fetch	c01 into 
	nr_seq_nota_fiscal_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	CALL cancelar_nf(nr_seq_nota_fiscal_w,nm_usuario_p);
 
end	loop;
close	c01;
 
delete	from convenio_retorno_nf 
where	nr_seq_retorno		= nr_seq_retorno_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_nf_convenio_retorno (nr_seq_retorno_p bigint, nm_usuario_p text) FROM PUBLIC;
