-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_resumo_curva_tencional (cd_estabelecimento_p bigint, nr_seq_consulta_p bigint, cd_pessoa_fisica_p text, ie_mostra_todos_p text, nr_seq_item_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
nm_profissional_w	varchar(255);
ds_espaco_20_w		varchar(255) 	:= lpad(' ',1,' ');
ds_enter_w		varchar(30)	:= chr(13) || chr(10);	
ds_observacao_w		varchar(1000);
dt_registro_w		varchar(30);
ds_curva_tensional_w	varchar(32000);
ds_curva_tensional_oe_w varchar(1000);
ds_curva_tensional_od_w varchar(1000);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(327202, null, wheb_usuario_pck.get_nr_seq_idioma);--DATA: 
expressao2_w	varchar(255) := obter_desc_expressao_idioma(728918, null, wheb_usuario_pck.get_nr_seq_idioma);--PROFISSIONAL: 
expressao3_w	varchar(255) := obter_desc_expressao_idioma(294741, null, wheb_usuario_pck.get_nr_seq_idioma);--OD (mmHg) 
expressao4_w	varchar(255) := obter_desc_expressao_idioma(294760, null, wheb_usuario_pck.get_nr_seq_idioma);--OE (mmHg) 
C01 CURSOR FOR 
SELECT 	obter_nome_pf(cd_profissional) nm_profissional, 
	TO_CHAR(dt_registro,'dd/mm/yyyy hh24:mi:ss'), 
	vl_oe_ct, 
	vl_od_ct 
from	oft_curva_tencional 
WHERE 	((nr_seq_consulta = nr_seq_consulta_p) OR ((ie_mostra_todos_p = 'S') AND nr_seq_consulta IN (SELECT c.nr_sequencia 
                                    	 	 	   FROM  atendimento_paciente b, 
                                       				   oft_consulta c 
                                    				   WHERE  c.nr_atendimento = b.nr_atendimento 
                                    			   AND  b.cd_pessoa_fisica = cd_pessoa_fisica_p))) 
 
and	coalesce(ie_situacao,'A') = 'A' 
order by dt_registro desc;


BEGIN 
 
open C01;
loop 
	fetch C01 into 
		nm_profissional_w, 
		dt_registro_w, 
		ds_curva_tensional_oe_w, 
		ds_curva_tensional_od_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_curva_tensional_w	:=	'';
	ds_curva_tensional_w	:= 	ds_curva_tensional_w || upper(expressao1_w) || ' ' || dt_registro_w || ds_espaco_20_w || 
							   upper(expressao2_w) || ' ' ||nm_profissional_w || ds_enter_w||ds_enter_w;
	 
	ds_curva_tensional_w	:= ds_curva_tensional_w ||lpad(upper(expressao3_w) || ': ',15,' ')||ds_curva_tensional_od_w || ds_enter_w;
	ds_curva_tensional_w	:= ds_curva_tensional_w ||lpad(upper(expressao4_w) || ': ',15,' ')||ds_curva_tensional_oe_w || ds_enter_w;
	 
	CALL gravar_registro_resumo_oft(ds_curva_tensional_w,nr_seq_item_p,nm_usuario_p,to_date(dt_registro_w,'dd/mm/yyyy hh24:mi:ss'));
	end;
end loop;
close C01;
	 
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_resumo_curva_tencional (cd_estabelecimento_p bigint, nr_seq_consulta_p bigint, cd_pessoa_fisica_p text, ie_mostra_todos_p text, nr_seq_item_p bigint, nm_usuario_p text) FROM PUBLIC;

