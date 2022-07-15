-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_consiste_dose_limite_bfpost (cd_material_p bigint, nr_dias_receita_p bigint, qt_dose_p bigint, cd_unidade_medida_p text, cd_intervalo_p text, nr_ciclo_p bigint, nr_seq_receita_p bigint, ds_mensagem_p INOUT text, nm_usuario_p text, ie_just_nula_p text default 'S') AS $body$
DECLARE


ds_mensagem_w		varchar(4000);
ds_material_w		varchar(255);
qt_idade_w		bigint;
cd_pessoa_fisica_w	varchar(10);
qt_dose_minima_w	double precision;
qt_dose_maxima_w	double precision;
ie_dose_limite_w	varchar(15);
cd_unid_med_regra_w	varchar(30);
qt_operacao_w		bigint;
nr_ocorrencia_w		double precision;
nr_ciclo_w		integer;
qt_dose_w		double precision;
ie_justificativa_w	varchar(1);
ie_just_retorno_w	varchar(1) := 'N';

C01 CURSOR FOR
	SELECT	a.qt_dose_minima,
		a.qt_dose_maxima,
		coalesce(a.ie_dose_limite,'DOSE'),
		coalesce(a.cd_unidade_medida,cd_unidade_medida_p),
		coalesce(a.ie_justificativa,'N')
	from	fa_regra_limite_terap a,
		fa_medic_farmacia_amb b
	where	a.nr_seq_medic = b.nr_sequencia
	and	b.cd_material = cd_material_p
	and	coalesce(a.cd_intervalo,cd_intervalo_p) = cd_intervalo_p
	and	coalesce(a.nr_dias_utilizacao,nr_dias_receita_p) = nr_dias_receita_p
	and	coalesce(qt_idade_w,1) between coalesce(obter_idade_conversao(a.qt_idade_min,a.qt_idade_min_mes,a.qt_idade_min_dia,0,0,0,'MIN'),0) and
					coalesce(obter_idade_conversao(0,0,0,a.qt_idade_max,a.qt_idade_max_mes,a.qt_idade_max_dia,'MAX'),9999999)
	and	((coalesce(ie_just_nula_p,'N')	= 'S') or (a.ie_justificativa = 'N'))
	order by 1;

BEGIN

if (nr_seq_receita_p IS NOT NULL AND nr_seq_receita_p::text <> '') then
	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	fa_receita_farmacia
	where	nr_sequencia = nr_seq_receita_p;

	select	max(obter_idade(dt_nascimento,coalesce(dt_obito,clock_timestamp()),'DIA'))
	into STRICT	qt_idade_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;

	select	substr(obter_desc_material(cd_material_p),1,255)
	into STRICT	ds_material_w
	;

	qt_dose_w := qt_dose_p;

	open C01;
	loop
	fetch C01 into
		qt_dose_minima_w,
		qt_dose_maxima_w,
		ie_dose_limite_w,
		cd_unid_med_regra_w,
		ie_justificativa_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	CASE WHEN ie_just_retorno_w='N' THEN ie_justificativa_w  ELSE ie_just_retorno_w END
		into STRICT	ie_just_retorno_w
		;

		if (cd_unidade_medida_p <> cd_unid_med_regra_w) then
			qt_dose_w := Obter_dose_convertida(cd_material_p, qt_dose_p, cd_unidade_medida_p, cd_unid_med_regra_w);
		end if;

		if (ie_dose_limite_w = 'DIA') then
			-- Intervalo em horas
			select	coalesce(MAX(coalesce(qt_operacao_fa,qt_operacao)),0)
			into STRICT	qt_operacao_w
			from	intervalo_prescricao
			where	cd_intervalo = cd_intervalo_p
			and	ie_operacao = 'H';

			nr_ocorrencia_w := Obter_ocorrencia_intervalo(cd_intervalo_p,24,'O');

			select	nr_ocorrencia_w * qt_dose_w * CASE WHEN coalesce(nr_ciclo_p,1)=0 THEN 1  ELSE coalesce(nr_ciclo_p,1) END
			into STRICT	qt_dose_w
			;

		end if;

		if (qt_dose_w < qt_dose_minima_w) then
			ds_mensagem_w := ds_mensagem_w || '343290;'||ds_material_w||';'||qt_dose_minima_w||';'||cd_unid_med_regra_w||';'||lower(ie_dose_limite_w)||'|';
		elsif (qt_dose_w > qt_dose_maxima_w) then
			ds_mensagem_w := ds_mensagem_w || '343295;'||ds_material_w||';'||qt_dose_maxima_w||';'||cd_unid_med_regra_w||';'||lower(ie_dose_limite_w)||'|';
		end if;

		end;
	end loop;
	close C01;

	if	(ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '' AND ie_just_retorno_w = 'S') then
		ds_mensagem_p := ds_mensagem_w|| wheb_mensagem_pck.get_texto(343297); -- Favor informar a justificativa!
	else
		ds_mensagem_p := ds_mensagem_w;
	end if;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_consiste_dose_limite_bfpost (cd_material_p bigint, nr_dias_receita_p bigint, qt_dose_p bigint, cd_unidade_medida_p text, cd_intervalo_p text, nr_ciclo_p bigint, nr_seq_receita_p bigint, ds_mensagem_p INOUT text, nm_usuario_p text, ie_just_nula_p text default 'S') FROM PUBLIC;

