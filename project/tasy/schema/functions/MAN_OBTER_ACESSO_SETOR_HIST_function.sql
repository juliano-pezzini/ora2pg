-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_acesso_setor_hist ( nr_seq_historico_p bigint, cd_setor_p bigint, ie_visualiza_inclui_p text default 'V', nm_usuario_p text default null) RETURNS varchar AS $body$
DECLARE


/*ie_visualiza_inclui_p
I - Incluindo
V - Visualizando
*/
ds_retorno_w			varchar(1)	:= 'S';
nr_seq_tipo_w			bigint;
cd_cargo_w			bigint	:= 0;
nr_seq_grupo_des_w		bigint;
nm_usuario_w			varchar(15);
ie_subst_analista_desenv_w		varchar(15);

c01 CURSOR FOR
	SELECT	ie_visualiza
	from	man_tipo_hist_setor
	where	nr_seq_tipo_hist = nr_seq_tipo_w
	and	coalesce(cd_setor_atendimento,cd_setor_p) = cd_setor_p
	and	coalesce(cd_cargo,coalesce(cd_cargo_w,0))	= coalesce(cd_cargo_w,0)
	and	coalesce(nm_usuario_regra,coalesce(nm_usuario_w,'X')) = coalesce(nm_usuario_w,'X')
	order by nm_usuario_regra desc,
		cd_cargo desc,
		cd_setor_atendimento desc,
		nr_sequencia;


BEGIN

nr_seq_tipo_w	:= nr_seq_historico_p;

if (nr_seq_tipo_w > 0) then
	begin
	nm_usuario_w	:= coalesce(nm_usuario_p,wheb_usuario_pck.get_nm_usuario);

	begin
	cd_cargo_w	:= (Obter_Dados_Usuario_Opcao(nm_usuario_w,'R'))::numeric;
	exception when others then
		cd_cargo_w	:= 0;
	end;

	if (user = 'CORP') then
		select	max(nr_seq_grupo)
		into STRICT	nr_seq_grupo_des_w
		from	usuario_grupo_des a,
		grupo_desenvolvimento b
		where	nm_usuario_grupo = nm_usuario_w
		and a.nr_seq_grupo = b.nr_sequencia
		and b.ie_situacao = 'A';


		select	coalesce(substr(des_obter_se_usuario_substit(nm_usuario_w, nr_seq_grupo_des_w, clock_timestamp()),1,1),'N')
		into STRICT	ie_subst_analista_desenv_w
		;

		if (ie_subst_analista_desenv_w = 'S') then
			cd_cargo_w	:= 221; /*Analista de sistemas JR*/
		end if;
	end if;

	open C01;
	loop
	fetch C01 into
		ds_retorno_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	end;
end if;

if (ds_retorno_w = 'V') and (ie_visualiza_inclui_p = 'I') then
	ds_retorno_w := 'N';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_acesso_setor_hist ( nr_seq_historico_p bigint, cd_setor_p bigint, ie_visualiza_inclui_p text default 'V', nm_usuario_p text default null) FROM PUBLIC;
