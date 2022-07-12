-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cont_email_solic_medica (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_solicita_medica_w	varchar(2000);
ds_material_w		varchar(255);
qt_material_w		double precision;
ie_permanente_w		varchar(255);
ds_fornecedor_w		varchar(255);
ds_observacao_w		varchar(255);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(312878, null, wheb_usuario_pck.get_nr_seq_idioma);--Qt
expressao2_w	varchar(255) := obter_desc_expressao_idioma(295535, null, wheb_usuario_pck.get_nr_seq_idioma);--Permanente
expressao3_w	varchar(255) := obter_desc_expressao_idioma(298651, null, wheb_usuario_pck.get_nr_seq_idioma);--Solicitação médica
c01 CURSOR FOR
	SELECT	a.DS_MATERIAL,
		a.QT_QUANTIDADE,
		a.DS_FORNECEDOR,
		a.IE_PERMANENTE,
		SUBSTR(a.ds_observacao,1,255)
	FROM	AGENDA_PAC_CONSIGNADO a
	WHERE	a.nr_seq_agenda = nr_seq_agenda_p
	ORDER BY  a.ds_material DESC;


BEGIN

open c01;
loop
fetch c01 into
	ds_material_w,
	qt_material_w,
	ds_fornecedor_w,
	ie_permanente_w,
	ds_observacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_solicita_medica_w	:= substr(ds_material_w || ' ('||expressao1_w||': ' || qt_material_w || ')' || chr(13) || chr(10) || ds_fornecedor_w || chr(13) || chr(10) || expressao2_w || ': '|| ie_permanente_w || chr(13) || chr(10) || ds_observacao_w || chr(13) || chr(10) || ds_solicita_medica_w,1,2000);
	end;
end loop;
close c01;

ds_solicita_medica_w	:= substr(expressao3_w || ': ' || chr(13) || chr(10) || ds_solicita_medica_w,1,2000);

return 	substr(ds_solicita_medica_w,1,2000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cont_email_solic_medica (nr_seq_agenda_p bigint) FROM PUBLIC;
