-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.gerar_interf_j005_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) AS $body$
DECLARE

			
ds_linha_w			varchar(8000);
tp_registro_w			varchar(15);
sep_w				varchar(1) := '|';


BEGIN
tp_registro_w 	:=	'J005';

ds_linha_w	:= substr(	sep_w || tp_registro_w 				 		||
				sep_w || to_char(regra_sped_p.dt_ref_inicial,'ddmmyyyy') 	|| 
				sep_w || to_char(regra_sped_p.dt_ref_final,'ddmmyyyy') 	 	|| 
				sep_w || regra_sped_p.ie_demonstrativo 				|| 
				sep_w || regra_sped_p.ds_demonstrativo			 	|| 
				sep_w,1,8000);

regra_sped_p.cd_registro_variavel := tp_registro_w;
regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.inserir_registros_vetor(regra_sped_p => regra_sped_p, ds_linha_p => ds_linha_w);
regra_sped_p => regra_sped_p := ctb_sped_ecd_pck.persistir_registros_em_lote(regra_sped_p => regra_sped_p, nm_usuario_p => nm_usuario_p);	

END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.gerar_interf_j005_ecd (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) FROM PUBLIC;