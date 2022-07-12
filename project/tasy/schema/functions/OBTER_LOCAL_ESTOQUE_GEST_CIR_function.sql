-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_estoque_gest_cir ( nm_maquina_atual_p text, cd_setor_atendimento_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


ie_local_estoque_w	varchar(1);
cd_local_estoque_w	smallint;
cd_local_estoque_ww	smallint;
qt_local_computador_w	smallint:=0;


BEGIN

ie_local_estoque_w := obter_param_usuario(900, 73, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_local_estoque_w);


if (ie_local_estoque_w = 'C') then
	begin

	select	count(*)
	into STRICT	qt_local_computador_w
	from	local_estoque_computador b,
		computador a
	where	a.nr_sequencia  = b.nr_seq_computador
	and	a.nm_computador_pesquisa  = padronizar_nome(upper(nm_maquina_atual_p));


	if (qt_local_computador_w = 0) then
		begin
		--(-20011, substr(obter_texto_tasy (47611, wheb_usuario_pck.get_nr_seq_idioma),1,255) || '#@#@');
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(47611);
		end;
	else
		begin

		select	coalesce(max(b.cd_local_estoque), '0')
		into STRICT	cd_local_estoque_ww
		from	local_estoque_computador b,
			computador a
		where  	a.nr_sequencia  = b.nr_seq_computador
		and    	a.nm_computador_pesquisa  = padronizar_nome(upper(nm_maquina_atual_p));

		end;
	end if;
	end;
elsif (ie_local_estoque_w = 'U') then
	begin

	select	cd_local_estoque
	into STRICT	cd_local_estoque_ww
	from	setor_atendimento
	where	cd_setor_atendimento = cd_setor_atendimento_p;

	end;
elsif (ie_local_estoque_w = 'P') then
	begin
	select	a.cd_local_estoque
	into STRICT	cd_local_estoque_ww
	from	setor_atendimento a,
		cirurgia b
	where	b.cd_setor_atendimento = a.cd_setor_atendimento
	and	b.nr_cirurgia = nr_cirurgia_p;
	end;
end if;

cd_local_estoque_w := cd_local_estoque_ww;

return	cd_local_estoque_w;

end 	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_estoque_gest_cir ( nm_maquina_atual_p text, cd_setor_atendimento_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
