-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE create_ontology_expression ( ds_description_p text, ds_valor_onto_p text, min_similarity_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_exp_label_w		tabela_visao_atributo.cd_exp_label%type;
cd_exp_valores_w	tabela_visao_atributo.cd_exp_valores%type;
nm_atributo_w		tabela_visao_atributo.nm_atributo%type;
nm_tabela_w			tabela_visao.nm_tabela%type;
cd_funcao_w			objeto_schematic.cd_funcao%type;
nr_seq_obj_sch_w	objeto_schematic.nr_sequencia%type;			
nr_visao_w			tabela_visao_atributo.nr_sequencia%type;
ds_description_w	varchar(1000);
nr_similarity_w		bigint;
cd_expvl_dominio_w	valor_dominio.cd_exp_valor_dominio%type;
vl_dominio_w		valor_dominio.vl_dominio%type;
cd_exp_val_sep_w	varchar(500);
ds_exp_val_sep_w	varchar(500);
ds_exp_final_w		varchar(500);
ds_exp_w			varchar(500);
ds_funcao_w			varchar(255);
ds_documentation_w	varchar(4000);
ds_path_schematic_w	varchar(2000);


C01 CURSOR FOR
SELECT *
FROM (	SELECT	t.cd_exp_label,
				t.nm_atributo,
				v.nm_tabela,
				o.cd_funcao,
				obter_desc_expressao_idioma(t.cd_exp_label, null, 5),
				t.nr_sequencia visao,
				round((UTL_MATCH.JARO_WINKLER(upper(obter_desc_expressao_idioma(t.cd_exp_label, null, 5)), upper(ds_description_p)) * 100)::numeric, 6) SIMILARITY,
				o.nr_sequencia
		FROM 	tabela_visao_atributo t,
				tabela_visao v,
				objeto_schematic o
		WHERE 	o.nr_seq_visao = t.nr_sequencia
		and		t.nr_sequencia = v.nr_sequencia
		and   	o.cd_funcao in (2314, 1113, 281, 872, 874)
		and 	UTL_MATCH.JARO_WINKLER_SIMILARITY(upper(obter_desc_expressao_idioma(t.cd_exp_label, null, 5)), upper(ds_description_p)) >= min_similarity_p
		ORDER BY 3 DESC ) alias12
WHERE 1 = 1
ORDER BY SIMILARITY DESC;

C02 CURSOR FOR
SELECT *
FROM (	SELECT	v.vl_dominio,
				v.cd_exp_valor_dominio,				
				t.nm_atributo,
				tv.nm_tabela,
				o.cd_funcao,
				OBTER_DESC_EXPRESSAO_IDIOMA(v.cd_exp_valor_dominio, null, 5),
				t.nr_sequencia visao,
				round((UTL_MATCH.JARO_WINKLER(upper(OBTER_DESC_EXPRESSAO_IDIOMA(v.cd_exp_valor_dominio, null, 5)), upper(ds_description_p)) * 100)::numeric, 6) SIMILARITY,
				o.nr_sequencia
		FROM 	TABELA_VISAO_ATRIBUTO t,
				tabela_visao tv,
				valor_dominio v,
				OBJETO_SCHEMATIC o
		WHERE 	t.cd_dominio = v.cd_dominio
		and   	o.nr_seq_visao = t.nr_sequencia
		and		t.nr_sequencia = tv.nr_sequencia
		and   	o.cd_funcao in (2314, 1113, 281, 872, 874)
		and 	UTL_MATCH.JARO_WINKLER_SIMILARITY(upper(OBTER_DESC_EXPRESSAO_IDIOMA(v.cd_exp_valor_dominio, null, 5)), upper(ds_description_p)) >= min_similarity_p
		ORDER BY 3 DESC ) alias12
WHERE 1 = 1
ORDER BY SIMILARITY DESC;

C03 CURSOR FOR
SELECT  distinct t.cd_exp_valores,
        t.nm_atributo,
		v.nm_tabela,
		o.cd_funcao,
		OBTER_DESC_EXPRESSAO_IDIOMA(t.cd_exp_valores, null, 5),
		t.nr_sequencia visao,
		o.nr_sequencia
from 	tabela_visao_atributo t,
		tabela_visao v,
		OBJETO_SCHEMATIC o
WHERE 	o.nr_seq_visao = t.nr_sequencia
and		t.nr_sequencia = v.nr_sequencia
and   	o.cd_funcao in (2314, 1113, 281, 872, 874)
and   	(cd_exp_valores IS NOT NULL AND cd_exp_valores::text <> '');

		
C04 CURSOR FOR
SELECT	substr(cd,1,255),
        substr(ds,1,255)
from 	table( 	get_val_from_field_pck.get_valores(
					substr(OBTER_DESC_EXPRESSAO_IDIOMA(cd_exp_valores_w, null, 5),1,500)
				)
		)
where (cd IS NOT NULL AND cd::text <> '');
		
C05 CURSOR FOR
SELECT	ds_exp_val_sep_w

where 	UTL_MATCH.JARO_WINKLER_SIMILARITY(upper(ds_exp_val_sep_w), upper(ds_description_p)) >= min_similarity_p;



BEGIN

delete 	
from 	res_cadastro_ontologia_phi
where	nm_usuario 			= nm_usuario_p
and		cd_valor_ontologia 	= ds_valor_onto_p
and (ie_situacao <> 'S' or coalesce(ie_situacao::text, '') = '');


open C01;
loop
fetch C01 into	
	cd_exp_label_w,
	nm_atributo_w,
	nm_tabela_w,
	cd_funcao_w,
	ds_description_w,
	nr_visao_w,
	nr_similarity_w,
	nr_seq_obj_sch_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
		select 	obter_desc_funcao_idioma(cd_funcao_w, 5),
				get_path_schematic(nr_seq_obj_sch_w)
		into STRICT 	ds_funcao_w,
				ds_path_schematic_w
		;
	
		/*ds_documentation_w := 	' View: ' || nr_visao_w
								|| ' Function: ' ||  ds_funcao_w 
								|| ' ExpressionCode: ' || cd_exp_label_w 
								|| ' ExpressionDescription: ' || ds_description_w
								|| ' Similarity: ' || nr_similarity_w || '%'
								|| ' Path : ' || ds_path_schematic_w;
		*/
		
		ds_documentation_w := 	'->  Function: ' ||  ds_funcao_w || chr(13)
								|| ds_path_schematic_w || chr(13)
								|| '  -> ' || ds_description_w || '[ Similarity: ' || nr_similarity_w || '% ]';
								

		insert into res_cadastro_ontologia_phi(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_valor_tasy,
						nm_tabela,
						nm_atributo,
						ie_ontologia,
						cd_valor_ontologia,
						ds_documentacao,
						ie_situacao,
						nr_seq_visao)
		values (		nextval('res_cadastro_ontologia_phi_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						null,
						nm_tabela_w,
						nm_atributo_w,
						'SNO',
						ds_valor_onto_p,
						ds_documentation_w,
						null,
						nr_visao_w);
	
	end;
end loop;
close C01;


open C02;
loop
fetch C02 into
	vl_dominio_w,
	cd_expvl_dominio_w,
	nm_atributo_w,
	nm_tabela_w,
	cd_funcao_w,
	ds_description_w,
	nr_visao_w,
	nr_similarity_w,
	nr_seq_obj_sch_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin		
	
		select 	obter_desc_funcao_idioma(cd_funcao_w, 5),
				get_path_schematic(nr_seq_obj_sch_w)
		into STRICT 	ds_funcao_w,
				ds_path_schematic_w
		;
		
		/*
		ds_documentation_w := 	' View: ' || nr_visao_w
								|| ' Function: ' ||  ds_funcao_w 
								|| ' ExpressionCode: ' || cd_expvl_dominio_w 
								|| ' ExpressionDescription: ' || ds_description_w
								|| ' Similarity: ' || nr_similarity_w || '%'
								|| ' Path : ' || ds_path_schematic_w;
		*/
		
		ds_documentation_w := 	'->  Function: ' ||  ds_funcao_w || chr(13)
								|| ds_path_schematic_w || chr(13)
								|| '  -> ' || ds_description_w || '[ Similarity: ' || nr_similarity_w || '% ]';
	
		insert into res_cadastro_ontologia_phi(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_valor_tasy,
						nm_tabela,
						nm_atributo,
						ie_ontologia,
						cd_valor_ontologia,
						ds_documentacao,
						ie_situacao,
						nr_seq_visao)
		values (		nextval('res_cadastro_ontologia_phi_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						vl_dominio_w,
						nm_tabela_w,
						nm_atributo_w,
						'SNO',
						ds_valor_onto_p,
						ds_documentation_w,
						null,
						nr_visao_w);
	
	end;
end loop;
close C02;


open C03;
loop
fetch C03 into
	cd_exp_valores_w,
	nm_atributo_w,
	nm_tabela_w,
	cd_funcao_w,
	ds_description_w,
	nr_visao_w,
	nr_seq_obj_sch_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	
		open C04;
		loop
		fetch C04 into	
			cd_exp_val_sep_w,
			ds_exp_val_sep_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			
	
				open C05;
				loop
				fetch C05 into	
					ds_exp_w;
				EXIT WHEN NOT FOUND; /* apply on C05 */
					begin
					
						select 	obter_desc_funcao_idioma(cd_funcao_w, 5),
								get_path_schematic(nr_seq_obj_sch_w)
						into STRICT 	ds_funcao_w,
								ds_path_schematic_w
						;
		
						/*
						ds_documentation_w := 	' View: ' || nr_visao_w
												|| ' Function: ' ||  ds_funcao_w 
												|| ' ExpressionCode: ' || cd_exp_valores_w 
												|| ' ExpressionDescription: ' || ds_description_w
												|| ' Similarity: ' || nr_similarity_w || '%'
												|| ' Path : ' || ds_path_schematic_w;
						*/
												
						ds_documentation_w := 	'->  Function: ' ||  ds_funcao_w || chr(13)
												|| ds_path_schematic_w || chr(13)
												|| '  -> ' || ds_description_w || '[ Similarity: ' || nr_similarity_w || '% ]';
												
				
						insert into res_cadastro_ontologia_phi(
										nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										cd_valor_tasy,
										nm_tabela,
										nm_atributo,
										ie_ontologia,
										cd_valor_ontologia,
										ds_documentacao,
										ie_situacao,
										nr_seq_visao)
						values (		nextval('res_cadastro_ontologia_phi_seq'),
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										ds_exp_val_sep_w,
										nm_tabela_w,
										nm_atributo_w,
										'SNO',
										ds_valor_onto_p,
										ds_documentation_w,
										null,
										nr_visao_w);
				
					end;
				end loop;
				close C05;					
	
			end;
		end loop;
		close C04;
	
	end;
end loop;
close C03;


commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE create_ontology_expression ( ds_description_p text, ds_valor_onto_p text, min_similarity_p bigint, nm_usuario_p text) FROM PUBLIC;
