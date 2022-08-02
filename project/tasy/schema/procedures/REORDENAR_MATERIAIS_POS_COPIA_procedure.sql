-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reordenar_materiais_pos_copia (nr_prescricao_p bigint) AS $body$
DECLARE


nr_sequencia_w		integer;
nr_agrupamento_w	double precision;
nr_agrupamento_ww	double precision;
nr_agrup_base_w		double precision;
ie_ordena_via_w		varchar(1);
cd_estabelecimento_w	smallint;
nm_usuario_w		varchar(15);

C01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_agrupamento
FROM material b, prescr_material a
LEFT OUTER JOIN via_aplicacao c ON (a.ie_via_aplicacao = c.ie_via_aplicacao)
WHERE a.nr_prescricao 		= nr_prescricao_p and a.cd_material			= b.cd_material  and ie_agrupador			<> 1 order by c.nr_impressao,
	a.ie_via_aplicacao,
	a.nr_agrupamento,
	a.nr_sequencia;

C02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_agrupamento
from	material b,
	prescr_material a
where	a.nr_prescricao 		= nr_prescricao_p
  and	a.cd_material			= b.cd_material
  and	ie_agrupador			<> 1
order by a.nr_agrupamento,
	a.nr_sequencia;

C03 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_agrupamento
FROM material b, prescr_material a
LEFT OUTER JOIN via_aplicacao c ON (a.ie_via_aplicacao = c.ie_via_aplicacao)
WHERE a.nr_prescricao 		= nr_prescricao_p and a.cd_material			= b.cd_material  and ie_agrupador			<> 1 Order by c.nr_impressao,
	a.ie_via_aplicacao,
	b.ds_material,
	a.nr_agrupamento,
	a.nr_sequencia;

C05 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_agrupamento
FROM prescr_material a, material b
LEFT OUTER JOIN material_familia c ON (b.nr_seq_familia = c.nr_sequencia)
WHERE a.nr_prescricao 		= nr_prescricao_p and a.cd_material			= b.cd_material  and ie_tipo_material		> 1 and ie_agrupador			= 1 and coalesce(nr_sequencia_dieta::text, '') = '' and coalesce(nr_sequencia_proc::text, '') = '' and coalesce(nr_sequencia_solucao::text, '') = '' and coalesce(nr_sequencia_diluicao::text, '') = '' Order by c.nr_sequencia,
	a.ie_via_aplicacao,
	b.ds_material,
	a.nr_agrupamento,
	a.nr_sequencia;


BEGIN

select	cd_estabelecimento,
	nm_usuario_original
into STRICT	cd_estabelecimento_w,
	nm_usuario_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

ie_ordena_via_w := Obter_Param_Usuario(924, 157, obter_perfil_ativo, nm_usuario_w, cd_estabelecimento_w, ie_ordena_via_w);

Select	coalesce(Max(nr_agrupamento),0)
into STRICT	nr_agrupamento_ww
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and 	ie_agrupador = 1;

nr_agrup_base_w		:= -1;

if (ie_ordena_via_w = 'S') then
	begin
	OPEN C01;
	LOOP
	FETCH C01 INTO
		nr_sequencia_w,
		nr_agrupamento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (nr_agrupamento_w	<> nr_agrup_base_w) then
			nr_agrupamento_ww	:= nr_agrupamento_ww + 1;
			nr_agrup_base_w		:= nr_agrupamento_w;
		end if;

		update	prescr_material
		set	nr_agrupamento	= nr_agrupamento_ww
		where	nr_prescricao	= nr_prescricao_p
	  	and	nr_sequencia	= nr_sequencia_w;
		end;
	END LOOP;
	CLOSE C01;
	end;

elsif (ie_ordena_via_w = 'D')	 then
	begin
	OPEN C03;
	LOOP
	FETCH C03 INTO
		nr_sequencia_w,
		nr_agrupamento_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		if (nr_agrupamento_w	<> nr_agrup_base_w) then
			nr_agrupamento_ww	:= nr_agrupamento_ww + 1;
			nr_agrup_base_w		:= nr_agrupamento_w;
		end if;

		update	prescr_material
		set	nr_agrupamento	= nr_agrupamento_ww
		where	nr_prescricao	= nr_prescricao_p
	  	and	nr_sequencia	= nr_sequencia_w;
		end;
	END LOOP;
	CLOSE C03;
	end;
elsif (ie_ordena_via_w = 'F')	 then
	begin
	OPEN C05;
	LOOP
	FETCH C05 INTO
		nr_sequencia_w,
		nr_agrupamento_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		if (nr_agrupamento_w	<> nr_agrup_base_w) then
			nr_agrupamento_ww	:= nr_agrupamento_ww + 1;
			nr_agrup_base_w		:= nr_agrupamento_w;
		end if;

		update	prescr_material
		set	nr_agrupamento	= nr_agrupamento_ww
		where	nr_prescricao	= nr_prescricao_p
	  	and	nr_sequencia	= nr_sequencia_w;
		end;
	END LOOP;
	CLOSE C05;
	end;
else
	begin
	OPEN C02;
	LOOP
	FETCH C02 INTO
		nr_sequencia_w,
		nr_agrupamento_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		if (nr_agrupamento_w	<> nr_agrup_base_w) then
			nr_agrupamento_ww	:= nr_agrupamento_ww + 1;
			nr_agrup_base_w		:= nr_agrupamento_w;
		end if;

		update	prescr_material
		set	nr_agrupamento	= nr_agrupamento_ww
		where	nr_prescricao	= nr_prescricao_p
	  	and	nr_sequencia	= nr_sequencia_w;
		end;
	END LOOP;
	CLOSE C02;
	end;
end if;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reordenar_materiais_pos_copia (nr_prescricao_p bigint) FROM PUBLIC;

