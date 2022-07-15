-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_dose_terapeutica (cd_estabelecimento_p bigint, nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_solic_medic_p text, cd_pessoa_fisica_p text, cd_material_p bigint, qt_dose_p bigint, nr_unidade_terp_p bigint, qt_peso_p bigint, nm_usuario_p text, ie_acao_p INOUT text, ds_mensagem_p INOUT text) AS $body$
DECLARE



qt_dose_min_aviso_w		double precision;
qt_dose_max_aviso_w		double precision;
qt_dose_min_bloqueia_w		double precision;
qt_dose_max_bloqueia_w		double precision;
qt_existe_regra_w		bigint;
qt_idade_w			bigint;
cd_setor_atendimento_w		integer;
nr_atendimento_w			bigint;

C01 CURSOR FOR
	SELECT	coalesce(qt_dose_min_aviso,0),
			coalesce(qt_dose_max_aviso,9999999999),
			coalesce(qt_dose_min_bloqueia,0),
			coalesce(qt_dose_max_bloqueia,9999999999)
	from		material_dose_terap
	where	cd_estabelecimento	= cd_estabelecimento_p
	and		cd_material		= cd_material_p
	and		nr_seq_dose_terap	= nr_unidade_terp_p
	and		qt_idade_w between Obter_idade_dose_ter(nr_sequencia,'MIN') and Obter_idade_dose_ter(nr_sequencia,'MAX')
	and		coalesce(qt_peso_p,0) between coalesce(qt_peso_minimo,0) and coalesce(qt_peso_maximo,9999)
	and		coalesce(cd_setor_atendimento,cd_setor_atendimento_w)	= cd_setor_atendimento_w
	and		((coalesce(cd_doenca_cid::text, '') = '') or (obter_se_cid_atendimento(nr_atendimento_w,cd_doenca_cid) = 'S'))
	order by coalesce(cd_setor_atendimento,0),
		coalesce(qt_idade_minima,0),
		coalesce(qt_idade_maxima,0),
		coalesce(qt_peso_minimo,0),
		coalesce(qt_peso_maximo,0);



BEGIN


ie_acao_p	:= '';
ds_mensagem_p	:= '';


select	count(*)
into STRICT	qt_existe_regra_w
from	material_dose_terap
where	cd_estabelecimento	= cd_estabelecimento_p;

if (qt_existe_regra_w > 0) and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin
	qt_dose_min_aviso_w	:= null;

	select	obter_idade(dt_nascimento,coalesce(dt_obito,clock_timestamp()),'DIA')
	into STRICT	qt_idade_w
	from	pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

	select	max(nr_atendimento),
			coalesce(max(cd_setor_atendimento),0)
	into STRICT		nr_atendimento_w,
			cd_setor_atendimento_w
	from		prescr_medica
	where	nr_prescricao	= nr_prescricao_p;

	OPEN C01;
	LOOP
	FETCH C01 into
		qt_dose_min_aviso_w,
		qt_dose_max_aviso_w,
		qt_dose_min_bloqueia_w,
		qt_dose_max_bloqueia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		qt_dose_min_aviso_w	:= qt_dose_min_aviso_w;
		qt_dose_max_aviso_w	:= qt_dose_max_aviso_w;
		qt_dose_min_bloqueia_w	:= qt_dose_min_bloqueia_w;
		qt_dose_max_bloqueia_w	:= qt_dose_max_bloqueia_w;
		end;
	END LOOP;
	close c01;

	if (qt_dose_min_aviso_w IS NOT NULL AND qt_dose_min_aviso_w::text <> '') then
		begin
		if (qt_dose_p < qt_dose_min_bloqueia_w) or (qt_dose_p > qt_dose_max_bloqueia_w) then
			begin
			ie_acao_p	:= 'B';
			-- 290366 "A dose terapêutica informada esta fora da faixa liberada pela farmácia desta instituição. Mínimo: #@QT_DOSE_MIN_BLOQUEIA#@ Máximo: #@QT_DOSE_MAX_BLOQUEIA#@."
			ds_mensagem_p	:= wheb_mensagem_pck.get_texto(290366,	'QT_DOSE_MIN_BLOQUEIA='||to_char(qt_dose_min_bloqueia_w)||
										';QT_DOSE_MAX_BLOQUEIA='||to_char(qt_dose_max_bloqueia_w));
			end;
		elsif (qt_dose_p < qt_dose_min_aviso_w) or (qt_dose_p > qt_dose_max_aviso_w) then
			begin
			ie_acao_p	:= 'A';
			-- 290380 "A dose terapêutica informada esta fora da faixa considerada normal pela farmácia desta instituição. Mínimo: #@QT_DOSE_MIN_AVISO#@ Máximo: #@QT_DOSE_MAX_AVISO#@."
			ds_mensagem_p	:= wheb_mensagem_pck.get_texto(290380,	'QT_DOSE_MIN_AVISO='||to_char(qt_dose_min_aviso_w)||
										';QT_DOSE_MAX_AVISO='||to_char(qt_dose_max_aviso_w));
			end;
		end if;
		end;
	end if;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_dose_terapeutica (cd_estabelecimento_p bigint, nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_solic_medic_p text, cd_pessoa_fisica_p text, cd_material_p bigint, qt_dose_p bigint, nr_unidade_terp_p bigint, qt_peso_p bigint, nm_usuario_p text, ie_acao_p INOUT text, ds_mensagem_p INOUT text) FROM PUBLIC;

