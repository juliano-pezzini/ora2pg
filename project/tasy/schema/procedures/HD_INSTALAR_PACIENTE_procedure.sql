-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_instalar_paciente ( nr_seq_dialise_p bigint, qt_pa_sist_pre_pe_p bigint, qt_pa_diast_pre_pe_p bigint, qt_pa_sist_pre_deit_p bigint, qt_pa_diast_pre_deit_p bigint, qt_peso_pre_p bigint, qt_peso_ideal_p bigint, nr_seq_acesso_p bigint, cd_estabelecimento_p bigint, dt_instalacao_p timestamp, nr_seq_motivo_peso_pre_p text, nr_seq_motivo_pa_deitado_pre_p text, nr_seq_motivo_pa_pe_pre_p text, qt_soro_reposicao_p bigint, qt_soro_devolucao_p bigint, nr_seq_tipo_soro_p bigint, qt_freq_resp_pre_p bigint default null, qt_glicemia_capilar_pre_p bigint default null, qt_saturacao_o2_pre_p bigint default null, qt_insulina_pre_p bigint default null, qt_glicose_adm_pre_p bigint default null, ie_commit_p text default 'S', qt_temp_auxiliar_pre_p bigint default null, qt_freq_cardiaca_pre_p bigint default null, nm_usuario_p text DEFAULT NULL, ds_erro_p INOUT text DEFAULT NULL) AS $body$
DECLARE

 
 
nr_seq_unid_dialise_w			bigint;


BEGIN 
 
if	(((qt_pa_sist_pre_pe_p = 0) or (qt_pa_diast_pre_pe_p = 0)) and (nr_seq_motivo_pa_pe_pre_p = '0')) or 
	(((qt_pa_sist_pre_deit_p = 0) or (qt_pa_diast_pre_deit_p = 0)) and (nr_seq_motivo_pa_deitado_pre_p = '0')) or 
	(qt_peso_pre_p = 0 AND nr_seq_motivo_peso_pre_p = '0') then 
	ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(277931,null);
elsif (nr_seq_acesso_p = 0) then 
	ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(277932,null);
else	 
	begin 
 
	/* Atualiza dados da diálise */
 
	update	hd_dialise 
	set	qt_pa_sist_pre_deitado		= qt_pa_sist_pre_deit_p, 
		qt_pa_diast_pre_deitado		= qt_pa_diast_pre_deit_p, 
		qt_pa_sist_pre_pe		= qt_pa_sist_pre_pe_p, 
		qt_pa_diast_pre_pe		= qt_pa_diast_pre_pe_p, 
		qt_peso_pre			= qt_peso_pre_p, 
		qt_peso_ideal			= qt_peso_ideal_p, 
		dt_instalacao			= dt_instalacao_p, 
		cd_pf_instalacao		= substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10), 
		nr_seq_motivo_peso_pre		= CASE WHEN nr_seq_motivo_peso_pre_p='0' THEN  null  ELSE nr_seq_motivo_peso_pre_p END , 
		nr_seq_motivo_pa_deitado_pre	= CASE WHEN nr_seq_motivo_pa_deitado_pre_p='0' THEN  null  ELSE nr_seq_motivo_pa_deitado_pre_p END , 
		nr_seq_motivo_pa_pe_pre		= CASE WHEN nr_seq_motivo_pa_pe_pre_p='0' THEN  null  ELSE nr_seq_motivo_pa_pe_pre_p END , 
		qt_soro_reposicao		= qt_soro_reposicao_p, 
		qt_soro_devolucao		= qt_soro_devolucao_p, 
		nr_seq_tipo_soro		= nr_seq_tipo_soro_p, 
		qt_freq_resp_pre		= coalesce(qt_freq_resp_pre_p, qt_freq_resp_pre), 
		qt_glicemia_capilar_pre		= coalesce(qt_glicemia_capilar_pre_p, qt_glicemia_capilar_pre), 
		qt_saturacao_o2_pre		= coalesce(qt_saturacao_o2_pre_p, qt_saturacao_o2_pre), 
		qt_insulina_pre			= coalesce(qt_insulina_pre_p, qt_insulina_pre), 
		qt_glicose_adm_pre		= coalesce(qt_glicose_adm_pre_p, qt_glicose_adm_pre), 
		qt_temp_auxiliar_pre		= coalesce(qt_temp_auxiliar_pre_p, qt_temp_auxiliar_pre), 
		qt_freq_cardiaca_pre		= coalesce(qt_freq_cardiaca_pre_p, qt_freq_cardiaca_pre), 
		nm_usuario			= nm_usuario_p, 
		dt_atualizacao			= clock_timestamp() 
	where	nr_sequencia			= nr_seq_dialise_p;
 
	/* Pega a unidade de diálise */
 
	select	nr_seq_unid_dialise 
	into STRICT	nr_seq_unid_dialise_w 
	from	hd_dialise 
	where	nr_sequencia	= nr_seq_dialise_p;
 
	/* Atualiza dados do acesso */
 
	insert into hd_dialise_acesso( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_acesso, 
		dt_acesso, 
		cd_pf_acesso, 
		cd_estabelecimento, 
		nr_seq_dialise, 
		nr_seq_unid_dialise 
	) values ( 
		nextval('hd_dialise_acesso_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_acesso_p, 
		dt_instalacao_p, 
		substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10), 
		cd_estabelecimento_p, 
		nr_seq_dialise_p, 
		nr_seq_unid_dialise_w 
	);
 
	/* Gerar avaliação do paciente */
 
	ds_erro_p := hd_gerar_avaliacao(nr_seq_dialise_p, nm_usuario_p, ds_erro_p);
 
	/* Calcula o GPID */
 
	ds_erro_p := hd_gerar_gpid(nr_seq_dialise_p, nm_usuario_p, ds_erro_p);
	 
	CALL hd_gerar_assinatura(null, null, nr_seq_dialise_p, null, null, null, null, null, null, 'CP', nm_usuario_p, 'N');
	 
	end;
end if;
 
if (coalesce(ie_commit_p, 'S') = 'S') then 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_instalar_paciente ( nr_seq_dialise_p bigint, qt_pa_sist_pre_pe_p bigint, qt_pa_diast_pre_pe_p bigint, qt_pa_sist_pre_deit_p bigint, qt_pa_diast_pre_deit_p bigint, qt_peso_pre_p bigint, qt_peso_ideal_p bigint, nr_seq_acesso_p bigint, cd_estabelecimento_p bigint, dt_instalacao_p timestamp, nr_seq_motivo_peso_pre_p text, nr_seq_motivo_pa_deitado_pre_p text, nr_seq_motivo_pa_pe_pre_p text, qt_soro_reposicao_p bigint, qt_soro_devolucao_p bigint, nr_seq_tipo_soro_p bigint, qt_freq_resp_pre_p bigint default null, qt_glicemia_capilar_pre_p bigint default null, qt_saturacao_o2_pre_p bigint default null, qt_insulina_pre_p bigint default null, qt_glicose_adm_pre_p bigint default null, ie_commit_p text default 'S', qt_temp_auxiliar_pre_p bigint default null, qt_freq_cardiaca_pre_p bigint default null, nm_usuario_p text DEFAULT NULL, ds_erro_p INOUT text DEFAULT NULL) FROM PUBLIC;

