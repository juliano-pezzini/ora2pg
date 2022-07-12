-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION obter_saldo_disp_estoque_pck.get_ie_baixa_disp (cd_local_estoque_p bigint) RETURNS varchar AS $body$
BEGIN
	/*'Restrição para não buscar os dados do mesmo local de estoque novamente (caso seja igual ao último a ser consultado)'*/

	if (current_setting('obter_saldo_disp_estoque_pck.cd_local_estoque_w')::local_estoque.cd_local_estoque%coalesce(type::text, '') = '') or (coalesce(cd_local_estoque_p::text, '') = '') or (current_setting('obter_saldo_disp_estoque_pck.cd_local_estoque_w')::local_estoque.cd_local_estoque%type <> cd_local_estoque_p) then
		begin
		PERFORM set_config('obter_saldo_disp_estoque_pck.cd_local_estoque_w', cd_local_estoque_p, false);

		begin
		select	'S'
		into STRICT	current_setting('obter_saldo_disp_estoque_pck.ie_baixa_disp_w')::local_estoque.ie_baixa_disp%type
		from	local_estoque
		where	cd_estabelecimento = current_setting('obter_saldo_disp_estoque_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type
		and	cd_local_estoque = cd_local_estoque_p
		and	((ie_baixa_disp = 'S') or (ie_tipo_local = '2'));
		exception
		when others then
			begin
			if (cd_local_estoque_p > 0) then
				PERFORM set_config('obter_saldo_disp_estoque_pck.ie_baixa_disp_w', 'N', false);
			else
				PERFORM set_config('obter_saldo_disp_estoque_pck.ie_baixa_disp_w', 'S', false);
			end if;
			end;
		end;
		end;
	end if;

	return current_setting('obter_saldo_disp_estoque_pck.ie_baixa_disp_w')::local_estoque.ie_baixa_disp%type;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_disp_estoque_pck.get_ie_baixa_disp (cd_local_estoque_p bigint) FROM PUBLIC;