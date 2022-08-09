-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_obter_dados_dialise_js ( nr_seq_dialise_p bigint, cd_pessoa_fisica_p INOUT text, nr_seq_dialisador_ativo_p INOUT text, nr_seq_dialise_dialis_ativo_p INOUT text, nm_pessoa_fisica_p INOUT text, qt_pa_diast_pre_deitado_p INOUT text, qt_pa_diast_pre_pe_p INOUT text, qt_pa_sist_pre_deitado_p INOUT text, qt_peso_pre_p INOUT text, nr_seq_unid_dialise_p INOUT text, nr_seq_ponto_acesso_p INOUT text, nr_seq_maquina_p INOUT text, ie_tipo_dialise_p INOUT text, dt_dialise_retro_p INOUT text, ds_dt_nascimento_pf_p INOUT text) AS $body$
DECLARE


nr_seq_dialisador_ativo_w	varchar(255);
nr_seq_dialise_dialis_ativo_w 	varchar(255);
nm_pessoa_fisica_w	varchar(255);
qt_pa_diast_pre_deitado_w	varchar(255);
qt_pa_diast_pre_pe_w	varchar(255);
qt_pa_sist_pre_deitado_w	varchar(255);
qt_peso_pre_w		varchar(255);
nr_seq_unid_dialise_w	varchar(255);
nr_seq_ponto_acesso_w	varchar(255);
nr_seq_maquina_w		varchar(255);


BEGIN

nr_seq_dialisador_ativo_w := hd_obter_dados_dialise(nr_seq_dialise_p,'DA');

nr_seq_dialise_dialis_ativo_w := hd_obter_dados_dialise(nr_seq_dialise_p,'DS');

nm_pessoa_fisica_w := hd_obter_dados_dialise(nr_seq_dialise_p,'NP');

qt_pa_diast_pre_deitado_w := hd_obter_dados_dialise(nr_seq_dialise_p,'PDD');

qt_pa_diast_pre_pe_w := hd_obter_dados_dialise(nr_seq_dialise_p,'PDP');

qt_pa_sist_pre_deitado_w := hd_obter_dados_dialise(nr_seq_dialise_p,'PSD');

qt_peso_pre_w := hd_obter_dados_dialise(nr_seq_dialise_p,'PP');

--nr_seq_unid_dialise_w := hd_obter_dados_dialise(nr_seq_dialise_p,'SU');
nr_seq_unid_dialise_w := hd_obter_unidade_prc(cd_pessoa_fisica_p,'C');

nr_seq_ponto_acesso_w := hd_obter_dados_dialise(nr_seq_dialise_p,'DP');

nr_seq_maquina_w := hd_obter_dados_dialise(nr_seq_dialise_p,'DM');

ie_tipo_dialise_p := hd_obter_dados_dialise(nr_seq_dialise_p, 'TD');

dt_dialise_retro_p := hd_obter_dt_dialise_retro(nr_seq_dialise_p);

cd_pessoa_fisica_p := hd_obter_dados_dialise(nr_seq_dialise_p, 'PF');

select	to_char(max(dt_nascimento),'dd/mm/yyyy')
into STRICT	ds_dt_nascimento_pf_p
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_p;

nr_seq_dialisador_ativo_p 	:= nr_seq_dialisador_ativo_w;
nr_seq_dialise_dialis_ativo_p 	:= nr_seq_dialise_dialis_ativo_w;
nm_pessoa_fisica_p 	:= nm_pessoa_fisica_w;
qt_pa_diast_pre_deitado_p 	:= qt_pa_diast_pre_deitado_w;
qt_pa_diast_pre_pe_p 	:= qt_pa_diast_pre_pe_w;
qt_pa_sist_pre_deitado_p 	:= qt_pa_sist_pre_deitado_w;
qt_peso_pre_p 		:= qt_peso_pre_w;
nr_seq_unid_dialise_p	:= nr_seq_unid_dialise_w;
nr_seq_ponto_acesso_p	:= nr_seq_ponto_acesso_w;
nr_seq_maquina_p		:= nr_seq_maquina_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_obter_dados_dialise_js ( nr_seq_dialise_p bigint, cd_pessoa_fisica_p INOUT text, nr_seq_dialisador_ativo_p INOUT text, nr_seq_dialise_dialis_ativo_p INOUT text, nm_pessoa_fisica_p INOUT text, qt_pa_diast_pre_deitado_p INOUT text, qt_pa_diast_pre_pe_p INOUT text, qt_pa_sist_pre_deitado_p INOUT text, qt_peso_pre_p INOUT text, nr_seq_unid_dialise_p INOUT text, nr_seq_ponto_acesso_p INOUT text, nr_seq_maquina_p INOUT text, ie_tipo_dialise_p INOUT text, dt_dialise_retro_p INOUT text, ds_dt_nascimento_pf_p INOUT text) FROM PUBLIC;
