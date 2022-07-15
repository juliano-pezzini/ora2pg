-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_cart_usuario (cd_convenio_p bigint, cd_carteirinha_usuario_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text, dt_validade_carteira_p INOUT timestamp) AS $body$
DECLARE


qt_regras_w			bigint;
cd_carteirinha_usuario_w	varchar(255);
cd_carteirinha_usuario_ww	varchar(255);

ie_regra_w			varchar(1);
qt_pos_inicial_w		bigint;
qt_tamanho_w			bigint;
nr_trilha_w			integer;

dt_aux_w			varchar(20);
ie_controle_w			varchar(3);

C01 CURSOR FOR
	SELECT	qt_tamanho,
		qt_pos_inicial,
		ie_regra,
		nr_trilha
	from 	conv_regra_dados_usuario
	where	cd_convenio = cd_convenio_p
	and 	cd_estabelecimento = cd_estabelecimento_p
	and 	ie_regra = ie_regra_w
	and 	ie_situacao = 'A'
	order by ie_regra;

BEGIN
dt_validade_carteira_p		:= null;
cd_carteirinha_usuario_w	:= cd_carteirinha_usuario_p;
dt_aux_w			:= '';
ie_controle_w			:= '*';

select 	count(*)
into STRICT	qt_regras_w
from 	conv_regra_dados_usuario
where	cd_convenio = cd_convenio_p
and 	cd_estabelecimento = cd_estabelecimento_p
and 	ie_situacao = 'A';

if (qt_regras_w > 0) then
	ie_regra_w:= 'C';-- Carteirinha do usuário
	open C01;
	loop
	fetch C01 into
		qt_tamanho_w,
		qt_pos_inicial_w,
		ie_regra_w,
		nr_trilha_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (obter_funcao_ativa in (916, 10021)) then
			if (coalesce(nr_trilha_w, 0) > 0) then
				cd_carteirinha_usuario_w := replace(cd_carteirinha_usuario_w, '*', chr(13));

				cd_carteirinha_usuario_ww := cd_carteirinha_usuario_w;
				for i in 1..coalesce(nr_trilha_w - 1, 0) loop
					cd_carteirinha_usuario_ww := substr(cd_carteirinha_usuario_ww, (position(chr(13) in cd_carteirinha_usuario_ww)+1), length(cd_carteirinha_usuario_ww));
				end loop;

				cd_carteirinha_usuario_w := coalesce(cd_carteirinha_usuario_ww, cd_carteirinha_usuario_w);
			else
				cd_carteirinha_usuario_w := replace(cd_carteirinha_usuario_w, '*', '');
			end if;
		end if;

		cd_carteirinha_usuario_p := substr(trim(both cd_carteirinha_usuario_w),qt_pos_inicial_w, qt_tamanho_w);
		end;
	end loop;
	close C01;

	ie_regra_w:= 'D'; -- Dia
	open C01;
	loop
	fetch C01 into
		qt_tamanho_w,
		qt_pos_inicial_w,
		ie_regra_w,
		nr_trilha_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ie_controle_w = '*') then
			ie_controle_w:= 'D';
		end if;
		end;
	end loop;
	close C01;

	if (ie_controle_w = 'D') then
		dt_aux_w:= substr(cd_carteirinha_usuario_w,qt_pos_inicial_w, qt_tamanho_w);
	end if;


	ie_regra_w:= 'M'; -- Mês
	open C01;
	loop
	fetch C01 into
		qt_tamanho_w,
		qt_pos_inicial_w,
		ie_regra_w,
		nr_trilha_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ie_controle_w = 'D') then
			ie_controle_w:= ie_controle_w || ie_regra_w;
		end if;
		end;
	end loop;
	close C01;

	if (ie_controle_w = 'DM') then
		dt_aux_w:= dt_aux_w || substr(cd_carteirinha_usuario_w,qt_pos_inicial_w, qt_tamanho_w);
	end if;

	ie_regra_w:= 'A'; --Ano
	open C01;
	loop
	fetch C01 into
		qt_tamanho_w,
		qt_pos_inicial_w,
		ie_regra_w,
		nr_trilha_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ie_controle_w = 'DM') then
			ie_controle_w:= ie_controle_w || ie_regra_w;
		end if;
		end;
	end loop;
	close C01;

	if (ie_controle_w = 'DMA') then
		dt_aux_w:= dt_aux_w || substr(cd_carteirinha_usuario_w,qt_pos_inicial_w, qt_tamanho_w);

		begin
		dt_validade_carteira_p:= to_date(dt_aux_w);
		exception
			when others then
			dt_validade_carteira_p:= null;
		end;
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_cart_usuario (cd_convenio_p bigint, cd_carteirinha_usuario_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text, dt_validade_carteira_p INOUT timestamp) FROM PUBLIC;

