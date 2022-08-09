-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_dev_estoque_lote ( nr_devolucao_p bigint, nr_seq_item_p bigint, nr_lote_fornec_p bigint, qt_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


cd_material_w		integer;
nr_prescricao_w		bigint;
nr_atendimento_w	bigint;
ie_estoque_lote_w	varchar(1);
qt_material_w		double precision;
ds_retorno_w		varchar(2000);
ie_valida_lote_w	varchar(1);


BEGIN

ie_valida_lote_w := obter_param_usuario(42, 78, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_valida_lote_w);

if (coalesce(ie_valida_lote_w,'N') = 'S') then
	begin

	select	b.cd_material,
		b.nr_prescricao,
		a.nr_atendimento
	into STRICT	cd_material_w,
		nr_prescricao_w,
		nr_atendimento_w
	from	devolucao_material_pac a,
		item_devolucao_material_pac b
	where	a.nr_devolucao = b.nr_devolucao
	and	a.nr_devolucao = nr_devolucao_p
	and	b.nr_sequencia = nr_seq_item_p;

	exception
		when others then

		cd_material_w		:= 0;
		nr_prescricao_w		:= 0;
		nr_atendimento_w	:= 0;

	end;

	select	coalesce(max(ie_estoque_lote),'N')
	into STRICT	ie_estoque_lote_w
	from	material_estab
	where	cd_material = cd_material_w
	and	cd_estabelecimento = cd_estabelecimento_p;

	if (ie_estoque_lote_w = 'S') then

		begin

		select	sum(qt_material)
		into STRICT	qt_material_w
		from	material_atend_paciente
		where	nr_seq_lote_fornec = nr_lote_fornec_p
		and (nr_prescricao = coalesce(nr_prescricao_w,0) or coalesce(nr_prescricao_w,0) = 0)
		and	nr_atendimento = nr_atendimento_w
		having sum(qt_material) > 0;

		exception
			when others then

			qt_material_w := 0;

		end;

		if (qt_material_p > qt_material_w) then
			ds_retorno_w := wheb_mensagem_pck.get_texto(261256);
								--Não é possível devolver quantidade maior que a atendida
		end if;

	end if;
end if;
ds_retorno_p := ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_dev_estoque_lote ( nr_devolucao_p bigint, nr_seq_item_p bigint, nr_lote_fornec_p bigint, qt_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
