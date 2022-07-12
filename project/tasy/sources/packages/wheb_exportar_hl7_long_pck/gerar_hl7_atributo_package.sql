-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_exportar_hl7_long_pck.gerar_hl7_atributo (ar_hl7_elemento_w hl7Segmento,ar_result_query_sup_p myArray, ds_valor_long_p INOUT DBMS_SQL.VARCHAR2A) AS $body$
DECLARE

	nr_seq_atrib_segm_w	bigint;
	ie_criar_atributo_w 	varchar(1);
	nm_atributo_hl7_w  	varchar(60);
	nm_atributo_w	  	varchar(60);
	ds_mascara_w		varchar(30);
	ie_tipo_atributo_w	varchar(10);
	nr_sequencia_w		bigint;
	nr_count_w 		integer := 0;
	ie_first_append_w 	boolean := true;
	ds_valor_w		text			:= '';
	ds_sql_atrib_w		varchar(32000);
	ie_tipo_conversao_w	varchar(10);
  ds_valor_long_w DBMS_SQL.VARCHAR2A;
  ds_obtem_valor_long_w DBMS_SQL.VARCHAR2A;
	c_atributo CURSOR FOR
		SELECT	nr_seq_atrib_segm,
			ie_criar_atributo,
			nm_atributo_hl7,
			nm_atributo,
			ds_mascara,
			ie_tipo_atributo,
			nr_sequencia,
			ds_sql,
			ie_conversao
		FROM 	hl7_atributo
		WHERE 	nr_seq_segmento = ar_hl7_elemento_w[1].NR_SEQUENCIA
		ORDER BY nr_seq_apresentacao;
	
BEGIN

		OPEN c_atributo;
		LOOP
		FETCH  c_atributo INTO
			nr_seq_atrib_segm_w,
			ie_criar_atributo_w,
			nm_atributo_hl7_w,
			nm_atributo_w,
			ds_mascara_w,
			ie_tipo_atributo_w,
			nr_sequencia_w,
			ds_sql_atrib_w,
			ie_tipo_conversao_w;
		EXIT WHEN NOT FOUND; /* apply on c_atributo */
		if ( ie_criar_atributo_w = 'S') then
			/*colocando cada campo em seu lugar, caso não gerar informação sabe em qual posição apendar o valor*/

			nr_count_w := nr_count_w + 1;

			/*um atributo referenciando um elemento significa um nó na arvore do HL7*/

			if (nr_seq_atrib_segm_w IS NOT NULL AND nr_seq_atrib_segm_w::text <> '') then
				ds_valor_long_w := wheb_exportar_hl7_long_pck.gerar_hl7_segmento(nr_seq_atrib_segm_w, ar_result_query_sup_p, nr_sequencia_w, ds_valor_long_w);
				if ( ds_valor_long_w.count > 0 ) then
          if ( ds_valor_long_p.count > 0 )then
            ds_valor_w := ds_valor_long_p(ds_valor_long_p.count);
					  SELECT * FROM wheb_exportar_hl7_long_pck.append_separator(ie_first_append_w, nr_count_w, ds_valor_w) INTO STRICT ie_first_append_w, nr_count_w, ds_valor_w;
            ds_valor_long_p(ds_valor_long_p.count) := ds_valor_w;
          else
            SELECT * FROM wheb_exportar_hl7_long_pck.append_separator(ie_first_append_w, nr_count_w, ds_valor_w) INTO STRICT ie_first_append_w, nr_count_w, ds_valor_w;
            ds_valor_long_p := wheb_exportar_hl7_long_pck.concat_valor_string(ds_valor_long_p, ds_valor_w);
          end if;
          for p in 1..ds_valor_long_w.count loop
            ds_valor_long_p(ds_valor_long_p.count+1) := ds_valor_long_w(p);
          end loop;
				end if;
        ds_valor_long_w.delete;
			else
				/*se possui um alias SQL apendar valor na mensagem*/

        ds_obtem_valor_long_w.delete;
				if (nm_atributo_w IS NOT NULL AND nm_atributo_w::text <> '') then
          if ( ds_valor_long_p.count > 0 )then
            ds_valor_w := ds_valor_long_p(ds_valor_long_p.count);
					  SELECT * FROM wheb_exportar_hl7_long_pck.append_separator(ie_first_append_w, nr_count_w, ds_valor_w) INTO STRICT ie_first_append_w, nr_count_w, ds_valor_w;
            ds_valor_long_p(ds_valor_long_p.count) := ds_valor_w;
          else
            SELECT * FROM wheb_exportar_hl7_long_pck.append_separator(ie_first_append_w, nr_count_w, ds_valor_w) INTO STRICT ie_first_append_w, nr_count_w, ds_valor_w;
            ds_valor_long_p := wheb_exportar_hl7_long_pck.concat_valor_string(ds_valor_long_p, ds_valor_w);
          end if;
					if (ds_sql_atrib_w IS NOT NULL AND ds_sql_atrib_w::text <> '') and (ie_tipo_conversao_w IS NOT NULL AND ie_tipo_conversao_w::text <> '') then
						CALL CALL wheb_exportar_hl7_long_pck.conv_atrib_rtf(ds_sql_atrib_w,ar_result_query_sup_p,ie_tipo_conversao_w);
						ds_valor_w := current_setting('wheb_exportar_hl7_long_pck.ds_rtf_string_w')::text;
						PERFORM set_config('wheb_exportar_hl7_long_pck.ds_rtf_string_w', null, false);
					else
						ds_obtem_valor_long_w := wheb_exportar_hl7_long_pck.obtem_valor(ar_result_query_sup_p, nm_atributo_w, ie_tipo_atributo_w, ds_mascara_w, ds_obtem_valor_long_w);
					end if;
          if ( ds_obtem_valor_long_w.count = 0 )then
            ds_valor_long_p := wheb_exportar_hl7_long_pck.concat_valor_string(ds_valor_long_p, ds_valor_w);
          else
            for p in 1..ds_obtem_valor_long_w.count loop
              ds_valor_long_p(ds_valor_long_p.count+1) := ds_obtem_valor_long_w(p);
            end loop;
          end if;

				end if;
			end if;

		end if;
		END LOOP;
		CLOSE c_atributo;
	end;


	 /*
	  Realizar o append respeitando as regras de posicionamento e caracter separador de componentes.
	  */
$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_hl7_long_pck.gerar_hl7_atributo (ar_hl7_elemento_w hl7Segmento,ar_result_query_sup_p myArray, ds_valor_long_p INOUT DBMS_SQL.VARCHAR2A) FROM PUBLIC;