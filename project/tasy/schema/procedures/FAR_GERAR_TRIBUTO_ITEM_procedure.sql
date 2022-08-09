-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE far_gerar_tributo_item ( nr_seq_venda_p bigint, nr_seq_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w	estabelecimento.cd_estabelecimento%TYPE;

cd_grupo_material_w	estrutura_material_v.cd_grupo_material%TYPE;
cd_subgrupo_material_w	estrutura_material_v.cd_subgrupo_material%TYPE;
cd_classe_material_w	estrutura_material_v.cd_classe_material%TYPE;

cd_material_w		far_venda_item.cd_material%TYPE;
vl_total_w		far_venda_item.vl_total%TYPE;

cd_tributo_w		tributo.cd_tributo%TYPE;

pr_aliquota_w		regra_calculo_imposto.pr_imposto%TYPE;
nr_seq_regra_w		regra_calculo_imposto.nr_sequencia%TYPE;
nr_seq_item_w		far_venda_item.nr_sequencia%TYPE;
cd_procedimento_w	far_venda_item.cd_procedimento%TYPE;
ie_origem_proced_w	far_venda_item.ie_origem_proced%TYPE;

cd_area_procedimento_w	estrutura_procedimento_v.cd_area_procedimento%type;
cd_especialidade_w	estrutura_procedimento_v.cd_especialidade%type;
cd_grupo_proc_w		estrutura_procedimento_v.cd_grupo_proc%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		coalesce(a.cd_material,0),
		a.vl_total,
		coalesce(a.cd_procedimento,0),
		coalesce(a.ie_origem_proced,0)
	FROM	far_venda_item a
	WHERE	a.nr_seq_venda = nr_seq_venda_p
	AND	a.nr_sequencia = coalesce(nr_seq_item_p,a.nr_sequencia);



BEGIN

OPEN C01;
LOOP
FETCH C01 INTO
	nr_seq_item_w,
	cd_material_w,
	vl_total_w,
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
	cd_estabelecimento_w :=  wheb_usuario_pck.get_cd_estabelecimento();

	DELETE FROM far_venda_item_trib WHERE nr_seq_item = nr_seq_item_w;

	IF (cd_material_w > 0) THEN
		SELECT	a.cd_classe_material,
			a.cd_subgrupo_material,
			a.cd_grupo_material
		INTO STRICT	cd_classe_material_w,
			cd_subgrupo_material_w,
			cd_grupo_material_w
		FROM	estrutura_material_v a
		WHERE	a.cd_material = cd_material_w;
	ELSE
		cd_classe_material_w	:=	0;
		cd_subgrupo_material_w	:=	0;
		cd_grupo_material_w		:=	0;
	END IF;

	IF (cd_procedimento_w > 0) then
		select	coalesce(max(a.cd_grupo_proc),0),
				coalesce(max(a.cd_especialidade),0),
				coalesce(max(a.cd_area_procedimento),0)
		into STRICT	cd_grupo_proc_w,
				cd_especialidade_w,
				cd_area_procedimento_w
		from	estrutura_procedimento_v a
		where	a.cd_procedimento = cd_procedimento_w
		and		a.ie_origem_proced = ie_origem_proced_w;
	end if;

	nr_seq_regra_w	:= NULL;
	cd_tributo_w	:= NULL;
	pr_aliquota_w	:= 0;

	/*SELECT	MAX(cd_tributo)
	INTO	cd_tributo_w
	FROM	tributo
	WHERE	ie_situacao = 'A'
	AND	ie_tipo_tributo = 'IVA'
	AND	(NVL(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w);
	*/
	SELECT * FROM obter_dados_trib_conta_pac(
		cd_estabelecimento_w, 0, clock_timestamp(), coalesce(cd_area_procedimento_w,0), coalesce(cd_especialidade_w,0), coalesce(cd_grupo_proc_w,0), cd_procedimento_w, ie_origem_proced_w, cd_grupo_material_w, cd_subgrupo_material_w, cd_classe_material_w, cd_material_w, cd_tributo_w, pr_aliquota_w, nr_seq_regra_w) INTO STRICT cd_tributo_w, pr_aliquota_w, nr_seq_regra_w;

	IF (cd_tributo_w IS NOT NULL AND cd_tributo_w::text <> '') AND (pr_aliquota_w IS NOT NULL AND pr_aliquota_w::text <> '') THEN
		INSERT INTO far_venda_item_trib(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_item,
			cd_tributo,
			vl_tributo,
			tx_tributo,
			vl_base
		) VALUES (
			nextval('far_venda_item_trib_seq'),		--nr_sequencia
			clock_timestamp(),					--dt_atualizacao
			nm_usuario_p,					--nm_usuario
			clock_timestamp(),					--dt_atualizacao_nrec
			nm_usuario_p,					--nm_usuario_nrec
			nr_seq_item_w,				--nr_seq_item
			cd_tributo_w,					--cd_tributo
			(vl_total_w * (pr_aliquota_w / 100)),		--vl_tributo
			pr_aliquota_w,					--tx_tributo
			vl_total_w);					--vl_base
	END IF;
	END;
END LOOP;
CLOSE C01;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE far_gerar_tributo_item ( nr_seq_venda_p bigint, nr_seq_item_p bigint, nm_usuario_p text) FROM PUBLIC;
