-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_desconto_conta (nr_interno_conta_p bigint) AS $body$
DECLARE


cd_material_w			integer;
nr_sequencia_w		bigint;
qt_resumo_w			double precision;
nr_prescricao_w		bigint;
cd_cgc_fornec_w		varchar(14);
vl_desconto_w			double precision;
pr_desconto_w			double precision;
vl_material_w			double precision;
nr_atendimento_w		bigint;
ie_desc_financ_resumo_w		varchar(1);
vl_liquido_w			double precision;
cd_estabelecimento_w		smallint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_material,
		coalesce(qt_resumo,0),
		nr_prescricao,
		cd_cgc_fornec,
		coalesce(vl_material,0)
	from 	conta_paciente_resumo
	where	nr_interno_conta		= nr_interno_conta_p
	and	(cd_material IS NOT NULL AND cd_material::text <> '')
	and	(cd_cgc_fornec IS NOT NULL AND cd_cgc_fornec::text <> '')
	and	(nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '')
	Order 	By cd_material;

C02 CURSOR FOR
	SELECT	a.vl_liquido,
		a.pr_desc_financ
	from	nota_fiscal_item a
	where	nr_atendimento	= nr_atendimento_w
	and	cd_material	= cd_material_w
	and	exists (SELECT 1
		from	nota_fiscal b
		where	a.nr_sequencia	= b.nr_sequencia
		and	coalesce(cd_cgc,cd_cgc_emitente) = cd_cgc_fornec_w)
	order by coalesce(pr_desc_financ,0) asc;



BEGIN

select	max(nr_atendimento),
	max(cd_estabelecimento)
into STRICT	nr_atendimento_w,
	cd_estabelecimento_w
from	conta_paciente
where	nr_interno_conta	= nr_interno_conta_p;

select 	coalesce(max(ie_desc_financ_resumo),'N')
into STRICT	ie_desc_financ_resumo_w
from 	parametro_faturamento
where 	cd_estabelecimento = cd_estabelecimento_w;

OPEN C01;
LOOP
FETCH C01 into
	nr_sequencia_w,
	cd_material_w,
	qt_resumo_w,
	nr_prescricao_w,
	cd_cgc_fornec_w,
	vl_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_desc_financ_resumo_w = 'N') then

		select	coalesce(max(pr_desc_financ),0)
		into STRICT	pr_desconto_w
		from	nota_fiscal_item a
		where	nr_atendimento	= nr_atendimento_w
		and	cd_material		= cd_material_w
		and	exists (SELECT 1
			from	nota_fiscal b
			where	a.nr_sequencia	= b.nr_sequencia
			and	coalesce(cd_cgc,cd_cgc_emitente) = cd_cgc_fornec_w);

	elsif (ie_desc_financ_resumo_w = 'S') then

		open C02;
		loop
		fetch C02 into
			vl_liquido_w,
			pr_desconto_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			vl_liquido_w	:= vl_liquido_w;
			pr_desconto_w	:= pr_desconto_w;
			end;
		end loop;
		close C02;

		vl_material_w:= vl_liquido_w;

	end if;

	vl_desconto_w			:= vl_material_w * pr_desconto_w / 100;
	if (pr_desconto_w > 0) then
		update Conta_paciente_Resumo
		set 	vl_desc_financ	= vl_desconto_w
		where	nr_interno_conta	= nr_interno_conta_p
		  and	nr_sequencia		= nr_sequencia_w;
	end if;
	end;
END LOOP;
CLOSE C01;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_desconto_conta (nr_interno_conta_p bigint) FROM PUBLIC;
