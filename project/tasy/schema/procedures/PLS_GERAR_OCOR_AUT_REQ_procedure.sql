-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_ocor_aut_req ( nr_seq_ocor_filtro_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text, ie_tipo_ocorrencia_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Rotina utilizada para validar as informacoes do da operadora executora (intercambio) com os filtros definidos na regra
de ocorrencia combinada
IE_TIPO_OCORRENCIA_W	= C - Gera a ocorrencia para o cabecalho
			= I - Gera ocorrencia para os itens
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: Performance
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 				

ie_gerar_ocorrencia_w		varchar(2)	:= 'N';
ie_regra_com_itens_w		varchar(1);
ie_tipo_processo_w		pls_requisicao.ie_tipo_processo%type;
nr_seq_ocor_aut_req_w		pls_ocor_aut_filtro_req.nr_sequencia%type;
dt_requisicao_w			pls_requisicao.dt_requisicao%type;
nr_seq_motivo_prorrogacao_w 	pls_motivo_prorrogacao_aut.nr_sequencia%type;
ie_consulta_urgencia_w		pls_requisicao.ie_consulta_urgencia%type;
ie_tipo_gat_w			pls_requisicao.ie_tipo_gat%type;
ie_ordem_servico_w		pls_ocor_aut_filtro_req.ie_ordem_servico%type;
nr_seq_motivo_inclusao_w	pls_requisicao.nr_seq_motivo_inclusao%type;
nr_seq_tipo_acomodacao_w	pls_requisicao.nr_seq_tipo_acomodacao%type;
nr_seq_guia_principal_w		pls_guia_plano.nr_sequencia%type;
ds_indicacao_clinica_w		pls_requisicao.ds_indicacao_clinica%type;
ie_hora_periodo_w		varchar(1);		
ie_tipo_guia_w			pls_requisicao.ie_tipo_guia%type;
nr_seq_prestador_w		pls_requisicao.nr_seq_prestador%type;
ie_diaria_permitida_w		varchar(1)	:= 'N';
qt_dia_solicitado_w		pls_requisicao.qt_dia_solicitado%type;
ie_carater_atendimento_w	pls_requisicao.ie_carater_atendimento%type;
ie_existe_anexo_w		integer;
ie_tipo_consulta_w		pls_requisicao.ie_tipo_consulta%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		vl_minimo,
		hr_inicial,
		hr_final,
		ie_guia_referencia,
		ie_exige_indicacao_clinica,
		ie_exige_prestador,
		ie_consiste_qt_diaria,
		ie_ordem_servico,
		ie_exige_anexo
	from	pls_ocor_aut_filtro_req
	where	nr_seq_ocor_aut_filtro	= nr_seq_ocor_filtro_p
	and	ie_situacao	= 'A'
	and (coalesce(ie_tipo_processo::text, '') = '' or ie_tipo_processo = ie_tipo_processo_w)
	and (coalesce(nr_seq_motivo_prorrogacao::text, '') = '' or nr_seq_motivo_prorrogacao = nr_seq_motivo_prorrogacao_w)
	and (coalesce(nr_seq_motivo_inclusao::text, '') = '' or nr_seq_motivo_inclusao = nr_seq_motivo_inclusao_w)
	and (coalesce(nr_seq_tipo_acomodacao::text, '') = '' or nr_seq_tipo_acomodacao = nr_seq_tipo_acomodacao_w)
	and (coalesce(ie_tipo_guia::text, '') = '' or ie_tipo_guia = ie_tipo_guia_w)
	and (coalesce(ie_val_dt_solic_futura,'N') = 'N' or (ie_val_dt_solic_futura = 'S' and dt_requisicao_w > clock_timestamp()))
	and (coalesce(ie_tipo_gat,'N') = 'N' or ie_tipo_gat = ie_tipo_gat_w)
	and (coalesce(ie_consulta_urgencia,'N') = 'N' or ie_consulta_urgencia = ie_consulta_urgencia_w)
	and (coalesce(ie_ordem_servico,'N') = 'N' or ie_ordem_servico = ie_ordem_servico_w)
	and (coalesce(ie_carater_atendimento::text, '') = '' or ie_carater_atendimento = ie_carater_atendimento_w)
	and (coalesce(ie_tipo_consulta::text, '') = '' or ie_tipo_consulta = ie_tipo_consulta_w);

BEGIN

if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	begin
			select	ie_tipo_processo,
				dt_requisicao,
				nr_seq_motivo_prorrogacao,
				ie_consulta_urgencia,
				ie_tipo_gat,
				nr_seq_motivo_inclusao,
				nr_seq_tipo_acomodacao,
				nr_seq_guia_principal,
				ds_indicacao_clinica,
				ie_tipo_guia,
				nr_seq_prestador,
				qt_dia_solicitado,
				ie_carater_atendimento,
				ie_tipo_consulta
			into STRICT	ie_tipo_processo_w,
				dt_requisicao_w,
				nr_seq_motivo_prorrogacao_w,
				ie_consulta_urgencia_w,
				ie_tipo_gat_w,
				nr_seq_motivo_inclusao_w,
				nr_seq_tipo_acomodacao_w,
				nr_seq_guia_principal_w,
				ds_indicacao_clinica_w,
				ie_tipo_guia_w,
				nr_seq_prestador_w,
				qt_dia_solicitado_w,
				ie_carater_atendimento_w,
				ie_tipo_consulta_w
			from	pls_requisicao			
			where	nr_sequencia 	= nr_seq_requisicao_p;
		
		select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
		into STRICT		ie_ordem_servico_w
		from		ptu_requisicao_ordem_serv
		where	nr_seq_requisicao = nr_seq_requisicao_p;
		
	exception
	when others then
		ie_tipo_processo_w		:= null;
		nr_seq_motivo_prorrogacao_w 	:= null;
	end;
end if;

for r_C01_w in  C01 loop
	begin

		ie_gerar_ocorrencia_w := 'S';
		
		if (r_C01_w.ie_exige_prestador	= 'S') then
			if (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
				ie_gerar_ocorrencia_w := 'N';
			end if;
		end if;
		
		if (coalesce(r_C01_w.vl_minimo, 0) > 0) then
			--A rotina ira verificar se a soma dos valores calculados e maior que a regra de valor minimo  e entao ira retornar 'S'
			ie_gerar_ocorrencia_w := pls_obter_se_valor_calculado(null, null, r_C01_w.vl_minimo, nr_seq_requisicao_p);					
		end if;
		
		if (r_C01_w.hr_inicial IS NOT NULL AND r_C01_w.hr_inicial::text <> '') and (r_C01_w.hr_final IS NOT NULL AND r_C01_w.hr_final::text <> '') then
			ie_hora_periodo_w := 	obter_se_datas_entre_periodo(to_date(to_char(r_C01_w.hr_inicial,'hh24:mi:ss'),'hh24:mi:ss'),
							to_date(to_char(r_C01_w.hr_final,'hh24:mi:ss'),'hh24:mi:ss'),
							to_date(to_char(dt_requisicao_w,'hh24:mi:ss'),'hh24:mi:ss'),
							to_date(to_char(dt_requisicao_w,'hh24:mi:ss'),'hh24:mi:ss'));
			if (ie_hora_periodo_w = 'N') then
				ie_gerar_ocorrencia_w := 'N';
			end if;
		end if;		
		
		if (coalesce(r_C01_w.ie_guia_referencia,'N') = 'S') then
			if (coalesce(nr_seq_guia_principal_w,0) <> 0) then
				ie_gerar_ocorrencia_w := 'N';
			end if;	
		end if;
		
		if (coalesce(r_C01_w.ie_exige_indicacao_clinica, 'N') = 'S') and (ds_indicacao_clinica_w IS NOT NULL AND ds_indicacao_clinica_w::text <> '') then
			ie_gerar_ocorrencia_w := 'N';
		end if;
		
		/*Regra para verificar a quantidade maxima de diarias que a guia de autorizacao podera ter */

		if	((coalesce(r_C01_w.ie_consiste_qt_diaria,'N') = 'S') and (ie_tipo_guia_w in ('1', '8'))) then
			ie_diaria_permitida_w := pls_obter_se_diarias_permitida(null,nr_seq_requisicao_p,null,coalesce(qt_dia_solicitado_w,0));
			if (ie_diaria_permitida_w = 'S') then
				ie_gerar_ocorrencia_w := 'N';			
			end if;
		end if;
		
		if (coalesce(r_C01_w.ie_exige_anexo, 'N') = 'S') then
			select	count(*)
			into STRICT	ie_existe_anexo_w
			from	pls_requisicao_anexo
			where 	nr_seq_requisicao = nr_seq_requisicao_p;
				
			if (ie_existe_anexo_w > 0) then
				ie_gerar_ocorrencia_w := 'N';
			end if;
		end if;
		
		if (ie_gerar_ocorrencia_w	= 'S') then
			exit;
		end if;
	end;
end loop;

if (ie_gerar_ocorrencia_w = 'S') then	
	ie_regra_com_itens_w  :=  pls_obter_se_oco_aut_fil_itens(nr_seq_ocor_filtro_p);
	
	if (ie_regra_com_itens_w = 'S') then
		ie_tipo_ocorrencia_p := 'I';
	else
		ie_tipo_ocorrencia_p := 'C';
	end if;
end if;

ie_gerar_ocorrencia_p	:= ie_gerar_ocorrencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_ocor_aut_req ( nr_seq_ocor_filtro_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text, ie_tipo_ocorrencia_p INOUT text) FROM PUBLIC;

