-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tributo_orc_pac ( nr_seq_orcamento_p bigint, nr_seq_proc_mat_p bigint, ie_proc_mat_p text, nm_usuario_p text) AS $body$
DECLARE


qt_registros_w		integer;

cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;

cd_convenio_w		orcamento_paciente.cd_convenio%type;

cd_procedimento_w	estrutura_procedimento_v.cd_procedimento%type;
ie_origem_proced_w	estrutura_procedimento_v.ie_origem_proced%type;
cd_area_procedimento_w	estrutura_procedimento_v.cd_area_procedimento%type;
cd_especialidade_w	estrutura_procedimento_v.cd_especialidade%type;
cd_grupo_proc_w		estrutura_procedimento_v.cd_grupo_proc%type;

cd_grupo_material_w	estrutura_material_v.cd_grupo_material%type;
cd_subgrupo_material_w	estrutura_material_v.cd_subgrupo_material%type;
cd_classe_material_w	estrutura_material_v.cd_classe_material%type;
cd_material_w		estrutura_material_v.cd_material%type;

cd_tributo_w		tributo.cd_tributo%type;

pr_aliquota_w		regra_calculo_imposto.pr_imposto%type;
nr_seq_regra_w		regra_calculo_imposto.nr_sequencia%type;

nr_seq_propaci_w		propaci_imposto.nr_sequencia%type;
nr_seq_matpaci_w		matpaci_imposto.nr_sequencia%type;

vl_material_w		material_atend_paciente.vl_material%type;
vl_procedimento_w		procedimento_paciente.vl_procedimento%type;
nr_seq_proc_princ_w	procedimento_paciente.nr_seq_proc_princ%type;

vl_imposto_w		orcamento_proc_imposto.vl_imposto%type;


BEGIN

if (nr_seq_orcamento_p IS NOT NULL AND nr_seq_orcamento_p::text <> '') and (nr_seq_proc_mat_p IS NOT NULL AND nr_seq_proc_mat_p::text <> '') and (ie_proc_mat_p IS NOT NULL AND ie_proc_mat_p::text <> '') then

	if (ie_proc_mat_p = 'P') then

		select	count(*)
		into STRICT	qt_registros_w
		from	orcamento_proc_imposto
		where	nr_seq_proc = nr_seq_proc_mat_p;

		if (qt_registros_w > 0) then
			delete from orcamento_proc_imposto where nr_seq_proc = nr_seq_proc_mat_p;
		end if;

		begin
		select	b.cd_procedimento,
			b.ie_origem_proced,
			a.cd_estabelecimento,
			a.cd_convenio,
			(b.vl_procedimento - coalesce(b.vl_desconto,0)),
			b.nr_seq_proc_princ
		into STRICT	cd_procedimento_w,
			ie_origem_proced_w,
			cd_estabelecimento_w,
			cd_convenio_w,
			vl_procedimento_w,
			nr_seq_proc_princ_w
		from	orcamento_paciente a,
			orcamento_paciente_proc b
		where	a.nr_sequencia_orcamento = b.nr_sequencia_orcamento
		and	a.nr_sequencia_orcamento = nr_seq_orcamento_p
		and	b.nr_sequencia = nr_seq_proc_mat_p;
		exception
			when others then
			cd_procedimento_w	:= 0;
			ie_origem_proced_w	:= 0;
			cd_estabelecimento_w	:= 1;
			cd_convenio_w		:= 0;
			vl_procedimento_w		:= 0;
		end;

		select	coalesce(max(a.cd_grupo_proc),0),
			coalesce(max(a.cd_especialidade),0),
			coalesce(max(a.cd_area_procedimento),0)
		into STRICT	cd_grupo_proc_w,
			cd_especialidade_w,
			cd_area_procedimento_w
		from	estrutura_procedimento_v a
		where	a.cd_procedimento = cd_procedimento_w
		and	a.ie_origem_proced = ie_origem_proced_w;

	elsif (ie_proc_mat_p = 'M') then

		select	count(*)
		into STRICT	qt_registros_w
		from	orcamento_mat_imposto
		where	nr_seq_mat = nr_seq_proc_mat_p;

		if (qt_registros_w > 0) then
			delete from orcamento_mat_imposto where nr_seq_mat = nr_seq_proc_mat_p;
		end if;

		begin
		select	b.cd_material,
			a.cd_estabelecimento,
			a.cd_convenio,
			b.vl_material - coalesce(b.vl_desconto,0)
		into STRICT	cd_material_w,
			cd_estabelecimento_w,
			cd_convenio_w,
			vl_material_w
		from	orcamento_paciente a,
			orcamento_paciente_mat b
		where	a.nr_sequencia_orcamento = b.nr_sequencia_orcamento
		and	a.nr_sequencia_orcamento = nr_seq_orcamento_p
		and	b.nr_sequencia = nr_seq_proc_mat_p;
		exception
			when others then
			cd_material_w		:= 0;
			cd_estabelecimento_w	:= 1;
			cd_convenio_w		:= 0;
			vl_material_w		:= 0;
		end;

		select	a.cd_classe_material,
			a.cd_subgrupo_material,
			a.cd_grupo_material
		into STRICT	cd_classe_material_w,
			cd_subgrupo_material_w,
			cd_grupo_material_w
		from	estrutura_material_v a
		where	a.cd_material = cd_material_w;

	end if;

	nr_seq_regra_w	:= null;
	cd_tributo_w	:= null;
	pr_aliquota_w	:= 0;

	/*select	max(cd_tributo)
	into	cd_tributo_w
	from	tributo
	where	ie_situacao = 'A'
	and	ie_tipo_tributo = 'IVA'
	and	(nvl(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w);*/
	SELECT * FROM obter_dados_trib_conta_pac(	cd_estabelecimento_w, cd_convenio_w, clock_timestamp(), coalesce(cd_area_procedimento_w,0), coalesce(cd_especialidade_w,0), coalesce(cd_grupo_proc_w,0), coalesce(cd_procedimento_w,0), coalesce(ie_origem_proced_w,0), coalesce(cd_grupo_material_w,0), coalesce(cd_subgrupo_material_w,0), coalesce(cd_classe_material_w,0), coalesce(cd_material_w,0), cd_tributo_w, pr_aliquota_w, nr_seq_regra_w) INTO STRICT cd_tributo_w, pr_aliquota_w, nr_seq_regra_w;

	if (ie_proc_mat_p = 'P') and (cd_tributo_w IS NOT NULL AND cd_tributo_w::text <> '') and (pr_aliquota_w IS NOT NULL AND pr_aliquota_w::text <> '') then

		select	nextval('orcamento_proc_imposto_seq')
		into STRICT	nr_seq_propaci_w
		;

		vl_imposto_w := (vl_procedimento_w * (pr_aliquota_w / 100));

		insert into orcamento_proc_imposto(
			nr_sequencia,
			nr_seq_proc,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_tributo,
			pr_imposto,
			vl_imposto,
			nr_seq_regra,
			vl_proc_imposto
		) values (
			nr_seq_propaci_w,				--nr_sequencia
			nr_seq_proc_mat_p,			--nr_seq_propaci
			clock_timestamp(),					--dt_atualizacao
			nm_usuario_p,				--nm_usuario
			clock_timestamp(),					--dt_atualizacao_nrec
			nm_usuario_p,				--nm_usuario_nrec
			cd_tributo_w,				--cd_tributo
			pr_aliquota_w,				--pr_imposto
			vl_imposto_w,	--vl_imposto
			nr_seq_regra_w,				--nr_seq_regra
			(vl_procedimento_w + vl_imposto_w));

	elsif (ie_proc_mat_p = 'M') and (cd_tributo_w IS NOT NULL AND cd_tributo_w::text <> '') and (pr_aliquota_w IS NOT NULL AND pr_aliquota_w::text <> '') then

		select	nextval('orcamento_mat_imposto_seq')
		into STRICT	nr_seq_matpaci_w
		;

		vl_imposto_w := (vl_material_w * (pr_aliquota_w / 100));

		insert into orcamento_mat_imposto(
			nr_sequencia,
			nr_seq_mat,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_tributo,
			pr_imposto,
			vl_imposto,
			nr_seq_regra,
			vl_mat_imposto
		) values (
			nr_seq_matpaci_w,			--nr_sequencia
			nr_seq_proc_mat_p,		--nr_seq_matpaci
			clock_timestamp(),				--dt_atualizacao
			nm_usuario_p,			--nm_usuario
			clock_timestamp(),				--dt_atualizacao_nrec
			nm_usuario_p,			--nm_usuario_nrec
			cd_tributo_w,			--cd_tributo
			pr_aliquota_w,			--pr_imposto
			vl_imposto_w,	--vl_imposto
			nr_seq_regra_w,
			(vl_material_w + vl_imposto_w));			--nr_seq_regra
	elsif (ie_proc_mat_p = 'P') and (nr_seq_proc_princ_w IS NOT NULL AND nr_seq_proc_princ_w::text <> '') then

		select	count(*)
		into STRICT	qt_registros_w
		from	orcamento_proc_imposto
		where	nr_seq_proc = nr_seq_proc_princ_w;

		if (qt_registros_w > 0) then

			select	nextval('orcamento_proc_imposto_seq')
			into STRICT	nr_seq_propaci_w
			;

			insert into orcamento_proc_imposto(
				nr_sequencia,
				nr_seq_proc,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_tributo,
				pr_imposto,
				vl_imposto,
				nr_seq_regra)
			SELECT	nr_seq_propaci_w,
				nr_seq_proc_mat_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_tributo,
				pr_imposto,
				CASE WHEN sign(vl_imposto)=-1 THEN  vl_imposto * -1  ELSE vl_imposto END ,
				nr_seq_regra
			from	orcamento_proc_imposto
			where	nr_seq_proc = nr_seq_proc_princ_w;

		end if;

	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tributo_orc_pac ( nr_seq_orcamento_p bigint, nr_seq_proc_mat_p bigint, ie_proc_mat_p text, nm_usuario_p text) FROM PUBLIC;
