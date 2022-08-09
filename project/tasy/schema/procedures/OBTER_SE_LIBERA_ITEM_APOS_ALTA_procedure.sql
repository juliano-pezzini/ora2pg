-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_se_libera_item_apos_alta (nr_prescricao_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, ie_libera_p INOUT text) AS $body$
DECLARE


ds_mensagem_w	varchar(255)	:= '';
ie_permite_w	varchar(2) 	:= 'S';
possui_reg_w	bigint	:= 0;
qt_coletas_w	bigint	:= 0;
qt_glicemia_w	bigint	:= 0;
qt_dieta_w	bigint	:= 0;
qt_gas_w	bigint	:= 0;
qt_hemoterapia_w bigint	:= 0;
qt_ivc_w	 bigint	:= 0;
qt_jejum_w	 bigint	:= 0;
qt_leite_w	bigint	:= 0;
qt_material_w	bigint	:= 0;
qt_medicamento_w bigint	:= 0;
qt_npt_adulta_w	 bigint	:= 0;
qt_npt_neo_w     bigint	:= 0;
qt_proced_w	 bigint	:= 0;
qt_recomendacao_w bigint	:= 0;
qt_solucao_w	  bigint	:= 0;
qt_suplemento_w	  bigint	:= 0;
qt_suporte_w	  bigint	:= 0;
qt_dialise_w	  bigint	:= 0;
quebra_w	varchar(10)	:= chr(13)||chr(10);


BEGIN


select	count(ie_permite)
into STRICT	possui_reg_w
from	plt_regra_lib_apos_alta
where	ie_permite = 'N';

if (possui_reg_w > 0)	then

	--  Início Coletas
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 20;

	if (ie_permite_w = 'N') then
		select	count(nr_seq_exame)
		into STRICT	qt_coletas_w
		from	prescr_procedimento
		where	nr_prescricao = nr_prescricao_p
		and	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '')
		and	coalesce(nr_seq_solic_sangue::text, '') = ''
		and	coalesce(nr_seq_derivado::text, '') = ''
		and	coalesce(nr_seq_exame_sangue::text, '') = '';

		if (qt_coletas_w > 0) then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,20),1,50) ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''||substr(obter_valor_dominio(3270,20),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim coletas
	--  Início Controle de glicemia
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 18;

	if (ie_permite_w = 'N') then
		select	count(nr_seq_prot_glic)
		into STRICT	qt_glicemia_w
		from	prescr_procedimento
		where	nr_prescricao = nr_prescricao_p
		and	(nr_seq_prot_glic IS NOT NULL AND nr_seq_prot_glic::text <> '');

		if (qt_glicemia_w > 0)  then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,18),1,50) ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''||substr(obter_valor_dominio(3270,18),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim Controle de Glicemia
	-- Início Dieta
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 2;

	if (ie_permite_w = 'N') then
		select	count(cd_dieta)
		into STRICT	qt_dieta_w
		from	prescr_Dieta
		where	nr_prescricao = nr_prescricao_p;

		if (qt_dieta_w > 0)	then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,2),1,50) ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''||substr(obter_valor_dominio(3270,2),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;

	end if;

	-- Fim Dieta
	--Início Gasoterapia
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 3;

	if (ie_permite_w = 'N') then
		select	count(nr_seq_gas)
		into STRICT	qt_gas_w
		from	prescr_gasoterapia
		where	nr_prescricao	= nr_prescricao_p;

		if (qt_gas_w > 0)	then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,3),1,50) ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''||substr(obter_valor_dominio(3270,3),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim Gasoterapia
	-- Início Hemoterapia
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 4;

	if (ie_permite_w = 'N') then
		select	count(nr_seq_derivado)
		into STRICT	qt_hemoterapia_w
		from	prescr_procedimento
		where	nr_prescricao = nr_prescricao_p
		and	coalesce(nr_seq_exame::text, '') = ''
		and	(nr_seq_solic_sangue IS NOT NULL AND nr_seq_solic_sangue::text <> '')
		and	((nr_seq_derivado IS NOT NULL AND nr_seq_derivado::text <> '') or (Obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'AT') = 'S') or (Obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'BSST') = 'S') or (Obter_se_exibe_proced(nr_prescricao,nr_sequencia,ie_tipo_proced,'BS') = 'S'))
		and	coalesce(nr_seq_exame_sangue::text, '') = '';

		if (qt_hemoterapia_w > 0)	then

			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,4),1,50) ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''||substr(obter_valor_dominio(3270,4),1,50)||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;

	end if;

	-- Fim Hemoterapia
	-- Início IVC
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 19;

	if (ie_permite_w = 'N') then
		select	count(w.ie_ivc)
		into STRICT	qt_ivc_w
		from	proc_interno w,
			prescr_procedimento x
		where	x.nr_prescricao = nr_prescricao_p
		and	w.nr_sequencia = x.nr_seq_proc_interno
		and	w.ie_tipo <> 'G'
		and	w.ie_tipo <> 'BS'
		and	w.ie_ivc = 'S'
		and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
		and	coalesce(x.nr_seq_prot_glic::text, '') = ''
		and	coalesce(x.nr_seq_exame::text, '') = ''
		and	coalesce(x.nr_seq_solic_sangue::text, '') = ''
		and	coalesce(x.nr_seq_derivado::text, '') = '';

		if (qt_ivc_w > 0)	then

			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,19),1,50) ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''||substr(obter_valor_dominio(3270,19),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim IVC
	-- Início Jejum
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 5;

	if (ie_permite_w = 'N') then
		select	count(nr_seq_tipo)
		into STRICT	qt_jejum_w
		from	rep_jejum
		where	nr_prescricao = nr_prescricao_p;

		if (qt_jejum_w > 0) 	then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,5),1,50) ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''||substr(obter_valor_dominio(3270,5),1,50) ||quebra_w;
			end if;
		ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim Jejum
	-- Início Leite e Derivados
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 21;

	if (ie_permite_w = 'N') then
		select	count(nr_sequencia)
		into STRICT	qt_leite_w
		from	prescr_leite_deriv
		where	nr_prescricao 	= nr_prescricao_p;

		if (qt_leite_w > 0)	then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,21),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w || ''||substr(obter_valor_dominio(3270,21),1,50) ||quebra_w;
			end if;
		ie_libera_p  := 'N';
		end if;

	end if;

	-- Fim Leite e Derivados
	-- Início Materiais
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 6;

	if (ie_permite_w = 'N') then
		select	count(nr_sequencia)
		into STRICT	qt_material_w
		from	prescr_material
		where	nr_prescricao 	= nr_prescricao_p
		and	ie_agrupador = 2;

		if (qt_material_w > 0) then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,6),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w || ''||substr(obter_valor_dominio(3270,6),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim materiis
	-- Início medicamentos
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  =	7;

	if (ie_permite_w = 'N') then
		select	count(nr_sequencia)
		into STRICT	qt_medicamento_w
		from	prescr_material
		where	nr_prescricao 	= nr_prescricao_p
		and	ie_agrupador = 1;

		if (qt_medicamento_w > 0) then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,7),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w || ''||substr(obter_valor_dominio(3270,7),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim medicamentos
	-- Início npt Adulta
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  =	8;

	if (ie_permite_w = 'N') then
		select	count(nr_sequencia)
		into STRICT	qt_npt_adulta_w
		from	nut_pac
		where	nr_prescricao	= nr_prescricao_p
		and	coalesce(ie_npt_adulta,'N') = 'S';

		if (qt_npt_adulta_w > 0)	then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,8),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w || ''||substr(obter_valor_dominio(3270,8),1,50)||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim npt Adulta
	-- Início npt neo
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  =	9;

	if (ie_permite_w = 'N') then
		select	count(nr_sequencia)
		into STRICT	qt_npt_neo_w
		from	nut_pac
		where	nr_prescricao	= nr_prescricao_p
		and	coalesce(ie_npt_adulta,'N') = 'N';

		if (qt_npt_neo_w > 0)	then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,9),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w || ''||substr(obter_valor_dominio(3270,9),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim npt neo
	-- Início procedimento
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  =	12;

	if (ie_permite_w = 'N')	then
		select	count(nr_sequencia)
		into STRICT	qt_proced_w
		from	prescr_procedimento
		where	nr_prescricao = nr_prescricao_p
		and	coalesce(nr_seq_exame::text, '') = ''
		and	coalesce(nr_seq_solic_sangue::text, '') = ''
		and	coalesce(nr_seq_derivado::text, '') = ''
		and	coalesce(nr_seq_exame_sangue::text, '') = ''
		and	coalesce(nr_seq_origem::text, '') = ''
		and	coalesce(nr_seq_prot_glic::text, '') = '';

		if (qt_proced_w > 0)	then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,12),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w || ''||substr(obter_valor_dominio(3270,12),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim procedimento
	-- Início Recomendação
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 13;

	if (ie_permite_w = 'N')	then
		select	count(nr_sequencia)
		into STRICT	qt_recomendacao_w
		from	prescr_recomendacao
		where	nr_prescricao = nr_prescricao_p;

		if (qt_recomendacao_w > 0) then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,13),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w || ''||substr(obter_valor_dominio(3270,13),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim Recomendação
	-- Início Solução
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 16;

	if (ie_permite_w = 'N') 	then
		select	count(nr_seq_solucao)
		into STRICT	qt_solucao_w
		from	prescr_solucao
		where	nr_prescricao = nr_prescricao_p
		and	coalesce(nr_seq_dialise::text, '') = '';

		if (qt_solucao_w > 0) then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,16),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w || ''||substr(obter_valor_dominio(3270,16),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;

	end if;

	-- FIm Solução
	-- Início Suplemento
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 15;

	if (ie_permite_w	= 'N')	then
		select	count(nr_sequencia)
		into STRICT	qt_suplemento_w
		from	prescr_material
		where	nr_prescricao 	= nr_prescricao_p
		and	ie_agrupador = 12;

		if (qt_suplemento_w > 0) then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,15),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''||substr(obter_valor_dominio(3270,15),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- FIm Suplemento
	-- Início Suporte
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 14;

	if (ie_permite_w	= 'N')	then
		select	count(nr_sequencia)
		into STRICT	qt_suporte_w
		from	prescr_material
		where	nr_prescricao 	= nr_prescricao_p
		and	ie_agrupador = 8;

		if (qt_suporte_w > 0) then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,14),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''||substr(obter_valor_dominio(3270,14),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;
	end if;

	-- Fim Suporte
	-- Início Diálise
	select	coalesce(max(ie_permite),'S')
	into STRICT	ie_permite_w
	from	plt_regra_lib_apos_alta
	where	ie_tipo_item  = 1;

	if (ie_permite_w = 'N') then
		select	count(ie_tipo_dialise)
		into STRICT	qt_dialise_w
		from	hd_prescricao
		where	nr_prescricao = nr_prescricao_p
		and	ie_tipo_dialise in ('H','P');

		if (qt_dialise_w > 0) then
			if (coalesce(ds_mensagem_w::text, '') = '') then
				ds_mensagem_w := substr(obter_valor_dominio(3270,1),1,50)  ||quebra_w;
			else
				ds_mensagem_w := ds_mensagem_w ||''|| substr(obter_valor_dominio(3270,1),1,50) ||quebra_w;
			end if;
			ie_libera_p  := 'N';
		end if;

	end if;

	-- FIm Diálise
end if;
if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') and (ie_libera_p = 'N') then
	ds_mensagem_p :=  substr(/*'Conforme regra não é permitido liberar os seguintes itens após alta médica : '*/
 obter_desc_expressao(782116)||' '||quebra_w|| ds_mensagem_w,1,255);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_se_libera_item_apos_alta (nr_prescricao_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, ie_libera_p INOUT text) FROM PUBLIC;
