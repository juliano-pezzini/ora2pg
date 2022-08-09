-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cta_registrar_historico_pend ( nr_seq_pend_p bigint, nr_seq_estagio_novo_p bigint, ds_historico_p text, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/* ie_opcao_p = '1' - Alteracao de estagio */

nr_seq_estagio_ant_w	bigint;

dt_inicio_estagio_w	timestamp;
dt_final_estagio_w	timestamp;
nr_seq_pend_hist_w	bigint;
ie_tipo_estagio_w	varchar(15);

vl_auditoria_w		double precision:= 0;
nr_seq_auditoria_w	bigint;
nr_interno_conta_w	bigint;
vl_incluido_w		double precision;
vl_excluido_w		double precision;
vl_transferido_w	double precision;
cd_estabelecimento_w	smallint;
ie_Gerar_Pendencia_w	varchar(1);
nr_seq_pend_hist_ww	bigint;
vl_incluido_ant_w	double precision;
vl_excluido_ant_w	double precision;
vl_transf_ant_w		double precision;
vl_incluido_atual_w	double precision;
vl_excluido_atual_w	double precision;
vl_transf_atual_w	double precision;
					

BEGIN

select 	max(nr_seq_estagio),
	coalesce(max(nr_seq_auditoria),0),
	coalesce(max(nr_interno_conta),0)
into STRICT	nr_seq_estagio_ant_w,
	nr_seq_auditoria_w,
	nr_interno_conta_w
from 	cta_pendencia
where 	nr_sequencia = nr_seq_pend_p;

select 	coalesce(max(cd_estabelecimento),0)
into STRICT	cd_estabelecimento_w
from 	conta_paciente
where 	nr_interno_conta = nr_interno_conta_w;

ie_Gerar_Pendencia_w := obter_valor_param_usuario(1116, 136, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w);

if (nr_seq_auditoria_w > 0) then
	vl_auditoria_w:=  coalesce(obter_valor_auditoria(nr_seq_auditoria_w,nr_interno_conta_w),0);
	if (ie_Gerar_Pendencia_w = 'V') then
		
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_pend_hist_ww
		from 	cta_pendencia_hist
		where 	nr_seq_pend = nr_seq_pend_p;
		
		select 	coalesce(max(vl_incluido),0),
			coalesce(max(vl_excluido),0),
			coalesce(max(vl_transferido),0)
		into STRICT	vl_incluido_ant_w,
			vl_excluido_ant_w,
			vl_transf_ant_w
		from 	cta_pendencia_hist
		where 	nr_sequencia = nr_seq_pend_hist_ww;		
	
		vl_incluido_atual_w :=  coalesce(obter_valor_audit_estagio(nr_seq_auditoria_w,nr_interno_conta_w, 'I'),0);
		vl_excluido_atual_w :=  coalesce(obter_valor_audit_estagio(nr_seq_auditoria_w,nr_interno_conta_w, 'E'),0);
		vl_transf_atual_w   :=  coalesce(obter_valor_audit_estagio(nr_seq_auditoria_w,nr_interno_conta_w, 'T'),0);
		
		vl_incluido_w	:= vl_incluido_atual_w - vl_incluido_ant_w;
		vl_excluido_w	:= vl_excluido_atual_w - vl_excluido_ant_w;
		vl_transferido_w:= vl_transf_atual_w   - vl_transf_ant_w;
		
		update	cta_pendencia_hist
		set 	vl_incluido = vl_incluido_w,
			vl_excluido = vl_excluido_w,
			vl_transferido = vl_transferido_w
		where 	nr_sequencia = nr_seq_pend_hist_ww;
	end if;
end if;

select 	coalesce(max(ie_tipo_estagio),'A')
into STRICT	ie_tipo_estagio_w
from 	cta_estagio_pend
where 	nr_sequencia = nr_seq_estagio_novo_p;

select 	max(clock_timestamp())
into STRICT	dt_final_estagio_w
;
		
if (ie_opcao_p = '1') then

	select 	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_pend_hist_w
	from 	cta_pendencia_hist
	where 	nr_seq_pend = nr_seq_pend_p;
	
	if (nr_seq_pend_hist_w = 0) then
		select 	max(clock_timestamp())
		into STRICT	dt_inicio_estagio_w
		;
	else
		dt_inicio_estagio_w:= dt_final_estagio_w;			
		
		if (ie_Gerar_Pendencia_w = 'V') then
			update 	cta_pendencia_hist
			set 	dt_final_estagio = dt_final_estagio_w,
				qt_horas_estagio = CASE WHEN dt_final_estagio_w = NULL THEN  null  ELSE trunc((dt_final_estagio_w - dt_inicio_estagio) * 24) END ,
				ie_tipo_meta	 = CASE WHEN dt_final_estagio_w = NULL THEN  null  ELSE Obter_Tipo_Meta_Estagio(nr_seq_estagio, 0, CASE WHEN dt_final_estagio_w = NULL THEN  null  ELSE trunc((dt_final_estagio_w - dt_inicio_estagio) * 24) END ) END
			where 	nr_sequencia = nr_seq_pend_hist_w;
		else
			update 	cta_pendencia_hist
			set 	dt_final_estagio = dt_final_estagio_w
			where 	nr_sequencia = nr_seq_pend_hist_w;			
		end if;
	end if;				

	insert into cta_pendencia_hist(NR_SEQUENCIA,
			NR_SEQ_PEND,
			DT_ATUALIZACAO,
			NM_USUARIO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO_NREC,
			NR_SEQ_ESTAGIO,
			DS_HISTORICO,
			nr_seq_estagio_ant,
			dt_inicio_estagio,
			dt_final_estagio,
			vl_auditoria,
			vl_incluido,
			vl_excluido,
			vl_transferido,
			qt_horas_estagio,
			ie_tipo_meta)
		values (nextval('cta_pendencia_hist_seq'),
			nr_seq_pend_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_estagio_novo_p,
			substr(ds_historico_p,1,4000),
			nr_seq_estagio_ant_w,
			dt_inicio_estagio_w,
			CASE WHEN ie_tipo_estagio_w='F' THEN  dt_final_estagio_w  ELSE null END ,
			vl_auditoria_w,
			0,
			0,
			0,
			CASE WHEN ie_tipo_estagio_w='F' THEN  trunc((dt_final_estagio_w - dt_inicio_estagio_w) * 24)  ELSE null END ,
			CASE WHEN ie_Gerar_Pendencia_w='V' THEN  CASE WHEN ie_tipo_estagio_w='F' THEN   Obter_Tipo_Meta_Estagio(nr_seq_estagio_novo_p, 0, trunc((dt_final_estagio_w - dt_inicio_estagio_w) * 24))  ELSE null END   ELSE null END );
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cta_registrar_historico_pend ( nr_seq_pend_p bigint, nr_seq_estagio_novo_p bigint, ds_historico_p text, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
