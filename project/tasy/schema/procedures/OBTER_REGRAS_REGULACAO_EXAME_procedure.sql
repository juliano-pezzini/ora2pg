-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regras_regulacao_exame ( nr_seq_exame_p bigint, nr_seq_exame_lab_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_material_exame_p text, nr_atendimento_p bigint default null, ie_exige_justi_p INOUT text DEFAULT NULL, nr_seq_aval_p INOUT bigint DEFAULT NULL, ds_mensagem_p INOUT text DEFAULT NULL, nr_seq_item_pos_p INOUT bigint DEFAULT NULL, ds_sql_p INOUT text DEFAULT NULL, ds_titulo_p INOUT text DEFAULT NULL, ds_documentacao_p INOUT text DEFAULT NULL) AS $body$
DECLARE


cd_grupo_proc_w				bigint;
cd_especialidade_w			bigint;
cd_area_procedimento_w		bigint;
nr_seq_grupo_exame_lab_w	bigint;

ie_justificar_w				varchar(1);
nr_seq_avaliacao_w			bigint;

ie_exige_justi_w			varchar(1);
nr_seq_aval_w				bigint;
ds_mensagem_w				varchar(255);
nr_seq_item_pos_w			bigint;

ds_sql_consulta_w			varchar(4000);
ds_titulo_consulta_w		varchar(80);
ds_documentacao_consulta_w	varchar(200);
ds_sql_w					varchar(4000);
ds_titulo_w					varchar(80);
ds_documentacao_w			varchar(200);

C01 CURSOR FOR
	SELECT 	b.ie_justificar,
			b.nr_seq_avaliacao,
			b.ds_sql,
			b.ds_titulo,
			b.ds_documentacao
	from	regra_regulacao a,
			regra_regulacao_itens b
	where	a.nr_sequencia = b.nr_seq_regra_reg
	and		a.ie_tipo = 'SE'
	and		coalesce(a.cd_procedimento, coalesce(cd_procedimento_p,0))			= coalesce(cd_procedimento_p,0)
	and		((coalesce(a.ie_origem_proced::text, '') = '') or (ie_origem_proced = coalesce(ie_origem_proced_p,ie_origem_proced)))
	and		coalesce(a.cd_area_procedimento, coalesce(cd_area_procedimento_w,0))	= coalesce(cd_area_procedimento_w,0)
	and		coalesce(a.cd_espec_proc, coalesce(cd_especialidade_w,0))		= coalesce(cd_especialidade_w,0)
	and		coalesce(a.cd_grupo_proc, coalesce(cd_grupo_proc_w,0))			= coalesce(cd_grupo_proc_w,0)
	and		coalesce(a.cd_grupo_proc, coalesce(cd_grupo_proc_w,0))			= coalesce(cd_grupo_proc_w,0)
	and		coalesce(a.nr_seq_proc_interno, coalesce(nr_seq_proc_interno_p,0))		= coalesce(nr_seq_proc_interno_p,0)
	and		coalesce(a.nr_seq_grupo, coalesce(nr_seq_grupo_exame_lab_w,0))	= coalesce(nr_seq_grupo_exame_lab_w,0)
	and		coalesce(a.nr_seq_exame, coalesce(nr_seq_exame_lab_p,0))			= coalesce(nr_seq_exame_lab_p,0)
	and		coalesce(a.nr_seq_exame_cad, coalesce(nr_seq_exame_p,0))			= coalesce(nr_seq_exame_p,0)
	and		coalesce(b.ie_situacao,'A') = 'A'
	and		obter_se_regulacao_regra_lib(a.ie_somente_ref,nr_atendimento_p,b.nr_sequencia) = 'S'
	and		((coalesce(trim(both a.cd_material_exame)::text, '') = '') or (trim(both a.cd_material_exame) = trim(both cd_material_exame_p)))
	order by   coalesce(a.cd_procedimento, 0),
				coalesce(a.cd_grupo_proc, 0),
				coalesce(a.cd_espec_proc, 0),
				coalesce(a.cd_area_procedimento, 0),
				coalesce(a.nr_seq_proc_interno,0),
				coalesce(a.nr_seq_grupo,0),
				coalesce(a.nr_seq_exame,0),
				coalesce(a.nr_seq_exame_cad,0);


BEGIN


select	max(cd_grupo_proc),
		max(cd_especialidade),
		max(cd_area_procedimento)
into STRICT	cd_grupo_proc_w,
		cd_especialidade_w,
		cd_area_procedimento_w
from	estrutura_procedimento_v
where	cd_procedimento		= cd_procedimento_p
and		ie_origem_proced	= ie_origem_proced_p;

select	max(nr_seq_grupo)
into STRICT	nr_seq_grupo_exame_lab_w
from	exame_laboratorio
where	nr_seq_exame	= nr_seq_exame_lab_p;


open C01;
loop
fetch C01 into
	ie_justificar_w,
	nr_seq_avaliacao_w,
	ds_sql_w,
	ds_titulo_w,
	ds_documentacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	  ie_exige_justi_w := ie_justificar_w;
	  nr_seq_aval_w := nr_seq_avaliacao_w;
	  ds_sql_consulta_w := ds_sql_w;
	  ds_titulo_consulta_w := ds_titulo_w;
	  ds_documentacao_consulta_w := ds_documentacao_w;
	end;
end loop;
close C01;

nr_seq_aval_p 	 	:= nr_seq_aval_w;
ie_exige_justi_p 	:= ie_exige_justi_w;
ds_mensagem_p		:= ds_mensagem_w;
nr_seq_item_pos_p	:= nr_seq_item_pos_w;
ds_sql_p	  		:= ds_sql_consulta_w;
ds_titulo_p			:= ds_titulo_consulta_w;
ds_documentacao_p	:= ds_documentacao_consulta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regras_regulacao_exame ( nr_seq_exame_p bigint, nr_seq_exame_lab_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_material_exame_p text, nr_atendimento_p bigint default null, ie_exige_justi_p INOUT text DEFAULT NULL, nr_seq_aval_p INOUT bigint DEFAULT NULL, ds_mensagem_p INOUT text DEFAULT NULL, nr_seq_item_pos_p INOUT bigint DEFAULT NULL, ds_sql_p INOUT text DEFAULT NULL, ds_titulo_p INOUT text DEFAULT NULL, ds_documentacao_p INOUT text DEFAULT NULL) FROM PUBLIC;
