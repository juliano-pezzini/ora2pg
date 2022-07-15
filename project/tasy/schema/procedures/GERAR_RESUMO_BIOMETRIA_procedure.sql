-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_resumo_biometria (cd_estabelecimento_p bigint, nr_seq_consulta_p bigint, cd_pessoa_fisica_p text, ie_mostra_todos_p text, nr_seq_item_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
nm_profissional_w		varchar(255);
ds_espaco_20_w			varchar(255) 	:= lpad(' ',1,' ');
ds_enter_w				varchar(30)	:= chr(13) || chr(10);	
ds_observacao_w			varchar(1000);
dt_registro_w			varchar(30);
ds_biometria_w			varchar(32000);
qt_od_acd_inter_w		real;
qt_od_eixo_inter_w		real;
qt_od_emt_inter_w		real;
ie_od_formula_inter_w	varchar(10);
qt_od_acd_ultra_w		real;
qt_od_eixo_ultra_w		real;
qt_od_emt_ultra_w		real;
ie_od_formula_ultra_w	varchar(10);
ds_od_formula_inter_w	varchar(255);
ds_od_formula_ultra_w	varchar(255);
ds_oe_formula_inter_w	varchar(255);
ds_oe_formula_ultra_w	varchar(255);
qt_oe_acd_inter_w		real;
qt_oe_eixo_inter_w		real;
qt_oe_emt_inter_w		real;
qt_oe_acd_ultra_w		real;
qt_oe_eixo_ultra_w		real;
qt_oe_emt_ultra_w		real;

C01 CURSOR FOR 
SELECT obter_nome_pf(cd_profissional) nm_profissional, 
	  TO_CHAR(dt_registro,'dd/mm/yyyy hh24:mi:ss'), 
	  qt_od_acd_inter, 
	  qt_od_eixo_inter, 
	  qt_od_emt_inter, 
	  obter_valor_dominio(3950,ie_od_formula_inter) ds_formula1, 
	  qt_od_acd_ultra, 
	  qt_od_eixo_ultra, 
	  qt_od_emt_ultra, 
	  obter_valor_dominio(3950,ie_od_formula_ultra) ds_formula2, 
	  qt_oe_acd_inter, 
	  qt_oe_eixo_inter, 
	  qt_oe_emt_inter, 
	  obter_valor_dominio(3950,ie_oe_formula_inter) ds_formula3, 
	  ds_observacao, 
	  qt_oe_acd_ultra, 
	  qt_oe_eixo_ultra, 
	  qt_oe_emt_ultra, 
	  obter_valor_dominio(3950,ie_oe_formula_ultra) ds_formula4 
FROM  oft_biometria 
WHERE 	((nr_seq_consulta = nr_seq_consulta_p) OR ((ie_mostra_todos_p = 'S') AND nr_seq_consulta IN (SELECT c.nr_sequencia 
                                    	 	 	   FROM  atendimento_paciente b, 
                                       				   oft_consulta c 
                                    				   WHERE  c.nr_atendimento = b.nr_atendimento 
                                    			   AND  b.cd_pessoa_fisica = cd_pessoa_fisica_p))) 
and  coalesce(ie_situacao,'A') = 'A'	  	  
ORDER BY dt_registro desc;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	  nm_profissional_w, 
	  dt_registro_w, 
	  qt_od_acd_inter_w, 
	  qt_od_eixo_inter_w, 
	  qt_od_emt_inter_w, 
	  ds_od_formula_inter_w, 
	  qt_od_acd_ultra_w, 
	  qt_od_eixo_ultra_w, 
	  qt_od_emt_ultra_w, 
	  ds_od_formula_ultra_w, 
	  qt_oe_acd_inter_w, 
	  qt_oe_eixo_inter_w, 
	  qt_oe_emt_inter_w, 
	  ds_oe_formula_inter_w, 
	  ds_observacao_w, 
	  qt_oe_acd_ultra_w, 
	  qt_oe_eixo_ultra_w, 
	  qt_oe_emt_ultra_w, 
    ds_oe_formula_ultra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
		ds_biometria_w	:=	'';
		ds_biometria_w	:= 	ds_biometria_w || obter_desc_expressao(343703) || ' ' || dt_registro_w || ds_espaco_20_w || 
							'PROFISSIONAL: ' ||nm_profissional_w || ds_enter_w || ds_enter_w;
	    ds_biometria_w	:= ds_biometria_w ||'INTERFEROMETRIA'||ds_enter_w;	
	if (qt_od_acd_inter_w IS NOT NULL AND qt_od_acd_inter_w::text <> '') or (qt_od_eixo_inter_w IS NOT NULL AND qt_od_eixo_inter_w::text <> '') or (qt_od_emt_inter_w IS NOT NULL AND qt_od_emt_inter_w::text <> '') or (ds_od_formula_inter_w IS NOT NULL AND ds_od_formula_inter_w::text <> '')	then 
		ds_biometria_w	:= ds_biometria_w || lpad('OD ACD: ',12,' ')||to_char(qt_od_acd_inter_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || Lpad(obter_desc_expressao(289084),12,' ') ||to_char(qt_od_eixo_inter_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || lpad('EMT: ',12,' ')||to_char(qt_od_emt_inter_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || Lpad(obter_desc_expressao(290429),12,' ') ||ds_od_formula_inter_w|| ds_enter_w;
	end if;
	 
	if (qt_oe_acd_inter_w IS NOT NULL AND qt_oe_acd_inter_w::text <> '') or (qt_oe_eixo_inter_w IS NOT NULL AND qt_oe_eixo_inter_w::text <> '') or (qt_oe_emt_inter_w IS NOT NULL AND qt_oe_emt_inter_w::text <> '') or (ds_oe_formula_inter_w IS NOT NULL AND ds_oe_formula_inter_w::text <> '')	then 
		ds_biometria_w	:= ds_biometria_w || lpad('OE ACD: ',12,' ')||to_char(qt_oe_acd_inter_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || Lpad(obter_desc_expressao(289084),12,' ') ||to_char(qt_oe_eixo_inter_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || lpad('EMT: ',12,' ')||to_char(qt_oe_emt_inter_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || Lpad(obter_desc_expressao(290429),12,' ') ||ds_oe_formula_inter_w ||ds_enter_w;
	end if;
	 
	ds_biometria_w	:= ds_biometria_w || ds_enter_w || 'ULTRASSONICA'||ds_enter_w;	
	 
	if (qt_od_acd_ultra_w IS NOT NULL AND qt_od_acd_ultra_w::text <> '') or (qt_od_eixo_ultra_w IS NOT NULL AND qt_od_eixo_ultra_w::text <> '') or (qt_od_emt_ultra_w IS NOT NULL AND qt_od_emt_ultra_w::text <> '') or (ds_od_formula_ultra_w IS NOT NULL AND ds_od_formula_ultra_w::text <> '')	then 
		ds_biometria_w	:= ds_biometria_w ||lpad('OD ACD: ',12,' ')||to_char(qt_od_acd_ultra_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || Lpad(obter_desc_expressao(289084),12,' ') ||to_char(qt_od_eixo_ultra_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w ||lpad('EMT: ',12,' ')||to_char(qt_od_emt_ultra_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || Lpad(obter_desc_expressao(290429),12,' ') ||ds_od_formula_ultra_w ||ds_enter_w;
	end if;
	 
	if (qt_oe_acd_ultra_w IS NOT NULL AND qt_oe_acd_ultra_w::text <> '') or (qt_oe_eixo_ultra_w IS NOT NULL AND qt_oe_eixo_ultra_w::text <> '') or (qt_oe_emt_ultra_w IS NOT NULL AND qt_oe_emt_ultra_w::text <> '') or (ds_oe_formula_ultra_w IS NOT NULL AND ds_oe_formula_ultra_w::text <> '')	then 
		ds_biometria_w	:= ds_biometria_w ||lpad('OE ACD: ',12,' ')||to_char(qt_oe_acd_ultra_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || Lpad(obter_desc_expressao(289084),12,' ') ||to_char(qt_oe_eixo_ultra_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w ||lpad('EMT: ',12,' ')||to_char(qt_oe_emt_ultra_w, 'fm999990.00');
		ds_biometria_w	:= ds_biometria_w || Lpad(obter_desc_expressao(290429),12,' ') ||ds_oe_formula_ultra_w ||ds_enter_w;
	end if;
	ds_biometria_w := ds_biometria_w || ds_enter_w || obter_desc_expressao(330933)/*'OBSERVAÇÃO: '*/
 || ds_observacao_w ||ds_enter_w;
 
	CALL gravar_registro_resumo_oft(ds_biometria_w,nr_seq_item_p,nm_usuario_p,to_date(dt_registro_w,'dd/mm/yyyy hh24:mi:ss'));
	 
	end;
end loop;
close C01;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_resumo_biometria (cd_estabelecimento_p bigint, nr_seq_consulta_p bigint, cd_pessoa_fisica_p text, ie_mostra_todos_p text, nr_seq_item_p bigint, nm_usuario_p text) FROM PUBLIC;

