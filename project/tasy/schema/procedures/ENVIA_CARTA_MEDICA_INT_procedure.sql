-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_carta_medica_int ( cd_pessoa_fisica_p text, nr_seq_carta_p bigint, nr_atendimento_p bigint) AS $body$
DECLARE

			
ds_sep_bv_w				varchar(100);
ds_param_integ_hl7_w	varchar(4000);
nr_seq_interno_w		bigint;


BEGIN
ds_sep_bv_w := obter_separador_bv;	

select	max(obter_atepacu_paciente( nr_atendimento_p ,'A'))
into STRICT	nr_seq_interno_w
;

ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || cd_pessoa_fisica_p	|| ds_sep_bv_w ||
						'nr_atendimento='   || nr_atendimento_p		|| ds_sep_bv_w ||               
						'nr_seq_interno='   || nr_seq_interno_w		|| ds_sep_bv_w ||               
						'nr_seq_carta='    	|| nr_seq_carta_p		|| ds_sep_bv_w ||              
						'cd_pessoa_fisica'  || cd_pessoa_fisica_p	|| ds_sep_bv_w;

CALL gravar_agend_integracao(945, ds_param_integ_hl7_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE envia_carta_medica_int ( cd_pessoa_fisica_p text, nr_seq_carta_p bigint, nr_atendimento_p bigint) FROM PUBLIC;

