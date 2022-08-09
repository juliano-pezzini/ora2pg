-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_consulta_res_manual ( nr_atendimento_p bigint, nr_seq_prontuario_p text default null, cd_transacao_p bigint DEFAULT NULL, ie_regra_p text DEFAULT NULL, ds_lista_p text DEFAULT NULL, qt_dias_p bigint DEFAULT NULL) AS $body$
DECLARE




ds_tipo_area_w			varchar(10);
tamanho_lista_w			bigint;
posicao_virgula_w 		smallint;
nr_max_loop_w			smallint := 9999;
ds_lista_w 				varchar(10000);
ie_tipo_info_hsf_w		varchar(1) := 'N';
ie_tipo_info_hsa_w		varchar(1) := 'N';
ie_tipo_info_at_w		varchar(1) := 'N';
ie_tipo_info_ei_w		varchar(1) := 'N';
ie_tipo_info_el_w		varchar(1) := 'N';
ie_tipo_info_hsh_w		varchar(1) := 'N';
ie_tipo_info_im_w		varchar(1) := 'N';
ie_tipo_info_me_w		varchar(1) := 'N';
ie_tipo_info_edp_w		varchar(1) := 'N';
ie_tipo_info_di_w		varchar(1) := 'N';
ie_tipo_info_pr_w		varchar(1) := 'N';
ie_tipo_info_ts_w		varchar(1) := 'N';
ie_tipo_info_sva_w		varchar(1) := 'N';





BEGIN
if (ds_lista_p IS NOT NULL AND ds_lista_p::text <> '') then
	begin
	tamanho_lista_w := length(ds_lista_p);
	ds_lista_w := ds_lista_p;

	while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') and (nr_max_loop_w > 0) loop
		begin
		posicao_virgula_w := position(',' in ds_lista_w);
		if (posicao_virgula_w > 1) and ((substr(ds_lista_w, 1, posicao_virgula_w -1) IS NOT NULL AND (substr(ds_lista_w, 1, posicao_virgula_w -1))::text <> '')) then
			begin
			ds_tipo_area_w := to_char(substr(ds_lista_w, 1, posicao_virgula_w -1));
			ds_lista_w := substr(ds_lista_w, posicao_virgula_w +1, tamanho_lista_w);
			end;
		elsif (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') then
			begin
			ds_tipo_area_w := replace(ds_lista_w, ',', '');
			ds_lista_w := '';
			end;
		end if;

		if (ds_tipo_area_w IS NOT NULL AND ds_tipo_area_w::text <> '') then

			if (ds_tipo_area_w = 'HSF') then

				ie_tipo_info_hsf_w := 'S';

			elsif (ds_tipo_area_w = 'HSA') then

				ie_tipo_info_HSA_w := 'S';

			elsif (ds_tipo_area_w = 'AT') then

				ie_tipo_info_AT_w := 'S';

			elsif (ds_tipo_area_w = 'EI') then

				ie_tipo_info_EI_w := 'S';

			elsif (ds_tipo_area_w = 'EI') then

				ie_tipo_info_EI_w := 'S';

			elsif (ds_tipo_area_w = 'EL') then

				ie_tipo_info_EL_w := 'S';

			elsif (ds_tipo_area_w = 'HSH') then

				ie_tipo_info_HSH_w := 'S';

			elsif (ds_tipo_area_w = 'IM') then

				ie_tipo_info_IM_w := 'S';

			elsif (ds_tipo_area_w = 'ME') then

				ie_tipo_info_ME_w := 'S';

			elsif (ds_tipo_area_w = 'EDP') then

				ie_tipo_info_EDP_w := 'S';

			elsif (ds_tipo_area_w = 'DI') then

				ie_tipo_info_DI_w := 'S';

			elsif (ds_tipo_area_w = 'PR') then

				ie_tipo_info_PR_w := 'S';

			elsif (ds_tipo_area_w = 'SVA') then

				ie_tipo_info_SVA_w := 'S';

			elsif (ds_tipo_area_w = 'TS') then

				ie_tipo_info_TS_w := 'S';
			end if;
		end if;

		nr_max_loop_w := nr_max_loop_w -1;
		end;
	end loop;


	CALL gerar_consulta_res( nr_atendimento_p,
						nr_seq_prontuario_p,
						cd_transacao_p,
						ie_regra_p,
						IE_TIPO_INFO_HSF_w,
						qt_dias_p,
						IE_TIPO_INFO_HSA_w,
						qt_dias_p,
						IE_TIPO_INFO_AT_w,
						qt_dias_p,
						IE_TIPO_INFO_EI_w,
						qt_dias_p,
						IE_TIPO_INFO_EL_w,
						qt_dias_p,
						IE_TIPO_INFO_HSH_w,
						qt_dias_p,
						IE_TIPO_INFO_IM_w,
						qt_dias_p,
						IE_TIPO_INFO_ME_w,
						qt_dias_p,
						IE_TIPO_INFO_EDP_w,
						qt_dias_p,
						IE_TIPO_INFO_DI_w,
						qt_dias_p,
						IE_TIPO_INFO_PR_w,
						qt_dias_p,
						IE_TIPO_INFO_TS_w,
						qt_dias_p,
						IE_TIPO_INFO_SVA_w,
						qt_dias_p);

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_consulta_res_manual ( nr_atendimento_p bigint, nr_seq_prontuario_p text default null, cd_transacao_p bigint DEFAULT NULL, ie_regra_p text DEFAULT NULL, ds_lista_p text DEFAULT NULL, qt_dias_p bigint DEFAULT NULL) FROM PUBLIC;
