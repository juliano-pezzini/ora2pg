-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validar_se_barras_vinc_titulo (nr_bloqueto_p text, nr_titulo_p bigint) AS $body$
DECLARE


qt_titulo_w		bigint;


BEGIN

select count(*)
into STRICT qt_titulo_w
from (SELECT 1
	from titulo_pagar
	where nr_bloqueto = nr_bloqueto_p
	
union

	SELECT 1
	from banco_escrit_barras
	where nr_titulo	= nr_titulo_p) alias1;

if (qt_titulo_w > 0) then
	-- Este código de barras já está vinculado em outro título
	CALL wheb_mensagem_pck.exibir_mensagem_abort(458581);
end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_se_barras_vinc_titulo (nr_bloqueto_p text, nr_titulo_p bigint) FROM PUBLIC;
