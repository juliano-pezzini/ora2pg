-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE rep_gerar_resumo_pck.gerar_resumo ( nr_prescricao_p bigint, ie_rtf_html_p text, nm_usuario_p text) AS $body$
DECLARE


	nr_sequencia_w		bigint;
	qt_tamanho_w		bigint;
	
BEGIN
	
	CALL rep_gerar_resumo_pck.gerar_expressoes();

	PERFORM set_config('rep_gerar_resumo_pck.nr_prescricao_w', nr_prescricao_p, false);
	
	select	substr(obter_nome_pf(cd_pessoa_fisica),1,255),
		cd_pessoa_fisica,
		to_char(dt_prescricao,'dd/mm/yyyy hh24:mi:ss'),
		ds_observacao,
		ds_justificativa
	into STRICT	current_setting('rep_gerar_resumo_pck.nm_paciente_w')::varchar(255),
		current_setting('rep_gerar_resumo_pck.cd_pessoa_fisica_w')::varchar(10),
		current_setting('rep_gerar_resumo_pck.dt_prescricao_w')::varchar(50),
		current_setting('rep_gerar_resumo_pck.ds_obs_prescr_w')::varchar(2000),
		current_setting('rep_gerar_resumo_pck.ds_justif_prescr_w')::varchar(2000)
	from	prescr_medica
	where	nr_prescricao = current_setting('rep_gerar_resumo_pck.nr_prescricao_w')::bigint;
	
	
	
	if (ie_rtf_html_p = 'RTF') then
		begin
		PERFORM set_config('rep_gerar_resumo_pck.ie_rtf_w', 'N', false);
		PERFORM set_config('rep_gerar_resumo_pck.nl_w', chr(13) || chr(10), false);
		end;
	else
		begin
		PERFORM set_config('rep_gerar_resumo_pck.ie_rtf_w', 'S', false);
		PERFORM set_config('rep_gerar_resumo_pck.nl_w', '<br>', false);
		end;
	end if;
	
	PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', '<html>
		
				<head>
					<title></title>
					<style>
					body {
						font-size: small;	
					}
					td {
						font-size: small;
					}
					h1 {
						text-align: center;
						font-size: medium;
						font-weight : bold;
					}
					</style>
				</head>
				<body>
					<h1> ' || current_setting('rep_gerar_resumo_pck.ds_exp1_w')::varchar(255) || ' ('||nr_prescricao_p||') </h1> <br>
					
					<table align=center width="100%" border="0" cellpadding="5" cellspacing="0" >
						<tr bgcolor="#E6E6E6">
							<td colspan="3" align="left">
								<b>' || current_setting('rep_gerar_resumo_pck.ds_exp2_w')::varchar(255) || '</b> ' || current_setting('rep_gerar_resumo_pck.cd_pessoa_fisica_w')::varchar(10) || ' - ' || current_setting('rep_gerar_resumo_pck.nm_paciente_w')::varchar(255) || '
							</td>
							<td colspan="3" align="left">
								<b>' || current_setting('rep_gerar_resumo_pck.ds_exp25_w')::varchar(255) || ':</b> ' || current_setting('rep_gerar_resumo_pck.dt_prescricao_w')::varchar(50) || '
							</td>
						</tr>
					</table> <br>
					
					<table align=center width="100%" border="0" cellpadding="5" cellspacing="0" >', false);
	
	delete	FROM prescr_medica_resumo
	where	nr_prescricao = nr_prescricao_p;
	select	nextval('prescr_medica_resumo_seq')
	into STRICT	nr_sequencia_w
	;
	
	CALL rep_gerar_resumo_pck.gerar_rep_resumo_dieta_oral();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp3_w')::varchar(255) || '</b>
					</td>
				</tr>
				<tr bgcolor="#E6E6E6">
					<td width="35%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp4_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp26_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp5_w')::varchar(255) || '
					</td width="5%">
					<td width="10%">
						'|| current_setting('rep_gerar_resumo_pck.c_nbsp')::varchar(10) ||'
					</td width="10%">
					<td>
						'|| current_setting('rep_gerar_resumo_pck.c_nbsp')::varchar(10) ||'
					</td width="5%">
					<td width="20%">
						
					</td>
					<td width="20%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp6_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text,1,30000), false);
	end if;
	
	CALL rep_gerar_resumo_pck.gerar_rep_resumo_supl();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7" >
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp7_w')::varchar(255) || '</b>
					</td>
				</tr>
				<tr bgcolor="#E6E6E6">
					<td width="35%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp4_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp8_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp5_w')::varchar(255) || '
					</td width="5%">
					<td width="10%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp11_w')::varchar(255) || '
					</td width="10%">
					<td>
						' || current_setting('rep_gerar_resumo_pck.c_nbsp')::varchar(10) ||'
					</td width="5%">
					<td width="20%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp9_w')::varchar(255) || '
					</td>
					<td width="30%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp6_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;
	
	CALL rep_gerar_resumo_pck.gerar_rep_resumo_sne();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp10_w')::varchar(255) || '</b>
					</td>
				</tr>
				<tr bgcolor="#E6E6E6">
					<td width="35%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp4_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp8_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp5_w')::varchar(255) || '
					</td width="5%">
					<td width="10%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp11_w')::varchar(255) || '
					</td width="10%">
					<td>
						' || current_setting('rep_gerar_resumo_pck.c_nbsp')::varchar(10) || '
					</td width="5%">
					<td width="20%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp9_w')::varchar(255) || '
					</td>
					<td width="30%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp6_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;
	
	CALL rep_gerar_resumo_pck.gerar_rep_resumo_npta();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp12_w')::varchar(255) || '</b>
					</td>
				</tr>
				<tr bgcolor="#E6E6E6">
					<td width="35%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp27_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp28_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp13_w')::varchar(255) || '
					</td width="5%">
					<td width="10%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp29_w')::varchar(255) || '
					</td width="30%">
					<td>
						' || current_setting('rep_gerar_resumo_pck.c_nbsp')::varchar(10) || '
					</td width="5%">
					<td width="20%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp11_w')::varchar(255) || '
					</td>
					<td width="30%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp30_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;
	
	CALL rep_gerar_resumo_pck.gerar_rep_resumo_medic();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp14_w')::varchar(255) || '</b>
					</td>
				</tr>
				<tr bgcolor="#E6E6E6">
					<td width="35%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp4_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp8_w')::varchar(255) || '
					</td>
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp5_w')::varchar(255) || '
					</td width="5%">
					<td width="10%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp11_w')::varchar(255) || '
					</td width="10%">
					<td width="5%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp34_w')::varchar(255) || '
					</td width="5%">
					<td width="20%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp31_w')::varchar(255) || '
					</td>
					<td width="30%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp6_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;
	

	CALL rep_gerar_resumo_pck.gerar_rep_resumo_solucao();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp15_w')::varchar(255) || '</b>
					</td>
				</tr> 
				<tr bgcolor="#E6E6E6">
					<td width="70%" colspan="6">
						' || current_setting('rep_gerar_resumo_pck.ds_exp4_w')::varchar(255) || '
					</td>
					<td width="30%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp6_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;
	CALL rep_gerar_resumo_pck.gerar_rep_resumo_proc();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7"  width="70%">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp16_w')::varchar(255) || '</b>
					</td>
					
				</tr> 
				<tr bgcolor="#E6E6E6">
					<td width="70%" colspan="6">
						' || current_setting('rep_gerar_resumo_pck.ds_exp4_w')::varchar(255) || '
					</td>
					<td width="30%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp6_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;

	CALL rep_gerar_resumo_pck.gerar_rep_resumo_recomend();	
	
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp17_w')::varchar(255) || '</b>
					</td>
				</tr> 
				<tr bgcolor="#E6E6E6">
					<td width="70%" colspan="6">
						' || current_setting('rep_gerar_resumo_pck.ds_exp4_w')::varchar(255) || '
					</td>
					<td width="30%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp6_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;	
	
	CALL rep_gerar_resumo_pck.gerar_rep_resumo_hemoderivado();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp18_w')::varchar(255) || '</b>
					</td>
				</tr> 
				<tr bgcolor="#E6E6E6">
					<td width="70%" colspan="6">
						' || current_setting('rep_gerar_resumo_pck.ds_exp4_w')::varchar(255) || '
					</td>
					<td width="30%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp6_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;
	
	CALL rep_gerar_resumo_pck.gerar_rep_resumo_gasoterapia();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp19_w')::varchar(255) || '</b>
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;
	
	CALL rep_gerar_resumo_pck.gerar_rep_resumo_opm();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7"  width="70%">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp20_w')::varchar(255) || '</b>
					</td>
					
				</tr> 
				<tr bgcolor="#E6E6E6">
					<td width="70%" colspan="6">
						' || current_setting('rep_gerar_resumo_pck.ds_exp32_w')::varchar(255) || '
					</td>
					<td width="30%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp33_w')::varchar(255) || '
					</td>
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;
	
	CALL rep_gerar_resumo_pck.gerar_rep_leites_deriv();
	if (current_setting('rep_gerar_resumo_pck.ds_resumo_w')::(text IS NOT NULL AND text::text <> '')) then
		PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
			'	<tr>
					<td colspan="7">
						<b>' || current_setting('rep_gerar_resumo_pck.ds_exp21_w')::varchar(255) || '</b>
					</td>
					
				</tr> 
				<tr bgcolor="#E6E6E6">
					<td colspan="5">
						' || current_setting('rep_gerar_resumo_pck.ds_exp22_w')::varchar(255) || '
					</td>
					<td width="10%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp11_w')::varchar(255) || '
					</td>
					<td width="10%">
						' || current_setting('rep_gerar_resumo_pck.ds_exp6_w')::varchar(255) || '
					</td>					
				</tr> ' || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255) || current_setting('rep_gerar_resumo_pck.ds_resumo_w')::text  || current_setting('rep_gerar_resumo_pck.nl_w')::varchar(255),1,30000), false);
	end if;
	
	
	PERFORM set_config('rep_gerar_resumo_pck.ds_resumo_ww', substr(current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text ||
		'				</table> '||
		'		</body>'||
		'</html>',1,30000), false);

	if (current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::(text IS NOT NULL AND text::text <> '')) then
		insert into prescr_medica_resumo(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_prescricao,
			ds_resumo)
		values (nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_prescricao_p,
			current_setting('rep_gerar_resumo_pck.ds_resumo_ww')::text);
	end if;
	commit;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_gerar_resumo_pck.gerar_resumo ( nr_prescricao_p bigint, ie_rtf_html_p text, nm_usuario_p text) FROM PUBLIC;
