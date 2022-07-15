-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_gerar_refr_rec_suger ( nr_seq_consulta_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_profissional_w	varchar(10);
qt_oft_refracao_w	bigint;
				

BEGIN 
 
select	obter_pessoa_fisica_usuario(nm_usuario_p,'C') 
into STRICT	cd_profissional_w
;
 
select	count(*) 
into STRICT	qt_oft_refracao_w 
from	oft_refracao 
where	nr_seq_consulta = nr_seq_consulta_p 
and 	((ie_refracao_sugerida = 'N') or (coalesce(ie_refracao_sugerida::text, '') = ''));
 
if (qt_oft_refracao_w > 0) then 
	begin 
	insert into OFT_REFRACAO( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_consulta, 
		VL_OD_PL_ARD_ESF, 
		VL_OD_PL_ARD_CIL, 
		VL_OD_PL_ARD_EIXO, 
		vl_od_pl_ard_av_sc, 
		vl_od_adic_av, 
		vl_oe_pl_ard_esf, 
		vl_oe_pl_ard_cil, 
		vl_oe_pl_ard_eixo, 
		vl_oe_pl_ard_av_sc, 
		vl_adicao, 
		vl_adicao_oe, 
		vl_oe_adic_av, 
		vl_od_pp_ard_esf, 
		vl_od_pp_ard_cil, 
		vl_od_pp_ard_eixo, 
		vl_od_pp_ard_av_sc, 
		vl_oe_pp_ard_esf, 
		vl_oe_pp_ard_cil, 
		vl_oe_pp_ard_eixo, 
		vl_oe_pp_ard_av_sc, 
		vl_od_pl_are_esf, 
		vl_od_pl_are_cil, 
		vl_od_pl_are_eixo, 
		vl_od_pl_are_av_sc, 
		vl_oe_pl_are_esf, 
		vl_oe_pl_are_cil, 
		vl_oe_pl_are_eixo, 
		vl_oe_pl_are_av_sc, 
		vl_od_pp_are_esf, 
		vl_od_pp_are_cil, 
		vl_od_pp_are_eixo, 
		vl_od_pp_are_av_sc, 
		vl_oe_pp_are_esf, 
		vl_oe_pp_are_cil, 
		vl_oe_pp_are_eixo, 
		vl_oe_pp_are_av_sc, 
		cd_profissional, 
		dt_exame, 
		ds_observacao, 
		ie_refracao_sugerida, 
		ie_situacao) 
	SELECT	nextval('oft_refracao_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_consulta_p, 
		CASE WHEN ie_receita_dinamica='S' THEN vl_od_pl_ard_esf  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_od_pl_ard_cil  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_od_pl_ard_eixo  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_od_pl_ard_av_sc  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_od_adic_av  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pl_ard_esf  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pl_ard_cil  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pl_ard_eixo  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pl_ard_av_sc  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_adicao  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_adicao_oe  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN VL_OE_ADIC_AV  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_od_pp_ard_esf  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_od_pp_ard_cil  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_od_pp_ard_eixo  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_od_pp_ard_av_sc  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pp_ard_esf  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pp_ard_cil  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pp_ard_eixo  ELSE null END , 
		CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pp_ard_av_sc  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_od_pl_are_esf  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_od_pl_are_cil  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_od_pl_are_eixo  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_od_pl_are_av_sc  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_oe_pl_are_esf  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_oe_pl_are_cil  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_oe_pl_are_eixo  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_oe_pl_are_av_sc  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_od_pp_are_esf  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_od_pp_are_cil  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_od_pp_are_eixo  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_od_pp_are_av_sc  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_oe_pp_are_esf  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_oe_pp_are_cil  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_oe_pp_are_eixo  ELSE null END , 
		CASE WHEN ie_receita_estatica='S' THEN vl_oe_pp_are_av_sc  ELSE null END , 
		cd_profissional_w, 
		clock_timestamp(), 
		ds_observacao, 
		'S', 
		'A' 
	from	oft_refracao 
	where	nr_seq_consulta = nr_seq_consulta_p 
	and 	ie_situacao = 'A' 
	and 	((ie_refracao_sugerida = 'N') or (coalesce(ie_refracao_sugerida::text, '') = ''));
	commit;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_gerar_refr_rec_suger ( nr_seq_consulta_p bigint, nm_usuario_p text) FROM PUBLIC;

