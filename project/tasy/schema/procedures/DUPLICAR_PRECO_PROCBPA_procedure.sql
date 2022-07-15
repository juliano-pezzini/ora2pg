-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_preco_procbpa ( dt_comp_origem_p timestamp, ie_versao_origem_p text, dt_comp_destino_p timestamp, ie_versao_destino_p text, nm_usuario_p text) AS $body$
DECLARE


dt_competencia_w	timestamp;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
vl_tph_w		double precision;
vl_taxa_sala_w		double precision;
vl_honorario_medico_w	double precision;
vl_anestesia_w		double precision;
vl_matmed_w		double precision;
vl_contraste_w		double precision;
vl_filme_rx_w		double precision;
vl_gesso_w		double precision;
vl_quimioterapia_w	double precision;
vl_dialise_w		double precision;
vl_sadt_rx_w		double precision;
vl_sadt_pc_w		double precision;
vl_sadt_outros_w	double precision;
vl_filme_ressonancia_w	double precision;
vl_outros_w		double precision;
vl_procedimento_w	double precision;
vl_plantonista_w	double precision;
ie_versao_w		varchar(20);
ie_cessao_credito_w	varchar(1);
ie_pab_w		varchar(1);
ie_faec_w		varchar(1);
cd_rub_w		varchar(4);
ds_aux_w		varchar(20);

qt_registros_w		integer	:= 0;

C01 CURSOR FOR
	SELECT	dt_comp_destino_p,
		cd_procedimento,
		ie_origem_proced,
		vl_tph,
		vl_taxa_sala,
		vl_honorario_medico,
		vl_anestesia,
		vl_matmed,
		vl_contraste,
		vl_filme_rx,
		vl_gesso,
		vl_quimioterapia,
		vl_dialise,
		vl_sadt_rx,
		vl_sadt_pc,
		vl_sadt_outros,
		vl_filme_ressonancia,
		vl_outros,
		vl_procedimento,
		vl_plantonista,
		ie_versao_destino_p,
		ie_cessao_credito,
		ie_pab,
		ie_faec,
		cd_rub,
		ds_aux
	from	sus_preco_procBPA
	where	coalesce(dt_comp_origem_p,dt_competencia)	= dt_competencia
	and	coalesce(ie_versao_origem_p,ie_versao)	= ie_versao;


BEGIN

select	count(*)
into STRICT	qt_registros_w
from	sus_preco_procbpa
where	dt_competencia	= dt_comp_destino_p;
if (qt_registros_w	> 0) then
	--r.aise_application_error(-20011,'Já existe uma tabela com a data de competencia: '|| dt_comp_destino_p);
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263303,'DT_COMP_DESTINO_P='||DT_COMP_DESTINO_P);
end if;

select	count(*)
into STRICT	qt_registros_w
from	sus_preco_procbpa
where	ie_versao	= ie_versao_destino_p;
if (qt_registros_w	> 0) then
	--r.aise_application_error(-20011,'Já existe uma tabela com a versão: '|| ie_versao_destino_p);
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263304,'IE_VERSAO_DESTINO_P='||IE_VERSAO_DESTINO_P);
end if;

OPEN C01;
LOOP
FETCH C01 into
	dt_competencia_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	vl_tph_w,
	vl_taxa_sala_w,
	vl_honorario_medico_w,
	vl_anestesia_w,
	vl_matmed_w,
	vl_contraste_w,
	vl_filme_rx_w,
	vl_gesso_w,
	vl_quimioterapia_w,
	vl_dialise_w,
	vl_sadt_rx_w,
	vl_sadt_pc_w,
	vl_sadt_outros_w,
	vl_filme_ressonancia_w,
	vl_outros_w,
	vl_procedimento_w,
	vl_plantonista_w,
	ie_versao_w,
	ie_cessao_credito_w,
	ie_pab_w,
	ie_faec_w,
	cd_rub_w,
	ds_aux_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	insert into sus_preco_procBPA(DT_COMPETENCIA,
		CD_PROCEDIMENTO,
		IE_ORIGEM_PROCED,
		VL_TPH,
		VL_TAXA_SALA,
		VL_HONORARIO_MEDICO,
		VL_ANESTESIA,
		VL_MATMED,
		VL_CONTRASTE,
		VL_FILME_RX,
		VL_GESSO,
		VL_QUIMIOTERAPIA,
		VL_DIALISE,
		VL_SADT_RX,
		VL_SADT_PC,
		VL_SADT_OUTROS,
		VL_FILME_RESSONANCIA,
		VL_OUTROS,
		VL_PROCEDIMENTO,
		DT_ATUALIZACAO,
		NM_USUARIO,
		VL_PLANTONISTA,
		IE_VERSAO,
		IE_CESSAO_CREDITO,
		IE_PAB,
		IE_FAEC,
		CD_RUB,
		DS_AUX)
	values (dt_competencia_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		vl_tph_w,
		vl_taxa_sala_w,
		vl_honorario_medico_w,
		vl_anestesia_w,
		vl_matmed_w,
		vl_contraste_w,
		vl_filme_rx_w,
		vl_gesso_w,
		vl_quimioterapia_w,
		vl_dialise_w,
		vl_sadt_rx_w,
		vl_sadt_pc_w,
		vl_sadt_outros_w,
		vl_filme_ressonancia_w,
		vl_outros_w,
		vl_procedimento_w,
		clock_timestamp(),
		nm_usuario_p,
		vl_plantonista_w,
		ie_versao_w,
		ie_cessao_credito_w,
		ie_pab_w,
		ie_faec_w,
		cd_rub_w,
		ds_aux_w);
	exception
		when others then
		--r.aise_application_error(-20011,CD_PROCEDIMENTO_W);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263306,'CD_PROCEDIMENTO_W='||CD_PROCEDIMENTO_W);
	end;
END LOOP;
CLOSE C01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_preco_procbpa ( dt_comp_origem_p timestamp, ie_versao_origem_p text, dt_comp_destino_p timestamp, ie_versao_destino_p text, nm_usuario_p text) FROM PUBLIC;

