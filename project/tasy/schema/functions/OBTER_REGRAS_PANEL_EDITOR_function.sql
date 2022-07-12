-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regras_panel_editor ( nm_tabela_p configuracao_panel_editor.nm_tabela%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);
count_w	integer	:= 0;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from		configuracao_panel_editor
	where	nm_tabela = nm_tabela_p
	and		cd_perfil = cd_perfil_p
	and		cd_estabelecimento	= cd_estabelecimento_p
	and 		coalesce(nm_usuario_config::text, '') = '';

c01_w		c01%rowtype;

c02 CURSOR FOR
	SELECT	nr_sequencia
	from		configuracao_panel_editor
	where	nm_tabela = nm_tabela_p
	and		cd_perfil = cd_perfil_p
	and		coalesce(cd_estabelecimento::text, '') = ''
	and 		coalesce(nm_usuario_config::text, '') = '';

c02_w		c02%rowtype;

c03 CURSOR FOR
	SELECT	nr_sequencia
	from		configuracao_panel_editor
	where	nm_tabela = nm_tabela_p
	and		cd_estabelecimento	= cd_estabelecimento_p
	and		coalesce(cd_perfil::text, '') = ''
	and 		coalesce(nm_usuario_config::text, '') = '';

c03_w		c03%rowtype;

c04 CURSOR FOR
	SELECT	nr_sequencia
	from		configuracao_panel_editor
	where	nm_tabela = nm_tabela_p
	and		coalesce(cd_estabelecimento::text, '') = ''
	and		coalesce(cd_perfil::text, '') = ''
	and 		coalesce(nm_usuario_config::text, '') = '';

c04_w		c04%rowtype;


BEGIN

select	count(*)
into STRICT		count_w
from		configuracao_panel_editor
where	nm_tabela = nm_tabela_p;

if (count_w > 0) then
	open c01;
	loop
	fetch c01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			if (coalesce(ds_retorno_w, 'X') <> 'X') then
				ds_retorno_w	:= ds_retorno_w || ',';
			end if;
			ds_retorno_w	:= ds_retorno_w || c01_w.nr_sequencia;
		end;
	end loop;
	close c01;

	if (coalesce(ds_retorno_w, 'X') = 'X') then
		open c02;
		loop
		fetch c02 into
			c02_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
				if (coalesce(ds_retorno_w, 'X') <> 'X') then
					ds_retorno_w	:= ds_retorno_w || ',';
				end if;
				ds_retorno_w	:= ds_retorno_w || c02_w.nr_sequencia;
			end;
		end loop;
		close c02;
		
		if (coalesce(ds_retorno_w, 'X') = 'X') then
			open c03;
			loop
			fetch c03 into
				c03_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin
					if (coalesce(ds_retorno_w, 'X') <> 'X') then
						ds_retorno_w	:= ds_retorno_w || ',';
					end if;
					ds_retorno_w	:= ds_retorno_w || c03_w.nr_sequencia;
				end;
			end loop;
			close c03;
		end if;
		
		if (coalesce(ds_retorno_w, 'X') = 'X') then
			open c04;
			loop
			fetch c04 into
				c04_w;
			EXIT WHEN NOT FOUND; /* apply on c04 */
				begin
					if (coalesce(ds_retorno_w, 'X') <> 'X') then
						ds_retorno_w	:= ds_retorno_w || ',';
					end if;
					ds_retorno_w	:= ds_retorno_w || c04_w.nr_sequencia;
				end;
			end loop;
			close c04;
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regras_panel_editor ( nm_tabela_p configuracao_panel_editor.nm_tabela%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type) FROM PUBLIC;

