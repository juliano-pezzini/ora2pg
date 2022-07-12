-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION obter_saldo_disp_estoque_pck.get_qt_reg_kit_estoque ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint default null, nr_seq_lote_p bigint default null) RETURNS bigint AS $body$
DECLARE


	qt_reg_kit_w			double precision := 0;
	qt_kit_avulso_w			double precision := 0;
	cd_material_estoque_ww		material.cd_material%type;

	
BEGIN
	CALL CALL CALL CALL CALL CALL CALL CALL CALL obter_saldo_disp_estoque_pck.set_cd_estabelecimento(cd_estabelecimento_p);
	CALL obter_saldo_disp_estoque_pck.set_nr_seq_lote(nr_seq_lote_p);
	CALL obter_saldo_disp_estoque_pck.set_cd_material(cd_material_p);
	cd_material_estoque_ww		:=	obter_saldo_disp_estoque_pck.get_cd_material_estoque();

	if (current_setting('obter_saldo_disp_estoque_pck.ie_disp_reg_kit_estoque_w')::parametro_estoque.ie_disp_reg_kit_estoque%type = 'S') then
		if (cd_local_estoque_p > 0) then
			if	((nr_seq_lote_p > 0) and (current_setting('obter_saldo_disp_estoque_pck.ie_estoque_lote_w')::material_estab.ie_estoque_lote%type = 'S')) then
				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_reg_kit_w
				from	kit_estoque_reg c,
					kit_estoque b,
					material x,
					kit_estoque_comp a
				where	c.nr_sequencia		= b.nr_seq_reg_kit
				and	a.nr_seq_kit_estoque	= b.nr_sequencia
				and	a.cd_material 		= x.cd_material
				and	x.cd_material_estoque	= cd_material_estoque_ww
				and	b.cd_local_estoque	= cd_local_estoque_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	a.ie_gerado_barras	= 'S'
				and	coalesce(a.nr_seq_motivo_exclusao::text, '') = ''
				and	coalesce(b.dt_utilizacao::text, '') = ''
				and	c.ie_situacao		= 'A'
				and	coalesce(c.dt_utilizacao::text, '') = ''
				and	a.nr_seq_lote_fornec 	= nr_seq_lote_p;

				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_kit_avulso_w
				from	kit_estoque_reg b,
					material x,
					kit_estoque_comp_avulso a
				where	b.nr_sequencia		= a.nr_seq_reg_kit
				and	x.cd_material		= a.cd_material
				and	a.cd_local_estoque	= cd_local_estoque_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	x.cd_material_estoque	= cd_material_estoque_ww
				and	b.ie_situacao		= 'A'
				and	a.ie_gerado_barras	= 'S'
				and	coalesce(b.dt_utilizacao::text, '') = ''
				and	a.nr_seq_lote_fornec 	= nr_seq_lote_p;
			else
				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_reg_kit_w
				from	kit_estoque_reg c,
					kit_estoque b,
					material x,
					kit_estoque_comp a
				where	c.nr_sequencia		= b.nr_seq_reg_kit
				and	a.nr_seq_kit_estoque	= b.nr_sequencia
				and	a.cd_material 		= x.cd_material
				and	x.cd_material_estoque	= cd_material_estoque_ww
				and	b.cd_local_estoque	= cd_local_estoque_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	a.ie_gerado_barras	= 'S'
				and	coalesce(a.nr_seq_motivo_exclusao::text, '') = ''
				and	coalesce(b.dt_utilizacao::text, '') = ''
				and	c.ie_situacao		= 'A'
				and	coalesce(c.dt_utilizacao::text, '') = '';

				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_kit_avulso_w
				from	kit_estoque_reg b,
					material x,
					kit_estoque_comp_avulso a
				where	b.nr_sequencia		= a.nr_seq_reg_kit
				and	x.cd_material		= a.cd_material
				and	a.cd_local_estoque	= cd_local_estoque_p
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	x.cd_material_estoque	= cd_material_estoque_ww
				and	b.ie_situacao		= 'A'
				and	a.ie_gerado_barras	= 'S'
				and	coalesce(b.dt_utilizacao::text, '') = '';
			end if;
		else
			if	((nr_seq_lote_p > 0) and (current_setting('obter_saldo_disp_estoque_pck.ie_estoque_lote_w')::material_estab.ie_estoque_lote%type = 'S')) then
				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_reg_kit_w
				from	kit_estoque_reg c,
					kit_estoque b,
					material x,
					kit_estoque_comp a
				where	c.nr_sequencia		= b.nr_seq_reg_kit
				and	a.nr_seq_kit_estoque	= b.nr_sequencia
				and	a.cd_material 		= x.cd_material
				and	x.cd_material_estoque	= cd_material_estoque_ww
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = b.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p)
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	a.ie_gerado_barras	= 'S'
				and	coalesce(a.nr_seq_motivo_exclusao::text, '') = ''
				and	coalesce(b.dt_utilizacao::text, '') = ''
				and	c.ie_situacao		= 'A'
				and	coalesce(c.dt_utilizacao::text, '') = ''
				and	a.nr_seq_lote_fornec 	= nr_seq_lote_p;

				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_kit_avulso_w
				from	kit_estoque_reg b,
					material x,
					kit_estoque_comp_avulso a
				where	b.nr_sequencia		= a.nr_seq_reg_kit
				and	x.cd_material		= a.cd_material
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = b.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p)
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	x.cd_material_estoque	= cd_material_estoque_ww
				and	b.ie_situacao		= 'A'
				and	a.ie_gerado_barras	= 'S'
				and	coalesce(b.dt_utilizacao::text, '') = ''
				and	a.nr_seq_lote_fornec 	= nr_seq_lote_p;
			else
				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_reg_kit_w
				from	kit_estoque_reg c,
					kit_estoque b,
					material x,
					kit_estoque_comp a
				where	c.nr_sequencia		= b.nr_seq_reg_kit
				and	a.nr_seq_kit_estoque	= b.nr_sequencia
				and	a.cd_material 		= x.cd_material
				and	x.cd_material_estoque	= cd_material_estoque_ww
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = b.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p)
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	a.ie_gerado_barras	= 'S'
				and	coalesce(a.nr_seq_motivo_exclusao::text, '') = ''
				and	coalesce(b.dt_utilizacao::text, '') = ''
				and	c.ie_situacao		= 'A'
				and	coalesce(c.dt_utilizacao::text, '') = '';

				select	coalesce(sum(a.qt_material),0)
				into STRICT	qt_kit_avulso_w
				from	kit_estoque_reg b,
					material x,
					kit_estoque_comp_avulso a
				where	b.nr_sequencia		= a.nr_seq_reg_kit
				and	x.cd_material		= a.cd_material
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = b.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p)
				and	b.cd_estabelecimento	= cd_estabelecimento_p
				and	x.cd_material_estoque	= cd_material_estoque_ww
				and	b.ie_situacao		= 'A'
				and	a.ie_gerado_barras	= 'S'
				and	coalesce(b.dt_utilizacao::text, '') = '';
			end if;
		end if;

		qt_reg_kit_w	:=	dividir(qt_reg_kit_w + qt_kit_avulso_w, current_setting('obter_saldo_disp_estoque_pck.qt_conv_estoque_w')::material.qt_conv_estoque_consumo%type);
	end if;
	return qt_reg_kit_w;
	end;



$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_disp_estoque_pck.get_qt_reg_kit_estoque ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint default null, nr_seq_lote_p bigint default null) FROM PUBLIC;