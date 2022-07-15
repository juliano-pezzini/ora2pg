-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_gerar_receita_oculos ( nr_seq_consulta_p bigint, nm_usuario_p text, lista_sequencia_p text default null, ie_html_p text default 'N', nr_seq_consulta_form_p bigint default null, nr_seq_oft_oculos_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE


cd_profissional_w	varchar(10);
qt_oft_refracao_w	bigint;
observacao_padrao_w	varchar(255);
ds_observacao_atrib_w	varchar(4000);
nr_sequencia_w		bigint := 0;
vl_od_pl_dio_esf_w	real;
vl_od_pl_dio_cil_w	real;
vl_od_pl_eixo_w		smallint;
vl_oe_pl_dio_esf_w	real;
vl_oe_pl_dio_cil_w	real;
vl_oe_pl_eixo_w		smallint;
vl_od_pp_dio_esf_w	real;
vl_od_pp_dio_cil_w	real;
vl_od_pp_eixo_w		smallint;
vl_oe_pp_dio_esf_w	real;
vl_oe_pp_dio_cil_w	real;
vl_oe_pp_eixo_w		smallint;
ds_observacao_w		varchar(4000);
vl_od_pl_adicao_w	real;
vl_oe_pl_adicao_w	real;
vl_od_pl_dio_esf_ww	real;
vl_od_pl_dio_cil_ww	real;
vl_od_pl_eixo_ww	smallint;
vl_oe_pl_dio_esf_ww	real;
vl_oe_pl_dio_cil_ww	real;
vl_oe_pl_eixo_ww	smallint;
vl_od_pp_dio_esf_ww	real;
vl_od_pp_dio_cil_ww	real;
vl_od_pp_eixo_ww	smallint;
vl_oe_pp_dio_esf_ww	real;
vl_oe_pp_dio_cil_ww	real;
vl_oe_pp_eixo_ww	smallint;
vl_od_pl_adicao_ww	real;
vl_oe_pl_adicao_ww	real;


c01 CURSOR FOR
	SELECT	CASE WHEN ie_receita_dinamica='S' THEN vl_od_pl_ard_esf  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_od_pl_are_esf  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_od_pl_ard_cil  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_od_pl_are_cil  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_od_pl_ard_eixo  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_od_pl_are_eixo  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pl_ard_esf  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_oe_pl_are_esf  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pl_ard_cil  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_oe_pl_are_cil  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pl_ard_eixo  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_oe_pl_are_eixo  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_od_pp_ard_esf  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_od_pp_are_esf  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_od_pp_ard_cil  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_od_pp_are_cil  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_od_pp_ard_eixo  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_od_pp_are_eixo  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pp_ard_esf  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_oe_pp_are_esf  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pp_ard_cil  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_oe_pp_are_cil  ELSE null END  END ,
				CASE WHEN ie_receita_dinamica='S' THEN vl_oe_pp_ard_eixo  ELSE CASE WHEN ie_receita_estatica='S' THEN vl_oe_pp_are_eixo  ELSE null END  END ,
				SUBSTR(coalesce(ds_observacao_atrib_w,ds_observacao),1,4000),
				vl_adicao,
				vl_adicao_oe
	from		oft_refracao
	where		((nr_seq_consulta = nr_seq_consulta_p AND nr_sequencia_w = 0) or (nr_sequencia = nr_sequencia_w))
	and		 ((coalesce(ie_receita_dinamica,'N') = 'S') or (coalesce(ie_receita_estatica,'N') = 'S'))
	and (coalesce(ie_situacao, 'A') = 'A')
	and		((ie_html_p = 'N') or ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_p));
				

BEGIN

select	obter_pessoa_fisica_usuario(nm_usuario_p,'C')
into STRICT	cd_profissional_w
;

if (coalesce(lista_sequencia_p::text, '') = '') then
	select	count(*)
	into STRICT	qt_oft_refracao_w
	from	oft_refracao
	where	nr_seq_consulta = nr_seq_consulta_p
	and	((coalesce(ie_receita_dinamica,'N') = 'S') or (coalesce(ie_receita_estatica,'N') = 'S'));
else		
	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	oft_refracao
	where	dt_exame =	(	SELECT	max(dt_exame)
							from	oft_refracao
							where	obter_se_contido(nr_sequencia,lista_sequencia_p) = 'S'
							and		((coalesce(ie_receita_dinamica,'N') = 'S') or (coalesce(ie_receita_estatica,'N') = 'S'))
							and		coalesce(ie_situacao,'A') = 'A')
	and (obter_se_contido(nr_sequencia,lista_sequencia_p) = 'S');
	
	qt_oft_refracao_w := 1;			
end if;	

select	Obter_Regra_Atributo2(	'OFT_OCULOS',
				'DS_OBSERVACAO',
				0,
				'VLD',
				wheb_usuario_pck.get_cd_estabelecimento,
				obter_perfil_ativo,
				obter_funcao_ativa,
				nm_usuario_p)
into STRICT	ds_observacao_atrib_w
;

if (qt_oft_refracao_w > 0) then
	open C01;
	loop
	fetch C01 into	
		vl_od_pl_dio_esf_w,
		vl_od_pl_dio_cil_w,
		vl_od_pl_eixo_w,
		vl_oe_pl_dio_esf_w,
		vl_oe_pl_dio_cil_w,
		vl_oe_pl_eixo_w,
		vl_od_pp_dio_esf_w,
		vl_od_pp_dio_cil_w,
		vl_od_pp_eixo_w,
		vl_oe_pp_dio_esf_w,
		vl_oe_pp_dio_cil_w,
		vl_oe_pp_eixo_w,
		ds_observacao_w,
		vl_od_pl_adicao_w,
		vl_oe_pl_adicao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	nextval('oft_oculos_seq')
		into STRICT	nr_sequencia_w
		;
		
		if (coalesce(vl_od_pp_dio_cil_w,0) = 0
			and coalesce(vl_od_pl_adicao_w,0) > 0) then
			vl_od_pp_dio_cil_w := vl_od_pl_dio_cil_w;
		end if;
		
		if (coalesce(vl_oe_pp_dio_cil_w,0) = 0
			and coalesce(vl_oe_pl_adicao_w,0) > 0) then
			vl_oe_pp_dio_cil_w := vl_oe_pl_dio_cil_w;
		end if;
		
		insert into oft_oculos(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_consulta,
			vl_od_pl_dio_esf,
			vl_od_pl_dio_cil,
			vl_od_pl_eixo,
			vl_oe_pl_dio_esf,
			vl_oe_pl_dio_cil,
			vl_oe_pl_eixo,
			vl_od_pp_dio_esf,
			vl_od_pp_dio_cil,
			vl_od_pp_eixo,
			vl_oe_pp_dio_esf,
			vl_oe_pp_dio_cil,
			vl_oe_pp_eixo,
			cd_profissional,
			dt_registro,
			ds_observacao,
			ie_situacao,
			vl_od_pl_adicao,
			vl_oe_pl_adicao,
			nr_seq_consulta_form)
		values (nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_consulta_p,
			vl_od_pl_dio_esf_w,
			vl_od_pl_dio_cil_w,
			vl_od_pl_eixo_w,
			vl_oe_pl_dio_esf_w,
			vl_oe_pl_dio_cil_w,
			vl_oe_pl_eixo_w,
			vl_od_pp_dio_esf_w,
			vl_od_pp_dio_cil_w,
			vl_od_pp_eixo_w,
			vl_oe_pp_dio_esf_w,
			vl_oe_pp_dio_cil_w,
			vl_oe_pp_eixo_w,
			cd_profissional_w,
			clock_timestamp(),
			ds_observacao_w,
			'A',
			vl_od_pl_adicao_w,
			vl_oe_pl_adicao_w,
			nr_seq_consulta_form_p);
		commit;
		end;
	end loop;
	close C01;	
end if;

nr_seq_oft_oculos_p := nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_gerar_receita_oculos ( nr_seq_consulta_p bigint, nm_usuario_p text, lista_sequencia_p text default null, ie_html_p text default 'N', nr_seq_consulta_form_p bigint default null, nr_seq_oft_oculos_p INOUT bigint DEFAULT NULL) FROM PUBLIC;

