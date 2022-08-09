-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_gerar_dados_interf (cd_interface_p bigint, nr_prescricao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_limpar_tabela_p text default 'S') AS $body$
DECLARE


cMatrix CURSOR FOR
	SELECT	cd_tipo_registro,
			substr(ds_amostra,1,30) ds_amostra,
			substr(ie_reservado,1,6) ie_reservado,
			substr(ie_repeticao,1,1) ie_repeticao,
			substr(qt_diluicao,1,7) qt_diluicao,
			substr(cd_agrupamento,1,12) cd_agrupamento,
			substr(ie_reservado2,1,1) ie_reservado2,
			dt_coleta,
			substr(ie_prioridade,1,1) ie_prioridade,
			substr(cd_material,1,8) cd_material,
			substr(cd_instrumento,1,6) cd_instrumento,
			nr_prescricao,
			substr(nr_prescr_consulta,1,12) nr_prescr_consulta,
			ie_origem,
			substr(ds_exames,1,160) ds_exames,
			substr(nm_paciente,1,50) nm_paciente,
			substr(dt_idade,1,7) dt_idade,
			dt_nascimento,
			substr(ie_sexo,1,1) ie_sexo,
			substr(ie_cor,1,1) ie_cor,
			substr(cd_atributo,1,1) cd_atributo,
			substr(ds_valor,1,80) ds_valor,
			substr(ie_digito,1,2) ie_digito
	from	laboratorio_hrh_v
	where	nr_prescricao = nr_prescricao_p
	order by nr_prescricao,
		 cd_tipo_registro,
		 ds_amostra;

cLabLink CURSOR FOR
	SELECT	distinct cd_tipo_registro,
			CASE WHEN cd_tipo_registro='11' THEN  '0'  ELSE substr(ds_amostra,1,30) END  ds_amostra,
			substr(ie_reservado,1,6) ie_reservado,
			substr(ie_repeticao,1,1) ie_repeticao,
			substr(qt_diluicao,1,7) qt_diluicao,
			substr(cd_agrupamento,1,12) cd_agrupamento,
			substr(ie_reservado2,1,1) ie_reservado2,
			dt_coleta,
			substr(ie_prioridade,1,1) ie_prioridade,
			substr(cd_material,1,8) cd_material,
			substr(cd_instrumento,1,6) cd_instrumento,
			nr_prescricao,
			ie_origem,
			substr(ds_ie_origem,60) ds_ie_origem,
			substr(ds_exames,1,160) ds_exames,
			substr(nm_paciente,1,50) nm_paciente,
			substr(dt_idade,1,7) dt_idade,
			dt_nascimento,
			substr(ie_sexo,1,1) ie_sexo,
			substr(ie_cor,1,1) ie_cor,
			substr(cd_atributo,1,1) cd_atributo,
			substr(ds_valor,1,80) ds_valor,
			substr(ie_digito,1,2) ie_digito
	from	laboratorio_lablink_v
	where	nr_prescricao = nr_prescricao_p
	order by nr_prescricao,
		 cd_tipo_registro,
		 ds_amostra;

cLabLinkAnterior CURSOR FOR
SELECT cd_tipo_registro,
       substr(ds_amostra,1,30) ds_amostra,
       substr(ie_reservado,1,6) ie_reservado,
       substr(ie_repeticao,1,1) ie_repeticao,
       substr(qt_diluicao,1,7) qt_diluicao,
       substr(cd_agrupamento,1,12) cd_agrupamento,
       substr(ie_reservado2,1,1) ie_reservado2,
       dt_coleta,
       substr(ie_prioridade,1,1) ie_prioridade,
       substr(cd_material,1,8) cd_material,
       substr(cd_instrumento,1,6) cd_instrumento,
       nr_prescricao,
       ie_origem,
       '' ds_ie_origem,
       substr(ds_exames,1,160) ds_exames,
       substr(nm_paciente,1,50) nm_paciente,
       substr(dt_idade,1,7) dt_idade,
       dt_nascimento,
       substr(ie_sexo,1,1) ie_sexo,
       substr(ie_cor,1,1) ie_cor,
       substr(cd_atributo,1,1) cd_atributo,
       substr(ds_valor,1,80) ds_valor,
       substr(ie_digito,1,2) ie_digito,
       substr(RESULT_ANT,1,20) RESULT_ANT,
       substr(DS_EXAME_FILHO,1,10) DS_EXAME_FILHO ,
       substr(DS_OBSERVACAO,1,183) DS_OBSERVACAO,
       substr(DS_COLETA,1,15) DS_COLETA
 from  laboratorio_lablink_v2
 where nr_prescricao = nr_prescricao_p
 order by nr_prescricao,
          ds_amostra,
          cd_tipo_registro;

cMatrixAnterior CURSOR FOR
	SELECT	cd_tipo_registro,
			substr(ds_amostra,1,30) ds_amostra,
			substr(ie_repeticao,1,1) ie_repeticao,
			substr(qt_diluicao,1,7) qt_diluicao,
			substr(cd_agrupamento,1,12) cd_agrupamento,
			substr(ie_reservado2,1,1) ie_reservado2,
			dt_coleta,
			substr(ie_prioridade,1,1) ie_prioridade,
			substr(cd_material,1,8) cd_material,
			substr(cd_instrumento,1,6) cd_instrumento,
			nr_prescricao,
			substr(nr_prescr_consulta,1,12) nr_prescr_consulta,
			ie_origem,
			substr(ds_exames,1,160) ds_exames,
			substr(nm_paciente,1,50) nm_paciente,
			substr(dt_idade,1,7) dt_idade,
			dt_nascimento,
			substr(ie_sexo,1,1) ie_sexo,
			substr(ie_cor,1,1) ie_cor,
			substr(cd_atributo,1,8) cd_atributo,
			substr(ds_valor,1,80) ds_valor,
			substr(ie_digito,1,2) ie_digito,
			substr(cd_exame,1,8) cd_exame,
			substr(ds_resultado_ant,1,80) ds_resultado_ant,
			dt_prescricao,
			hr_prescricao
	from	laboratorio_hrh_v3
	where	nr_prescricao = nr_prescricao_p
	order by nr_prescricao,
		 cd_tipo_registro,
		 ds_amostra;

cMatrix_w		cMatrix%rowtype;
cLabLink_w		cLabLink%rowtype;
cLabLinkAnterior_w		cLabLinkAnterior%rowtype;
cMatrixAnterior_w		cMatrixAnterior%rowtype;
nr_sequencia_w	w_dados_interf.nr_sequencia%type;


BEGIN
	if coalesce(ie_limpar_tabela_p, 'S') = 'S' then
		delete
		from	w_dados_interf
		where	cd_estabelecimento = cd_estabelecimento_p
		  and	cd_interface = cd_interface_p
		  and	nm_usuario = nm_usuario_p;

		commit;
	end if;

	select	nextval('w_dados_interf_seq')
	into STRICT	nr_sequencia_w
	;

	if (cd_interface_p = 2816)  then

		open cMatrix;
		loop
		fetch cMatrix into
			cMatrix_w;
		EXIT WHEN NOT FOUND; /* apply on cMatrix */
			begin
				insert into w_dados_interf(
						nr_sequencia,
						cd_tipo_registro,
						ds_amostra,
						ie_reservado,
						ie_repeticao,
						qt_diluicao,
						cd_agrupamento,
						ie_reservado2,
						dt_coleta,
						ie_prioridade,
						cd_material,
						cd_instrumento,
						nr_prescricao,
						nr_prescr_consulta,
						ie_origem,
						ds_exames,
						nm_paciente,
						dt_idade,
						dt_nascimento,
						ie_sexo,
						ie_cor,
						cd_atributo,
						ds_valor,
						ie_digito,
						nm_usuario,
						cd_estabelecimento,
						cd_interface)
				values (
					nr_sequencia_w,
					to_char(cMatrix_w.cd_tipo_registro),
					cMatrix_w.ds_amostra,
					cMatrix_w.ie_reservado,
					cMatrix_w.ie_repeticao,
					cMatrix_w.qt_diluicao,
					cMatrix_w.cd_agrupamento,
					cMatrix_w.ie_reservado2,
					cMatrix_w.dt_coleta,
					cMatrix_w.ie_prioridade,
					cMatrix_w.cd_material,
					cMatrix_w.cd_instrumento,
					cMatrix_w.nr_prescricao,
					cMatrix_w.nr_prescr_consulta,
					to_char(cMatrix_w.ie_origem),
					cMatrix_w.ds_exames,
					cMatrix_w.nm_paciente,
					cMatrix_w.dt_idade,
					cMatrix_w.dt_nascimento,
					cMatrix_w.ie_sexo,
					cMatrix_w.ie_cor,
					cMatrix_w.cd_atributo,
					cMatrix_w.ds_valor,
					cMatrix_w.ie_digito,
					nm_usuario_p,
					cd_estabelecimento_p,
					cd_interface_p);
			end;
		end loop;
		close cMatrix;

		commit;

	elsif (cd_interface_p = 2839 or cd_interface_p = 2928) then
		open cLabLink;
		loop
		fetch cLabLink into
			cLabLink_w;
		EXIT WHEN NOT FOUND; /* apply on cLabLink */
			begin
				insert into w_dados_interf(
						nr_sequencia,
						cd_tipo_registro,
						ds_amostra,
						ie_reservado,
						ie_repeticao,
						qt_diluicao,
						cd_agrupamento,
						ie_reservado2,
						dt_coleta,
						ie_prioridade,
						cd_material,
						cd_instrumento,
						nr_prescricao,
						ie_origem,
						ds_ie_origem,
						ds_exames,
						nm_paciente,
						dt_idade,
						dt_nascimento,
						ie_sexo,
						ie_cor,
						cd_atributo,
						ds_valor,
						ie_digito,
						nm_usuario,
						cd_estabelecimento,
						cd_interface)
				values (
					nr_sequencia_w,
					to_char(cLabLink_w.cd_tipo_registro),
					cLabLink_w.ds_amostra,
					cLabLink_w.ie_reservado,
					cLabLink_w.ie_repeticao,
					cLabLink_w.qt_diluicao,
					cLabLink_w.cd_agrupamento,
					cLabLink_w.ie_reservado2,
					cLabLink_w.dt_coleta,
					cLabLink_w.ie_prioridade,
					cLabLink_w.cd_material,
					cLabLink_w.cd_instrumento,
					cLabLink_w.nr_prescricao,
					to_char(cLabLink_w.ie_origem),
					cLabLink_w.ds_ie_origem,
					cLabLink_w.ds_exames,
					cLabLink_w.nm_paciente,
					cLabLink_w.dt_idade,
					cLabLink_w.dt_nascimento,
					cLabLink_w.ie_sexo,
					cLabLink_w.ie_cor,
					cLabLink_w.cd_atributo,
					cLabLink_w.ds_valor,
					cLabLink_w.ie_digito,
					nm_usuario_p,
					cd_estabelecimento_p,
					cd_interface_p);
			end;
		end loop;
		close cLabLink;

		commit;
  elsif (cd_interface_p = 3213) then
		open cLabLinkAnterior;
		loop
		fetch cLabLinkAnterior into
			cLabLinkAnterior_w;
		EXIT WHEN NOT FOUND; /* apply on cLabLinkAnterior */
			begin
				insert into w_dados_interf(
						nr_sequencia,
						cd_tipo_registro,
						ds_amostra,
						ie_reservado,
						ie_repeticao,
						qt_diluicao,
						cd_agrupamento,
						ie_reservado2,
						dt_coleta,
						ie_prioridade,
						cd_material,
						cd_instrumento,
						nr_prescricao,
						ie_origem,
						ds_ie_origem,
						ds_exames,
						nm_paciente,
						dt_idade,
						dt_nascimento,
						ie_sexo,
						ie_cor,
						cd_atributo,
						ds_valor,
						ie_digito,
						nm_usuario,
						cd_estabelecimento,
						cd_interface,
            DS_OBSERVACAO,
            RESULT_ANT,
            DS_COLETA,
            DS_EXAME_FILHO)
				values (
					nr_sequencia_w,
					to_char(cLabLinkAnterior_w.cd_tipo_registro),
					cLabLinkAnterior_w.ds_amostra,
					cLabLinkAnterior_w.ie_reservado,
					cLabLinkAnterior_w.ie_repeticao,
					cLabLinkAnterior_w.qt_diluicao,
					cLabLinkAnterior_w.cd_agrupamento,
					cLabLinkAnterior_w.ie_reservado2,
					cLabLinkAnterior_w.dt_coleta,
					cLabLinkAnterior_w.ie_prioridade,
					cLabLinkAnterior_w.cd_material,
					cLabLinkAnterior_w.cd_instrumento,
					cLabLinkAnterior_w.nr_prescricao,
					to_char(cLabLinkAnterior_w.ie_origem),
					cLabLinkAnterior_w.ds_ie_origem,
					cLabLinkAnterior_w.ds_exames,
					cLabLinkAnterior_w.nm_paciente,
					cLabLinkAnterior_w.dt_idade,
					cLabLinkAnterior_w.dt_nascimento,
					cLabLinkAnterior_w.ie_sexo,
					cLabLinkAnterior_w.ie_cor,
					cLabLinkAnterior_w.cd_atributo,
					cLabLinkAnterior_w.ds_valor,
					cLabLinkAnterior_w.ie_digito,
					nm_usuario_p,
					cd_estabelecimento_p,
					cd_interface_p,
          cLabLinkAnterior_w.DS_OBSERVACAO,
          cLabLinkAnterior_w.RESULT_ANT,
          cLabLinkAnterior_w.DS_COLETA,
          cLabLinkAnterior_w.DS_EXAME_FILHO);

			end;
		end loop;
		close cLabLinkAnterior;

		commit;
  elsif (cd_interface_p = 3227) then
		open cMatrixAnterior;
		loop
		fetch cMatrixAnterior into
			cMatrixAnterior_w;
		EXIT WHEN NOT FOUND; /* apply on cMatrixAnterior */
			begin
				insert into w_dados_interf(
						nr_sequencia,
						cd_tipo_registro,
						ds_amostra,
						ie_repeticao,
						qt_diluicao,
						cd_agrupamento,
						ie_reservado2,
						dt_coleta,
						ie_prioridade,
						cd_material,
						cd_instrumento,
						nr_prescricao,
						nr_prescr_consulta,
						ie_origem,
						ds_exames,
						nm_paciente,
						dt_idade,
						dt_nascimento,
						ie_sexo,
						ie_cor,
						cd_atributo_matrix,
						ds_valor,
						ie_digito,
						cd_exame,
						ds_resultado_ant,
						dt_prescricao,
						hr_prescricao,
						nm_usuario,
						cd_estabelecimento,
						cd_interface)
				values (
					nr_sequencia_w,
					to_char(cMatrixAnterior_w.cd_tipo_registro),
					cMatrixAnterior_w.ds_amostra,
					cMatrixAnterior_w.ie_repeticao,
					cMatrixAnterior_w.qt_diluicao,
					cMatrixAnterior_w.cd_agrupamento,
					cMatrixAnterior_w.ie_reservado2,
					cMatrixAnterior_w.dt_coleta,
					cMatrixAnterior_w.ie_prioridade,
					cMatrixAnterior_w.cd_material,
					cMatrixAnterior_w.cd_instrumento,
					cMatrixAnterior_w.nr_prescricao,
					cMatrixAnterior_w.nr_prescr_consulta,
					to_char(cMatrixAnterior_w.ie_origem),
					cMatrixAnterior_w.ds_exames,
					cMatrixAnterior_w.nm_paciente,
					cMatrixAnterior_w.dt_idade,
					cMatrixAnterior_w.dt_nascimento,
					cMatrixAnterior_w.ie_sexo,
					cMatrixAnterior_w.ie_cor,
					cMatrixAnterior_w.cd_atributo,
					cMatrixAnterior_w.ds_valor,
					cMatrixAnterior_w.ie_digito,
					cMatrixAnterior_w.cd_exame,
					cMatrixAnterior_w.ds_resultado_ant,
					cMatrixAnterior_w.dt_prescricao,
					cMatrixAnterior_w.hr_prescricao,
					nm_usuario_p,
					cd_estabelecimento_p,
					cd_interface_p);

			end;
		end loop;
		close cMatrixAnterior;

		commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_gerar_dados_interf (cd_interface_p bigint, nr_prescricao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_limpar_tabela_p text default 'S') FROM PUBLIC;
