-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_add_fav_recomendacao ( nr_seq_xml_p cpoe_parse_xml.nr_sequencia%type, nm_usuario_p cpoe_recomendacao.nm_usuario%type) AS $body$
DECLARE



cd_recomendacao_w		cpoe_recomendacao.cd_recomendacao%type;
ds_recomendacao_w		cpoe_recomendacao.ds_recomendacao%type;
cd_intervalo_w			cpoe_recomendacao.cd_intervalo%type;
nr_seq_topografia_w		cpoe_recomendacao.nr_seq_topografia%type;
nr_ocorrencia_w			cpoe_recomendacao.nr_ocorrencia%type;
ie_acm_w				cpoe_recomendacao.ie_acm%type;
ie_urgencia_w			cpoe_recomendacao.ie_urgencia%type;
ie_se_necessario_w		cpoe_recomendacao.ie_se_necessario%type;
ie_administracao_w		cpoe_recomendacao.ie_administracao%type;
ie_evento_unico_w		cpoe_recomendacao.ie_evento_unico%type;
ie_duracao_w			cpoe_recomendacao.ie_duracao%type;

c01 CURSOR FOR
SELECT 	ExtractValue( value( pes ) , 'JSONOBJECT/CD_RECOMENDACAO' ) cd_recomendacao,
		ExtractValue( value( pes ) , 'JSONOBJECT/DS_RECOMENDACAO' ) ds_recomendacao,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_INTERVALO' ) cd_intervalo,
		ExtractValue( value( pes ) , 'JSONOBJECT/NR_SEQ_TOPOGRAFIA' ) nr_seq_topografia,
		ExtractValue( value( pes ) , 'JSONOBJECT/NR_OCORRENCIA' ) nr_ocorrencia,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_ACM' ) ie_acm,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_URGENCIA' ) ie_urgencia,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_SE_NECESSARIO' ) ie_se_necessario,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_ADMINISTRACAO' ) ie_administracao,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_EVENTO_UNICO' ) ie_evento_unico,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_DURACAO' ) ie_duracao
from 	cpoe_parse_xml ,
		table( XMLSequence( extract( ds_xml, '/JSONOBJECT' ) ) ) pes
where	nr_sequencia  = nr_seq_xml_p;




BEGIN

open c01;
loop
fetch c01 into	cd_recomendacao_w,
				ds_recomendacao_w,
				cd_intervalo_w,
				nr_seq_topografia_w,
				nr_ocorrencia_w,
				ie_acm_w,
				ie_urgencia_w,
				ie_se_necessario_w,
				ie_administracao_w,
				ie_evento_unico_w,
				ie_duracao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	insert into cpoe_fav_recomendacao(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_ocorrencia,
						ds_recomendacao,
						cd_intervalo,
						cd_recomendacao,
						ie_acm,
						ie_urgencia,
						ie_se_necessario,
						ie_duracao,
						nr_seq_topografia,
						ie_administracao,
						ie_evento_unico)
					values (
						nextval('cpoe_fav_recomendacao_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_ocorrencia_w,
						ds_recomendacao_w,
						cd_intervalo_w,
						cd_recomendacao_w,
						ie_acm_w,
						ie_urgencia_w,
						ie_se_necessario_w,
						ie_duracao_w,
						nr_seq_topografia_w,
						ie_administracao_w,
						ie_evento_unico_w);
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_add_fav_recomendacao ( nr_seq_xml_p cpoe_parse_xml.nr_sequencia%type, nm_usuario_p cpoe_recomendacao.nm_usuario%type) FROM PUBLIC;

