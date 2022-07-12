-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_values_integrations_cpoe (nr_seq_cpoe_p cpoe_material.nr_sequencia%type, cd_material_p cpoe_material.cd_material%type, nr_atendimento_p cpoe_material.nr_atendimento%type, cd_pessoa_fisica_p cpoe_material.cd_pessoa_fisica%type ) RETURNS varchar AS $body$
DECLARE


ds_elementos_w 		varchar(4000);
count_apis_w		integer;
ie_integ_ativa_w	cliente_integracao.ie_situacao%type;

  c_api_items CURSOR FOR
	SELECT
		cd_api,
		ds_type,
		ds_description,
		nr_order_type,
		count(*) qt_items
	FROM (
		SELECT 
			a.nr_gravidade,
			a.cd_api,
			CASE a.cd_api
				WHEN 'A' THEN 'DRUG' 
				WHEN 'B' THEN 'DISEASE'
				WHEN 'C' THEN 'TC_DUPLICATION' 
				WHEN 'D' THEN 'DRUG_DOSE_INTERACTIONS' 
				WHEN 'E' THEN 'ROUTE_CONTRAINDICATIONS'
				WHEN 'F' THEN 'AGE_CONTRAINDICATION'
				WHEN 'G' THEN 'GENDER_CONTRAINDICATIONS'
				WHEN 'H' THEN 'PREGNANCY'
				WHEN 'I' THEN 'LACTATION'
				WHEN 'DDC' THEN 'DRUG_DISEASE_CONTRAINDICATIONS'
				WHEN 'PE' THEN 'PRECAUTIONS'
				ELSE null
			END ds_type,
			obter_nome_api_lexicomp(a.cd_api) ds_description,
			/* Ordem que esta no rodape da CPOE */

			CASE a.cd_api
				WHEN 'A' THEN 10 	-- Drug
				WHEN 'C' THEN 20 	-- Duplication
				WHEN 'D' THEN 30 	-- Drug Dose
				WHEN 'DDC' THEN 40	-- Drug Disease
				WHEN 'E' THEN 50 	-- Route
				WHEN 'F' THEN 60	-- Age
				WHEN 'G' THEN 70	-- Gender
				WHEN 'H' THEN 80	-- Pregnancy
				WHEN 'I' THEN 90	-- Lactation
				WHEN 'B' THEN 100 	-- Disease
				WHEN 'PE' THEN 110	-- Patient Education
				ELSE 999
			END nr_order_type
		FROM 	alerta_api a
		WHERE	a.nr_seq_cpoe = nr_seq_cpoe_p
		AND 	coalesce(a.ie_status_requisicao::text, '') = ''
	) alias3
	GROUP BY
		cd_api,
		ds_type,
		ds_description,
		nr_order_type
	ORDER BY	
		nr_order_type;

function get_max_severity( cd_api_p	alerta_api.cd_api%type )
						return text is

	ds_severity_w varchar(255);

BEGIN

	SELECT
		CASE max(nr_order_severity)
			WHEN 90 THEN 'CONTRAINDICATED'
			WHEN 80 THEN 'MAJOR'
			WHEN 70 THEN 'MODERATE'
			WHEN 60 THEN 'INFO'
			WHEN 10 THEN 'MINOR'
			ELSE 'UNKNOWN'
		END ds_severity
	INTO STRICT
		ds_severity_w
	FROM (
		SELECT distinct
			nr_gravidade,
			CASE nr_gravidade
				WHEN 0 THEN 10 		/*MINOR*/
				WHEN 1 THEN 90 		/*CONTRAINDICATED*/
				WHEN 2 THEN 80 		/*MAJOR*/
				WHEN 3 THEN 70 		/*MODERATE*/
				WHEN 4 THEN 70 		/*MODERATE*/
				WHEN 5 THEN 60 		/*INFO*/
				ELSE 0 				/*UNKNOWN*/
			END nr_order_severity
		FROM	alerta_api
		WHERE	nr_seq_cpoe = nr_seq_cpoe_p
		AND 	cd_api 		= cd_api_p
		AND 	coalesce(ie_status_requisicao::text, '') = ''
		ORDER BY 
			nr_order_severity desc
	) alias2;

	return ds_severity_w;

end;

function get_structure_span_icon(ds_descricao_p	Varchar2,
					   type_p		Varchar2,
					   ds_severity_p	Varchar2,
					   count_p	pls_integer )
 		    	return Varchar2 is

	ds_elemento_html_w varchar2(255 char);
	ds_structure_type_w varchar2(1000 char);

begin

	if (type_p IS NOT NULL AND type_p::text <> '') then
		ds_structure_type_w := ' inconsistency-type--' || type_p || ' severity-icon--' || ds_severity_p;
		ds_elemento_html_w := '<span class=''linha-cpoe-integrations''>' ||
								'<i class=''inconsistencies-icon icon-small' || ds_structure_type_w ||  ''' ></i>' ||
								'<div>'|| ds_descricao_p || ' (' || count_p || ')' || '</div>' ||
							  '</span>';
	end if;

	return	ds_elemento_html_w;

end;

begin

	ds_elementos_w  :=  null;

	select coalesce(max(a.ie_situacao), 'I')
	  into STRICT ie_integ_ativa_w
	  from cliente_integracao a
	 where a.nr_seq_inf_integracao = 826;

	if (ie_integ_ativa_w = 'A') then
		FOR item_w IN c_api_items
		LOOP
			select count(*)
			  into STRICT count_apis_w
			  from table(lista_pck.obter_lista_char(get_list_API_available(nr_atendimento_p, cd_pessoa_fisica_p, 'N'))) A1
			 where A1.cd_registro = item_w.cd_api;
		
			if (count_apis_w > 0) then
				if (coalesce(ds_elementos_w::text, '') = '' )then
					ds_elementos_w := '<span class=''container-cpoe-span-integrations''>' ||
										get_structure_span_icon(item_w.ds_description, item_w.ds_type, get_max_severity(item_w.cd_api), item_w.qt_items);
				else
					ds_elementos_w :=  ds_elementos_w || get_structure_span_icon(item_w.ds_description, item_w.ds_type, get_max_severity(item_w.cd_api), item_w.qt_items);
				end if;
			end if;

		END LOOP;
		
		if (ds_elementos_w IS NOT NULL AND ds_elementos_w::text <> '')then
			ds_elementos_w := ds_elementos_w || '</span>';
		end if;
	end if;

	return	ds_elementos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_values_integrations_cpoe (nr_seq_cpoe_p cpoe_material.nr_sequencia%type, cd_material_p cpoe_material.cd_material%type, nr_atendimento_p cpoe_material.nr_atendimento%type, cd_pessoa_fisica_p cpoe_material.cd_pessoa_fisica%type ) FROM PUBLIC;

