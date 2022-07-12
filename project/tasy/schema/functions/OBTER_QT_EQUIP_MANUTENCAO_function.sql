-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_equip_manutencao ( nr_seq_classif_equip_p bigint, cd_equipamento_p bigint, dt_agenda_p timestamp default null) RETURNS bigint AS $body$
DECLARE


cd_imobilizado_w		varchar(20);
nr_seq_equipamento_w		bigint;
qt_ordem_servico_w		bigint;
qt_equip_man_w			bigint;
ie_periodo_parado_w		varchar(1);
nr_seq_equipamento_man_w	bigint;

c01 CURSOR FOR
	SELECT	cd_imobilizado,
		nr_seq_equipamento_man
	from	equipamento
	where	((nr_seq_classif_equip_p IS NOT NULL AND nr_seq_classif_equip_p::text <> '' AND cd_classificacao = nr_seq_classif_equip_p) or
		 (cd_equipamento_p IS NOT NULL AND cd_equipamento_p::text <> '' AND cd_equipamento = cd_equipamento_p))
	and	ie_situacao = 'A';


BEGIN

ie_periodo_parado_w := Obter_Param_Usuario(871, 474, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_periodo_parado_w);

qt_equip_man_w	:= 0;

OPEN C01;
LOOP
FETCH C01 into
	cd_imobilizado_w,
	nr_seq_equipamento_man_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (cd_imobilizado_w IS NOT NULL AND cd_imobilizado_w::text <> '') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_equipamento_w
		from	man_equipamento
		where	cd_imobilizado = cd_imobilizado_w;
	else
		nr_seq_equipamento_w := coalesce(nr_seq_equipamento_man_w,0);
	end if;

	if (ie_periodo_parado_w = 'N') then
		select	count(*)
		into STRICT	qt_ordem_servico_w
		from	man_ordem_servico
		where	ie_status_ordem <> '3'
		and	nr_seq_equipamento = nr_seq_equipamento_w;
	elsif (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (ie_periodo_parado_w = 'S') then
		select	count(*)
		into STRICT	qt_ordem_servico_w
		from   	man_equip_periodo_parado a,
			man_ordem_servico b
		where  	a.nr_seq_equipamento 	= b.nr_seq_equipamento
		and	a.nr_seq_equipamento 	= nr_seq_equipamento_w
		and	b.ie_parado		= 'S'
		and	dt_agenda_p		between a.dt_periodo_inicial and a.dt_periodo_final;
	end if;


	if (qt_ordem_servico_w > 0) then
		qt_equip_man_w	:= qt_equip_man_w + 1;
	end if;
	end;
END LOOP;
CLOSE C01;

return qt_equip_man_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_equip_manutencao ( nr_seq_classif_equip_p bigint, cd_equipamento_p bigint, dt_agenda_p timestamp default null) FROM PUBLIC;
