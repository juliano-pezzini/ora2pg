-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hfp_atualizar_risco ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


--atributos
ie_segmento_st_w		varchar(1);	-- infradesnivel
ie_capacidade_funcional_w	varchar(1);	-- capacidade funcional
ie_fracao_ejecao_w		varchar(1);	-- fração ejeção
ie_hemodinamica_anormal_w	varchar(1);	-- hemodinamica anormal no esforço
ie_angina_w			varchar(1);	-- angina ou outros sintomas significativos
ie_arritmia_ventr_w		varchar(1);	-- arritmia ventricular
ie_historio_pcr_w		varchar(1);	-- historico pcr
ie_iam_complicado_w		varchar(1);	-- iam complicado
ie_proced_reavas_w		varchar(1);	-- procedimento de revascularizacao
ie_sinais_sintomas_w		varchar(1);	-- sinais e sintomas de isquemias
ie_depressao_clinica_w		varchar(1);	-- depressao clinica
ie_nivel_risco_w		varchar(1);	-- nivel de risco calculado
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	ie_segmento_st,
		ie_capacidade_funcional,
		ie_fracao_ejecao,
		ie_hemodinamica_anormal,
		ie_angina,
		ie_arritmia_ventr,
		ie_historio_pcr,
		ie_iam_complicado,
		ie_proced_reavas,
		ie_sinais_sintomas,
		ie_depressao_clinica
	into STRICT	ie_segmento_st_w,
		ie_capacidade_funcional_w,
		ie_fracao_ejecao_w,
		ie_hemodinamica_anormal_w,
		ie_angina_w,
		ie_arritmia_ventr_w,
		ie_historio_pcr_w,
		ie_iam_complicado_w,
		ie_proced_reavas_w,
		ie_sinais_sintomas_w,
		ie_depressao_clinica_w
	from	hfp_parecer_medico
	where	nr_sequencia = nr_sequencia_p;

	-- Verificação Nivel Risco Alto
	ie_nivel_risco_w := 'B';  -- Baixo como inicial
	if (ie_arritmia_ventr_w = 'S') or		-- Verifica se Nivel Alto
		(ie_angina_w = 'A') or (ie_segmento_st_w = 'A') or (ie_hemodinamica_anormal_w = 'S') or (ie_fracao_ejecao_w = 'A') or (ie_historio_pcr_w = 'S') or (ie_iam_complicado_w = 'S') or (ie_proced_reavas_w = 'S') or (ie_sinais_sintomas_w = 'S') or (ie_depressao_clinica_w = 'S') then
		ie_nivel_risco_w := 'A';
	elsif (ie_angina_w = 'M') or			-- Verifica se Nivel Moderado
		(ie_segmento_st_w = 'M') or (ie_capacidade_funcional_w = 'M') or (ie_fracao_ejecao_w = 'M') then
		ie_nivel_risco_w := 'M';
	end if;

	update	hfp_parecer_medico
	set	ie_nivel_risco = ie_nivel_risco_w,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hfp_atualizar_risco ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
