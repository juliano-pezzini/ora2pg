-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_gerar_laudo_congenitas ( nr_seq_proc_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_conclusao_manometria_pre_w		varchar(20000) := '';
ds_conclusao_manometria_pos_w		varchar(20000) := '';
ds_dispositivo_w			varchar(20000) := '';
ds_dispositivo_utilizado_w		varchar(20000) := '';
ds_observacao_diametro_w		varchar(20000) := '';
ds_observacao_w				varchar(20000) := '';
ds_seta_w				varchar(20000) := '';
ds_texto_w				varchar(20000) := '';
ds_cabecalho_w				varchar(20000) := '';
ds_sql_w				varchar(20000) := '';
ds_conclusao_w				varchar(20000) := '';
retorno_w				integer;
qt_pri_diametro_w			double precision;
qt_comprimento				double precision;
qt_seg_diametro_w			double precision;
C001					integer;
ds_sucesso_w				varchar(2000) := '';
qt_valor_inicial_w			hem_conclusao_coron.qt_valor_inicial%Type;
qt_valor_final_w			hem_conclusao_coron.qt_valor_final%Type;

ds_camara_pre_w				varchar(20000) := '';
nr_seq_apresent_pre_w		varchar(20000) := '';
qt_pa_sistolica_pre_w		varchar(20000) := '';
qt_pa_diastolica_ini_pre_w	varchar(20000) := '';
qt_pa_diastolica_fim_pre_w	varchar(20000) := '';
qt_pam_pre_w				varchar(20000) := '';
nr_sequencia_pre_w			varchar(20000) := '';
ds_pre_w					varchar(20000) := '';

ds_camara_pos_w				varchar(20000) := '';
nr_seq_apresent_pos_w		varchar(20000) := '';
qt_pa_sistolica_pos_w		varchar(20000) := '';
qt_pa_diastolica_ini_pos_w	varchar(20000) := '';
qt_pa_diastolica_fim_pos_w	varchar(20000) := '';
qt_pam_pos_w				varchar(20000) := '';
nr_sequencia_pos_w			varchar(20000) := '';
ds_pos_w					varchar(20000) := '';
qt_tamanho_w			bigint;
tab_w				varchar(255) := '';
ie_laudo_congenitas_w     varchar(1) := 'N';

C01 CURSOR FOR
	SELECT	'\par  '||ds_seta_w||substr(obter_desc_hem_analise_man(nr_seq_analise),1,250)||' '
	from 	hem_analise_manometria
	where 	nr_seq_proc = nr_seq_proc_p
	and 	ie_momento = 'PR'
	order by 	nr_sequencia;
	
C02 CURSOR FOR
	SELECT	'\par  '||ds_seta_w||substr(obter_desc_hem_analise_man(nr_seq_analise),1,250)||' '
	from 	hem_analise_manometria
	where 	nr_seq_proc = nr_seq_proc_p
	and 	ie_momento = 'PO'
	order by 	nr_sequencia;

C03 CURSOR FOR
	SELECT 	obter_desc_hem_balao(nr_seq_balao),
		qt_diametro,
		qt_comprimento,
		qt_diametro_2,
		replace(ds_observacao,chr(10),'\par '||chr(10))
	from 	hem_atc_balao
	where 	nr_seq_proc = nr_seq_proc_p
	order by	nr_sequencia;

C04 CURSOR FOR
	  SELECT 	'\par  '||obter_desc_expressao(798572) ||' '||lower(obter_desc_expressao(CASE WHEN a.ie_sucesso='S' THEN  709579  ELSE 632403 END ))||
                                (CASE WHEN substr(obter_desc_hem_sucesso(a.NR_SEQ_MOTIVO),1,100) IS NOT NULL THEN ', '||substr(obter_desc_hem_sucesso(a.NR_SEQ_MOTIVO),1,100) ELSE '' END)
                                ||(CASE WHEN (a.qt_valor_inicial IS NOT NULL AND a.qt_valor_inicial::text <> '') THEN ' '||obter_desc_expressao( 746911)||' '||a.qt_valor_inicial||' '||b.cd_unidade_medida ELSE '' END)||(CASE WHEN (a.qt_valor_final IS NOT NULL AND a.qt_valor_final::text <> '') THEN ' '||obter_desc_expressao( 727816)||' ' ELSE '' END)||a.qt_valor_final||' '||b.cd_unidade_medida||'.',
            		a.qt_valor_inicial,
	               a.qt_valor_final
	FROM hem_conclusao_coron a
LEFT OUTER JOIN hem_sucesso b ON (a.nr_seq_motivo = b.nr_sequencia)
WHERE a.nr_seq_proc = nr_seq_proc_p order by	a.nr_sequencia;
	
--manometria pre-intervencao
C05 CURSOR FOR
	SELECT	' '||SUBSTR(obter_valor_dominio(6939,ie_tipo),1,255),
		(SELECT nr_seq_apresent FROM valor_dominio_v WHERE cd_dominio = 6939 AND vl_dominio = ie_tipo) nr_seq_apresent,	
		coalesce(TO_CHAR(QT_PA_SISTOLICA),'-'),
		coalesce(TO_CHAR(QT_PA_DIASTOLICA_INI),'-'),
		coalesce(TO_CHAR(QT_PA_DIASTOLICA_FIM),'-'),
		coalesce(TO_CHAR(QT_PAM),'-'),
		NR_SEQUENCIA
	FROM	HEM_MANOMETRIA_COMPLETA
	WHERE	nr_seq_proc = nr_seq_proc_p
	and 	ie_momento = 'PR'
	ORDER BY nr_seq_apresent;
	
--manometria pos-intervencao
C06 CURSOR FOR
	SELECT	' '||SUBSTR(obter_valor_dominio(6939,ie_tipo),1,255),
		(SELECT nr_seq_apresent FROM valor_dominio_v WHERE cd_dominio = 6939 AND vl_dominio = ie_tipo) nr_seq_apresent,		
		coalesce(TO_CHAR(QT_PA_SISTOLICA),'-'),
		coalesce(TO_CHAR(QT_PA_DIASTOLICA_INI),'-'),
		coalesce(TO_CHAR(QT_PA_DIASTOLICA_FIM),'-'),
		coalesce(TO_CHAR(QT_PAM),'-'),
		NR_SEQUENCIA
	FROM	HEM_MANOMETRIA_COMPLETA
	WHERE	nr_seq_proc = nr_seq_proc_p
	and 	ie_momento = 'PO'
	ORDER BY nr_seq_apresent;
	
	

BEGIN

ie_laudo_congenitas_w := Obter_Param_Usuario(868, 6, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_laudo_congenitas_w);

if (coalesce(nr_seq_proc_p, 0) > 0) then

	ds_seta_w	:= 	' {\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fnil\fcharset0 Calibri;}}'||
				'{\*\generator Msftedit 5.41.21.2510;}\viewkind4\uc1\pard\sa200\sl276\slmult1\lang22\b\f0\fs24\u8594?\b0\fs22'||
				'} ';
	
	ds_cabecalho_w	:=	'{\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fnil\fcharset0 Arial;}{\f1\fnil\fcharset0 Calibri;}}'||
				'{\colortbl ;\red0\green0\blue0;}' || chr(13);
	
	ds_texto_w := '';

    if (ie_laudo_congenitas_w = 'N') then
	
        open C01;
        loop
        fetch C01 into	
            ds_texto_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
            begin
                ds_conclusao_manometria_pre_w := ds_conclusao_manometria_pre_w || chr(13)|| ds_texto_w||'\par \pard\qj ';
            end;
        end loop;
        close C01;

        ds_texto_w := '';

        open C02;
        loop
        fetch C02 into	
            ds_texto_w;
        EXIT WHEN NOT FOUND; /* apply on C02 */
            begin
                ds_conclusao_manometria_pos_w := ds_conclusao_manometria_pos_w || chr(13)|| ds_texto_w||'\par \pard\qj ';
            end;
        end loop;
        close C02;

        ds_texto_w := '';
	
    end if;

	open C03;
	loop
	fetch C03 into	
		ds_dispositivo_utilizado_w,
		qt_pri_diametro_w,
		qt_comprimento,
		qt_seg_diametro_w,
		ds_observacao_diametro_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
			ds_texto_w := '';
			ds_texto_w := '\par  '||ds_seta_w|| ds_dispositivo_utilizado_w;
			if (coalesce(qt_pri_diametro_w,0) > 0) then
				ds_texto_w := ds_texto_w || ', ' || wheb_mensagem_pck.get_texto(473936) || ' ' || qt_pri_diametro_w || ' mm';
			end if;
			if (coalesce(qt_comprimento,0) > 0) then
				ds_texto_w := ds_texto_w || ', ' || wheb_mensagem_pck.get_texto(473937) || ' ' || qt_comprimento || ' mm';
			end if;
			if (coalesce(qt_seg_diametro_w,0) > 0) then
				ds_texto_w := ds_texto_w || ', ' || wheb_mensagem_pck.get_texto(473938) || ' ' || qt_seg_diametro_w || ' mm';
			end if;
			if (ds_observacao_diametro_w <> ' ') then
				ds_texto_w := ds_texto_w || chr(10) || '. ' || '\par '||chr(10) || ds_observacao_diametro_w;
			end if;
			ds_dispositivo_w := ds_dispositivo_w || chr(13)|| ds_texto_w||'\par \pard\qj ';
		end;
	end loop;
	close C03;
	
	open C04;
	loop
	fetch C04 into	
		ds_sucesso_w,
		qt_valor_inicial_w,
		qt_valor_final_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		
		ds_conclusao_w := ds_conclusao_w || chr(13)||  ds_sucesso_w||'\par \pard\qj ';
		end;
	end loop;
	close C04;

    if (ie_laudo_congenitas_w = 'N') then
	
        ds_pre_w := '\viewkind4\uc1\pard\qj\fs24 \par  '||wheb_mensagem_pck.get_texto(960853) || '                     	| ' || wheb_mensagem_pck.get_texto(960854) || '  | ' || wheb_mensagem_pck.get_texto(960855) || '  | ' ||  wheb_mensagem_pck.get_texto(960856) || '    |   ' || wheb_mensagem_pck.get_texto(960857) ||'\par \pard\qj ';
        open C05;
        loop
        fetch C05 into	
            ds_camara_pre_w,
            nr_seq_apresent_pre_w,
            qt_pa_sistolica_pre_w,
            qt_pa_diastolica_ini_pre_w,
            qt_pa_diastolica_fim_pre_w,
            qt_pam_pre_w,
            nr_sequencia_pre_w;
        EXIT WHEN NOT FOUND; /* apply on C05 */
            begin
            qt_tamanho_w := length(ds_camara_pre_w);
            if (qt_tamanho_w <= 6) then
                tab_w := '					';
            elsif (qt_tamanho_w <= 14) then
                tab_w := '				';
            elsif (qt_tamanho_w <= 20) then
                tab_w := '			';
            elsif (qt_tamanho_w <= 28) then
                tab_w := '		';
            else
                tab_w := '	';
            end if;

            ds_pre_w := ds_pre_w || chr(13)||  ds_camara_pre_w|| tab_w|| qt_pa_sistolica_pre_w||  '		'|| qt_pa_diastolica_ini_pre_w||  '		'|| qt_pa_diastolica_fim_pre_w||   '		'|| qt_pam_pre_w||'\par \pard\qj ';
            end;
        end loop;
        close C05;

        ds_pos_w := '\par  '||wheb_mensagem_pck.get_texto(960853) || '                     	| ' || wheb_mensagem_pck.get_texto(960854) || '  | ' || wheb_mensagem_pck.get_texto(960855) || '  | ' ||  wheb_mensagem_pck.get_texto(960856) || '    |   ' || wheb_mensagem_pck.get_texto(960857) ||'\par \pard\qj ';
        open C06;
        loop
        fetch C06 into	
            ds_camara_pos_w,
            nr_seq_apresent_pos_w,
            qt_pa_sistolica_pos_w,
            qt_pa_diastolica_ini_pos_w,
            qt_pa_diastolica_fim_pos_w,
            qt_pam_pos_w,
            nr_sequencia_pos_w;
        EXIT WHEN NOT FOUND; /* apply on C06 */
            begin
            qt_tamanho_w := length(ds_camara_pos_w);
            if (qt_tamanho_w <= 6) then
                tab_w := '					';
            elsif (qt_tamanho_w <= 14) then
                tab_w := '				';
            elsif (qt_tamanho_w <= 20) then
                tab_w := '			';
            elsif (qt_tamanho_w <= 28) then
                tab_w := '		';
            else
                tab_w := '	';
            end if;

            ds_pos_w := ds_pos_w || chr(13)||  ds_camara_pos_w|| tab_w || qt_pa_sistolica_pos_w||  '		'|| qt_pa_diastolica_ini_pos_w||  '		'|| qt_pa_diastolica_fim_pos_w||   '		'|| qt_pam_pos_w||'\par \pard\qj ';
            end;
        end loop;
        close C06;

        if (ds_pre_w <> ' ') then
            ds_pre_w	 := '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(960896)) ||
                            '\i0 \par \pard\qj '||'\b0 '||
                            ds_pre_w  ||
                            '\par \pard\qj ';
        end if;
        if (ds_conclusao_manometria_pre_w <> ' ') then
            ds_conclusao_manometria_pre_w	 := '\viewkind4\uc1\pard\cf1\lang1046\fs24 '||
                                                ds_conclusao_manometria_pre_w  ||
                                                '\par \pard\qj ';
        end if;
        if (ds_pos_w <> ' ') then
            ds_pos_w	 := '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(960902)) ||
                            '\i0 \par \pard\qj '||'\b0 '||
                            ds_pos_w  ||
                            '\par \pard\qj ';
        end if;
        if (ds_conclusao_manometria_pos_w <> ' ') then
            ds_conclusao_manometria_pos_w	 := '\viewkind4\uc1\pard\cf1\lang1046\fs24 '||
                                                ds_conclusao_manometria_pos_w  ||
                                                '\par \pard\qj ';
        end if;

    end if;

    select 	max(replace(ds_observacao_laudo,chr(10),'\par '||chr(10)))
    into STRICT	ds_observacao_w
    from 	hem_observacao_laudo
    where 	nr_seq_proc = nr_seq_proc_p;

	if (ds_conclusao_w <> ' ') then
		ds_conclusao_w	:= '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(293574)) ||
								'\i0 \par \pard\qj '||'\b0 '||
								ds_conclusao_w  ||
								'\par \pard\qj ';
	end if;
	if (ds_dispositivo_w <> ' ') then
		ds_dispositivo_w	:= '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(473338)) ||
								'\i0 \par \pard\qj '||'\b0 '||
								ds_dispositivo_w  ||
								'\par \pard\qj ';
	end if;
    if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
		ds_observacao_w		:=  '\viewkind4\uc1\pard\cf1\lang1046\b\i\fs24 '|| UPPER(wheb_mensagem_pck.get_texto(473339)) ||
								'\i0 \par \pard\qj '||'\b0 '||'\par  '||
								ds_observacao_w ||
								'\par \pard\qj '||
								'\par \pard\qj ';
	end if;

	ds_sql_w	:= ' update hem_proc set ds_laudo = :DS_LAUDO where nr_sequencia  = '||nr_seq_proc_p;
	
	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_sql_w, dbms_sql.Native);
	DBMS_SQL.BIND_VARIABLE(C001, 'DS_LAUDO', ds_cabecalho_w || ds_pre_w || ds_conclusao_manometria_pre_w || ds_pos_w ||ds_conclusao_manometria_pos_w || ds_dispositivo_w || ds_conclusao_w || ds_observacao_w/* || ds_texto_w*/ || ' }');
	retorno_w := DBMS_SQL.EXECUTE(c001);
	DBMS_SQL.CLOSE_CURSOR(C001);	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_gerar_laudo_congenitas ( nr_seq_proc_p bigint, nm_usuario_p text) FROM PUBLIC;
