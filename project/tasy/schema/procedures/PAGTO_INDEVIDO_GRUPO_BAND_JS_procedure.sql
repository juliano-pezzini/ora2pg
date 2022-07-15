-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pagto_indevido_grupo_band_js ( nr_sequencia_p bigint, ie_pag_indevido_p text) AS $body$
BEGIN

/* Se a opção de menu for Marcar como pagamento indevido*/

if (ie_pag_indevido_p = 'S') then
	begin
	update  extrato_cartao_cr_movto
	set     ie_pagto_indevido   	= 'S'
	where   nr_sequencia 		= nr_sequencia_p;

	CALL desconciliar_movto_redecard(nr_sequencia_p);
	end;
/* Senão a opção de menu for Desmarcar pagamento indevido*/

else
	begin
	update  extrato_cartao_cr_movto
	set     ie_pagto_indevido   	= 'N'
	where   nr_sequencia 		= nr_sequencia_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pagto_indevido_grupo_band_js ( nr_sequencia_p bigint, ie_pag_indevido_p text) FROM PUBLIC;

