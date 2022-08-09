-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_inclusao_tit_pagar (nr_titulo_p bigint, nm_usuario_p text, ie_baixa_titulo_p text default null) AS $body$
DECLARE


-- ATENCÃO !!! Esta procedure não teve ter COMMIT e não pode chamar procedures que dão COMMIT
tit_w bigint;


BEGIN

CALL gerar_w_tit_pag_imposto(nr_titulo_p, nm_usuario_p, ie_baixa_titulo_p);

select count(*)
into STRICT tit_w
from conta_pagar_lib
where nr_titulo = nr_titulo_p;

if (tit_w = 0) then
	begin
	-- dsantos em 11/01/2012 - para gerar usuarios que precisam liberar o titulo para pagamento.
	CALL GERAR_LIB_CONTAS_PAGAR(	nr_titulo_p,
				851,
				nm_usuario_p,
				'L');

	/* ahoffelder - OS 388850 - 30/01/2012 */

	CALL gerar_lib_titulo_pagar(	nr_titulo_p,
			nm_usuario_p,
			'L');


	exception
	when others then
	null;
	end;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_inclusao_tit_pagar (nr_titulo_p bigint, nm_usuario_p text, ie_baixa_titulo_p text default null) FROM PUBLIC;
