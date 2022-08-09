-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_estoque ( dt_parametro_P timestamp, NM_USUARIO_P text) AS $body$
DECLARE



dt_mesano_referencia_w		timestamp;
cd_estabelecimento_w		smallint;
cd_local_estoque_w		smallint;
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
cd_material_w			integer;
ie_consignado_w			varchar(1);
vl_estoque_w			double precision;
vl_estoque_ww			double precision;
dt_referencia_w			timestamp;
nr_sequencia_w			bigint;
dt_mes_ano_w			timestamp;

C01 CURSOR FOR
	SELECT	/*+ CHOOSE*/		a.dt_mesano_referencia,
		a.cd_estabelecimento,
		a.cd_local_estoque,
		c.cd_grupo_material,
		c.cd_subgrupo_material,
		c.cd_classe_material,
		a.cd_material,
		b.ie_consignado,
		coalesce(a.vl_estoque,0)
	FROM	estrutura_material_v c,
		Material b,
		Saldo_Estoque a
	WHERE	a.cd_material	= b.cd_material
	AND	b.cd_material		= c.cd_material
	AND	a.dt_mesano_referencia = dt_mes_ano_w;


BEGIN
--INSERT INTO Log_xxTasy VALUES (SYSDATE, nm_usuario_p, 601, 'Estoque');
dt_referencia_w	:=	trunc(dt_parametro_p,'dd');
dt_mes_ano_w	:=	trunc(dt_referencia_w,'mm');

nr_sequencia_w := Gravar_Log_Indicador(34, wheb_mensagem_pck.get_texto(306348), clock_timestamp(), TRUNC(dt_referencia_w,'month'), nm_usuario_p, nr_sequencia_w);  --'Estoque Materiais/Medicamentos'
delete	FROM eis_Estoque
where	dt_referencia = dt_mes_ano_w
and	ie_periodo = 'M';

delete	FROM eis_Estoque
where	dt_referencia = dt_referencia_w
and	ie_periodo = 'D';

OPEN C01;
LOOP
FETCH C01 INTO
	dt_mesano_referencia_w,
	cd_estabelecimento_w,
	cd_local_estoque_w,
	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	cd_material_w,
	ie_consignado_w,
	vl_estoque_ww;
EXIT WHEN NOT FOUND; /* apply on c01 */
	BEGIN

	vl_estoque_w	:= vl_estoque_ww;

	if (trunc(clock_timestamp(),'dd') <> dt_referencia_w) then
		select	Obter_valor_Diario_Estoque(
					dt_referencia_w,
					cd_estabelecimento_w,
					cd_local_estoque_w,
					cd_material_w)
		into STRICT	vl_estoque_w
		;
	end if;

	INSERT INTO eis_Estoque(
		nr_sequencia,
		ie_periodo,
		dt_referencia,
		cd_estabelecimento,
		cd_local_estoque,
		cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material,
		cd_material,
		ie_consignado,
		dt_atualizacao,
		nm_usuario,
		cd_operacao_estoque,
		vl_estoque)
	VALUES ( nextval('eis_estoque_seq'),
		'D',
		dt_referencia_w,
		cd_estabelecimento_w,
		cd_local_estoque_w,
		cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w,
		cd_material_w,
		ie_consignado_w,
		clock_timestamp(),
		nm_usuario_p,
		'0',
		vl_estoque_w);

	INSERT INTO eis_Estoque(
		nr_sequencia,
		ie_periodo,
		dt_referencia,
		cd_estabelecimento,
		cd_local_estoque,
		cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material,
		cd_material,
		ie_consignado,
		dt_atualizacao,
		nm_usuario,
		cd_operacao_estoque,
		vl_estoque)
	VALUES ( nextval('eis_estoque_seq'),
		'M',
		dt_mes_ano_w,
		cd_estabelecimento_w,
		cd_local_estoque_w,
		cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w,
		cd_material_w,
		ie_consignado_w,
		clock_timestamp(),
		nm_usuario_p,
		'0',
		vl_estoque_ww);
	END;
END LOOP;
CLOSE c01;

---INSERT INTO Log_xxxTasy VALUES (SYSDATE, nm_usuario_p, 602, 'Estoque');
CALL Atualizar_Log_Indicador(clock_timestamp(), nr_sequencia_w);

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_estoque ( dt_parametro_P timestamp, NM_USUARIO_P text) FROM PUBLIC;
