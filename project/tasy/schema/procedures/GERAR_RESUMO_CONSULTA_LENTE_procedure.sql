-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_resumo_consulta_lente (cd_estabelecimento_p bigint, nr_seq_consulta_p bigint, cd_pessoa_fisica_p text, ie_mostra_todos_p text, nr_seq_item_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
nm_profissional_w	varchar(255);
ds_espaco_20_w		varchar(255) 	:= lpad(' ',1,' ');
ds_enter_w		varchar(30)	:= chr(13) || chr(10);	
ds_observacao_w		varchar(1000);
dt_registro_w		varchar(30);
ds_lentes_w		varchar(32000);
qt_eixo_w		double precision;
qt_adicao_w		double precision;
qt_grau_cilindrico_w	double precision;
qt_grau_longe_w		double precision;
desc_lente_w		varchar(255);
ds_lado_w		varchar(255);
qt_grau_lente_w		double precision;
qt_grau_esferico_w	double precision;
ie_tela_nova_lente_w	varchar(1);
qt_curva_base_w		double precision;
qt_curva_base_um_w  	double precision;		
qt_curva_base_dois_w	double precision;	
qt_diametro_w	 	double precision;

expressao1_w	varchar(255) := obter_desc_expressao_idioma(327202, null, wheb_usuario_pck.get_nr_seq_idioma);--DATA: 
expressao2_w	varchar(255) := obter_desc_expressao_idioma(728918, null, wheb_usuario_pck.get_nr_seq_idioma);--PROFISSIONAL: 
expressao3_w	varchar(255) := obter_desc_expressao_idioma(292502, null, wheb_usuario_pck.get_nr_seq_idioma);--LENTE 
expressao4_w	varchar(255) := obter_desc_expressao_idioma(294765, null, wheb_usuario_pck.get_nr_seq_idioma);--OLHO 
expressao5_w	varchar(255) := obter_desc_expressao_idioma(311147, null, wheb_usuario_pck.get_nr_seq_idioma);--CB 
expressao6_w	varchar(255) := obter_desc_expressao_idioma(311620, null, wheb_usuario_pck.get_nr_seq_idioma);--CB1 
expressao7_w	varchar(255) := obter_desc_expressao_idioma(311148, null, wheb_usuario_pck.get_nr_seq_idioma);--CB2 
expressao8_w	varchar(255) := obter_desc_expressao_idioma(287729, null, wheb_usuario_pck.get_nr_seq_idioma);--DIÂMETRO 
expressao9_w	varchar(255) := obter_desc_expressao_idioma(290981, null, wheb_usuario_pck.get_nr_seq_idioma);--GRAU ESFÉRICO 
expressao10_w	varchar(255) := obter_desc_expressao_idioma(290964, null, wheb_usuario_pck.get_nr_seq_idioma);--GRAU CILÍNDRICO 
expressao11_w	varchar(255) := obter_desc_expressao_idioma(289084, null, wheb_usuario_pck.get_nr_seq_idioma);--EIXO 
expressao12_w	varchar(255) := obter_desc_expressao_idioma(283205, null, wheb_usuario_pck.get_nr_seq_idioma);--ADIÇÃO 
expressao13_w	varchar(255) := obter_desc_expressao_idioma(294639, null, wheb_usuario_pck.get_nr_seq_idioma);--OBSERVAÇÃO 
expressao14_w	varchar(255) := obter_desc_expressao_idioma(290963, null, wheb_usuario_pck.get_nr_seq_idioma);--GRAU 
expressao15_w	varchar(255) := obter_desc_expressao_idioma(290990, null, wheb_usuario_pck.get_nr_seq_idioma);--GRAU LONGE 
C25 CURSOR FOR 
SELECT TO_CHAR(dt_atualizacao,'dd/mm/yyyy hh24:mi:ss'), 
	SUBSTR(obter_desc_lente_contato(nr_seq_lente),1,255) desc_lente, 
	SUBSTR(obter_valor_dominio(1372,IE_LADO),1,255) ds_lado, 
	QT_GRAU, 
	QT_GRAU_ESFERICO, 
	QT_GRAU_CILINDRICO, 
	QT_GRAU_LONGE, 
	QT_EIXO, 
	QT_ADICAO, 
	obter_nome_pf(cd_profissional) nm_profissional, 
	qt_curva_base,        
	qt_curva_base_um,      		 
	qt_curva_base_dois,	  
	qt_diametro, 
	ds_observacao 
FROM	OFT_consulta_lente 
WHERE 	((nr_seq_consulta = nr_seq_consulta_p) OR ((ie_mostra_todos_p = 'S') AND nr_seq_consulta IN (SELECT c.nr_sequencia 
                                    	 	 	   FROM  atendimento_paciente b, 
                                       				   oft_consulta c 
                                    				   WHERE  c.nr_atendimento = b.nr_atendimento 
                                    			   AND  b.cd_pessoa_fisica = cd_pessoa_fisica_p))) 
AND	coalesce(ie_situacao,'A') = 'A' 
ORDER  BY dt_atualizacao, ds_lado desc;


BEGIN 
 
ie_tela_nova_lente_w := obter_param_usuario(3010, 62, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_tela_nova_lente_w);
 
open C25;
loop 
	fetch C25 into 
		dt_registro_w, 
		desc_lente_w,		 
		ds_lado_w,		 
		qt_grau_lente_w,		 
		qt_grau_esferico_w,	 
		qt_grau_cilindrico_w,	 
		qt_grau_longe_w,		 
		qt_eixo_w,		 
		qt_adicao_w, 
		nm_profissional_w, 
		qt_curva_base_w,		       
		qt_curva_base_um_w,  	   		 
		qt_curva_base_dois_w,	 	  
		qt_diametro_w, 
		ds_observacao_w;	
	EXIT WHEN NOT FOUND; /* apply on C25 */
	begin 
	 
	if (ie_tela_nova_lente_w = 'S') then 
		ds_lentes_w	:=	'';
		ds_lentes_w	:= 	ds_lentes_w || upper(expressao1_w) || ' ' || dt_registro_w || ds_espaco_20_w || 
					    upper(expressao2_w) || ' ' ||nm_profissional_w || ds_enter_w ||ds_enter_w;
	 
		ds_lentes_w	:= ds_lentes_w ||upper(expressao3_w) || ' : ' ||desc_lente_w ||ds_enter_w;
		ds_lentes_w	:= ds_lentes_w ||upper(expressao4_w) || ' : ' ||ds_lado_w || ds_enter_w;
	 
		 
		if (qt_curva_base_w IS NOT NULL AND qt_curva_base_w::text <> '') or (qt_curva_base_um_w IS NOT NULL AND qt_curva_base_um_w::text <> '') or (qt_curva_base_dois_w IS NOT NULL AND qt_curva_base_dois_w::text <> '') then 
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao5_w) || ': ',18,' ')||to_char(qt_curva_base_w, 'fm999990.00')||ds_espaco_20_w;
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao6_w) || ': ',18,' ')||to_char(qt_curva_base_um_w, 'fm999990.00')||ds_espaco_20_w;
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao7_w) || ': ',18,' ')||to_char(qt_curva_base_dois_w, 'fm999990.00')||ds_enter_w;
		end if;
		 
		if (qt_grau_esferico_w IS NOT NULL AND qt_grau_esferico_w::text <> '') or (qt_grau_cilindrico_w IS NOT NULL AND qt_grau_cilindrico_w::text <> '') or (qt_diametro_w IS NOT NULL AND qt_diametro_w::text <> '')	then 
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao8_w) || ': ',18,' ')||to_char(qt_diametro_w, 'fm999990.00')||ds_espaco_20_w;
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao9_w) || ': ',18,' ')||oft_obter_valor_com_sinal(qt_grau_esferico_w)||ds_espaco_20_w;
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao10_w) || ': ',18,' ')||to_char(qt_grau_cilindrico_w, 'fm999990.00')||ds_enter_w;
		end if;
	 
		if (qt_eixo_w IS NOT NULL AND qt_eixo_w::text <> '') or (qt_adicao_w IS NOT NULL AND qt_adicao_w::text <> '') then 
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao11_w) || ': ',18,' ')||(qt_eixo_w);
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao12_w) || ': ',18,' ')||oft_obter_valor_com_sinal(qt_adicao_w) ||ds_enter_w;
		end if;
	 
	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then 
		ds_lentes_w	:= ds_lentes_w || ds_enter_w || upper(expressao13_w) || ': ' || ds_observacao_w ||ds_enter_w;
	end if;
		 
		 
	CALL gravar_registro_resumo_oft(ds_lentes_w,nr_seq_item_p,nm_usuario_p,to_date(dt_registro_w,'dd/mm/yyyy hh24:mi:ss'));
	 
	elsif (ie_tela_nova_lente_w = 'N') then 
		ds_lentes_w	:=	'';
		ds_lentes_w	:= 	ds_lentes_w || upper(expressao1_w) || ': ' || dt_registro_w || ds_espaco_20_w || 
						    upper(expressao2_w) || ': ' ||nm_profissional_w || ds_enter_w ||ds_enter_w;
	 
		ds_lentes_w	:= ds_lentes_w ||upper(expressao3_w) || ': ' ||desc_lente_w ||ds_enter_w;
		ds_lentes_w	:= ds_lentes_w ||upper(expressao4_w) || ': ' ||ds_lado_w || ds_enter_w;
	 
		if (qt_grau_lente_w IS NOT NULL AND qt_grau_lente_w::text <> '') or (qt_grau_esferico_w IS NOT NULL AND qt_grau_esferico_w::text <> '') or (qt_grau_cilindrico_w IS NOT NULL AND qt_grau_cilindrico_w::text <> '') then 
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao14_w) || ': ',18,' ')||qt_grau_lente_w||ds_espaco_20_w;
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao9_w) || ': ',18,' ')||qt_grau_esferico_w||ds_espaco_20_w;
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao10_w) || ': ',18,' ')||qt_grau_cilindrico_w||ds_enter_w;
		end if;
	 
		if (qt_grau_longe_w IS NOT NULL AND qt_grau_longe_w::text <> '') or (qt_eixo_w IS NOT NULL AND qt_eixo_w::text <> '') or (qt_adicao_w IS NOT NULL AND qt_adicao_w::text <> '') 	 then 
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao15_w) || ': ',18,' ')||qt_grau_longe_w;
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao11_w) || ': ',18,' ')||qt_eixo_w;
			ds_lentes_w	:= ds_lentes_w ||lpad(upper(expressao12_w) || ': ',18,' ')||qt_adicao_w ||ds_enter_w;
		end if;
	 
	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then 
		ds_lentes_w	:= ds_lentes_w || ds_enter_w || upper(expressao13_w) || ': ' || ds_observacao_w ||ds_enter_w;
	end if;
		 
		 
	CALL gravar_registro_resumo_oft(ds_lentes_w,nr_seq_item_p,nm_usuario_p,to_date(dt_registro_w,'dd/mm/yyyy hh24:mi:ss'));
	end if;
	 
	end;
end loop;
close C25;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_resumo_consulta_lente (cd_estabelecimento_p bigint, nr_seq_consulta_p bigint, cd_pessoa_fisica_p text, ie_mostra_todos_p text, nr_seq_item_p bigint, nm_usuario_p text) FROM PUBLIC;
