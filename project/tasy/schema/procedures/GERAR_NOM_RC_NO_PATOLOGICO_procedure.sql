-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nom_rc_no_patologico (nr_seq_cabecalho_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w					atendimento_paciente.nr_atendimento%type;
cd_pessoa_fisica_w					atendimento_paciente.cd_pessoa_fisica%type;
nr_seq_episodio_w					episodio_paciente.nr_sequencia%type;
nm_usuario_w						usuario.nm_usuario%type;
cd_estabelecimento_w				estabelecimento.cd_estabelecimento%type;	
nr_seq_paciente_habito_vicio_w		paciente_habito_vicio.nr_sequencia%type;
ds_html_alc_w						varchar(32000)	:= null;
ds_html_tab_w						varchar(32000)	:= null;
ds_html_drg_w						varchar(32000)	:= null;
ds_html_sangre_w					varchar(4000)	:= null;
qtd_registros_alc_w					smallint := 0;
qtd_registros_tab_w					smallint := 0;
qtd_registros_drg_w					smallint := 0;
dt_tipo_sangre_w					nom_rc_no_patologico.dt_tipo_sangre%type;/*id_264*/
ds_tipo_sangre_w					nom_rc_no_patologico.ds_tipo_sangre%type;/*id_265*/
ie_tipo_antecedente_w				nom_rc_no_patologico.ie_tipo_antecedente%type;	/*id_266, id_270, id_274*/
dt_inicio_w							nom_rc_no_patologico.dt_inicio%type;			/*id_267, id_271, id_275*/
dt_fim_w							nom_rc_no_patologico.dt_fim%type;			 	/*id_268, id_272, id_276*/
ds_consumo_w						nom_rc_no_patologico.ds_consumo%type;			/*id_273, id_277*/
nr_seq_resultado_w					exame_lab_result_item.nr_seq_resultado%type;
dt_resultado_w						exame_lab_resultado.dt_resultado%type;
ds_oid_w							varchar(255);
ie_possui_tabaquismo_w				varchar(2);
ie_possui_alcoholismo_w				varchar(2);
ie_possui_otras_w					varchar(2);
first_record_w						varchar(1)	:= 'S';


/*Usado para o tipo T*/

c_tabaco CURSOR FOR
SELECT 	distinct 
		a.nr_sequencia nr_sequencia,
		a.dt_inicio dt_inicio, /*id_267*/
		a.dt_fim dt_fim,	   /*id_268*/
		substr(coalesce(ds_quantidade, a.qt_utilizacao) || ' ' || 
			(CASE WHEN (a.cd_unidade_medida IS NOT NULL AND a.cd_unidade_medida::text <> '') THEN obter_um_habito_vicio(a.cd_unidade_medida) || '(s)' ELSE ''  END) || ' de ' || 
			obter_desc_tipo_vicio(a.nr_seq_tipo) || ' (' || coalesce(c.ds_marca,a.ds_observacao) || ') ' ||   obter_valor_dominio(1336,a.ie_frequencia),1,255)
FROM atendimento_paciente b, paciente_habito_vicio a
LEFT OUTER JOIN med_tipo_vicio_marca c ON (a.nr_seq_marca = c.nr_sequencia)
WHERE b.cd_pessoa_fisica = cd_pessoa_fisica_w and a.ie_classificacao = 'T' --Tabaco
  and a.cd_pessoa_fisica = b.cd_pessoa_fisica  and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and coalesce(a.dt_inativacao::text, '') = '' and coalesce(a.ie_nega_habito, 'N') = 'N';

/*Usado para o tipo 'A'*/

c_alcool CURSOR FOR
SELECT 	distinct
		a.nr_sequencia nr_sequencia,
		a.dt_inicio dt_inicio, /*id_271*/
		a.dt_fim dt_fim,		 /*id_272*/
	
		substr(coalesce(ds_quantidade, a.qt_utilizacao) || ' ' || 
			(CASE WHEN (a.cd_unidade_medida IS NOT NULL AND a.cd_unidade_medida::text <> '') THEN obter_um_habito_vicio(a.cd_unidade_medida) || '(s)' ELSE ''  END) || ' de ' || 
			obter_desc_tipo_vicio(a.nr_seq_tipo) || ' (' || coalesce(c.ds_marca,a.ds_observacao) || ') ' ||   obter_valor_dominio(1336,a.ie_frequencia),1,255)
FROM atendimento_paciente b, paciente_habito_vicio a
LEFT OUTER JOIN med_tipo_vicio_marca c ON (a.nr_seq_marca = c.nr_sequencia)
WHERE b.cd_pessoa_fisica = cd_pessoa_fisica_w and a.ie_classificacao = 'A' --Alcool
  and a.cd_pessoa_fisica = b.cd_pessoa_fisica  and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and coalesce(a.dt_inativacao::text, '') = '' and coalesce(a.ie_nega_habito, 'N') = 'N';

/*Utilizado para o tipo 'D'*/

c_drogas CURSOR FOR
SELECT 	distinct
		a.nr_sequencia nr_sequencia,
		a.dt_inicio dt_inicio, /*id_275*/
		a.dt_fim dt_fim, /*id_276*/
		substr(coalesce(ds_quantidade, a.qt_utilizacao) || ' ' || 
			(CASE WHEN (a.cd_unidade_medida IS NOT NULL AND a.cd_unidade_medida::text <> '') THEN obter_um_habito_vicio(a.cd_unidade_medida) || '(s)' ELSE ''  END) || ' de ' || 
			obter_desc_tipo_vicio(a.nr_seq_tipo) || ' (' || coalesce(c.ds_marca,a.ds_observacao) || ') ' ||   obter_valor_dominio(1336,a.ie_frequencia),1,255)
FROM atendimento_paciente b, paciente_habito_vicio a
LEFT OUTER JOIN med_tipo_vicio_marca c ON (a.nr_seq_marca = c.nr_sequencia)
WHERE b.cd_pessoa_fisica = cd_pessoa_fisica_w and a.ie_classificacao = 'D' --Drogas
  and a.cd_pessoa_fisica = b.cd_pessoa_fisica  and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and coalesce(a.dt_inativacao::text, '') = '' and coalesce(a.ie_nega_habito, 'N') = 'N';

c_otras CURSOR FOR
SELECT 	distinct
		substr(coalesce(ds_quantidade, a.qt_utilizacao) || ' ' || 
			(CASE WHEN (a.cd_unidade_medida IS NOT NULL AND a.cd_unidade_medida::text <> '') THEN obter_um_habito_vicio(a.cd_unidade_medida) || '(s)' ELSE ''  END) || ' de ' || 
			obter_desc_tipo_vicio(a.nr_seq_tipo) || ' (' || coalesce(c.ds_marca,a.ds_observacao) || ') ' ||    obter_valor_dominio(1336,a.ie_frequencia),1,255)
FROM atendimento_paciente b, paciente_habito_vicio a
LEFT OUTER JOIN med_tipo_vicio_marca c ON (a.nr_seq_marca = c.nr_sequencia)
WHERE b.cd_pessoa_fisica = cd_pessoa_fisica_w and a.ie_classificacao not in ('T','A','D') and a.cd_pessoa_fisica = b.cd_pessoa_fisica  and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and coalesce(a.dt_inativacao::text, '') = '' and coalesce(a.ie_nega_habito, 'N') = 'N';

c_paragraph CURSOR FOR
SELECT	'Tipo sangre: ' || (SELECT max(x.ds_tipo_sangre) from nom_rc_no_patologico x where x.nr_seq_cabecalho = nr_seq_cabecalho_p and (x.ds_tipo_sangre IS NOT NULL AND x.ds_tipo_sangre::text <> '')) ds_paragraph


union all

select	'Tabaquismo: ' || (select CASE WHEN coalesce(max(x.dt_inicio)::text, '') = '' THEN 'No'  ELSE 'Si' END  from nom_rc_no_patologico x where x.nr_seq_cabecalho = nr_seq_cabecalho_p and x.ie_tipo_antecedente = 'T') ds_paragraph


union all

select	'Alchool: ' || (select CASE WHEN coalesce(max(x.dt_inicio)::text, '') = '' THEN 'No'  ELSE 'Si' END  from nom_rc_no_patologico x where x.nr_seq_cabecalho = nr_seq_cabecalho_p and x.ie_tipo_antecedente = 'A') ds_paragraph


union all

select	'Otras sustancias: ' || (select CASE WHEN coalesce(max(x.dt_inicio)::text, '') = '' THEN 'No'  ELSE 'Si' END  from nom_rc_no_patologico x where x.nr_seq_cabecalho = nr_seq_cabecalho_p and x.ie_tipo_antecedente = 'D') ds_paragraph


union all

select	'' ds_paragraph
;

BEGIN



delete FROM nom_rc_no_patologico where nr_seq_cabecalho = nr_seq_cabecalho_p;

select	a.nr_atendimento,
		a.nr_seq_episodio,
		a.cd_estabelecimento,
		a.nm_usuario nm_usuario		
into STRICT	nr_atendimento_w,
		nr_seq_episodio_w,
		cd_estabelecimento_w,
		nm_usuario_w		
from	nom_rc_cabecalho a
where	a.nr_sequencia	= nr_seq_cabecalho_p;

ds_oid_w	:= get_oid_details(8,'OID_NUMBER', 'NOM', cd_estabelecimento_w);

if	((coalesce(nr_atendimento_w::text, '') = '') and (nr_seq_episodio_w IS NOT NULL AND nr_seq_episodio_w::text <> '')) then
	select	min(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atendimento_paciente a
	where	a.nr_seq_episodio = nr_seq_episodio_w;
end if;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

		select	cd_pessoa_fisica
		into STRICT	cd_pessoa_fisica_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_w;

		select	max(a.nr_seq_resultado)
		into STRICT	nr_seq_resultado_w
		from	exame_lab_result_item b,
				exame_lab_resultado a
		where 	a.nr_seq_resultado = b.nr_seq_resultado
		and		a.cd_pessoa_fisica = cd_pessoa_fisica_w
		and 	b.nr_seq_exame = (	SELECT 	max(nr_seq_exame_tipo_sangue)
									from	config_nom
									where	cd_estabelecimento = cd_estabelecimento_w);

		if (nr_seq_resultado_w IS NOT NULL AND nr_seq_resultado_w::text <> '') then
			select 	max(a.ds_resultado)
			into STRICT	ds_tipo_sangre_w
			from 	exame_lab_result_item a
			where 	a.nr_seq_resultado = nr_seq_resultado_w
			and		(a.ds_resultado IS NOT NULL AND a.ds_resultado::text <> '');

			select	dt_resultado
			into STRICT	dt_tipo_sangre_w
			from	exame_lab_resultado a
			where	a.nr_seq_resultado = nr_seq_resultado_w;
		end if;

		if (coalesce(ds_tipo_sangre_w::text, '') = '') then
			select 	a.ie_tipo_sangue || a.ie_fator_rh ds_tipo_sangue,
						 coalesce((select c.dt_atualizacao
							from tasy_log_alt_campo c
							where c.nr_seq_log_alteracao in (select max(d.nr_sequencia)
																							from tasy_log_alteracao d
																							where d.nm_tabela = 'PESSOA_FISICA'
																							and d.ds_chave_simples = a.cd_pessoa_fisica)
							and c.nm_atributo = 'IE_TIPO_SANGUE'),a.dt_atualizacao_nrec) dt_tipo_sangre
			into STRICT 	ds_tipo_sangre_w,
						dt_tipo_sangre_w
			from 	pessoa_fisica a,
					atendimento_paciente b
			where	b.nr_atendimento = nr_atendimento_w
			and		a.cd_pessoa_fisica = b.cd_pessoa_fisica;
		end if;

		if (coalesce(ds_tipo_sangre_w::text, '') = '') then	
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1072275);
		else
			insert into nom_rc_no_patologico(
				  nr_sequencia,
				  dt_atualizacao,
				  nm_usuario,
				  dt_atualizacao_nrec,
				  nm_usuario_nrec,
				  nr_seq_cabecalho,
				  ie_tipo_antecedente,
				  ds_tipo_sangre,
				  dt_tipo_sangre,
				  dt_inicio,
				  dt_fim,
				  ds_consumo,
				  ie_tipo,
				  ds_oid
				) values (
				  nextval('nom_rc_no_patologico_seq'),
				  clock_timestamp(),
				  nm_usuario_p,
				  clock_timestamp(),
				  nm_usuario_p,
				  nr_seq_cabecalho_p,
				  null,
				  ds_tipo_sangre_w,
				  dt_tipo_sangre_w,
				  null,
				  null,
				  null,
				  null,
				  ds_oid_w
				);

			open c_tabaco;
			loop
			fetch c_tabaco into
				nr_seq_paciente_habito_vicio_w,
				dt_inicio_w,
				dt_fim_w,
				ds_consumo_w;
			EXIT WHEN NOT FOUND; /* apply on c_tabaco */

				qtd_registros_tab_w := qtd_registros_tab_w + 1;

				if (coalesce(ie_possui_tabaquismo_w::text, '') = '') then
					ie_possui_tabaquismo_w := 'Si';	
				end if;

				first_record_w	:= 'S';
				if (first_record_w = 'S') then
					/*Inicio html do tabaco*/

					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || '<table class="wrichedit-table" width="100%" xmlns="urn:hl7-org:v3">';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || '<thead>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<tr>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th colspan="6">Tabaquismo</th>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '</tr>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<tr>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th>Fecha de inicio</th>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th>Fecha de fin</th>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th>Cigarros por día</th>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '</tr>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || '</thead>';
					ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || '<tbody>';
					
					first_record_w	:= 'N';
				end if;
				
				ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<tr>';
				ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<td>' || obter_data_utc(dt_inicio_w, 'NOM_TABLE')|| '</td>';
				ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<td>' || obter_data_utc(dt_fim_w, 'NOM_TABLE') || '</td>';
				ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<td>' || ds_consumo_w  || '</td>';
				ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '</tr>';
			

				insert into nom_rc_no_patologico(
				  nr_sequencia,
				  dt_atualizacao,
				  nm_usuario,
				  dt_atualizacao_nrec,
				  nm_usuario_nrec,
				  nr_seq_cabecalho,
				  ie_tipo_antecedente,
				  ds_tipo_sangre,
				  dt_tipo_sangre,
				  dt_inicio,
				  dt_fim,
				  ds_consumo,
				  ie_tipo,
				  ds_oid
				) values (
				  nextval('nom_rc_no_patologico_seq'),
				  clock_timestamp(),
				  nm_usuario_p,
				  clock_timestamp(),
				  nm_usuario_p,
				  nr_seq_cabecalho_p,
				  'T',
				  null,
				  null,
				  dt_inicio_w,
				  dt_fim_w,
				  ds_consumo_w,
				  'T',
				  ds_oid_w
				);
			end loop;
			close c_tabaco;
			
			if (qtd_registros_tab_w > 0) then
				ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) || chr(9) || '</tbody>';
				ds_html_tab_w := ds_html_tab_w || chr(13) || chr(10) || chr(9) ||'</table>';/*Fim html tabaco*/
			end if;

			if (qtd_registros_tab_w = 0 and coalesce(ie_possui_tabaquismo_w::text, '') = '') then
				ie_possui_tabaquismo_w := 'No';	
			end if;

			open c_alcool;
			loop
			fetch c_alcool into
				nr_seq_paciente_habito_vicio_w,
				dt_inicio_w,
				dt_fim_w,
				ds_consumo_w;
			EXIT WHEN NOT FOUND; /* apply on c_alcool */

				qtd_registros_alc_w := qtd_registros_alc_w + 1;

				if (coalesce(ie_possui_alcoholismo_w::text, '') = '') then
					ie_possui_alcoholismo_w := 'Si';	
				end if;

				first_record_w	:= 'S';
				if (first_record_w = 'S') then
					/*Inicio html do alcool*/

					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || '<table class="wrichedit-table" width="100%" xmlns="urn:hl7-org:v3">';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || '<thead>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<tr>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th colspan="6">Alcoholismo</th>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '</tr>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<tr>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th>Fecha de inicio</th>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th>Fecha de fin</th>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th>Consumo</th>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '</tr>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || '</thead>';
					ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || '<tbody>';
					
					first_record_w	:= 'N';
				end if;	
					
				ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<tr>';
				ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<td>' || obter_data_utc(dt_inicio_w, 'NOM_TABLE') || '</td>';
				ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<td>' || obter_data_utc(dt_fim_w, 'NOM_TABLE') || '</td>';
				ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<td>' || ds_consumo_w	|| '</td>';
				ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '</tr>';	

				insert into nom_rc_no_patologico(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_cabecalho,
					ie_tipo_antecedente,
					ds_tipo_sangre,
					dt_tipo_sangre,
					dt_inicio,
					dt_fim,
					ds_consumo,
					ie_tipo,
					ds_oid
				) values (
					nextval('nom_rc_no_patologico_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_cabecalho_p,
					'A',
					null,
					null,
					dt_inicio_w,
					dt_fim_w,
					ds_consumo_w,
					'A',
					ds_oid_w
				);
			end loop;
			close c_alcool;
			
			if (qtd_registros_alc_w > 0) then
				ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) || chr(9) ||  '</tbody>';
				ds_html_alc_w := ds_html_alc_w || chr(13) || chr(10) || chr(9) ||'</table>'; /*Fim html alcool*/
			end if;

			if (qtd_registros_alc_w = 0 and coalesce(ie_possui_alcoholismo_w::text, '') = '') then
				ie_possui_alcoholismo_w := 'No';	
			end if;

			open c_drogas;
			loop
			fetch c_drogas into
				nr_seq_paciente_habito_vicio_w,
				dt_inicio_w,
				dt_fim_w,
				ds_consumo_w;
			EXIT WHEN NOT FOUND; /* apply on c_drogas */

				qtd_registros_drg_w := qtd_registros_drg_w + 1;

				if (coalesce(ie_possui_otras_w::text, '') = '') then
					ie_possui_otras_w := 'Si';	
				end if;

				first_record_w	:= 'S';
				if (first_record_w = 'S') then
					/*Inicio html outras drogas*/

					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) ||'<table class="wrichedit-table" width="100%" xmlns="urn:hl7-org:v3">';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || '<thead>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<tr>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th colspan="6">Consumo de otras sustancias</th>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '</tr>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<tr>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th>Fecha de inicio</th>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th>Fecha de fin</th>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<th>Consumo</th>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '</tr>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || '</thead>';
					ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || '<tbody>';
					
					first_record_w	:= 'N';
				end if;	
					
				ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '<tr>';
				ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<td>' || obter_data_utc(dt_inicio_w, 'NOM_TABLE') || '</td>';
				ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<td>' || obter_data_utc(dt_fim_w, 'NOM_TABLE') || '</td>';
				ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || chr(9) || '<td>' || ds_consumo_w || '</td>';
				ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || chr(9) || '</tr>';


				insert into nom_rc_no_patologico(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_cabecalho,
					ie_tipo_antecedente,
					ds_tipo_sangre,
					dt_tipo_sangre,
					dt_inicio,
					dt_fim,
					ds_consumo,
					ie_tipo,
					ds_oid
				) values (
					nextval('nom_rc_no_patologico_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_cabecalho_p,
					'D',
					null,
					null,
					dt_inicio_w,
					dt_fim_w,
					ds_consumo_w,
					'D',
					ds_oid_w
				);	

			end loop;
			close c_drogas;
			
			if (qtd_registros_drg_w > 0) then
				ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) || chr(9) || '</tbody>';
				ds_html_drg_w := ds_html_drg_w || chr(13) || chr(10) || chr(9) ||'</table>'; /*Fim html outras drogas*/
			end if;

			if (qtd_registros_drg_w = 0 and coalesce(ie_possui_otras_w::text, '') = '') then			
				ie_possui_otras_w := 'No';		
			end if;

			/*open c_otras;  Nao obrigatório QUERY: 1072282
			loop
			fetch c_otras into
				ds_consumo_w;
			exit when c_otras%notfound;

				insert into nom_rc_no_patologico(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_cabecalho,
					ds_consumo,
					ds_oid) 
				values
					(nom_rc_no_patologico_seq.nextval,
					sysdate,
					nm_usuario_p,
					sysdate,
					nm_usuario_p,
					nr_seq_cabecalho_p,
					ds_consumo_w,
					ds_oid_w);	

			end loop;
			close c_otras;
			*/


			/*Tabaquismo*/

			insert into nom_rc_no_patologico(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_cabecalho,
				ds_html,
				ds_oid)
			values (nextval('nom_rc_no_patologico_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_cabecalho_p,
				ds_html_tab_w,
				ds_oid_w);	

			/* Alcool */

			insert into nom_rc_no_patologico(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_cabecalho,
				ds_html,
				ds_oid)
			values (nextval('nom_rc_no_patologico_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_cabecalho_p,
				ds_html_alc_w,
				ds_oid_w);	

			/* Drogas */
	
			insert into nom_rc_no_patologico(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_cabecalho,
				ds_html,
				ds_oid)
			values (nextval('nom_rc_no_patologico_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_cabecalho_p,
				ds_html_drg_w,
				ds_oid_w);

			/* General */
		

			for r_c_paragraph in c_paragraph loop
				insert into nom_rc_no_patologico(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_cabecalho,
					ds_paragrafo,
					ds_oid)
				values (nextval('nom_rc_no_patologico_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_cabecalho_p,
					r_c_paragraph.ds_paragraph,
					ds_oid_w);
				
				if (coalesce(ds_html_sangre_w::text, '') = '') then
					ds_html_sangre_w	:= '<paragraph>' || r_c_paragraph.ds_paragraph || '</paragraph>';
				else
					ds_html_sangre_w 	:= ds_html_sangre_w || chr(13) || chr(10) || chr(9) || '<paragraph>' || r_c_paragraph.ds_paragraph || '</paragraph>';
				end if;
			end loop;
			ds_html_sangre_w := ds_html_sangre_w || chr(13) || chr(10) || chr(9) || '<paragraph/>';
			
			insert into nom_rc_no_patologico(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_cabecalho,
				ds_tipo_sangre,
				ds_html,
				ds_oid)
			values (nextval('nom_rc_no_patologico_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_cabecalho_p,
				ds_tipo_sangre_w,
				ds_html_sangre_w  || chr(13) || chr(10) || 
				ds_html_tab_w || chr(13) || chr(10) || 
				ds_html_alc_w || chr(13) || chr(10) || 
				ds_html_drg_w,
				ds_oid_w);

		end if;	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nom_rc_no_patologico (nr_seq_cabecalho_p bigint, nm_usuario_p text) FROM PUBLIC;
