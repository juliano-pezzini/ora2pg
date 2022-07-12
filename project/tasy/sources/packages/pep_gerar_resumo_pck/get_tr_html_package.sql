-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pep_gerar_resumo_pck.get_tr_html ( col1_p text, col2_p text, col3_p text, col4_p text, col5_p text, col6_p text, qt_col_p bigint) RETURNS varchar AS $body$
DECLARE

	ds_retorno_w 	varchar(20000);
	
BEGIN
	
	
	ds_retorno_w := ' <tr valign="topmargin"> ' || chr(13) ||
		'	<td colspan="'|| (7 - qt_col_p) ||'">' || chr(13) ||
						coalesce(col1_p,'&' || 'nbsp;') || chr(13) ||
				'	</td>'|| chr(13);
		if (qt_col_p >= 2) then
			ds_retorno_w  := ds_retorno_w ||
				'	<td>' || chr(13) ||
						 coalesce(col2_p,'&' || 'nbsp;') || chr(13) ||
				'	</td>'|| chr(13);
		end if;
		if (qt_col_p >= 3) then
			ds_retorno_w  := ds_retorno_w ||
			'	<td>' || chr(13) ||
					 coalesce(col3_p,'&' || 'nbsp;') || chr(13) ||
			'	</td>'|| chr(13);
		end if;
		if (qt_col_p >= 4) then
			ds_retorno_w  := ds_retorno_w ||
			'	<td>' || chr(13) ||
					 coalesce(col4_p,'&' || 'nbsp;') || chr(13) ||
			'	</td>'|| chr(13);
		end if;
		if (qt_col_p >= 5) then
			ds_retorno_w  := ds_retorno_w ||
			'	<td>' || chr(13) ||
					 coalesce(col5_p,'&' || 'nbsp;') || chr(13) ||
			'	</td>'|| chr(13);
		end if;
		if (qt_col_p >= 6) then
			ds_retorno_w  := ds_retorno_w ||
			'	<td>' || chr(13) ||
					 coalesce(replace(col6_P, chr(13), '<br>' || chr(13)),'&' || 'nbsp;') ||
			'	</td>'|| chr(13);
		end if;
		ds_retorno_w  := ds_retorno_w || '</tr>' || chr(13);
	return ds_retorno_w;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pep_gerar_resumo_pck.get_tr_html ( col1_p text, col2_p text, col3_p text, col4_p text, col5_p text, col6_p text, qt_col_p bigint) FROM PUBLIC;