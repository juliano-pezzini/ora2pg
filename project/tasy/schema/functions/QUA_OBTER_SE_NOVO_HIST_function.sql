-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_novo_hist ( nr_seq_nao_conform_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_novo_historico_w			char(1) := 'N';
dt_acesso_w					timestamp;
dt_historico_w				timestamp;
qt_existe_hist_w			integer;
qt_existe_usuario_w			integer;
ie_consid_hist_sistema_w	varchar(01);


BEGIN
/*Nao existe novo historico*/

ie_consid_hist_sistema_w := obter_param_usuario(4000, 266, obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_consid_hist_sistema_w);

select	coalesce(max('S'),'N')
into STRICT	ie_novo_historico_w
from	qua_nao_conform_hist where		nr_seq_nao_conform	= nr_seq_nao_conform_p
and		((ie_origem = 'U' and ie_consid_hist_sistema_w = 'N') or (ie_consid_hist_sistema_w = 'S')) LIMIT 1;

if (ie_novo_historico_w = 'S') then
	begin
	select	coalesce(max('N'),'S')
	into STRICT	ie_novo_historico_w
	from	qua_nao_conform_leitura where		nr_seq_nao_conform	= nr_seq_nao_conform_p
	and		nm_usuario_acesso	= nm_usuario_p LIMIT 1;

	if (ie_novo_historico_w = 'N') then
		begin
		select	max(dt_acesso)
		into STRICT	dt_acesso_w
		from	qua_nao_conform_leitura
		where	nr_seq_nao_conform	= nr_seq_nao_conform_p
		and		nm_usuario_acesso	= nm_usuario_p;

		select	max(dt_historico)
		into STRICT	dt_historico_w
		from	qua_nao_conform_hist
		where	nr_seq_nao_conform	= nr_seq_nao_conform_p
		and		((ie_origem = 'U' and ie_consid_hist_sistema_w = 'N') or (ie_consid_hist_sistema_w = 'S'))
		and		nm_usuario <> nm_usuario_p;

		if (coalesce(dt_acesso_w::text, '') = '') or (dt_acesso_w < dt_historico_w) then
			ie_novo_historico_w	:= 'S';
		end if;
		end;
	end if;
	end;
end if;

return ie_novo_historico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_novo_hist ( nr_seq_nao_conform_p bigint, nm_usuario_p text) FROM PUBLIC;
