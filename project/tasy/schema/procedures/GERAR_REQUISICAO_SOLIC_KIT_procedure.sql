-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_requisicao_solic_kit (nr_sequencia_p bigint, cd_local_estoque_p bigint, nm_usuario_p text, ie_liberar_p text, ds_erro_p INOUT text, ds_mensagem_p INOUT text) AS $body$
DECLARE


cd_material_w			integer;
nr_seq_item_w			integer;
qt_disponivel_w			double precision;
cd_local_estoque_w		smallint;
cd_estabelecimento_w		smallint;
qt_solicitada_w			bigint;
qt_disp_estoque_w			double precision;
ds_erro_w			varchar(1000);
qt_requisicao_w			double precision;
nr_requisicao_w			bigint := 0;
cd_pessoa_requisitante_w		bigint;
cd_unidade_medida_estoque_w	varchar(30);
cd_unidade_medida_w		varchar(30);
nr_sequencia_w			bigint;
nr_seq_erro_w			bigint;
cd_operacao_estoque_w		smallint;
qt_requisicao_estoque_w		double precision;
qt_existe_requisicao_w		bigint;


C01 CURSOR FOR
SELECT	a.cd_material,
	a.qt_solicitada,
	a.qt_disponivel
from	solic_kit_mat_comp a
where	nr_seq_solic_kit = nr_sequencia_p;


BEGIN

select	cd_estabelecimento,
	cd_local_estoque
into STRICT	cd_estabelecimento_w,
	cd_local_estoque_w
from	solic_kit_material
where	nr_sequencia = nr_sequencia_p;

select	cd_operacao_transf_setor
into STRICT	cd_operacao_estoque_w
from	parametro_estoque
where	cd_estabelecimento = cd_estabelecimento_w;

cd_pessoa_requisitante_w := substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10);

select	count(*)
into STRICT	qt_existe_requisicao_w
from	requisicao_material
where	nr_seq_solic_kit = nr_sequencia_p
and	coalesce(dt_baixa::text, '') = '';

if (qt_existe_requisicao_w > 0) then
	begin
	select	max(nr_requisicao)
	into STRICT	nr_requisicao_w
	from	requisicao_material
	where	nr_seq_solic_kit = nr_sequencia_p
	and	coalesce(dt_baixa::text, '') = '';
	end;
end if;

open C01;
loop
fetch C01 into
	cd_material_w,
	qt_solicitada_w,
	qt_disponivel_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	cd_unidade_medida_estoque_w	:= obter_dados_material_estab(cd_material_w,cd_estabelecimento_w,'UME');

	if (qt_disponivel_w < qt_solicitada_w) then

		if (nr_requisicao_w = 0) then

			select	nextval('requisicao_seq')
			into STRICT	nr_requisicao_w
			;

			insert into requisicao_material(
				nr_requisicao,
				cd_estabelecimento,
				cd_local_estoque,
				dt_solicitacao_requisicao,
				dt_atualizacao,
				nm_usuario,
				cd_operacao_estoque,
				cd_pessoa_requisitante,
				cd_local_estoque_destino,
				nm_usuario_lib,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_geracao,
				ie_urgente,
				nr_seq_solic_kit,
				ie_origem_requisicao)
			values (	nr_requisicao_w,
				cd_estabelecimento_w,
				cd_local_estoque_p,
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				cd_operacao_estoque_w,
				cd_pessoa_requisitante_w,
				cd_local_estoque_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				'I',
				'N',
				nr_sequencia_p,
				'RSK');

			ds_mensagem_p := substr(WHEB_MENSAGEM_PCK.get_texto(281667) || ' ' ||  nr_requisicao_w || '.' ||chr(10),1,255);
		end if;

		qt_requisicao_w		:= qt_solicitada_w - qt_disponivel_w;
		cd_unidade_medida_w 	:= obter_dados_material_estab(cd_material_w,cd_estabelecimento_w,'UMS');
		qt_requisicao_estoque_w := obter_quantidade_convertida(cd_material_w,qt_requisicao_w,cd_unidade_medida_w,'UME');

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_sequencia_w
		from	item_requisicao_material
		where	nr_requisicao = nr_requisicao_w
		and	cd_material = cd_material_w;

		if (nr_sequencia_w > 0) then
			update	item_requisicao_material
			set	dt_atualizacao = clock_timestamp(),
				nm_usuario = nm_usuario_p,
				qt_material_requisitada = qt_requisicao_w,
				qt_estoque = qt_requisicao_estoque_w,
				cd_unidade_medida = cd_unidade_medida_w,
				cd_unidade_medida_estoque = cd_unidade_medida_estoque_w
			where	nr_requisicao = nr_requisicao_w
			and	nr_sequencia = nr_sequencia_w;
		else
			begin
			select	coalesce(max(nr_sequencia),0) + 1
			into STRICT	nr_sequencia_w
			from	item_requisicao_material
			where	nr_requisicao = nr_requisicao_w;

			insert into item_requisicao_material(
				nr_requisicao,
				nr_sequencia,
				cd_estabelecimento,
				cd_material,
				qt_material_requisitada,
				vl_material,
				dt_atualizacao,
				nm_usuario,
				cd_unidade_medida,
				cd_unidade_medida_estoque,
				qt_estoque)
			values ( nr_requisicao_w,
				nr_sequencia_w,
				cd_estabelecimento_w,
				cd_material_w,
				qt_requisicao_w,
				0,
				clock_timestamp(),
				nm_usuario_p,
				cd_unidade_medida_w,
				cd_unidade_medida_estoque_w,
				qt_requisicao_estoque_w);
			end;
		end if;
	end if;

	end;
end loop;
close C01;

if (ie_liberar_p = 'S') and (nr_requisicao_w <> 0) then
	ds_erro_p := consistir_requisicao(nr_requisicao_w, nm_usuario_p, cd_local_estoque_w, null, 'N', 'N', 'N', 'N', 'N', 'N', 'N', cd_operacao_estoque_w, ds_erro_p);

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_erro_w
	from	requisicao_mat_consist
	where	nr_requisicao = nr_requisicao_w;

	if (coalesce(nr_seq_erro_w,0) <> 0) then
		select	coalesce(substr(cd_material || ' - ' || ds_consistencia,1,2000),null)
		into STRICT	ds_erro_p
		from	requisicao_mat_consist
		where	nr_sequencia = nr_seq_erro_w;
	else
		ds_mensagem_p := substr(ds_mensagem_p || WHEB_MENSAGEM_PCK.get_texto(281668) || '  ' ||  nr_requisicao_w || '.',1,255);
	end if;
end if;

if (nr_requisicao_w = 0) then

	select  substr(WHEB_MENSAGEM_PCK.get_texto(1026492),1,255)
	into STRICT	ds_erro_p
	;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_requisicao_solic_kit (nr_sequencia_p bigint, cd_local_estoque_p bigint, nm_usuario_p text, ie_liberar_p text, ds_erro_p INOUT text, ds_mensagem_p INOUT text) FROM PUBLIC;
