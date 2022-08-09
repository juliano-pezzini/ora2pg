-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_rel_news_aux ( ie_libera_news_p text, dt_alteracao_p timestamp, cd_funcao_p bigint, nr_ordem_servico_p bigint, ie_alteracao_p text, ie_tipo_cliente_p text, ie_global_p text default null, ie_locales_p text default null, ie_delphi_p text default null, ie_java_p text default null, ie_html5_p text default null, ie_tws_p text default null, nr_seq_template_obj_p text DEFAULT NULL, nr_seq_template_alt_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL, cd_versao_p text DEFAULT NULL) AS $body$
DECLARE

				
ds_comando_w			varchar(32000);
ds_parametros_w			varchar(32000);
ds_sep_bv_w				varchar(50);


BEGIN

ds_sep_bv_w := obter_separador_bv;
ds_comando_w :=	'declare '||
		'begin '||
			'gerar_release_news' || '(	:ie_libera_news_p,
												:dt_alteracao_p,
												:cd_funcao_p,
												:nr_ordem_servico_p,
												:ie_alteracao_p,
												:ie_tipo_cliente_p,
												:ie_global_p,
												:ie_locales_p,
												:ie_delphi_p,
												:ie_java_p,
												:ie_html5_p,
												:ie_tws_p,
												:nr_seq_template_obj_p,
												:nr_seq_template_alt_p,
												:nm_usuario_p,
												:cd_versao_p);' ||
		'END;';

ds_parametros_w :=				'ie_libera_news_p='		|| ie_libera_news_p			|| ds_sep_bv_w ||
								'dt_alteracao_p='		|| dt_alteracao_p			|| ds_sep_bv_w ||
								'cd_funcao_p='			|| cd_funcao_p 				|| ds_sep_bv_w || 
								'nr_ordem_servico_p='	|| nr_ordem_servico_p 		|| ds_sep_bv_w ||
								'ie_alteracao_p=' 		|| ie_alteracao_p 			|| ds_sep_bv_w ||
								'ie_tipo_cliente_p='	|| ie_tipo_cliente_p		|| ds_sep_bv_w || 
								'ie_global_p='			|| ie_global_p				|| ds_sep_bv_w ||
								'ie_locales_p='			|| ie_locales_p				|| ds_sep_bv_w ||
								'ie_delphi_p='			|| ie_delphi_p				|| ds_sep_bv_w ||
								'ie_java_p='			|| ie_java_p				|| ds_sep_bv_w ||
								'ie_html5_p='			|| ie_html5_p		    	|| ds_sep_bv_w ||
								'ie_tws_p='		    	|| ie_tws_p		        	|| ds_sep_bv_w ||
								'nr_seq_template_obj_p='			|| nr_seq_template_obj_p		        || ds_sep_bv_w ||
								'nr_seq_template_alt_p='	  		|| nr_seq_template_alt_p		    	|| ds_sep_bv_w ||
								'nm_usuario_p='	    	|| nm_usuario_p		    || ds_sep_bv_w ||
								'cd_versao_p='			|| cd_versao_p;

CALL exec_sql_dinamico_bv('gerar_release_news', ds_comando_w, 	ds_parametros_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_rel_news_aux ( ie_libera_news_p text, dt_alteracao_p timestamp, cd_funcao_p bigint, nr_ordem_servico_p bigint, ie_alteracao_p text, ie_tipo_cliente_p text, ie_global_p text default null, ie_locales_p text default null, ie_delphi_p text default null, ie_java_p text default null, ie_html5_p text default null, ie_tws_p text default null, nr_seq_template_obj_p text DEFAULT NULL, nr_seq_template_alt_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL, cd_versao_p text DEFAULT NULL) FROM PUBLIC;
