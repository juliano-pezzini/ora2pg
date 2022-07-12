-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION comunic_interna_pck.obter_se_estab_lib_usuario (cd_estab_p bigint) RETURNS varchar AS $body$
DECLARE

ie_achou_w varchar(1) :='N';
BEGIN



if (current_setting('comunic_interna_pck.cd_estabelecimento_atual_w')::estabelecimento.cd_estabelecimento%type <> coalesce(current_setting('comunic_interna_pck.cd_estabelecimento_ant_w')::estabelecimento.cd_estabelecimento%type,0)) then
	PERFORM set_config('comunic_interna_pck.ie_carregar_estab_adic_w', true, false);

	if (current_setting('comunic_interna_pck.estabelecimentos_usuario_w')::Vetor.count <> 0) then
		current_setting('comunic_interna_pck.estabelecimentos_usuario_w')::Vetor.delete;
	end if;

end if;


if ( current_setting('comunic_interna_pck.ie_carregar_estab_adic_w')::boolean ) and ( current_setting('comunic_interna_pck.estabelecimentos_usuario_w')::Vetor.count = 0 ) then
	CALL CALL comunic_interna_pck.carregar_estab_usuario();
	PERFORM set_config('comunic_interna_pck.ie_carregar_estab_adic_w', false, false);
end if;

for j in 1..estabelecimentos_usuario_w.count loop
	if (current_setting('comunic_interna_pck.estabelecimentos_usuario_w')::Vetor[j].cd_estabelecimento = cd_estab_p) then
		ie_achou_w := 'S';
	end if;
end loop;
return ie_achou_w;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION comunic_interna_pck.obter_se_estab_lib_usuario (cd_estab_p bigint) FROM PUBLIC;
