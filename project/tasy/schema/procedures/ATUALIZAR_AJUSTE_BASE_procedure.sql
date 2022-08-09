-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_ajuste_base ( cd_ajuste_base_p bigint, nm_tabela_p text, ie_tipo_objeto_p text, nm_objeto_p text, ds_script_p text, dt_atualizacao_p timestamp, nm_usuario_p text, ie_regra_tabela_p text, ie_acompanhamento_p text) AS $body$
DECLARE

qt_reg_w	bigint;

BEGIN

select	count(*)
into STRICT	qt_reg_w
from	TASY_AJUSTE_BASE
where	cd_ajuste_base	= cd_ajuste_base_p;

if (qt_reg_w = 0 ) then
	insert into tasy_ajuste_base(	cd_ajuste_base,
					nm_tabela,
					ie_tipo_objeto,
					nm_objeto,
					ds_script,
					dt_atualizacao,
					nm_usuario,
					ie_regra_tabela,
					ie_acompanhamento)
			values (	cd_ajuste_base_p,
					nm_tabela_p,
                                        ie_tipo_objeto_p,
					nm_objeto_p,
                                        ds_script_p,
                                        dt_atualizacao_p,
                                        nm_usuario_p,
					ie_regra_tabela_p,
					ie_acompanhamento_p);


else
	update	tasy_ajuste_base
	set	nm_tabela		= nm_tabela_p,
		ie_tipo_objeto		= ie_tipo_objeto_p,
		nm_objeto		= nm_objeto_p,
		ds_script		= ds_script_p,
		dt_atualizacao		= dt_atualizacao_p,
		nm_usuario		= nm_usuario_p,
		ie_regra_tabela		= ie_regra_tabela_p,
		ie_acompanhamento	= ie_acompanhamento_p
	where	cd_ajuste_base = cd_ajuste_base_p;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_ajuste_base ( cd_ajuste_base_p bigint, nm_tabela_p text, ie_tipo_objeto_p text, nm_objeto_p text, ds_script_p text, dt_atualizacao_p timestamp, nm_usuario_p text, ie_regra_tabela_p text, ie_acompanhamento_p text) FROM PUBLIC;
