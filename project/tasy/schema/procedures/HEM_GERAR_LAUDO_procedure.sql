-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_gerar_laudo ( nr_seq_proc_p bigint, nm_usuario_p text) AS $body$
DECLARE


				
ds_conc_manometria_w		varchar(20000) := '';
ds_coronariografia_w		varchar(20000) := '';
ds_ventriculografia_w		varchar(20000) := '';
ds_cineangiocardiografia_w	varchar(20000) := '';
ds_conclusao_w			varchar(20000) := '';
ds_observacao_w			varchar(20000) := '';
ds_texto_w			varchar(20000) := '';
ds_texto_aux_w			varchar(20000) := '';
ds_cabecalho_w			varchar(20000) := '';
ds_seta_w			varchar(20000) := '';
ds_circulacao_w			varchar(20000) := '';
ds_sql_w			varchar(20000);
retorno_w			integer;
nr_seq_apresent_w		bigint;
nr_seq_vaso_w			bigint;
c001				integer;
ie_tipo_w			integer;
nr_seq_coron_w			bigint;
qt_registros_w			bigint;
ie_lesao_culpada_w  		varchar(20);
ds_segmento_w       		varchar(2000);
ds_dominancia_w			varchar(100);
tx_dominancia_w			varchar(200);
novo_paragrafo  		varchar(14);
possui_anterior 		smallint := 0;

C01 CURSOR FOR
	SELECT	'\par  '||ds_seta_w||substr(obter_desc_hem_analise_man(a.nr_seq_analise),1,250)||' '
	from	hem_analise_manometria a
	where	a.nr_seq_proc	= nr_seq_proc_p
	order by (substr(Obter_seq_hem_analise_man(nr_seq_analise),1,255))::numeric;
	
	
C08 CURSOR FOR
	SELECT	distinct ds_seta_w||substr(CASE WHEN coalesce(a.nr_seq_vaso::text, '') = '' THEN ''  ELSE obter_desc_hem_vaso(a.nr_seq_vaso) END ,1,100)||chr(13),
		a.nr_seq_vaso,
		b.nr_seq_apresent		
	from	hem_coronariografia a,
		hem_vaso b
	where	nr_seq_proc	= nr_seq_proc_p
	and	a.nr_seq_vaso = b.nr_sequencia
	order by b.nr_seq_apresent;
	
C02 CURSOR FOR
	SELECT	CASE WHEN coalesce(a.nr_seq_importancia::text, '') = '' THEN  ''  ELSE substr(obter_descricao_padrao('HEM_IMPORTANCIA_VASO','DS_IMPORTANCIA',a.NR_SEQ_IMPORTANCIA)||' ',1,255) END ||
		CASE WHEN coalesce(a.nr_seq_tipo_lesao::text, '') = '' THEN ''  ELSE substr(obter_descricao_padrao('HEM_TIPO_LESAO','DS_TIPO_LESAO',a.NR_SEQ_TIPO_LESAO),1,255) END ||
		CASE WHEN a.pr_obstrucao='' THEN ''  ELSE ' '||pr_obstrucao||'%' END ||'',
		a.nr_sequencia		
	from	hem_coronariografia a,
		hem_vaso b
	where	nr_seq_proc	= nr_seq_proc_p
	and	a.nr_seq_vaso	= nr_seq_vaso_w
	and	a.nr_seq_vaso	= b.nr_sequencia
	order by a.nr_sequencia;
	
C03 CURSOR FOR
	SELECT	'\par '||ds_seta_w||'\viewkind4\uc1\pard\cf1\lang1046\b\fs24 '|| substr(obter_desc_expressao(289474)||': ',1,255)||'\b0 ', -- Esquerda
		1
	from	hem_ventriculografia_proc
	where	nr_seq_proc	= nr_seq_proc_p
	and	(nr_seq_ventric_ve IS NOT NULL AND nr_seq_ventric_ve::text <> '')
	
union

	SELECT	'\par '||ds_seta_w||'\viewkind4\uc1\pard\cf1\lang1046\b\fs24 '|| substr(obter_desc_expressao(287958)||': ',1,255)||'\b0 ', -- Direita
		2
	from	hem_ventriculografia_proc
	where	nr_seq_proc	= nr_seq_proc_p
	and	(nr_seq_ventric_vd IS NOT NULL AND nr_seq_ventric_vd::text <> '')
	order by 1 desc;
	
C09 CURSOR FOR
	SELECT substr(obter_descricao_padrao('HEM_DESC_VENTRICULOGRAFIA','DS_VENTRICULOGRAFIA',CASE WHEN  ie_tipo_w=1 THEN  NR_SEQ_VENTRIC_VE WHEN  ie_tipo_w=2 THEN  NR_SEQ_VENTRIC_VD END ),1,255)
	from hem_ventriculografia_proc
	where nr_seq_proc	= nr_seq_proc_p
	and CASE WHEN  ie_tipo_w=1 THEN NR_SEQ_VENTRIC_VE WHEN  ie_tipo_w=2 THEN NR_SEQ_VENTRIC_VD (END IS NOT NULL AND END::text <> '');

C04 CURSOR FOR
	SELECT	'\par '||ds_seta_w||substr(obter_descricao_padrao('HEM_DESC_CINEANGIOCARD','DS_CINEANGIOCARDIOGRAFIA',NR_SEQ_CINEANGIOC),1,255)||' '
	from	hem_cineangiocard_proc
	where	nr_seq_proc	= nr_seq_proc_p
	order by NR_SEQ_CINEANGIOC;

C05 CURSOR FOR
	SELECT	'\par  '||substr(obter_desc_hem_coronaria(nr_seq_coronaria),1,100)||' '
	from	hem_conclusao_coron
	where	nr_seq_proc	= nr_seq_proc_p
	order by 1;

C06 CURSOR FOR

	SELECT	'\par  '||replace(ds_observacao_laudo,chr(10),'\par '||chr(10))
	from	hem_observacao_laudo
	where	nr_seq_proc	= nr_seq_proc_p
	and	(ds_observacao_laudo IS NOT NULL AND ds_observacao_laudo::text <> '')
	order by 1;

C07 CURSOR FOR
	SELECT	'\par '|| ds_seta_w||substr(converte_pri_letra_maiusculo(hem_obter_desc_fonte_dir(nr_seq_fonte_dir)),1,255)||
						CASE WHEN coalesce(nr_seq_intensidade::text, '') = '' THEN ' '  ELSE ' '||substr(obter_desc_expressao(691064),1,30)||' '||substr(hem_obter_desc_intensidade(nr_seq_intensidade),1,255) END
	from	hem_circulacao_colateral
	where	nr_seq_proc	= nr_seq_proc_p
	and	ie_circulacao_col = 'S'
	order by 1;

C10 CURSOR FOR
	SELECT distinct ' '||SUBSTR(Obter_desc_hem_segmento_princ(a.nr_seq_segmento),1,100)
	from	hem_coron_localizacao a,
		hem_coronariografia b
	where	a.nr_seq_coron = nr_seq_coron_w
	and	b.nr_seq_proc	= nr_seq_proc_p
	order by 1;


BEGIN
if (coalesce(nr_seq_proc_p,0) > 0) then
	ds_texto_w	:= 	'';
	
	ds_seta_w	:= 	' {\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fnil\fcharset0 Calibri;}}'||
				'{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\sa200\sl276\slmult1\lang22\b\f0\fs24\u8594?\b0\fs22'||
				'} ';
				
				/*
				--seta

				'{\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fnil\fcharset0 Calibri;}}'||
				'{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\sa200\sl276\slmult1\lang22\b\f0\fs24\u8594?\b0\fs22'||
				'} ';
				
				--check negrito

				'{\listtext\pard\plain \li360\ri0\lin360\rin0\fi-360\f0\f1\f1\f1 \u10004}'||
				'{\ilvl0 \ltrpar\s1\rtlch\afs24\lang255\ltrch\dbch\af7\langfe255\hich\fs24\lang1046\loch\fs24\lang1046 '||
				'{\rtlch \ltrch\loch  }{\rtlch \ltrch\loch\f0\fs24\lang1046\i0\b0 }}  ';*/
				
	ds_cabecalho_w	:=	'{\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fnil\fcharset0 Arial;}{\f1\fnil\fcharset0 Calibri;}}'||
				'{\colortbl ;\red0\green0\blue0;}';

	select	substr(hem_obter_dominancia(max(a.NR_SEQ_IMPORTANCIA)),1,100) ds_dominancia
	into STRICT	ds_dominancia_w
	from	hem_coronariografia a
	where	nr_seq_proc	= nr_seq_proc_p;
	
	if (ds_dominancia_w IS NOT NULL AND ds_dominancia_w::text <> '') then
		tx_dominancia_w :=  '\par \pard\qj' || '\ul '||obter_desc_expressao(650722)||'\ulnone: '||ds_dominancia_w || '\par \pard\qj'; -- 650722: Padrão de dominância
	end if;
	
	open C01;
	loop
	fetch C01 into	
		ds_texto_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_conc_manometria_w := ds_conc_manometria_w || chr(13)|| ds_texto_w||'\par \pard\qj ';
		end;
	end loop;
	close C01;

	ds_texto_w := '';
	ds_texto_aux_w := '';

	open C08;
	loop
	fetch C08 into
		ds_texto_aux_w,
		nr_seq_vaso_w,
		nr_seq_apresent_w;
	EXIT WHEN NOT FOUND; /* apply on C08 */
		begin
		ds_coronariografia_w := ds_coronariografia_w || chr(13) ||'\par \pard\qj '|| ds_texto_aux_w || chr(13) ||'\par \pard\qj ';
	
		open C02;
		loop
		fetch C02 into	
			ds_texto_w,
			nr_seq_coron_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			
			select count(*)
			into STRICT qt_registros_w
			from	hem_coron_localizacao a,
				hem_coronariografia b,
				hem_vaso c
			where	a.nr_seq_coron = nr_seq_coron_w
			and	c.nr_sequencia	= nr_seq_vaso_w
			and	c.nr_sequencia	= b.nr_seq_vaso
			and	b.nr_seq_proc	= nr_seq_proc_p;
			
			if (coalesce(qt_registros_w, 1) = 1) then
				ds_coronariografia_w := ds_coronariografia_w || chr(13) || ds_texto_w;-- || obter_desc_expressao(866060);
			else
				ds_coronariografia_w := ds_coronariografia_w || chr(13) || ds_texto_w;-- ||  obter_desc_expressao(855340);		
			end if;
			
			ds_texto_w := '';
			
			open C10;
			loop
			fetch C10 into	
				ds_segmento_w;
			EXIT WHEN NOT FOUND; /* apply on C10 */
				begin
				ds_texto_w := ds_texto_w || ds_segmento_w || ',';
				end;
			end loop;
			close C10;
			
			ds_texto_w := retirar_string(ds_texto_w, 1);
			ds_coronariografia_w := ds_coronariografia_w || ds_texto_w ||' ';		

			
			ds_texto_w := '';
			
			select	max(ie_lesao_culpada)
			into STRICT 	ie_lesao_culpada_w
			from 	hem_coronariografia
			where 	nr_seq_proc = nr_seq_proc_p
			and nr_sequencia = nr_seq_coron_w;
			
			if ((ie_lesao_culpada_w IS NOT NULL AND ie_lesao_culpada_w::text <> '') and ie_lesao_culpada_w <> 'N') then
				ds_texto_w := '	' || obter_desc_expressao(803058) || ': ';
				if (ie_lesao_culpada_w = 'I') then
					ds_texto_w := ds_texto_w || obter_desc_expressao(487950);
				end if;
				if (ie_lesao_culpada_w = 'S') then
					ds_texto_w := ds_texto_w || obter_desc_expressao(719927);
				end if;
				ds_coronariografia_w := ds_coronariografia_w || ds_texto_w || chr(13) ||'\par \pard\qj ';
			end if;
			
			end;
		end loop;
		close C02;
		end;
		ds_coronariografia_w := ds_coronariografia_w || chr(13) ||'\par \pard\qj ';
	end loop;
	close C08;
		
	ds_texto_w	:= '';
	ds_texto_aux_w	:= '';

	open C03;
	loop
	fetch C03 into	
		ds_texto_aux_w,
		ie_tipo_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		ds_ventriculografia_w := ds_ventriculografia_w || chr(13) ||ds_texto_aux_w || chr(13);
		open C09;
		loop
		fetch C09 into	
			ds_texto_w;
		EXIT WHEN NOT FOUND; /* apply on C09 */
			begin
			ds_ventriculografia_w := ds_ventriculografia_w || ds_texto_w || chr(13) ||'\par \pard\qj                           ';
			end;
		end loop;
		close C09;
		end;
		--ds_ventriculografia_w := ds_ventriculografia_w || chr(13) ||'\par \pard\qj ';
	end loop;
	close C03;

	ds_texto_w := '';

	open C04;
	loop
	fetch C04 into	
		ds_texto_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin			
		ds_cineangiocardiografia_w := ds_cineangiocardiografia_w || chr(13)|| ds_texto_w||'\par \pard\qj ';
		end;
	end loop;
	close C04;

	ds_texto_w := '';

	open C05;
	loop
	fetch C05 into	
		ds_texto_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		ds_conclusao_w := ds_conclusao_w || chr(13) || ds_texto_w;
		end;
	end loop;
	close C05;

	ds_texto_w := '';

	open C06;
	loop
	fetch C06 into	
		ds_texto_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
		begin
		ds_observacao_w := ds_observacao_w || chr(13) || ds_texto_w;
		end;
	end loop;
	close C06;

	ds_texto_w := '';

	open C07;
	loop
	fetch C07 into	
		ds_texto_w;
	EXIT WHEN NOT FOUND; /* apply on C07 */
		begin
		ds_circulacao_w := ds_circulacao_w || chr(13) || ds_texto_w;
		end;
	end loop;
	close C07;

	if (ds_conc_manometria_w <> ' ') then
		ds_conc_manometria_w	:= '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(284132)) ||
					'\i0 \par \pard\qj '||'\b0 '||
					ds_conc_manometria_w;
		possui_anterior := 1;
	end if;

	if (ds_coronariografia_w <> ' ') then
    		if (possui_anterior = 1) then
      			novo_paragrafo := '\par \pard\qj ';
    		else
      			novo_paragrafo := '';
    		end if;

		ds_coronariografia_w	:= novo_paragrafo || '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(284136)) ||
					'\i0 \par \pard\qj '||'\b0 '|| tx_dominancia_w ||
					ds_coronariografia_w;
    		possui_anterior := 1;
	end if;

	if (ds_ventriculografia_w <> ' ') then
    		if (possui_anterior = 1) then
      			novo_paragrafo := '\par \pard\qj ';
    		else
      			novo_paragrafo := '';
    		end if;

		ds_ventriculografia_w	:=  novo_paragrafo || '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(284344)) ||
					'\i0 \par \pard\qj '||'\b0 '||
					ds_ventriculografia_w;
    		possui_anterior := 1;
	end if;

	if (ds_cineangiocardiografia_w <> ' ') then
    		if (possui_anterior = 1) then
      			novo_paragrafo := '\par \pard\qj ';
    		else
      			novo_paragrafo := '';
    		end if;

		ds_cineangiocardiografia_w	:=  novo_paragrafo || '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(284362)) ||
					'\i0 \par \pard\qj '||'\b0 '||
					ds_cineangiocardiografia_w;
    		possui_anterior := 1;
	end if;

	if (ds_circulacao_w <> ' ') then
    		if (possui_anterior = 1) then
      			novo_paragrafo := '\par \pard\qj ';
    		else
      			novo_paragrafo := '';
    		end if;

		ds_circulacao_w	:=  novo_paragrafo || '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(288700)) ||
					'\i0 \par \pard\qj '||'\b0 '||
					ds_circulacao_w || '\par \pard\qj';
    		possui_anterior := 1;
	end if;

	if (ds_conclusao_w <> ' ') then
    		if (possui_anterior = 1) then
      			novo_paragrafo := '\par \pard\qj ';
    		else
      			novo_paragrafo := '';
    		end if;

		ds_conclusao_w		:=  novo_paragrafo || '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(284365)) ||
					'\i0 \par \pard\qj '||'\b0 '||
					ds_conclusao_w;
    		possui_anterior := 1;
	end if;

	if (ds_observacao_w <> ' ') then 
    		if (possui_anterior = 1) then
      			novo_paragrafo := '\par \pard\qj ';
    		else
      			novo_paragrafo := '';
    		end if;

		ds_observacao_w		:=  novo_paragrafo || '\par \pard\qj\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(292783)) ||
					'\i0 \par \pard\qj '||'\b0 '||
					ds_observacao_w;
	end if;

	ds_sql_w	:= ' update hem_proc set ds_laudo = :DS_LAUDO where nr_sequencia  = '||nr_seq_proc_p;

	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_sql_w, dbms_sql.Native);
	DBMS_SQL.BIND_VARIABLE(C001, 'DS_LAUDO', ds_cabecalho_w || ds_conc_manometria_w || ds_coronariografia_w || ds_ventriculografia_w || ds_cineangiocardiografia_w || ds_circulacao_w || ds_conclusao_w || ds_observacao_w ||' }');
	retorno_w := DBMS_SQL.EXECUTE(c001);
	DBMS_SQL.CLOSE_CURSOR(C001);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_gerar_laudo ( nr_seq_proc_p bigint, nm_usuario_p text) FROM PUBLIC;

