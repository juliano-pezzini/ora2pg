-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_gerar_laudo_angio ( nr_seq_proc_p bigint, nm_usuario_p text) AS $body$
DECLARE



ds_conc_manometria_w		varchar(20000) := ' ';
ds_coronariografia_w		varchar(20000) := ' ';
ds_ventriculografia_w		varchar(20000) := ' ';
ds_cineangiocardiografia_w	varchar(20000) := ' ';
ds_conclusao_w			varchar(20000) := ' ';
ds_observacao_w			varchar(20000) := ' ';
ds_texto_w			varchar(20000) := ' ';
ds_cabecalho_w			varchar(20000) := ' ';
ds_seta_w			varchar(20000) := ' ';
ds_circulacao_w			varchar(20000) := ' ';
ds_sql_w			varchar(20000);
retorno_w			integer;
--nr_seq_proc_w			number(10);
c001				integer;

C01 CURSOR FOR
	SELECT '\par '||wheb_mensagem_pck.get_texto(293500)||
		CASE WHEN coalesce(a.nr_seq_segmento::text, '') = '' THEN ''  ELSE ' '||SUBSTR(obter_desc_hem_segmento_princ(a.nr_seq_segmento),1,100)||' ' END ||
		CASE WHEN coalesce(a.nr_seq_vaso::text, '') = '' THEN ''  ELSE ' da(o) '||SUBSTR(obter_desc_hem_vaso(a.nr_seq_vaso),1,100) END ||
		', '||wheb_mensagem_pck.get_texto(293502)||' '||
		CASE WHEN coalesce(d.qt_diametro::text, '') = '' THEN ''  ELSE d.qt_diametro||' mm' END ||
		' x '||CASE WHEN coalesce(d.qt_comprimento::text, '') = '' THEN ''  ELSE d.qt_comprimento||' mm' END ||CASE WHEN e.ie_sucesso='S' THEN  ', '||wheb_mensagem_pck.get_texto(293560) END ||'.'
	FROM hem_coronariografia a
LEFT OUTER JOIN hem_cat_lesao b ON (a.nr_sequencia = b.nr_seq_cornon)
LEFT OUTER JOIN hem_atc e ON (a.nr_sequencia = e.nr_seq_coron)
LEFT OUTER JOIN hem_atc_stent d ON (e.nr_sequencia = d.nr_seq_atc)
WHERE a.nr_seq_proc	= nr_seq_proc_p   ORDER BY b.nr_sequencia;


BEGIN
if (coalesce(nr_seq_proc_p,0) > 0) then

	ds_texto_w	:= 	'';

	ds_seta_w	:= 	'{\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fnil\fcharset0 Calibri;}}'||
				'{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\sa200\sl276\slmult1\lang22\b\f0\fs24\u8594?\b0\fs22'||
				'} ';

	ds_cabecalho_w	:=	'{\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fnil\fcharset0 Arial;}{\f1\fnil\fcharset0 Calibri;}}'||
				'{\colortbl ;\red0\green0\blue0;}';

	open C01;
	loop
	fetch C01 into
		ds_texto_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_conclusao_w := ds_conclusao_w || chr(13)|| ds_texto_w||'\par '||chr(13);
		end;
	end loop;
	close C01;

	if (ds_conclusao_w <> ' ') then
		ds_conclusao_w	:= '\viewkind4\uc1\pard\cf1\lang1046\b\fs20 '|| UPPER(wheb_mensagem_pck.get_texto(293574)) ||
					'\par \pard\qj '||'\b0 '||
					ds_conclusao_w ||
					'\par \pard\qj '||
					'\par \pard\qj ';
	end if;

	ds_sql_w	:= ' update hem_proc set ds_laudo = :DS_LAUDO where nr_sequencia  = '||nr_seq_proc_p;

	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_sql_w, dbms_sql.Native);
	DBMS_SQL.BIND_VARIABLE(C001, 'DS_LAUDO', ds_cabecalho_w || ds_conclusao_w ||' }');
	retorno_w := DBMS_SQL.EXECUTE(c001);
	DBMS_SQL.CLOSE_CURSOR(C001);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_gerar_laudo_angio ( nr_seq_proc_p bigint, nm_usuario_p text) FROM PUBLIC;

