-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION regra_plano_material_valor (nr_seq_regra_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, cd_material_p bigint, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_plano_p bigint, nr_atendimento_p bigint, qt_material_p bigint, ie_valor_dia_p text, ie_valor_unitario_p text, ie_mat_conta_p text) RETURNS varchar AS $body$
DECLARE


vl_material_min_w   regra_convenio_plano_mat.vl_material_min%type;
vl_material_max_w   regra_convenio_plano_mat.vl_material_max%type;
ie_valor_w          regra_convenio_plano_mat.ie_valor%type;
ie_valor_dia_w      regra_convenio_plano_mat.ie_valor_dia%type;
ie_valor_unitario_w regra_convenio_plano_mat.ie_valor_unitario%type;
ie_mat_conta_w		regra_convenio_plano_mat.ie_mat_conta%type;
cd_material_w			double precision;
cd_material_preco_w		double precision;
cd_categoria_w			varchar(10);
vl_referencia_w			double precision	:= 0;
qt_material_w			bigint;
ie_aplica_w             varchar(1)	:= 'S';
vl_referencia_conta_w	double precision	:= 0;

C01 CURSOR FOR
SELECT	ie_valor,
	coalesce(vl_material_min, 0),
	coalesce(vl_material_max, 0),
	coalesce(coalesce(ie_valor_dia_p,ie_valor_dia),'N'),
	coalesce(coalesce(ie_valor_unitario_p,ie_valor_unitario),'N'),
    coalesce(coalesce(ie_mat_conta_p,ie_mat_conta),'N')
from 	regra_Convenio_Plano_mat
where	nr_sequencia							= nr_seq_regra_p;


BEGIN
    cd_material_w := cd_material_p;
    ie_aplica_w := 'S';

   open c01;
	loop
	fetch c01 into
		ie_valor_w,
		vl_material_min_w,
		vl_material_max_w,
		ie_valor_dia_w,
		ie_valor_unitario_w,
        ie_mat_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
        if (ie_valor_w in ('S','F')) then
            select	max(CASE WHEN coalesce(ie_mat_conta_w,'N')='N' THEN  cd_material_w  ELSE obter_material_conta(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, cd_material_w, cd_material_w, cd_material_w, cd_plano_p, cd_setor_atendimento_p, clock_timestamp(), 0, 0) END )
			into STRICT	cd_material_preco_w
			;
        end if;

        if (coalesce(cd_categoria_p,0) = 0) then
            select	min(cd_categoria)
            into STRICT	cd_categoria_w
            from	categoria_convenio
            where	cd_convenio	= cd_convenio_p
            and	    ie_situacao	= 'A';
        end if;

        vl_referencia_w := OBTER_PRECO_MATERIAL(cd_estabelecimento_p, cd_convenio_p, coalesce(cd_categoria_p,cd_categoria_w), clock_timestamp(), cd_material_w, cd_tipo_acomodacao_p, ie_tipo_atendimento_p, cd_setor_atendimento_p,null,0,0);

        select	CASE WHEN qt_material_p=0 THEN 1  ELSE qt_material_p END
		into STRICT	qt_material_w
		;

		if (coalesce(ie_valor_unitario_w,'N') = 'S') then
			qt_material_w	:= 1;
		end if;

        if (coalesce(ie_valor_dia_w,'N') = 'N') then

			if (ie_valor_w = 'S') then		-- Aplicar regra quando valor fora da faixa
				if	((coalesce(qt_material_w,1) * vl_referencia_w) between vl_material_min_w and vl_material_max_w) then
					ie_aplica_w := 'N';
				end if;
			elsif (ie_valor_w = 'F') then -- Aplicar regra quando valor dentro da faixa
				if	not((coalesce(qt_material_w,1) * vl_referencia_w) between vl_material_min_w and vl_material_max_w) then
					ie_aplica_w := 'N';
				end if;
			end if;
		elsif (coalesce(ie_valor_dia_w,'N') = 'S')and (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then


			begin
			select	coalesce(sum(vl_material),0)
			into STRICT	vl_referencia_conta_w
			from	material_atend_paciente
			where	cd_material = cd_material_w
			and	nr_atendimento = nr_atendimento_p
			and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_atendimento) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp())
			and	coalesce(cd_motivo_exc_conta::text, '') = '';
			exception
			when others then
				vl_referencia_conta_w := 0;
			end;

			if (ie_valor_w = 'S') then

				if	(((coalesce(qt_material_w,1) * vl_referencia_w) + vl_referencia_conta_w) between vl_material_min_w and vl_material_max_w) then
					ie_aplica_w := 'N';
				end if;
			elsif (ie_valor_w = 'F') then

				if	not(((coalesce(qt_material_w,1) * vl_referencia_w) + vl_referencia_conta_w) between vl_material_min_w and vl_material_max_w) then
					ie_aplica_w := 'N';
				end if;
			end if;
		end if;

    end loop;


    return ie_aplica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION regra_plano_material_valor (nr_seq_regra_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, cd_material_p bigint, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_plano_p bigint, nr_atendimento_p bigint, qt_material_p bigint, ie_valor_dia_p text, ie_valor_unitario_p text, ie_mat_conta_p text) FROM PUBLIC;

