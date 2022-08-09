-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consis_item_copart_liminar ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_segurado_p bigint, dt_referencia_p timestamp, ie_valor_zerado_p INOUT text, nr_seq_processo_copartic_p INOUT bigint) AS $body$
DECLARE


nr_seq_material_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_area_w			bigint;
cd_especialidade_w		bigint;
cd_grupo_w			bigint;
nr_seq_processo_jud_w		bigint;
nr_seq_processo_jud_copar_w	bigint;
qt_registros_w			bigint;
ie_tipo_despesa_w		varchar(10);
ie_valor_zerado_w		varchar(10);
nr_seq_contrato_w		bigint;


BEGIN

ie_valor_zerado_w	:= 'N';

select	max(nr_seq_contrato)
into STRICT	nr_seq_contrato_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

select	count(1)
into STRICT	qt_registros_w
from	processo_judicial_liminar
where	((nr_seq_segurado	= nr_seq_segurado_p) or (coalesce(nr_seq_segurado::text, '') = ''))
and	((nr_seq_contrato	= nr_seq_contrato_w) or (coalesce(nr_seq_contrato::text, '') = ''))
and	dt_referencia_p between coalesce(dt_inicio_validade,dt_referencia_p) and coalesce(dt_fim_validade,dt_referencia_p)
and	ie_estagio			= '2'
and	ie_impacto_coparticipacao	= 'S';

if (qt_registros_w > 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_processo_jud_w
	from	processo_judicial_liminar
	where	((nr_seq_segurado	= nr_seq_segurado_p) or (coalesce(nr_seq_segurado::text, '') = ''))
	and	((nr_seq_contrato	= nr_seq_contrato_w) or (coalesce(nr_seq_contrato::text, '') = ''))
	and	dt_referencia_p between coalesce(dt_inicio_validade,dt_referencia_p) and coalesce(dt_fim_validade,dt_referencia_p)
	and	ie_estagio			= '2'
	and	ie_impacto_coparticipacao	= 'S';

	select	max(nr_sequencia)
	into STRICT	nr_seq_processo_jud_copar_w
	from	pls_processo_jud_copartic
	where	nr_seq_processo	= nr_seq_processo_jud_w
	and	ie_isentar_coparticipacao	= 'S';

	if (nr_seq_processo_jud_copar_w IS NOT NULL AND nr_seq_processo_jud_copar_w::text <> '') then
		if (coalesce(nr_seq_conta_mat_p,0) <> 0) then
			select	nr_seq_material
			into STRICT	nr_seq_material_w
			from	pls_conta_mat
			where	nr_sequencia	= nr_seq_conta_mat_p;

			select	max(ie_tipo_despesa)
			into STRICT	ie_tipo_despesa_w
			from	pls_material
			where	nr_sequencia = nr_seq_material_w;

			select	count(1)
			into STRICT	qt_registros_w
			from	pls_processo_jud_mat
			where	nr_seq_processo_copartic	= nr_seq_processo_jud_copar_w
			and	((ie_tipo_despesa	= ie_tipo_despesa_w) or (coalesce(ie_tipo_despesa::text, '') = ''))
			and	((nr_seq_material	= nr_seq_material_w) or (coalesce(nr_seq_material::text, '') = ''));

			if (qt_registros_w > 0) then
				ie_valor_zerado_w	:= 'S';
			end if;

		elsif (coalesce(nr_seq_conta_proc_p, 0) <> 0) then
			select	cd_procedimento,
				ie_origem_proced
			into STRICT	cd_procedimento_w,
				ie_origem_proced_w
			from	pls_conta_proc
			where	nr_sequencia	= nr_seq_conta_proc_p;

			SELECT * FROM pls_obter_estrut_proc(cd_procedimento_w, ie_origem_proced_w, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w;

			select	count(1)
			into STRICT	qt_registros_w
			from	pls_processo_jud_proc
			where	nr_seq_processo_copartic			= nr_seq_processo_jud_copar_w
			and	coalesce(cd_procedimento,cd_procedimento_w)		= cd_procedimento_w
			and	coalesce(ie_origem_proced,ie_origem_proced_w) 	= ie_origem_proced_w
			and	coalesce(cd_grupo_proc,cd_grupo_w)			= cd_grupo_w
			and	coalesce(cd_especialidade, cd_especialidade_w)	= cd_especialidade_w
			and	coalesce(cd_area_procedimento, cd_area_w) 		= cd_area_w;

			if (qt_registros_w > 0) then
				ie_valor_zerado_w	:= 'S';
			end if;
		end if;
	end if;
end if;

if (ie_valor_zerado_w = 'S') then
	nr_seq_processo_copartic_p	:= nr_seq_processo_jud_copar_w;
end if;

ie_valor_zerado_p := coalesce(ie_valor_zerado_w, 'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consis_item_copart_liminar ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_segurado_p bigint, dt_referencia_p timestamp, ie_valor_zerado_p INOUT text, nr_seq_processo_copartic_p INOUT bigint) FROM PUBLIC;
