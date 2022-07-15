-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_resumo_angio_retino (cd_estabelecimento_p bigint, nr_seq_consulta_p bigint, cd_pessoa_fisica_p text, ie_mostra_todos_p text, nr_seq_item_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
nm_profissional_w	varchar(255);
ds_espaco_20_w		varchar(255) 	:= lpad(' ',1,' ');
ds_enter_w		varchar(30)	:= chr(13) || chr(10);	
ds_observacao_w		varchar(1000);
dt_registro_w		varchar(30);
ds_oe_angiografia_w	varchar(1000);
ds_retinografia_w	varchar(1000);
ds_oe_retinografia_w	varchar(1000);
ds_angiografia_w	varchar(1000);
nr_sequencia_w		bigint;
qt_imagem_exame_w	bigint;
ds_contem_imagem_w   varchar(1000);

ds_angio_retino_w	varchar(32000);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(774161, null, wheb_usuario_pck.get_nr_seq_idioma);--Esta consulta possui imagem do angio/retino, favor visualizar a mesma! 
expressao2_w	varchar(255) := obter_desc_expressao_idioma(327202, null, wheb_usuario_pck.get_nr_seq_idioma);--Data: 
expressao3_w	varchar(255) := obter_desc_expressao_idioma(728918, null, wheb_usuario_pck.get_nr_seq_idioma);--PROFISSIONAL: 
expressao4_w	varchar(255) := obter_desc_expressao_idioma(283482, null, wheb_usuario_pck.get_nr_seq_idioma);--ANGIOFLUORESCEINOGRAFIA OD 
expressao5_w	varchar(255) := obter_desc_expressao_idioma(283483, null, wheb_usuario_pck.get_nr_seq_idioma);--ANGIOFLUORESCEINOGRAFIA OE 
expressao6_w	varchar(255) := obter_desc_expressao_idioma(297860, null, wheb_usuario_pck.get_nr_seq_idioma);--RETINOGRAFIA OD 
expressao7_w	varchar(255) := obter_desc_expressao_idioma(329252, null, wheb_usuario_pck.get_nr_seq_idioma);--OBSERVAÇÃO 
C01 CURSOR FOR 
SELECT obter_nome_pf(cd_profissional) nm_profissional, 
	  TO_CHAR(dt_registro,'dd/mm/yyyy hh24:mi:ss'), 
	  ds_angiografia, 
	  ds_oe_angiografia, 
	  ds_retinografia,   
	  ds_oe_retinografia, 
	  ds_observacao, 
	  nr_sequencia 
FROM  OFT_ANGIO_RETINO 
WHERE 	((nr_seq_consulta = nr_seq_consulta_p) OR ((ie_mostra_todos_p = 'S') AND nr_seq_consulta IN (SELECT c.nr_sequencia 
                                    	 	 	   FROM  atendimento_paciente b, 
                                       				   oft_consulta c 
                                    				   WHERE  c.nr_atendimento = b.nr_atendimento 
                                    			   AND  b.cd_pessoa_fisica = cd_pessoa_fisica_p)))	 
AND  coalesce(ie_situacao,'A') = 'A'  
ORDER BY dt_registro desc;


BEGIN 
 
open C01;
loop 
	fetch C01 into 
		nm_profissional_w, 
		dt_registro_w, 
		ds_angiografia_w, 
		ds_oe_angiografia_w, 
		ds_retinografia_w, 
		ds_oe_retinografia_w, 
		ds_observacao_w, 
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select count(nr_sequencia) 
	into STRICT	qt_imagem_exame_w 
	from 	oft_imagem_exame 
	where	nr_seq_angio_retino = nr_sequencia_w;
 
	if (coalesce(qt_imagem_exame_w,0) > 0) then 
		ds_contem_imagem_w := upper(expressao1_w);
	else   
		ds_contem_imagem_w := '';
	end if;
	 
	ds_angio_retino_w	:= 	'';
	ds_angio_retino_w	:= 	ds_angio_retino_w || upper(expressao2_w) || ' ' || dt_registro_w || ds_espaco_20_w || 
								upper(expressao3_w) || ' ' ||nm_profissional_w || ds_enter_w ||ds_enter_w;
	if (ds_angiografia_w IS NOT NULL AND ds_angiografia_w::text <> '') then 
		ds_angio_retino_w	:= ds_angio_retino_w || upper(expressao4_w) || ': ' || ds_angiografia_w ||ds_enter_w;
	end if;
	 
	if (ds_oe_angiografia_w IS NOT NULL AND ds_oe_angiografia_w::text <> '') then 
		ds_angio_retino_w	:= ds_angio_retino_w || upper(expressao5_w) || ': ' || ds_oe_angiografia_w ||ds_enter_w;
	end if;
	 
	if (ds_retinografia_w IS NOT NULL AND ds_retinografia_w::text <> '') then 
		ds_angio_retino_w	:= ds_angio_retino_w || upper(expressao6_w) || ': ' || ds_retinografia_w ||ds_enter_w;
	end if;
	 
	if (ds_oe_retinografia_w IS NOT NULL AND ds_oe_retinografia_w::text <> '') then 
		ds_angio_retino_w	:= ds_angio_retino_w || upper(expressao6_w) || ': ' || ds_oe_retinografia_w ||ds_enter_w;
	end if;
	 
	ds_angio_retino_w := ds_angio_retino_w || ds_enter_w || upper(expressao7_w) || ' ' || ds_observacao_w ||ds_enter_w || ds_contem_imagem_w || ds_enter_w;
	 
	CALL gravar_registro_resumo_oft(ds_angio_retino_w,nr_seq_item_p,nm_usuario_p,to_date(dt_registro_w,'dd/mm/yyyy hh24:mi:ss'));
	end;
end loop;
close C01;
	 
 
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_resumo_angio_retino (cd_estabelecimento_p bigint, nr_seq_consulta_p bigint, cd_pessoa_fisica_p text, ie_mostra_todos_p text, nr_seq_item_p bigint, nm_usuario_p text) FROM PUBLIC;

